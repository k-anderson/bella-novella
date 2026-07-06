#!/usr/bin/env bash
set -euo pipefail

# Installer for Bella Novella
# Usage: sudo ./install.sh [--network] [--no-restart]

PACKAGE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FS_DIR="${FS_DIR:-/usr/local/freeswitch}"
FS_USER="${FS_USER:-freeswitch}"
FS_GROUP="${FS_GROUP:-freeswitch}"

DO_NETWORK=0
DO_RESTART=1
DO_FRESH=0
BUILD_SPANDSP=""
BUILD_SOFIA=""

usage() {
  cat <<USAGE
Usage: sudo ./install.sh [--fresh] [--network] [--no-restart] [--build-spandsp[=BRANCH]] [--build-sofia[=BRANCH]]

Options:
  --fresh                   Run one-time fresh-Pi bootstrap: install packages, create the
                            freeswitch user, prune desktop/bloat services, and apply OS tuning.
  --network                 Configure eth0 static IP and dnsmasq DHCP scope for ATA.
  --no-restart              Install files but do not restart FreeSWITCH.
  --build-spandsp[=BRANCH]  Build and install SpanDSP from source (optional branch/tag).
  --build-sofia[=BRANCH]    Build and install Sofia-SIP from source (optional branch/tag).
  -h, --help                Show this help message.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --fresh) DO_FRESH=1 ;;
    --network) DO_NETWORK=1 ;;
    --no-restart) DO_RESTART=0 ;;
    --build-spandsp) BUILD_SPANDSP="master" ;;
    --build-spandsp=*) BUILD_SPANDSP="${1#*=}" ;;
    --build-sofia) BUILD_SOFIA="master" ;;
    --build-sofia=*) BUILD_SOFIA="${1#*=}" ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
  shift
done

if [ "$(id -u)" -ne 0 ]; then
  echo "ERROR: run as root, e.g. sudo ./install.sh" >&2
  exit 1
fi

if [ ! -d "${FS_DIR}" ]; then
  echo "ERROR: ${FS_DIR} does not exist" >&2
  exit 1
fi

STAMP="$(date +%Y%m%d-%H%M%S)"

