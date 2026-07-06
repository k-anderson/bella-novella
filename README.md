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
> (Raspberry Pi OS bookworm). It is not a stable-release package.

---

## Use case

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

## Repository layout

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
| [`sounds/`](sounds/) | Prompt audio and hold music. The recorded IVR greeting lives under `sounds/en/us/callie/disco/`. | stock + recording |
| [`fonts/`](fonts/), [`htdocs/`](htdocs/), [`images/`](images/) | Assets shipped with FreeSWITCH (unused by this appliance). | stock |
| [`certs/`](certs/) | TLS/DTLS certificates. | stock |
| `db/`, `log/`, `run/` | Runtime state (SQLite DBs, logs, PID). **Regenerated on boot; git-ignored.** | generated |
| [`.devcontainer/`](.devcontainer/), [`CODESPACES.md`](CODESPACES.md) | GitHub Codespaces setup (see below). | tooling |

### `conf/` in detail

| File | Purpose |
|---|---|
| [`conf/freeswitch.xml`](conf/freeswitch.xml) | Root config: includes vars, autoload configs, the `default` dialplan, and the inline user directory. |
| [`conf/vars.xml`](conf/vars.xml) | Global settings: paths, the `192.168.50.1` bind IP, `PCMU` codec, and the `disco_raise`/`disco_lower` actuator commands. |
| [`conf/sip_profiles/ata.xml`](conf/sip_profiles/ata.xml) | The single SIP profile `ata`, bound to `192.168.50.1:5060`, tuned for POTS/ATA use (blind auth, RFC2833 DTMF, ACL-locked). |
| [`conf/directory/default/101.xml`](conf/directory/default/101.xml), [`102.xml`](conf/directory/default/102.xml) | The two SIP lines (passwords unused — blind registration). |
| [`conf/dialplan/default/`](conf/dialplan/default/) | Call routing (see the dialplan section). |
| [`conf/ivr_menus/disco_main_menu.xml`](conf/ivr_menus/disco_main_menu.xml) | The voice menu definition and digit→action mapping. |
| [`conf/autoload_configs/`](conf/autoload_configs/) | Per-module config. Notably `modules.conf.xml` (13 modules loaded), `acl.conf.xml` (`disco_ata_only` = `192.168.50.0/24`), `event_socket.conf.xml` (ESL on 127.0.0.1). |

---

## Current dialplan & call flow

Every call from the ATA lands in the IVR, and each menu digit `transfer`s to a virtual
destination handled by the dialplan.

### 1. Entry — any call → IVR
[`99_all_calls_to_ivr.xml`](conf/dialplan/default/99_all_calls_to_ivr.xml): dialing `700`, or
**any** number from the ATA, answers the call and runs the `disco_main_menu` IVR.

### 2. The menu
[`disco_main_menu.xml`](conf/ivr_menus/disco_main_menu.xml) plays the greeting
(`sounds/en/us/callie/disco/main-menu.wav`) and maps single digits:

| Digit | Transfers to | Action |
|---|---|---|
| **1** | `DISCO_CALL_OTHER` | Intercom the *other* line |
| **2** | `DISCO_RAISE` | Raise / extend the actuator |
| **3** | `DISCO_LOWER` | Lower / retract the actuator |
| **9** | `DISCO_RECORD_GREETING` | Re-record the menu greeting (hidden/admin) |

### 3. The actions
[`00_disco_control.xml`](conf/dialplan/default/00_disco_control.xml):

- **Intercom (`DISCO_CALL_OTHER`)** — checks the caller's SIP user: from **101** it bridges to
  **102**, from **102** it bridges to **101** (with an "invalid entry" fallback for anything
  else). `hangup_after_bridge` ends the call when the parties hang up.
- **Raise (`DISCO_RAISE`)** — runs `bgsystem $${disco_raise}` (→
  `sudo /usr/local/bin/disco-relay raise 5 15`) and plays a **rising** tone sweep, then hangs up.
- **Lower (`DISCO_LOWER`)** — runs `bgsystem $${disco_lower}` (→ `disco-relay lower 5 15`) and
  plays a **falling** tone sweep, then hangs up.

[`10_disco_record_greeting.xml`](conf/dialplan/default/10_disco_record_greeting.xml):

- **Record greeting (`DISCO_RECORD_GREETING`)** — plays a start tone, records up to 30s over the
  existing `main-menu.wav`, plays it back for review, then returns to the menu (`700`) so you can
  hear it live.

### The relay controller
[`scripts/disco-relay`](scripts/disco-relay) translates `raise`/`lower`/`brake`/`initialize` into
timed GPIO relay states on the Waveshare HAT:

- **K1/K2** set actuator direction: `raise` = K1 on, `lower` = K2 on, `brake` = both off.
- **K3** is an auxiliary relay toggled at a configurable percentage of the travel time.
- A `flock` guard prevents overlapping actuator commands from simultaneous calls.

`disco_raise=... raise 5 15` means: drive for **5 seconds**, switching K3 at **15%** of that
time. Tune these in [`conf/vars.xml`](conf/vars.xml).

---

## Open in GitHub Codespaces

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

## Redeploying to the Pi

Because the whole install tree is tracked (minus runtime-generated files), a fresh Pi can be
brought up by placing this repo at `/usr/local/freeswitch`. The relay script is expected at
`/usr/local/bin/disco-relay` with a passwordless sudo rule for the FreeSWITCH user (that sudoers
entry is host configuration and is intentionally **not** in this repo). Only `db/*.db`, `log/*`,
`run/*.pid`, and `*.backup.*` are excluded — they regenerate on first boot.
