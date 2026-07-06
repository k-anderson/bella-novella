#!/usr/bin/env bash
# Full in-container call simulation for the disco appliance — no hardware.
#
# Registers two headless baresip softphones as SIP lines 101 and 102 to the
# running FreeSWITCH (ata profile on 192.168.50.1), then lets you drive the IVR:
#
#   dial 700  ->  main menu
#     1  ->  intercom the other line (rings 102)
#     2  ->  raise actuator  (watch: journalctl / the relay log below)
#     3  ->  lower actuator
#     9  ->  record a new greeting
#
# Line 102 runs in the background on auto-answer (so intercom has someone to
# reach). Line 101 is interactive: type digits to send DTMF during the call.
#
# Prereq: FreeSWITCH already running, e.g.  fs-start -nc
#
# NOTE: baresip audio/DTMF module wiring is environment-sensitive under QEMU
# emulation; if registration or media misbehave, adjust the module lines below.
# This is the piece most likely to need a tweak during first-run verification.
set -euo pipefail

DOMAIN="192.168.50.1"
WORK="$(mktemp -d /tmp/disco-softphone.XXXXXX)"
RELAY_LOG="${DISCO_GPIO_LOG:-/var/log/disco-gpio.log}"

command -v baresip >/dev/null 2>&1 || {
  echo "baresip not installed — this is only available in the freeswitch-arm64 Codespace." >&2
  exit 1
}

# Confirm FreeSWITCH is up and the ata profile is listening.
if ! ss -lun 2>/dev/null | grep -q ":5060"; then
  echo "FreeSWITCH SIP (udp/5060) is not listening. Start it first:  fs-start -nc" >&2
  exit 1
fi

# --- write a baresip config + account for one line -------------------------
# $1 = extension (101|102), $2 = extra account params (e.g. answermode)
make_line() {
  local ext="$1" extra="$2" dir="${WORK}/${ext}"
  mkdir -p "$dir"

  # Minimal headless config. We omit module_path so baresip uses its compiled-in
  # default (platform-specific), and load only what we need: registration/menu
  # plus a sine-wave source and a loopback sink so no real sound card is needed.
  # (If module loading fails under emulation, `baresip -f DIR` once will write a
  # full default config to DIR/config that you can trim instead.)
  cat >"${dir}/config" <<CFG
module                 account.so
module                 menu.so
module                 ausine.so
module                 aubridge.so
audio_source           ausine,440
audio_player           aubridge,nil
sip_listen             0.0.0.0:0
CFG

  # Blind auth: any password is accepted by the ata profile.
  cat >"${dir}/accounts" <<ACC
<sip:${ext}@${DOMAIN}>;auth_pass=not-used;transport=udp;regint=60;${extra}
ACC
}

cleanup() {
  echo
  echo "[softphone] shutting down..."
  [ -n "${BG102_PID:-}" ] && kill "$BG102_PID" 2>/dev/null || true
  rm -rf "$WORK"
}
trap cleanup EXIT INT TERM

echo "[softphone] work dir: $WORK"
echo "[softphone] relay (GPIO) activity is logged to: $RELAY_LOG"
touch "$RELAY_LOG" 2>/dev/null || true

# Line 102: background, auto-answer — the intercom callee.
make_line 102 "answermode=auto"
baresip -f "${WORK}/102" >"${WORK}/102.out" 2>&1 &
BG102_PID=$!
echo "[softphone] line 102 registering (background, auto-answer), pid $BG102_PID"

sleep 2  # give 102 time to register

# Line 101: interactive — you drive the IVR from here.
make_line 101 ""
cat <<INSTR

============================================================================
 Line 101 console is starting. Useful baresip keys:
   /dial 700       place a call to the IVR
   1 2 3 9         send DTMF once the call is up (drives the menu)
   b               hang up
   /quit           exit (also stops line 102)

 In another terminal, watch what the actuator "does":
   tail -f ${RELAY_LOG}
   fs_cli -x 'sofia status'          # confirm 101 and 102 are registered
============================================================================

INSTR

exec baresip -f "${WORK}/101"