bootstrap_fresh() {
  echo "==> Fresh-Pi bootstrap (packages, user, service pruning, OS tuning)"

  # --- Packages: build toolchain + FreeSWITCH runtime deps + admin tools -----
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -y || true
  apt-get install -y \
    git curl wget ca-certificates gnupg pkg-config \
    build-essential autoconf automake libtool-bin cmake ninja-build \
    libssl-dev zlib1g-dev libpcre2-dev libedit-dev libsqlite3-dev \
    libcurl4-openssl-dev libldns-dev libspeex-dev libspeexdsp-dev \
    libopus-dev libsndfile1-dev liblua5.4-dev lua5.4 \
    libpq-dev libtiff-dev libjpeg-dev uuid-dev \
    yasm nasm python3 python3-dev python3-pip \
    dnsmasq tshark sngrep sox jq rsync \
    vim htop iftop tcpdump net-tools unzip lsof tmux ncdu tree \
    linux-cpupower || true

  # --- FreeSWITCH runtime user/group -----------------------------------------
  groupadd -r "${FS_GROUP}" 2>/dev/null || true
  useradd -r -g "${FS_GROUP}" -d "${FS_DIR}" -s /usr/sbin/nologin "${FS_USER}" 2>/dev/null || true
  chown -R "${FS_USER}:${FS_GROUP}" "${FS_DIR}" 2>/dev/null || true

  # --- Source build directory ------------------------------------------------
  mkdir -p /usr/local/src
  chown -R root:root /usr/local/src 2>/dev/null || true

  # --- Disable/stop bloat + desktop services (safe if already absent) --------
  for svc in \
    avahi-daemon triggerhappy ModemManager rpcbind nfs-blkmap \
    udisks2 packagekit accounts-daemon lightdm cups
  do
    systemctl disable --now "${svc}" 2>/dev/null || true
  done

  # NetworkManager-wait-online blocks boot ~6s for no benefit on this appliance.
  systemctl disable --now NetworkManager-wait-online 2>/dev/null || true
  systemctl mask NetworkManager-wait-online 2>/dev/null || true

  # --- Purge cloud-init only if present --------------------------------------
  if dpkg -l cloud-init 2>/dev/null | grep -q '^ii'; then
    apt-get purge -y cloud-init 2>/dev/null || true
    rm -rf /etc/cloud /var/lib/cloud || true
  fi

  # --- Headless target -------------------------------------------------------
  systemctl set-default multi-user.target 2>/dev/null || true

  # --- Full GUI strip (idempotent: missing packages do not fail the run) -----
  apt-get purge -y \
    lightdm 'rpd-*' 'wf-panel-pi' 'wfplug-*' wayvnc rpi-connect \
    pipewire pipewire-pulse wireplumber 'xdg-desktop-portal*' \
    rpi-chromium-mods rpi-firefox-mods rpi-imager rp-bookshelf \
    piclone rpicam-apps rpinters pi-printer-support cups \
    2>/dev/null || true
  apt-get autoremove --purge -y 2>/dev/null || true

  # --- GPU memory: hand as little as possible to the (headless) GPU ----------
  BOOT_CONFIG=""
  for candidate in /boot/firmware/config.txt /boot/config.txt; do
    if [ -f "${candidate}" ]; then BOOT_CONFIG="${candidate}"; break; fi
  done
  if [ -n "${BOOT_CONFIG}" ]; then
    backup_if_exists "${BOOT_CONFIG}"
    if grep -q '^[[:space:]]*gpu_mem=' "${BOOT_CONFIG}"; then
      sed -i 's/^[[:space:]]*gpu_mem=.*/gpu_mem=16/' "${BOOT_CONFIG}"
    else
      printf '\ngpu_mem=16\n' >>"${BOOT_CONFIG}"
    fi
    echo "OK: gpu_mem=16 set in ${BOOT_CONFIG}"
  else
    echo "WARN: no boot config.txt found; skipping gpu_mem tuning"
  fi

  # --- CPU governor: performance, persisted across reboots -------------------
  if command -v cpupower >/dev/null 2>&1; then
    cpupower frequency-set -g performance >/dev/null 2>&1 || true
  fi
  cat >/etc/default/cpupower <<'CPUPOWER'
# Set by Bella Novella install.sh --fresh: pin the CPU to the performance
# governor so media timing is not affected by frequency scaling.
GOVERNOR="performance"
CPUPOWER
  systemctl enable cpupower.service 2>/dev/null || true
  systemctl restart cpupower.service 2>/dev/null || true

  # --- Disable the ondemand governor service (it overrides 'performance') -----
  # cpufrequtils/raspi-config ship an 'ondemand' unit that sets the governor at
  # boot AFTER cpupower.service, silently undoing the performance setting above.
  systemctl disable --now ondemand 2>/dev/null || true

  # --- Disable swap: any swapping risks audio glitches on a media appliance ---
  if command -v dphys-swapfile >/dev/null 2>&1; then
    dphys-swapfile swapoff 2>/dev/null || true
  fi
  systemctl disable --now dphys-swapfile 2>/dev/null || true
  swapoff -a 2>/dev/null || true

  # --- Reduce SD-card writes: root noatime + keep the journal in RAM ----------
  if [ -f /etc/fstab ] && ! awk '$2=="/"{print $4}' /etc/fstab | grep -q noatime; then
    backup_if_exists /etc/fstab
    sed -i -E '/[[:space:]]\/[[:space:]]/ s/(defaults)/\1,noatime/' /etc/fstab || true
    echo "OK: added noatime to root mount in /etc/fstab"
  fi
  mkdir -p /etc/systemd/journald.conf.d
  cat >/etc/systemd/journald.conf.d/99-freeswitch.conf <<'JOURNALD'
[Journal]
# Bella Novella: keep the journal in RAM to avoid SD-card wear on the appliance.
Storage=volatile
RuntimeMaxUse=64M
JOURNALD
  systemctl restart systemd-journald 2>/dev/null || true

  # --- Hardware watchdog: auto-recover the appliance from a hard hang ---------
  mkdir -p /etc/systemd/system.conf.d
  cat >/etc/systemd/system.conf.d/99-freeswitch-watchdog.conf <<'WATCHDOG'
[Manager]
# Bella Novella: arm the Raspberry Pi hardware watchdog. Takes effect on reboot.
RuntimeWatchdogSec=15s
RebootWatchdogSec=2min
WATCHDOG

  echo "OK: fresh-Pi bootstrap complete"
}

