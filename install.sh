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

usage() {
  cat <<USAGE
Usage: sudo ./install.sh [--network] [--no-restart]

Options:
  --network     Configure eth0 static IP and dnsmasq DHCP scope for ATA.
  --no-restart  Install files but do not restart FreeSWITCH.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --network) DO_NETWORK=1 ;;
    --no-restart) DO_RESTART=0 ;;
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

echo "==> Validating required FreeSWITCH modules"
missing=0
for mod in \
  mod_console \
  mod_logfile \
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
    cat >/etc/NetworkManager/conf.d/99-bella-eth0-ignore-carrier.conf <<'NMC'
[device]
match-device=interface-name:eth0
ignore-carrier=true
NMC
    nmcli general reload || true

    nmcli con mod netplan-eth0 connection.autoconnect no 2>/dev/null || true

    ATA_CON_NAME="${ATA_CON_NAME:-bella-ata-eth0}"
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

  cat >/etc/sysctl.d/98-bella-no-routing.conf <<'SYSCTL'
net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0
SYSCTL
  sysctl --system >/dev/null || true

  if command -v dnsmasq >/dev/null 2>&1; then
    install -m 0644 "${PACKAGE_DIR}/network/bella-ata-dnsmasq.conf" /etc/dnsmasq.d/bella-ata.conf
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

cat >/tmp/disco-relay-sudoers <<EOF
bella ALL=(root) NOPASSWD: $SCRIPT
freeswitch ALL=(root) NOPASSWD: $SCRIPT
EOF

install -m 0440 /tmp/disco-relay-sudoers "$SUDOERS"
rm -f /tmp/disco-relay-sudoers

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
DISCO_SOUND_DIR="${FS_DIR}/sounds/en/us/callie/disco"
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
  echo "==> Restarting FreeSWITCH"
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

Relay command:
  /usr/local/freeswitch/scripts/disco-relay status
  /usr/local/freeswitch/scripts/disco-relay raise 10
  /usr/local/freeswitch/scripts/disco-relay lower 10
  /usr/local/freeswitch/scripts/disco-relay brake

Useful checks:
  ss -ulpn | grep ':5060'
  fs_cli -x 'sofia status profile ata'
  fs_cli -x 'show registrations'
  sudo sngrep -d eth0 port 5060

DONE
