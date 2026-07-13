#!/usr/bin/env bash
# Codespaces post-create setup for the "disco" FreeSWITCH appliance.
#
# Makes the checked-out repo behave like the Pi's /usr/local/freeswitch tree and
# stands up the hardware/telephony simulation so FreeSWITCH can boot and be
# call-tested without a Raspberry Pi, GPIO HAT, ATA, or physical phones.
#
# Idempotent: safe to re-run.
set -euo pipefail

# Resolve the repo root regardless of where this is invoked from.
# .devcontainer/common/setup.sh -> repo root is two levels up.
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
COMMON_DIR="${REPO_ROOT}/.devcontainer/common"
FS_ROOT="/usr/local/freeswitch"

log() { echo "[disco-setup] $*"; }

need_root() {
  if [ "$(id -u)" -ne 0 ]; then
    echo "[disco-setup] must run as root (devcontainer sets remoteUser=root)" >&2
    exit 1
  fi
}

need_root

# ---------------------------------------------------------------------------
# 1. Make the repo the FreeSWITCH base dir.
#    conf/vars.xml hardcodes base_dir=/usr/local/freeswitch, and derives
#    conf_dir/mod_dir/lib_dir/sounds_dir from it. Symlinking the repo there
#    means the committed aarch64 binaries + config + sounds are what run.
# ---------------------------------------------------------------------------
if [ -e "$FS_ROOT" ] && [ ! -L "$FS_ROOT" ]; then
  log "WARNING: $FS_ROOT exists and is not a symlink; leaving it in place"
else
  mkdir -p "$(dirname "$FS_ROOT")"
  ln -sfn "$REPO_ROOT" "$FS_ROOT"
  log "linked $FS_ROOT -> $REPO_ROOT"
fi

# ---------------------------------------------------------------------------
# 2. Runtime dirs FreeSWITCH writes to (git-ignored, may be empty on checkout).
# ---------------------------------------------------------------------------
mkdir -p "${REPO_ROOT}/db" "${REPO_ROOT}/log" "${REPO_ROOT}/run"

# ---------------------------------------------------------------------------
# 3. Loopback alias for the isolated ATA IP.
#    ata.xml binds sip-ip/rtp-ip to $${bind_server_ip} = 192.168.50.1, and the
#    bella_ata_only ACL only trusts 192.168.50.0/24. Aliasing it onto lo lets
#    mod_sofia bind and lets a local softphone register from within the ACL.
# ---------------------------------------------------------------------------
if ! ip addr show dev lo | grep -q "192.168.50.1/24"; then
  ip addr add 192.168.50.1/24 dev lo label lo:disco 2>/dev/null \
    && log "added 192.168.50.1/24 to lo" \
    || log "WARNING: could not add 192.168.50.1 to lo (call testing may fail)"
else
  log "192.168.50.1/24 already present on lo"
fi

# ---------------------------------------------------------------------------
# 4. GPIO command stubs. disco-relay calls pinctrl/raspi-gpio; the stubs log
#    instead of touching hardware, so the real script runs unchanged.
# ---------------------------------------------------------------------------
install -m 0755 "${COMMON_DIR}/gpio-stubs/pinctrl"    /usr/local/bin/pinctrl
install -m 0755 "${COMMON_DIR}/gpio-stubs/raspi-gpio" /usr/local/bin/raspi-gpio
: >/var/log/disco-gpio.log && chmod 0666 /var/log/disco-gpio.log
log "installed GPIO stubs (pinctrl, raspi-gpio); activity -> /var/log/disco-gpio.log"

# ---------------------------------------------------------------------------
# 5. disco-relay location
#    The repo contains `scripts/disco-relay` and FreeSWITCH is configured to
#    call the script from /usr/local/freeswitch/scripts. No system-wide
#    /usr/local/bin installation is required for Codespaces.
# ---------------------------------------------------------------------------
ln -sfn "${REPO_ROOT}/scripts/disco-relay" /usr/local/freeswitch/scripts/disco-relay
log "linked /usr/local/freeswitch/scripts/disco-relay"

# ---------------------------------------------------------------------------
# 6. Convenience launcher on PATH. fs_cli is used directly (the image puts
#    /usr/local/freeswitch/bin on PATH with LD_LIBRARY_PATH set), so no wrapper.
# ---------------------------------------------------------------------------
install -m 0755 "${COMMON_DIR}/fs-start" /usr/local/bin/fs-start
log "installed fs-start"

# ---------------------------------------------------------------------------
# 7. Prompt-regeneration toolchain (bella-regen-prompts).
#    Mirrors what `install.sh --fresh` provisions on the Pi: python3 + a venv
#    holding the ElevenLabs SDK (PEP 668 blocks system-wide pip on bookworm),
#    plus sox/libsox-fmt-all for the MP3 -> 8 kHz WAV conversion. Best-effort:
#    editing/call-testing does not depend on it, so failures only warn.
# ---------------------------------------------------------------------------
export DEBIAN_FRONTEND=noninteractive
if apt-get install -y --no-install-recommends \
     python3 python3-venv python3-pip sox libsox-fmt-all >/dev/null 2>&1; then
  BELLA_VENV="${REPO_ROOT}/.venv"
  if [ ! -x "${BELLA_VENV}/bin/python" ]; then
    python3 -m venv "${BELLA_VENV}" 2>/dev/null || true
  fi
  if [ -x "${BELLA_VENV}/bin/pip" ]; then
    "${BELLA_VENV}/bin/pip" install --upgrade pip >/dev/null 2>&1 || true
    if "${BELLA_VENV}/bin/pip" install --upgrade elevenlabs >/dev/null 2>&1; then
      log "prompt toolchain ready (.venv + elevenlabs, sox)"
    else
      log "WARNING: could not install elevenlabs into ${BELLA_VENV}"
    fi
  else
    log "WARNING: venv creation failed; bella-regen-prompts unavailable"
  fi
else
  log "WARNING: could not install python/sox; bella-regen-prompts unavailable"
fi

cat <<'DONE'

[disco-setup] Ready.

  fs-start            # boot FreeSWITCH in the foreground (Ctrl-C to stop)
  fs-start -nc        # boot in the background
  fs_cli              # attach to the running FreeSWITCH (defaults: 127.0.0.1:8021 / ClueCon)
  fs_cli -x 'sofia status'

  sudo /usr/local/freeswitch/scripts/disco-relay raise 5 15    # simulate the actuator (logged, no hardware)
  /usr/local/freeswitch/scripts/disco-relay status

  bash .devcontainer/common/softphone-test.sh    # full IVR/DTMF/intercom test

See CODESPACES.md for details and limitations.
DONE