echo "==> Installing system files from ${PACKAGE_DIR}/system"

backup_if_exists() {
  local path="$1"
  if [ -e "${path}" ]; then
    cp -a "${path}" "${path}.backup.${STAMP}" || true
    echo "BACKUP: ${path}.backup.${STAMP}"
  fi
}

if [ "${DO_FRESH}" -eq 1 ]; then
  bootstrap_fresh
fi

# profile.d
backup_if_exists /etc/profile.d/freeswitch-path.sh
install -D -m 0644 "${PACKAGE_DIR}/system/etc/profile.d/freeswitch-path.sh" /etc/profile.d/freeswitch-path.sh || true
backup_if_exists /etc/profile.d/freeswitch-pkgconfig.sh
install -D -m 0644 "${PACKAGE_DIR}/system/etc/profile.d/freeswitch-pkgconfig.sh" /etc/profile.d/freeswitch-pkgconfig.sh || true

# NetworkManager ignore-carrier (file is provided in system/)
backup_if_exists /etc/NetworkManager/conf.d/99-eth0-ignore-carrier.conf
install -D -m 0644 "${PACKAGE_DIR}/system/etc/NetworkManager/conf.d/99-eth0-ignore-carrier.conf" /etc/NetworkManager/conf.d/99-eth0-ignore-carrier.conf || true

# sysctl rules
backup_if_exists /etc/sysctl.d/98-no-routing.conf
install -D -m 0644 "${PACKAGE_DIR}/system/etc/sysctl.d/98-no-routing.conf" /etc/sysctl.d/98-no-routing.conf || true
backup_if_exists /etc/sysctl.d/99-freeswitch.conf
install -D -m 0644 "${PACKAGE_DIR}/system/etc/sysctl.d/99-freeswitch.conf" /etc/sysctl.d/99-freeswitch.conf || true
sysctl --system >/dev/null || true

# bella-wait helper
backup_if_exists /usr/local/bin/freeswitch-wait-eth0
install -D -m 0755 "${PACKAGE_DIR}/system/usr/local/bin/freeswitch-wait-eth0" /usr/local/bin/freeswitch-wait-eth0 || true

# systemd unit and limits
backup_if_exists /etc/systemd/system/freeswitch.service
install -D -m 0644 "${PACKAGE_DIR}/system/etc/systemd/system/freeswitch.service" /etc/systemd/system/freeswitch.service || true
backup_if_exists /etc/security/limits.d/99-freeswitch.conf
install -D -m 0644 "${PACKAGE_DIR}/system/etc/security/limits.d/99-freeswitch.conf" /etc/security/limits.d/99-freeswitch.conf || true

systemctl daemon-reload || true

build_spandsp() {
  BRANCH="$1"
  echo "==> Building SpanDSP (branch: ${BRANCH:-master})"
  mkdir -p /usr/local/src
  cd /usr/local/src
  if [ -d spandsp ]; then
    cd spandsp
    git fetch --all || true
    git checkout "${BRANCH:-master}" || true
    git pull --ff-only || true
  else
    git clone https://github.com/freeswitch/spandsp.git
    cd spandsp
    git checkout "${BRANCH:-master}" || true
  fi
  ./bootstrap.sh || true
  ./configure --prefix=/usr/local
  make -j"$(nproc)"
  make install
  ldconfig
}

build_sofia() {
  BRANCH="$1"
  echo "==> Building Sofia-SIP (branch: ${BRANCH:-master})"
  mkdir -p /usr/local/src
  cd /usr/local/src
  if [ -d sofia-sip ]; then
    cd sofia-sip
    git fetch --all || true
    git checkout "${BRANCH:-master}" || true
    git pull --ff-only || true
  else
    git clone https://github.com/freeswitch/sofia-sip.git
    cd sofia-sip
    git checkout "${BRANCH:-master}" || true
  fi
  ./bootstrap.sh || true
  ./configure --prefix=/usr/local
  make -j"$(nproc)"
  make install
  ldconfig
}

if [ -n "${BUILD_SPANDSP}" ]; then
  build_spandsp "${BUILD_SPANDSP}"
