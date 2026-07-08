#!/bin/bash
# wifi-fallback.sh
#
# Checks whether either of two known wifi networks is in range.
# If so, connects to the higher-priority one that's available.
# If neither is in range, switches wlan0 into hotspot (AP) mode.
#
# Requires NetworkManager. Designed to run periodically via a
# systemd timer (see wifi-fallback.timer / wifi-fallback.service).

IFACE="wlan0"

# List your known connection profile names here, in priority order
# (must match the con-name used in `nmcli connection add`)
KNOWN_CONS=("Location1" "Location2")

HOTSPOT_CON="Hotspot"
LOG_TAG="wifi-fallback"

log() {
    logger -t "$LOG_TAG" "$1"
}

# Find what's currently active on this interface
current_con=$(nmcli -t -f NAME,DEVICE connection show --active \
    | awk -F: -v dev="$IFACE" '$2==dev {print $1}')

# If we're currently hosting the hotspot, bring it down first so we
# can actually scan for other networks (the radio can't do both at once
# on most Pi wifi chips).
if [ "$current_con" == "$HOTSPOT_CON" ]; then
    log "Currently in hotspot mode, pausing it to scan"
    nmcli connection down "$HOTSPOT_CON" >/dev/null 2>&1
    sleep 3
fi

nmcli device wifi rescan ifname "$IFACE" >/dev/null 2>&1
sleep 5

available_ssids=$(nmcli -t -f SSID device wifi list ifname "$IFACE" 2>/dev/null)

found_con=""
for con in "${KNOWN_CONS[@]}"; do
    ssid=$(nmcli -t -f 802-11-wireless.ssid connection show "$con" 2>/dev/null | cut -d: -f2)
    if [ -n "$ssid" ] && echo "$available_ssids" | grep -Fxq "$ssid"; then
        found_con="$con"
        break
    fi
done

if [ -n "$found_con" ]; then
    if [ "$current_con" != "$found_con" ]; then
        log "Known network in range via profile '$found_con', connecting"
        nmcli connection up "$found_con" ifname "$IFACE" >/dev/null 2>&1
    else
        log "Already connected to '$found_con'"
    fi
else
    log "No known networks in range, starting hotspot"
    nmcli connection up "$HOTSPOT_CON" ifname "$IFACE" >/dev/null 2>&1
fi
