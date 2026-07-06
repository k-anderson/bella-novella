# bella-novella — the "disco" FreeSWITCH appliance

A self-contained [FreeSWITCH](https://freeswitch.org/) telephony appliance that runs on a
Raspberry Pi. Two analog phones (via an ATA) become the controls for a **motorized linear
actuator** and an intercom: lift a handset, navigate a short voice menu, and press a digit to
raise or lower the mechanism or ring the other phone.

This repository **is** the Pi's `/usr/local/freeswitch` directory, so it doubles as a complete,
redeployable backup of the appliance: binaries, configuration, sounds, and the relay-control
script are all here.

- **What it does:** analog phones → FreeSWITCH IVR → GPIO relays that drive a linear actuator.
- **How it's wired:** the actuator is driven by [`scripts/disco-relay`](scripts/disco-relay), a
  bash controller for a **Waveshare 3-relay HAT** (K1/K2 form the actuator's direction control,
  K3 is an auxiliary/lights relay).
- **Network model:** an isolated Ethernet segment (`192.168.50.0/24`). The phones register with
  no real authentication; safety comes from the isolated network plus an IP allow-list (ACL).

> **Version note:** this is FreeSWITCH **1.11.1** built from git *master* for **aarch64**
> (Raspberry Pi OS 64-bit, Debian 13 "trixie"). It is not a stable-release package.

---

## 1. Use case

The appliance turns a pair of ordinary POTS phones into a two-button remote plus intercom, with
no app, screen, or internet dependency:

1. An analog phone is plugged into an **ATA** (analog telephone adapter). The ATA registers to
   FreeSWITCH as SIP line **101** or **102** over the isolated LAN.
2. Picking up a phone (or dialing `700`) drops the caller into a **voice menu**.
3. Menu choices either **raise/lower the actuator** (via the relay HAT) or **intercom the other
   phone**. A hidden option lets you **re-record the menu greeting** from the handset itself.

Because everything is local and unauthenticated-by-design, the whole thing works on a closed
network with just the Pi, the ATA, and the phones.

---

## 2. Repository layout

This is a standard FreeSWITCH install tree. The **project-specific** parts are `conf/` and
`scripts/`; the rest is stock FreeSWITCH runtime kept here so the Pi can be rebuilt from the repo.

| Path | What it is | Custom? |
|---|---|---|
| [`conf/`](conf/) | All FreeSWITCH configuration — the heart of the project (see below). | **Yes** |
| [`scripts/disco-relay`](scripts/disco-relay) | Bash controller for the Waveshare 3-relay HAT (raise/lower/brake/K3 timing). | **Yes** |
| [`bin/`](bin/) | FreeSWITCH executables (`freeswitch`, `fs_cli`, …), **aarch64**. | stock |
| [`lib/`](lib/) | `libfreeswitch.so`. | stock |
| [`mod/`](mod/) | Loadable modules (`.so`), **aarch64**. Only a minimal set is used. | stock |
| [`include/`](include/) | FreeSWITCH C headers. | stock |
| [`sounds/`](sounds/) | Prompt audio and hold music. The recorded IVR greeting lives under `recordings/`. | stock + recording |
| [`fonts/`](fonts/), [`htdocs/`](htdocs/), [`images/`](images/) | Assets shipped with FreeSWITCH (unused by this appliance). | stock |
| [`certs/`](certs/) | TLS/DTLS certificates. | stock |
| `db/`, `log/`, `run/` | Runtime state (SQLite DBs, logs, PID). **Regenerated on boot; git-ignored.** | generated |
| [`.devcontainer/`](.devcontainer/), [`CODESPACES.md`](CODESPACES.md) | GitHub Codespaces setup (see below). | tooling |

### 2.1 `conf/` in detail

| File | Purpose |
|---|---|
| [`conf/freeswitch.xml`](conf/freeswitch.xml) | Root config: includes vars, autoload configs, the `default` dialplan, and the inline user directory. |
| [`conf/vars.xml`](conf/vars.xml) | Global settings: paths, the `192.168.50.1` bind IP, `PCMU` codec, and the `disco_raise`/`disco_lower` actuator commands. |
| [`conf/sip_profiles/ata.xml`](conf/sip_profiles/ata.xml) | The single SIP profile `ata`, bound to `192.168.50.1:5060`, tuned for POTS/ATA use (blind auth, RFC2833 DTMF, ACL-locked). |
| [`conf/directory/default/101.xml`](conf/directory/default/101.xml), [`102.xml`](conf/directory/default/102.xml) | The two SIP lines (passwords unused — blind registration). |
| [`conf/dialplan/default/`](conf/dialplan/default/) | Call routing and the IVR menu (see the dialplan section). |
| [`scripts/disco-messages`](scripts/disco-messages) | Message-store helper for the IVR (record rotation, playback navigation). |
| [`conf/autoload_configs/`](conf/autoload_configs/) | Per-module config. Notably `modules.conf.xml` (13 modules loaded), `acl.conf.xml` (`disco_ata_only` = `192.168.50.0/24`), `event_socket.conf.xml` (ESL on 127.0.0.1). |

---

## 3. Current dialplan & call flow

Every call from the ATA lands in the IVR, and each menu digit `transfer`s to a virtual
destination handled by the dialplan.

### 3.1 Entry — any call → the menu
[`99_all_calls_to_ivr.xml`](conf/dialplan/default/99_all_calls_to_ivr.xml): dialing `700` (the
ATA off-hook auto-dial), or **any** number from the ATA, is routed to the main menu at `700`.

### 3.2 The menu
[`00_disco_control.xml`](conf/dialplan/default/00_disco_control.xml) plays the greeting
(`recordings/main-menu.wav`) and collects the option with `play_and_get_digits` (1–3 digits, `*`
terminator, validated to the set below). The collected option is dispatched on a second routing
pass:

| Dial | Transfers to | Action |
|---|---|---|
| **1** | `DISCO_CALL_OTHER` | Intercom the *other* line |
| **2** | `DISCO_LEAVE` | Leave a message (max 60s) |
| **3** | `DISCO_LISTEN` | Listen to stored messages |
| **911** | `DISCO_RAISE` | Raise the disco ball |
| **411** | `DISCO_LOWER` | Lower the disco ball |
| **#** | `DISCO_STOP` | Stop the disco ball |

Anything else plays **one of six random "invalid" prompts** (from
[`scripts/disco-messages`](scripts/disco-messages) `invalid-prompt`). **Every** action — valid or
invalid — returns to the main menu.

### 3.3 The actions
[`00_disco_control.xml`](conf/dialplan/default/00_disco_control.xml):

- **Intercom (`DISCO_CALL_OTHER`)** — checks the caller's SIP user: from **101** it bridges to
  **102**, from **102** it bridges to **101** (with an "invalid entry" fallback). When the bridge
  ends it returns to the menu.
- **Raise / Lower (`DISCO_RAISE` / `DISCO_LOWER`)** — first read the ball's tracked position via
  `${system($${disco_position})}` (`up` / `down` / `unknown`). **911** raises unless the ball is
  already `up` (then it plays `disco-already-up.wav`); **411** lowers unless it is already `down`
  (then `disco-already-down.wav`). Otherwise it plays the raise/lower prompt, runs the relay, and
  returns to the menu.
- **Stop (`DISCO_STOP`)** — runs `disco-relay brake`, which cancels any movement **and resets the
  position to `unknown`** so either 911 or 411 will run next, then returns to the menu.
- **Position** is `unknown` at boot (and after `#`), so both 911 and 411 work; a completed raise
  sets `up` and a completed lower sets `down`. The state lives on `/run` (tmpfs), so it resets on
  reboot.

[`20_disco_messages.xml`](conf/dialplan/default/20_disco_messages.xml):

- **Leave (`DISCO_LEAVE`)** — plays a prompt and a beep, then records up to **60 s** to
  `recordings/messages/msg_<timestamp>_<uuid>.wav`. `record_min_sec=2` discards no-speech
  recordings. Messages are **kept on disk**; `disco-messages rotate` only prunes the oldest when
  free space runs low.
- **Listen (`DISCO_LISTEN`)** — plays the **newest 10** messages **oldest-first**. During a
  message, **1 = previous** and **2 = next**; when a message finishes with no key it
  **auto-advances**, and after the last one it returns to the menu. No other actions on messages
  are possible. The browse loop (`DISCO_MSG_PLAY` → `DISCO_MSG_NAV`) uses `disco-messages`
  `resolve`/`step` to map the index to a file.

### 3.4 The relay controller
[`scripts/disco-relay`](scripts/disco-relay) translates `raise`/`lower`/`brake`/`status`/`position`
into timed GPIO relay states on the Waveshare HAT:

- **K1/K2** drive the actuator motor: `raise` = `motor_up` (K1 on), `lower` = `motor_down`
  (K2 on), `brake` = `motor_stop` (both off).
- **K3** is the **spot lights**, switched (`spot_lights_on`/`spot_lights_off`) at a configurable
  percentage of the travel time.
- `raise`/`lower` take a **non-blocking** `flock` and run the movement in the **background**: if
  the lock is already held they print `busy` and change nothing, otherwise they print `started`.
  A completed raise records `up`, a completed lower records `down`.
- `brake` **preempts** — it signals the in-progress movement (tracked via
  `/run/disco-relay.pid`) to stop, forces the motor off, and resets the position to `unknown`.
- `status` reports the relay states, tracked position, and whether a movement is running;
  `position` prints `up`/`down`/`unknown` (stored in `/run/disco-relay.state`, so `unknown` at
  boot).

`disco_raise=... raise 5 15` means: drive for **5 seconds**, switching the spot lights at **15%**
of that time. Tune these in [`conf/vars.xml`](conf/vars.xml).

### 3.5 The message store
[`scripts/disco-messages`](scripts/disco-messages) manages `recordings/messages/` for the IVR
(runs as the `freeswitch` user — no sudo). It exposes the **newest 10** recordings for playback in
the order received, discards no-speech files, resolves an index to a file for playback, steps the
next/previous index, and returns a random invalid prompt. Older messages are **kept on disk** and
pruned oldest-first only when free space is low. All output is newline-free for use in
`${system(...)}`.

---

## 4. Open in GitHub Codespaces

You can edit — and, where the host allows, **run** — this project in the browser. Two dev
container configurations are provided; Codespaces lets you choose at creation time:

| Configuration | Use it to |
|---|---|
| **Disco - FreeSWITCH (arm64 emulated)** | Boot the repo's own aarch64 FreeSWITCH under QEMU emulation and call-test the dialplan/IVR/relay logic. Includes a softphone + GPIO simulation. |
| **Disco - Editor only** | Edit config/scripts in the browser (no FreeSWITCH runtime). Use if emulation isn't available on your host. |

**To open one:** on GitHub, click **Code ▸ Codespaces ▸ ⋯ ▸ New with options…**, pick the
**Dev container configuration** from the dropdown, and choose a **2-core / 4 GB** (or larger)
machine.

Once the emulated Codespace is running:

```bash
uname -m                          # -> aarch64  (emulation is working)
fs_cli -x version                 # -> 1.11.1

fs-start -nc                      # boot FreeSWITCH in the background
fs_cli -x 'sofia status'          # ata profile bound to 192.168.50.1:5060

sudo disco-relay raise 5 15       # simulate the actuator (logged, no hardware)
tail -f /var/log/disco-gpio.log   # watch the simulated relay activity

bash .devcontainer/common/softphone-test.sh   # register 101/102 and drive the IVR
```

**Limitations of the Codespace** (details in [`CODESPACES.md`](CODESPACES.md)): emulation is
slower than the Pi and real-time audio may be imperfect; there is no physical GPIO (relay actions
are logged, not moved); and no external phone/ATA can reach a Codespace (SIP/RTP are UDP, which
Codespaces doesn't forward). Physical testing stays on the Pi.

---

## 5. Quick deployment

The fastest path from a blank SD card to a working appliance. Every persistent step is baked
into [`install.sh`](install.sh); only the OS image and the ATA web UI are configured by hand.

### 5.1 Create the OS image

Use **Raspberry Pi Imager** with the latest 64-bit Raspberry Pi OS (Lite is preferred — the
installer strips the desktop anyway). In the imager's advanced options set:

```text
Hostname:       bella-novella
Username:       bella
Enable SSH:     yes
Wi-Fi:          your management SSID + password
Wi-Fi country:  US
Locale/timezone: your locale
```

Boot the Pi, then SSH in over Wi-Fi:

```sh
ssh bella@bella-novella.local     # or ssh bella@<pi-wifi-ip>
```

### 5.2 Clone this repo to the FreeSWITCH prefix

The repository **is** `/usr/local/freeswitch`, so clone it directly to that path:

```sh
sudo mkdir -p /usr/local/freeswitch
sudo chown "$USER":"$USER" /usr/local/freeswitch
git clone https://github.com/k-anderson/bella-novella.git /usr/local/freeswitch
cd /usr/local/freeswitch
```

### 5.3 Run the installer

On a brand-new Pi, run the full bootstrap plus the isolated ATA network. SpanDSP and Sofia-SIP
are only needed if you intend to (re)build FreeSWITCH — include those flags on the first install:

```sh
sudo ./install.sh --fresh --network --build-spandsp --build-sofia
```

After the first `--fresh` run, reboot so the service pruning, `gpu_mem`, and CPU-governor
changes take full effect:

```sh
sudo reboot
```

### 5.4 Configure the Grandstream HT812 ATA

Plug the ATA into `eth0`; it receives `192.168.50.100–192.168.50.150` from the Pi's DHCP scope.
Find its lease and open its web UI (tunnel from your laptop if needed):

```sh
cat /var/lib/misc/dnsmasq.leases
ssh -N -L 8080:192.168.50.<lease-ip>:80 bella@bella-novella.local   # then open http://localhost:8080
```

Set (see [6.11](#611-configure-the-grandstream-ht812-manual) for the full field list):

```text
Primary SIP Server: 192.168.50.1     SIP Transport: UDP     Registration: Yes
FXS 1: SIP User ID 101, Off-hook Auto-Dial 700
FXS 2: SIP User ID 102, Off-hook Auto-Dial 700
Vocoders: PCMU only     DTMF: RFC2833
```

Apply and reboot the ATA. Lift a handset — you should hear the IVR.

### 5.5 Verify

```sh
fs_cli -x "status"
fs_cli -x "sofia status profile ata"
fs_cli -x "show registrations"       # 101 and 102 registered
sudo /usr/local/freeswitch/scripts/disco-relay status
```

---

## 6. Manual deployment

This section reproduces **exactly what [`install.sh`](install.sh) does**, step by step, with the
real commands so you can copy them to the Pi one block at a time and see what each stage changes
(and why). Running the installer is the fast path; doing it by hand is the learning path — the
end state is identical.

All commands assume you are `root` and sitting in the repo. Start each session with:

```sh
sudo -i
cd /usr/local/freeswitch
```

> Steps 6.1, 6.3, 6.4, and 6.6 map to the `--fresh`, `--build-spandsp`, `--build-sofia`, and
> `--network` flags respectively. Steps 6.2 and 6.5–6.10 run on **every** `install.sh` invocation.

### 6.1 Fresh-Pi bootstrap (`--fresh`)

One-time OS preparation. Safe to skip on routine repo-update runs.

**Install the build toolchain, FreeSWITCH runtime libraries, and admin tools** — everything
needed to (re)build SpanDSP/Sofia/FreeSWITCH and to operate/debug the appliance:

```sh
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
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
  linux-cpupower
```

**Create the `freeswitch` system user/group** and hand it the install tree. FreeSWITCH runs as
its own unprivileged user, not root:

```sh
groupadd -r freeswitch 2>/dev/null || true
useradd -r -g freeswitch -d /usr/local/freeswitch -s /usr/sbin/nologin freeswitch 2>/dev/null || true
chown -R freeswitch:freeswitch /usr/local/freeswitch
```

**Create the source-build directory** used by the optional SpanDSP/Sofia/FreeSWITCH builds:

```sh
mkdir -p /usr/local/src
chown -R root:root /usr/local/src
```

**Disable desktop/bloat services** the appliance never uses, and **mask**
`NetworkManager-wait-online` (it otherwise blocks boot ~6 s waiting for the network):

```sh
for svc in avahi-daemon triggerhappy ModemManager rpcbind nfs-blkmap \
           udisks2 packagekit accounts-daemon lightdm cups; do
  systemctl disable --now "$svc" 2>/dev/null || true
done
systemctl disable --now NetworkManager-wait-online 2>/dev/null || true
systemctl mask NetworkManager-wait-online 2>/dev/null || true
```

**Purge cloud-init** (only if present — a stock Pi image should not have it) to shave boot time:

```sh
if dpkg -l cloud-init 2>/dev/null | grep -q '^ii'; then
  apt-get purge -y cloud-init
  rm -rf /etc/cloud /var/lib/cloud
fi
```

**Boot to a headless target** — no display manager, no desktop:

```sh
systemctl set-default multi-user.target
```

**Strip the Raspberry Pi desktop stack.** This is safe to run on an already-headless (Lite)
image — missing packages are ignored:

```sh
apt-get purge -y \
  lightdm 'rpd-*' 'wf-panel-pi' 'wfplug-*' wayvnc rpi-connect \
  pipewire pipewire-pulse wireplumber 'xdg-desktop-portal*' \
  rpi-chromium-mods rpi-firefox-mods rpi-imager rp-bookshelf \
  piclone rpicam-apps rpinters pi-printer-support cups 2>/dev/null || true
apt-get autoremove --purge -y
```

**Give the headless GPU the minimum memory** (installer edits whichever config exists):

```sh
sed -i 's/^[[:space:]]*gpu_mem=.*/gpu_mem=16/' /boot/firmware/config.txt \
  || printf '\ngpu_mem=16\n' >> /boot/firmware/config.txt
```

**Pin the CPU to the `performance` governor**, persisted across reboots, so frequency scaling
doesn't disturb media timing:

```sh
cpupower frequency-set -g performance || true
cat >/etc/default/cpupower <<'EOF'
GOVERNOR="performance"
EOF
systemctl enable --now cpupower.service
```

**Stop the `ondemand` governor service.** Raspberry Pi OS ships an `ondemand` unit that sets the
governor at boot *after* `cpupower.service`, silently undoing the `performance` setting above:

```sh
systemctl disable --now ondemand
```

**Disable swap** — on a media appliance any swapping can cause audio glitches, so turn it off
entirely rather than relying on low `swappiness`:

```sh
command -v dphys-swapfile >/dev/null && dphys-swapfile swapoff || true
systemctl disable --now dphys-swapfile
swapoff -a
```

**Reduce SD-card writes** — mount root `noatime` and keep the systemd journal in RAM (the
persistent journal is the single biggest source of avoidable SD writes and the latency spikes
they cause):

```sh
# Add noatime to the root mount only if it isn't already set (backup first).
if ! awk '$2=="/"{print $4}' /etc/fstab | grep -q noatime; then
  cp -a /etc/fstab "/etc/fstab.backup.$(date +%Y%m%d-%H%M%S)"
  sed -i -E '/[[:space:]]\/[[:space:]]/ s/(defaults)/\1,noatime/' /etc/fstab
fi

mkdir -p /etc/systemd/journald.conf.d
cat >/etc/systemd/journald.conf.d/99-freeswitch.conf <<'EOF'
[Journal]
Storage=volatile
RuntimeMaxUse=64M
EOF
systemctl restart systemd-journald
```

**Arm the hardware watchdog** so an unattended appliance auto-reboots if it ever hard-hangs
(takes effect on the next reboot):

```sh
mkdir -p /etc/systemd/system.conf.d
cat >/etc/systemd/system.conf.d/99-freeswitch-watchdog.conf <<'EOF'
[Manager]
RuntimeWatchdogSec=15s
RebootWatchdogSec=2min
EOF
```

Reboot once after the fresh bootstrap so service pruning, `gpu_mem`, the governor, and the
watchdog take full effect:

```sh
reboot
```

### 6.2 Install system files

Copy the tracked host configuration from [`system/`](system/) into place. The installer backs up
any existing file first (`.backup.<timestamp>`); by hand you can skip the backups. Each file and
its purpose:

```sh
# PATH + persisted PKG_CONFIG_PATH (so SpanDSP/Sofia builds are found after a reboot).
install -D -m 0644 system/etc/profile.d/freeswitch-path.sh      /etc/profile.d/freeswitch-path.sh
install -D -m 0644 system/etc/profile.d/freeswitch-pkgconfig.sh /etc/profile.d/freeswitch-pkgconfig.sh

# Keep eth0's static IP up even with no cable plugged in.
install -D -m 0644 system/etc/NetworkManager/conf.d/99-eth0-ignore-carrier.conf \
  /etc/NetworkManager/conf.d/99-eth0-ignore-carrier.conf

# Disable IP forwarding + file-handle/socket/RTP-buffer/swappiness tuning.
install -D -m 0644 system/etc/sysctl.d/98-no-routing.conf /etc/sysctl.d/98-no-routing.conf
install -D -m 0644 system/etc/sysctl.d/99-freeswitch.conf       /etc/sysctl.d/99-freeswitch.conf
sysctl --system

# Helper that blocks FreeSWITCH startup until eth0 has 192.168.50.1.
install -D -m 0755 system/usr/local/bin/freeswitch-wait-eth0 /usr/local/bin/freeswitch-wait-eth0

# systemd unit (NoNewPrivileges=no so the IVR can 'sudo disco-relay') + resource limits.
install -D -m 0644 system/etc/systemd/system/freeswitch.service /etc/systemd/system/freeswitch.service
install -D -m 0644 system/etc/security/limits.d/99-freeswitch.conf /etc/security/limits.d/99-freeswitch.conf

systemctl daemon-reload
```

Load the new PATH/PKG_CONFIG in your current shell without logging out:

```sh
source /etc/profile.d/freeswitch-path.sh
source /etc/profile.d/freeswitch-pkgconfig.sh
```

### 6.3 Build SpanDSP (`--build-spandsp`)

Optional. Debian's packaged SpanDSP (`0.0.6`) is too old for this FreeSWITCH build, so it is
compiled from source into `/usr/local`. Needed on a fresh install or when SpanDSP is updated:

```sh
cd /usr/local/src
git clone https://github.com/freeswitch/spandsp.git   # or: cd spandsp && git pull --ff-only
cd spandsp
./bootstrap.sh
./configure --prefix=/usr/local
make -j"$(nproc)"
make install
ldconfig
pkg-config --modversion spandsp    # verify: a modern version, not 0.0.6
```

Installer equivalent: `sudo ./install.sh --build-spandsp`.

### 6.4 Build Sofia-SIP (`--build-sofia`)

Optional. Same rationale — compiled from source into `/usr/local`. The persisted
`PKG_CONFIG_PATH` from [6.2](#62-install-system-files) is what lets FreeSWITCH find it:

```sh
cd /usr/local/src
git clone https://github.com/freeswitch/sofia-sip.git   # or: cd sofia-sip && git pull --ff-only
cd sofia-sip
./bootstrap.sh
./configure --prefix=/usr/local
make -j"$(nproc)"
make install
ldconfig
pkg-config --modversion sofia-sip-ua    # verify it resolves
```

Installer equivalent: `sudo ./install.sh --build-sofia`.

### 6.5 Validate required modules

Confirm every module the appliance loads is present under [`mod/`](mod/) before continuing — a
missing `.so` means FreeSWITCH won't start with this config:

```sh
cd /usr/local/freeswitch
for mod in mod_console mod_logfile mod_timerfd mod_posix_timer mod_event_socket \
           mod_sofia mod_commands mod_dptools mod_dialplan_xml mod_local_stream \
           mod_native_file mod_sndfile mod_tone_stream mod_say_en; do
  if [ -f "mod/${mod}.so" ]; then echo "OK: ${mod}"; else echo "MISSING: ${mod}" >&2; fi
done
```

### 6.6 Configure the isolated ATA network (`--network`)

Give `eth0` a static `192.168.50.1/24`, keep it off the default route (Wi-Fi stays the management
network), disable routing, and hand out DHCP to the ATA only.

**Keep the static IP up without a cable, then create/prime the `eth0` profile:**

```sh
mkdir -p /etc/NetworkManager/conf.d
cat >/etc/NetworkManager/conf.d/99-eth0-ignore-carrier.conf <<'EOF'
[device]
match-device=interface-name:eth0
ignore-carrier=true
EOF
nmcli general reload

# If a stock 'netplan-eth0'/DHCP profile exists, stop it auto-connecting.
nmcli con mod netplan-eth0 connection.autoconnect no 2>/dev/null || true

nmcli con add type ethernet ifname eth0 con-name disco-ata-eth0 \
  connection.autoconnect yes \
  ipv4.method manual ipv4.addresses 192.168.50.1/24 \
  ipv4.never-default yes ipv4.ignore-auto-dns yes ipv6.method disabled \
  2>/dev/null \
|| nmcli con mod disco-ata-eth0 \
  connection.interface-name eth0 connection.autoconnect yes \
  ipv4.method manual ipv4.addresses 192.168.50.1/24 \
  ipv4.never-default yes ipv4.ignore-auto-dns yes ipv6.method disabled
nmcli con up disco-ata-eth0
```

**Disable IP forwarding** so the ATA segment can't route out over Wi-Fi:

```sh
cat >/etc/sysctl.d/98-no-routing.conf <<'EOF'
net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0
EOF
sysctl --system
```

**Install the DHCP-only dnsmasq scope** (hands out `192.168.50.100–150`, advertises **no**
gateway or DNS) and restart it:

```sh
install -m 0644 system/etc/dnsmasq.d/eth0.conf /etc/dnsmasq.d/eth0.conf
systemctl enable dnsmasq
systemctl restart dnsmasq
```

### 6.7 Relay script permissions and sudoers

Lock down [`scripts/disco-relay`](scripts/disco-relay) and grant the `bella` and `freeswitch`
users passwordless `sudo` to **only** that script (so the IVR can drive the actuator):

```sh
chown root:root scripts/disco-relay
chmod 0755 scripts/disco-relay

install -m 0440 system/etc/sudoers.d/disco-relay /etc/sudoers.d/disco-relay
visudo -c    # validate sudoers syntax
```

### 6.8 Initialize the relays

Put the actuator into the known brake/default state (K1/K2 off) before FreeSWITCH starts:

```sh
scripts/disco-relay brake
scripts/disco-relay status
```

### 6.9 Recordings directory and fallback prompt

Create the recordings directory and, if no greeting has been recorded yet, symlink a stock
prompt in as a placeholder so the IVR has audio on first boot (option `9` overwrites
`recordings/main-menu.wav` from the handset):

```sh
mkdir -p /usr/local/freeswitch/recordings
FALLBACK=/usr/local/freeswitch/sounds/en/us/callie/ivr/ivr-welcome_to_freeswitch.wav
[ -e /usr/local/freeswitch/recordings/main-menu.wav ]       || ln -s "$FALLBACK" /usr/local/freeswitch/recordings/main-menu.wav
[ -e /usr/local/freeswitch/recordings/main-menu-short.wav ] || ln -s "$FALLBACK" /usr/local/freeswitch/recordings/main-menu-short.wav
```

### 6.10 Install FreeSWITCH configuration and start

Install [`conf/`](conf/) from the repo, own it as `freeswitch`, sanity-check the key files, then
enable and start the service:

```sh
# (Optional) back up any existing live config first.
[ -d /usr/local/freeswitch/conf ] && cp -a /usr/local/freeswitch/conf \
  "/usr/local/freeswitch/conf.backup.$(date +%Y%m%d-%H%M%S)"

# Since the repo IS /usr/local/freeswitch, conf/ is already in place; just fix ownership.
chown -R freeswitch:freeswitch /usr/local/freeswitch/conf /usr/local/freeswitch/recordings

# Sanity-check the critical config files exist.
test -f /usr/local/freeswitch/conf/freeswitch.xml
test -f /usr/local/freeswitch/conf/autoload_configs/modules.conf.xml
test -f /usr/local/freeswitch/conf/sip_profiles/ata.xml
test -f /usr/local/freeswitch/conf/dialplan/default/00_disco_control.xml

systemctl enable freeswitch
systemctl restart freeswitch
sleep 2
systemctl --no-pager --full status freeswitch

fs_cli -x status
fs_cli -x "sofia status profile ata"
fs_cli -x "show registrations"
```

### 6.11 Configure the Grandstream HT812 (manual)

The one step that cannot be scripted — the ATA is configured through its own web UI. In the
HT812:

```text
Basic:  Mode: Bridge, IP: DHCP
SIP profile:
  Primary SIP Server: 192.168.50.1
  Outbound Proxy: blank        SIP Transport: UDP
  NAT Traversal: No            SIP Registration: Yes
  Unregister on Reboot: Yes    Random SIP/RTP Port: No
Audio:
  Preferred Vocoder 1-4: PCMU  Silence Suppression: No
  DTMF: RFC2833                Jitter Buffer: Adaptive, Low/Medium
FXS Port 1: SIP User ID 101, Authenticate ID 101, Off-hook Auto-Dial 700
FXS Port 2: SIP User ID 102, Authenticate ID 102, Off-hook Auto-Dial 700
```

Apply and reboot the ATA, then confirm with `fs_cli -x "show registrations"`.

---

## 7. Updating an existing deployment

Because the whole install tree is tracked (minus runtime-generated files), an existing Pi is
updated by pulling the repo and re-running the installer **without** `--fresh`:

```sh
cd /usr/local/freeswitch
git pull
sudo ./install.sh
```

Add `--build-spandsp` and/or `--build-sofia` only when those libraries need rebuilding. Only
`db/*.db`, `log/*`, `run/*.pid`, `recordings/*`, and `*.backup.*` are excluded from the repo —
they are regenerated or recorded on the device.

---

## 8. Optional: build FreeSWITCH from scratch

The repo ships prebuilt aarch64 binaries, so this is **not** required. Build from source only to
upgrade FreeSWITCH itself. The build list in [`build/modules.conf`](build/modules.conf) compiles
**only** the modules this appliance loads, keeping the build fast and the tree small.

```sh
cd /usr/local/src
git clone https://github.com/signalwire/freeswitch.git
cd freeswitch

# Use this repo's minimal module list.
cp /usr/local/freeswitch/build/modules.conf /usr/local/src/freeswitch/modules.conf

./bootstrap.sh -j
./configure --prefix=/usr/local/freeswitch
make -j"$(nproc)"
sudo make install
```

Install sounds and hold music:

```sh
cd /usr/local/src/freeswitch
sudo make sounds-install
sudo make moh-install
```

> **Audio note:** optional HD sounds are fine, but the ATA path is narrowband G.711/PCMU. For
> best compatibility, prompts used by the IVR should be 8 kHz mono WAV, or at least tested
> through the ATA.

SpanDSP and Sofia-SIP are dependencies of this build — install them first with
`sudo ./install.sh --build-spandsp --build-sofia` (see [6.3](#63-build-spandsp---build-spandsp)
and [6.4](#64-build-sofia-sip---build-sofia)).