fi

if [ -n "${BUILD_SOFIA}" ]; then
  build_sofia "${BUILD_SOFIA}"
fi

echo "==> Validating required FreeSWITCH modules"
missing=0
for mod in \
  mod_console \
  mod_logfile \
  mod_timerfd \
  mod_posix_timer \
  mod_event_socket \
  mod_sofia \
  mod_commands \
  mod_dptools \
  mod_dialplan_xml \
  mod_local_stream \
  mod_native_file \
  mod_sndfile \
  mod_tone_stream \
  mod_say_en
do
  if [ ! -f "${FS_DIR}/mod/${mod}.so" ]; then
    echo "MISSING: ${FS_DIR}/mod/${mod}.so" >&2
    missing=1
  else
    echo "OK: ${mod}"
  fi
done

if [ "${missing}" -ne 0 ]; then
  echo "ERROR: one or more required modules are missing. Rebuild/install those modules first." >&2
  exit 1
fi

if [ "${DO_NETWORK}" -eq 1 ]; then
  echo "==> Configuring isolated ATA network on eth0"

  if command -v nmcli >/dev/null 2>&1; then
    mkdir -p /etc/NetworkManager/conf.d
    cat >/etc/NetworkManager/conf.d/99-eth0-ignore-carrier.conf <<'NMC'
[device]
match-device=interface-name:eth0
ignore-carrier=true
NMC
    nmcli general reload || true

    nmcli con mod netplan-eth0 connection.autoconnect no 2>/dev/null || true

    ATA_CON_NAME="${ATA_CON_NAME:-disco-ata-eth0}"
    ATA_IFACE="${ATA_IFACE:-eth0}"
    ATA_IP_CIDR="${ATA_IP_CIDR:-192.168.50.1/24}"

    if nmcli -t -f NAME con show | grep -qx "${ATA_CON_NAME}"; then
      nmcli con mod "${ATA_CON_NAME}" \
        connection.interface-name "${ATA_IFACE}" \
        connection.autoconnect yes \
        ipv4.method manual \
        ipv4.addresses "${ATA_IP_CIDR}" \
        ipv4.never-default yes \
        ipv4.ignore-auto-dns yes \
        ipv6.method disabled
    else
      nmcli con add type ethernet ifname "${ATA_IFACE}" con-name "${ATA_CON_NAME}" \
        connection.autoconnect yes \
        ipv4.method manual \
        ipv4.addresses "${ATA_IP_CIDR}" \
        ipv4.never-default yes \
        ipv4.ignore-auto-dns yes \
        ipv6.method disabled
    fi

    nmcli con up "${ATA_CON_NAME}" || true
  else
    echo "WARN: nmcli not found; skipping NetworkManager eth0 configuration"
  fi

  cat >/etc/sysctl.d/98-no-routing.conf <<'SYSCTL'
net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0
SYSCTL
  sysctl --system >/dev/null || true

    if command -v dnsmasq >/dev/null 2>&1; then
      if [ -f "${PACKAGE_DIR}/system/etc/dnsmasq.d/eth0.conf" ]; then
        backup_if_exists /etc/dnsmasq.d/eth0.conf
        install -m 0644 "${PACKAGE_DIR}/system/etc/dnsmasq.d/eth0.conf" /etc/dnsmasq.d/eth0.conf
      fi
      systemctl enable dnsmasq >/dev/null 2>&1 || true
      systemctl restart dnsmasq
      echo "OK: dnsmasq DHCP scope installed"
    else
      echo "WARN: dnsmasq is not installed. Install it with: sudo apt install dnsmasq"
    fi
fi

SCRIPT="${FS_DIR}/scripts/disco-relay"
SUDOERS=/etc/sudoers.d/disco-relay

echo "==> Ensuring disco-relay script permissions and sudoers"
if [ -f "$SCRIPT" ]; then
  chown root:root "$SCRIPT" || true
  chmod 0755 "$SCRIPT" || true
else
  echo "WARN: $SCRIPT not found in repo. Make sure scripts/disco-relay exists." >&2
fi

tmp_sudoers_file=$(mktemp)
cat >"${tmp_sudoers_file}" <<EOF
bella ALL=(root) NOPASSWD: $SCRIPT
freeswitch ALL=(root) NOPASSWD: $SCRIPT
EOF

