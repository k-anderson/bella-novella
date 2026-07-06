# Editing & testing this project in GitHub Codespaces

This repo is a copy of the Raspberry Pi's `/usr/local/freeswitch` tree for the **disco**
telephony appliance (FreeSWITCH 1.11.1, aarch64). These dev containers let you edit the config
and scripts on GitHub and — where the host allows it — run the project's *own* binaries and
call-test them, without a Pi, GPIO HAT, ATA, or physical phones.

## Two configurations

When you create a Codespace, GitHub asks which dev container to use:

| Configuration | What it does | When to use |
|---|---|---|
| **Disco - FreeSWITCH (arm64 emulated)** | Runs the repo's aarch64 FreeSWITCH under QEMU emulation; includes the call-simulation harness. | You want to boot FreeSWITCH and test dialplan / IVR / relay behavior. |
| **Disco - Editor only** | Plain x86_64 container, just VS Code + XML/shell tooling. | Quick edits, or if emulation isn't available on your host. |

> The binaries in `bin/`, `lib/`, `mod/` are **ARM (Raspberry Pi)**. A normal x86_64 Codespace
> cannot execute them, which is why the runnable configuration emulates an arm64 machine. If that
> configuration fails to build or start (some hosts disallow the QEMU registration step), just
> recreate the Codespace with **Editor only** — your files are all still there to edit.

## How the emulated configuration works

- `.devcontainer/freeswitch-arm64/Dockerfile` — `FROM --platform=linux/arm64 debian:bookworm`
  (matches Raspberry Pi OS bookworm) plus the shared libraries the binaries need and a headless
  softphone (`baresip`).
- `initializeCommand` registers the QEMU `aarch64` binfmt handler so the arm64 image can run on
  the x86_64 host.
- `.devcontainer/common/setup.sh` (post-create) makes the checkout behave like the Pi:
  - symlinks the repo to `/usr/local/freeswitch` (so `base_dir` in `conf/vars.xml` matches and
    the committed binaries/config/sounds are what run);
  - adds `192.168.50.1/24` to `lo` so `mod_sofia` can bind the isolated ATA address and a local
    softphone can register (within the `disco_ata_only` ACL);
  - installs **GPIO command stubs** (`pinctrl`, `raspi-gpio`) so the real `scripts/disco-relay`
    runs unchanged — every relay action is logged to `/var/log/disco-gpio.log` instead of moving
    hardware;
  - links `disco-relay` to `/usr/local/bin/` (where `conf/vars.xml` expects it) and installs the
    `fs-start` launcher.

## Running FreeSWITCH

```bash
fs-start              # foreground console (Ctrl-C to stop)
fs-start -nc          # run in the background

fs_cli                # attach (defaults: 127.0.0.1:8021 / ClueCon)
fs_cli -x 'sofia status'          # ata profile should be bound to 192.168.50.1:5060
fs_cli -x 'reloadxml'             # after editing conf/
```

`fs-start` sets `LD_LIBRARY_PATH` to the repo's `lib/` and points FreeSWITCH at the repo's
`conf/ mod/ db/ log/ run/`.

## Simulating the actuator (no hardware)

The IVR runs `sudo /usr/local/freeswitch/scripts/disco-relay raise|lower ...` via `bgsystem`. You can also run it
directly:

```bash
sudo disco-relay raise 5 15     # honors real timing; logs K1/K2/K3 transitions
sudo disco-relay lower 5 15
sudo disco-relay status

tail -f /var/log/disco-gpio.log  # watch the simulated relay activity
```

## Full call test (IVR + DTMF + intercom)

With FreeSWITCH running:

```bash
fs-start -nc
bash .devcontainer/common/softphone-test.sh
```

This registers lines **101** and **102** (blind auth) as `baresip` softphones. Line 102 auto-
answers in the background; line 101 is interactive. In the `baresip` console:

```
/dial 700     # reach the main menu
2             # raise  -> see /var/log/disco-gpio.log
3             # lower
1             # intercom -> rings line 102
9             # record a new greeting
b             # hang up
/quit
```

## Limitations (why this isn't a full substitute for the Pi)

- **Emulation is slow.** Fine for exercising dialplan/IVR/DTMF and relay *logic*; real-time audio
  fidelity under QEMU may be imperfect.
- **No real GPIO.** Relay actions are simulated and logged, never physical.
- **No external phones/ATA.** SIP and RTP are UDP; Codespaces only forwards TCP over HTTPS, so a
  real phone can't register to a Codespace. Physical-phone testing stays on the Pi.
- The softphone/audio wiring in `softphone-test.sh` is the piece most likely to need a small tweak
  the first time you run it under emulation — adjust the `baresip` module lines if registration or
  media misbehave.

## Deploying back to the Pi

Nothing here changes the deployable tree. On the Pi, `git pull` into `/usr/local/freeswitch` (or
re-clone) still yields a complete, runnable install: the aarch64 `bin/ lib/ mod/`, `conf/`,
`sounds/` (including recorded greetings), and `scripts/` are all tracked. Only runtime-generated
files (`db/*.db`, `log/*.log`, `run/*.pid`) and `*.backup.*` are ignored.