backup_if_exists "$SUDOERS"
install -m 0440 "${tmp_sudoers_file}" "$SUDOERS"
rm -f "${tmp_sudoers_file}"

if visudo -c >/dev/null 2>&1; then
  echo "sudoers file installed and valid: $SUDOERS"
else
  echo "WARNING: visudo reported problems; check $SUDOERS" >&2
fi

echo "==> Initializing actuator relays to brake/default"
if [ -x "$SCRIPT" ]; then
  if "$SCRIPT" brake; then
    echo "OK: relay brake/default state applied"
  else
    echo "WARN: relay initialization failed; check pinctrl/raspi-gpio and HAT installation"
  fi
else
  echo "SKIP: $SCRIPT not executable; skipping relay initialization"
fi

echo "==> Installing IVR fallback prompt symlinks if needed"
DISCO_SOUND_DIR="${FS_DIR}/recordings"
mkdir -p "${DISCO_SOUND_DIR}"
FALLBACK="${FS_DIR}/sounds/en/us/callie/ivr/ivr-welcome_to_freeswitch.wav"
if [ -f "${FALLBACK}" ]; then
  [ -e "${DISCO_SOUND_DIR}/main-menu.wav" ] || ln -s "${FALLBACK}" "${DISCO_SOUND_DIR}/main-menu.wav"
  [ -e "${DISCO_SOUND_DIR}/main-menu-short.wav" ] || ln -s "${FALLBACK}" "${DISCO_SOUND_DIR}/main-menu-short.wav"
else
  echo "WARN: fallback IVR prompt not found: ${FALLBACK}"
fi

echo "==> Backing up and installing FreeSWITCH config"
if [ -d "${FS_DIR}/conf" ]; then
  cp -a "${FS_DIR}/conf" "${FS_DIR}/conf.backup.${STAMP}"
  echo "BACKUP: ${FS_DIR}/conf.backup.${STAMP}"
fi

rm -rf "${FS_DIR}/conf"
cp -a "${PACKAGE_DIR}/conf" "${FS_DIR}/conf"
chown -R "${FS_USER}:${FS_GROUP}" "${FS_DIR}/conf" "${DISCO_SOUND_DIR}" 2>/dev/null || true

echo "==> Validating installed config file presence"
test -f "${FS_DIR}/conf/freeswitch.xml"
test -f "${FS_DIR}/conf/autoload_configs/modules.conf.xml"
test -f "${FS_DIR}/conf/sip_profiles/ata.xml"
test -f "${FS_DIR}/conf/ivr_menus/disco_main_menu.xml"

if [ "${DO_RESTART}" -eq 1 ]; then
  echo "==> Enabling and restarting FreeSWITCH"
  systemctl enable freeswitch >/dev/null 2>&1 || true
  systemctl restart freeswitch
  sleep 2
  systemctl --no-pager --full status freeswitch || true

  if command -v fs_cli >/dev/null 2>&1; then
    echo "==> FreeSWITCH status"
    fs_cli -x status || true
    echo "==> Sofia status"
    fs_cli -x "sofia status profile ata" || true
    echo "==> Registrations"
    fs_cli -x "show registrations" || true
  fi
else
  echo "SKIP: FreeSWITCH restart disabled"
fi

cat <<DONE

Install complete.

ATA settings:
  SIP server / registrar: 192.168.50.1
  SIP port: 5060 UDP
  Line 1 user: 101
  Line 2 user: 102
  Password: any value; FreeSWITCH accepts blind registration on the isolated profile.
  Optional off-hook auto-dial: 700

IVR options:
  1 = call the other phone
  2 = raise actuator
  3 = lower actuator
  4 = stop / brake

Relay command:
  /usr/local/freeswitch/scripts/disco-relay status
  /usr/local/freeswitch/scripts/disco-relay raise 10 40
  /usr/local/freeswitch/scripts/disco-relay lower 10 60
  /usr/local/freeswitch/scripts/disco-relay brake

Useful checks:
  ss -ulpn | grep ':5060'
  fs_cli -x 'sofia status profile ata'
  fs_cli -x 'show registrations'
  sudo sngrep -d eth0 port 5060

DONE
