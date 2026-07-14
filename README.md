# bella-novella — a FreeSWITCH appliance

A self-contained [FreeSWITCH](https://freeswitch.org/) telephony appliance that runs on a
Raspberry Pi. Up to four analog phones (via a single 4-port ATA) become the controls for a
**motorized linear actuator** and an intercom: lift a handset, navigate voice menus that respect
bella's personality, and press a digit to raise or lower the mechanism or ring another phone.

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

The appliance turns a set of ordinary POTS phones into a small remote plus intercom, with no app,
screen, or internet dependency:

1. Analog phones plug into a single 4-port **ATA** (analog telephone adapter), which registers
   each one to FreeSWITCH as a SIP line over the isolated LAN: **101** and **102** for the
   participants, **104** for the concierge (the driver/passenger phone), and **103** as a spare
   for future expansion.
2. Picking up a phone (or dialing `700`) drops the caller into a **voice menu**.
3. **Intercom** — dial `1` to ring the other participant line (101 ↔ 102).
4. **Listen to messages** — dial `2` to hear the messages callers have left, newest first.
5. **Leave a message** — dial `3` to record a message into the store.
6. **Dial a line directly** — dial `101`–`104` to ring that specific phone, or `0` to reach the
   concierge (line 104).
7. **Raise / lower / stop the actuator** — dial `911` to raise, `411` to lower, and `11` to stop
   the "disco ball" (the motorized mirror), via the relay HAT.
8. **Hidden — branching story** — dial `9` (never announced) for Bella's branching fable.
9. **Hidden — guess-my-number game** — dial `5` (never announced) to play.
10. **Hidden — the message drawer** — after listening to every message, dial `9` to browse the
    full archive, where `7` deletes the current message.

Because everything is local and unauthenticated-by-design, the whole thing works on a closed
network with just the Pi, the ATA, and the phones.

---

## 2. Repository layout

This is a standard FreeSWITCH install tree. The **project-specific** parts are `conf/` and
`scripts/`; the rest is stock FreeSWITCH runtime kept here so the Pi can be rebuilt from the repo.

| Path | What it is | Custom? |
|---|---|---|
| [`conf/`](conf/) | All FreeSWITCH configuration — the heart of the project (see below). | **Yes** |
| [`scripts/`](scripts/) | Project bash/Python helpers: `disco-relay` (relay HAT), `bella-messages` (message store), `bella-game` (hidden number game), `bella-ring` (periodic ring), `bella-convert-prompts` (MP3→WAV), `bella-regen-prompts` (ElevenLabs TTS). Documented per-script in [§4](#4-the-scripts). | **Yes** |
| [`prompts/`](prompts/) | Custom Bella voice prompts: MP3 sources plus the generated 8 kHz mono WAVs — the full menu greeting and its nine short variants, ten invalid-entry scolds, per-message playback announcements, the disco and message prompts, the branching story (`tale-*`), and the game (`game-*`, including randomized intro/win/lose and higher/lower variants). | **Yes** |
| [`system/`](system/) | Host files installed by `install.sh`: the `freeswitch` and `bella-ring` systemd units, plus sysctl/limits/sudoers/dnsmasq/NetworkManager drop-ins and helper scripts. Also carries the **optional** `wifi-fallback` unit + script (see [§10](#10-optional-wi-fi-fallback-and-hotspot)). | **Yes** |
| [`build/`](build/) | [`build/modules.conf`](build/modules.conf) — the minimal module list used to (re)build FreeSWITCH from source (see [§9](#9-optional-build-freeswitch-from-scratch)). | **Yes** |
| [`bin/`](bin/) | FreeSWITCH executables (`freeswitch`, `fs_cli`, …), **aarch64**. | stock |
| [`lib/`](lib/) | `libfreeswitch.so`. | stock |
| [`mod/`](mod/) | Loadable modules (`.so`), **aarch64**. Only a minimal set is used. | stock |
| [`include/`](include/) | FreeSWITCH C headers. | stock |
| [`fonts/`](fonts/), [`htdocs/`](htdocs/), [`images/`](images/) | Assets shipped with FreeSWITCH (unused by this appliance). | stock |
| [`certs/`](certs/) | TLS/DTLS certificates. | stock |
| `db/`, `log/`, `run/` | Runtime state (SQLite DBs, logs, PID). **Regenerated on boot; git-ignored.** | generated |
| [`recordings/`](recordings/) | Caller messages recorded by the IVR (`recordings/messages/`). **Git-ignored** (the folder is kept via `.gitkeep`). | generated |
| [`.devcontainer/`](.devcontainer/), [`CODESPACES.md`](CODESPACES.md) | GitHub Codespaces setup (see below). | tooling |

### 2.1 `conf/` in detail

| File | Purpose |
|---|---|
| [`conf/freeswitch.xml`](conf/freeswitch.xml) | Root config: includes vars, autoload configs, the `default` dialplan, and the inline user directory. |
| [`conf/vars.xml`](conf/vars.xml) | Global settings: paths, the `192.168.50.1` bind IP, `PCMU` codec, the actuator commands (`disco_raise`/`disco_lower`/`disco_stop`/`disco_position`), the message-store helper (`bella_messages`), and the hidden number-game helper (`bella_game`, `game_tries_max`). |
| [`conf/sip_profiles/ata.xml`](conf/sip_profiles/ata.xml) | The single SIP profile `ata`, bound to `192.168.50.1:5060`, tuned for POTS/ATA use (blind auth, RFC2833 DTMF, ACL-locked). |
| [`conf/directory/default/`](conf/directory/default/) | The four SIP lines — [`101.xml`](conf/directory/default/101.xml)/[`102.xml`](conf/directory/default/102.xml) (participants), [`103.xml`](conf/directory/default/103.xml) (spare), [`104.xml`](conf/directory/default/104.xml) (concierge). Passwords unused — blind registration. |
| [`conf/dialplan/default/`](conf/dialplan/default/) | Call routing and the IVR: `00_extensions.xml` (dial 101–104), `10_inbound_and_menu.xml` (menu 700), `20_option1_intercom.xml`, `30_option2_listen.xml`, `40_option3_leave.xml`, `50_disco_controls.xml`, `60_option9_tale.xml`, `70_option5_game.xml` (see [§3](#3-current-dialplan--call-flow)). |
| [`conf/autoload_configs/`](conf/autoload_configs/) | Per-module config. Notably `modules.conf.xml` (13 modules loaded), `acl.conf.xml` (`bella_ata_only` = `192.168.50.0/24`), `event_socket.conf.xml` (ESL on 127.0.0.1). |

---

## 3. Current dialplan & call flow

Every call from the ATA lands in the IVR, and each menu digit `transfer`s to a virtual
destination handled by the dialplan.

### 3.1 Entry — any call → the menu
[`10_inbound_and_menu.xml`](conf/dialplan/default/10_inbound_and_menu.xml) (`all-calls-to-menu`):
dialing `700` (the ATA off-hook auto-dial), or **any** number from the ATA, is routed to the main
menu at `700` — except the explicit line numbers `101`–`104`, which
[`00_extensions.xml`](conf/dialplan/default/00_extensions.xml) matches first (it sorts before the
menu file) so they ring the phone directly instead of being swallowed by the catch-all.

### 3.2 The menu
[`10_inbound_and_menu.xml`](conf/dialplan/default/10_inbound_and_menu.xml) plays the greeting and
collects the option with `play_and_get_digits` (1–3 digits, `*` terminator, validated to the set
`^(0|1|2|3|5|9|911|411|10[1-4]|11)$`). The **full** greeting (`prompts/main-menu.wav`) plays once
at the start of the call; every return to the menu thereafter plays **one of nine random short
greetings** (`prompts/main-menu-short-variant-1..9.wav`, via
[`scripts/bella-messages`](scripts/bella-messages) `short-menu-prompt`) — tracked by the
`menu_greeted` channel variable. The collected option (`bella_opt`) is dispatched on a second
routing pass:

| Dial | Transfers to | Action |
|---|---|---|
| **1** | `CALL_OTHER` | Intercom the *other* participant line (101 ↔ 102) |
| **2** | `LISTEN_MESSAGES` | Listen to stored messages |
| **3** | `LEAVE_MESSAGE` | Leave a message (max 60s) |
| **101**–**104** | `101`…`104` | Dial that SIP line directly (`00_extensions.xml`) |
| **0** | `104` | Dial the concierge (line 104) |
| **911** | `DISCO_RAISE` | Raise the disco ball |
| **411** | `DISCO_LOWER` | Lower the disco ball |
| **11** | `DISCO_STOP` | Stop the disco ball |
| **9** | `TALE_OPEN` | *(hidden, unspoken)* Bella reads a branching story — see §3.7 |
| **5** | `GAME_START` | *(hidden, unspoken)* Guess-my-number game — see §3.8 |

Anything else plays **one of ten random "invalid" prompts** (`prompts/invalid-entry-1..10.wav`,
via [`scripts/bella-messages`](scripts/bella-messages) `invalid-prompt`). A valid option pressed
over that prompt is acted on immediately; another invalid key plays a fresh scold — Bella keeps
scolding until a valid option is pressed or the caller stays silent (a timeout), which returns to
the menu greeting. Completed actions return to the menu.

> **Hidden options.** The spoken greeting only offers **1**, **2**, and **3**. Everything else on the
> menu is *unannounced* and spreads by word of mouth: dialing a line directly (**101**–**104**, or
> **0** for the concierge), the disco controls (**911** raise, **411** lower, **11** stop), the
> branching story (**9**, see §3.7), the guess-my-number game (**5**, see §3.8), and the message
> drawer reached after listening to everything (see §3.9). Bella hints that there's more — *"one of
> the ones I don't say out loud"* — but never names them.

### 3.3 The actions

- **Intercom (`CALL_OTHER`)** — [`20_option1_intercom.xml`](conf/dialplan/default/20_option1_intercom.xml):
  checks the caller's SIP user: from **101** it bridges to **102**, from **102** it bridges to
  **101**, with a ringback tone while the far phone rings. If the other line doesn't answer (or
  the call arrives from an unexpected line) it plays `no-answer.wav`. Either way it returns to the
  menu when finished.
- **Dial a line (`101`–`104`, or `0`)** — [`00_extensions.xml`](conf/dialplan/default/00_extensions.xml):
  each line has an explicit extension that bridges to that phone with ringback; on no-answer/busy
  it plays `no-answer.wav` and returns to the menu. Menu option **0** transfers to **104** (the
  concierge).
- **Listen (`LISTEN_MESSAGES`)** — [`30_option2_listen.xml`](conf/dialplan/default/30_option2_listen.xml):
  plays the **newest 10** messages **newest-first**, each preceded by its numbered announcement
  (`prompts/playback-announcement-<idx>.wav`) as a lead-in prompt. During a message, **1 = next**
  and **2 = previous**; navigating by key (or pressing a key during an announcement) **skips the
  announcement** and plays the message directly. When a message finishes with no key it
  **auto-advances** to the next message *with* its announcement, and after the last one it returns
  to the menu. The browse loop (`MESSAGE_ANN` → `MESSAGE_PLAY` → `MESSAGE_NAV`) uses `bella-messages`
  `announcement`/`resolve`/`step` to map the index to files.
- **Leave (`LEAVE_MESSAGE`)** — [`40_option3_leave.xml`](conf/dialplan/default/40_option3_leave.xml):
  plays a prompt and a beep, then records up to **60 s** to
  `recordings/messages/msg_<timestamp>_<uuid>.wav`. `record_min_sec=2` discards no-speech
  recordings. Messages are **kept on disk**; `bella-messages rotate` only prunes the oldest when
  free space runs low.
- **Disco ball (`DISCO_RAISE` / `DISCO_LOWER` / `DISCO_STOP`)** —
  [`50_disco_controls.xml`](conf/dialplan/default/50_disco_controls.xml): each reads the ball's
  tracked position via `${system($${disco_position})}` (`up` / `down` / `unknown`). **911** raises
  unless already `up` (plays `disco-already-up.wav`); **411** lowers unless already `down` (plays
  `disco-already-down.wav`); **11** runs `disco-relay brake`, which cancels any movement **and
  resets the position to `unknown`** so either 911 or 411 will run next. Every path returns to the
  menu. Position is `unknown` at boot and after `11` (state lives on `/run`, tmpfs).

### 3.4 The relay controller
[`scripts/disco-relay`](scripts/disco-relay) translates `raise`/`lower`/`brake`/`status`/`position`
into timed GPIO relay states on the Waveshare HAT:

- **K1/K2** drive the actuator motor: `raise` = `motor_up` (K1 on), `lower` = `motor_down`
  (K2 on), `brake` = `motor_stop` (both off).
- **K3** is the **spot lights**: on a `raise` they turn **on** after a configurable percentage of
  the travel time and stay on; on a `lower` they start on and turn **off** after that percentage.
- `raise`/`lower` take a **non-blocking** `flock` and run the movement in the **background**: if
  the lock is already held they print `busy` and change nothing, otherwise they print `started`.
  A completed raise records `up`, a completed lower records `down`.
- `brake` **preempts** — it signals the in-progress movement (tracked via
  `/run/disco-relay.pid`) to stop, forces the motor off, and resets the position to `unknown`.
- `status` reports the relay states, tracked position, and whether a movement is running;
  `position` prints `up`/`down`/`unknown` (stored in `/run/disco-relay.state`, so `unknown` at
  boot).

The commands in [`conf/vars.xml`](conf/vars.xml) set the timing: `disco_raise` runs
`disco-relay raise 120 75` (drive **120 s**; spot lights **on** after **75%** of that time) and
`disco_lower` runs `disco-relay lower 120 5` (drive **120 s**; spot lights **off** after **5%**).
Tune the seconds and percentages there.

### 3.5 The message store
[`scripts/bella-messages`](scripts/bella-messages) manages `recordings/messages/` for the IVR
(runs as the `freeswitch` user — no sudo). It exposes the **newest 10** recordings for playback
newest-first, resolves an index to a file, maps an index to its lead-in announcement, steps the
next/previous index, and returns random invalid / short-menu prompts. It also backs the hidden
message **drawer** (§3.9) with commands over the **full** archive — `count-all`, `resolve-all`,
`step-all`, `drawer-start`, and `delete-all` (which removes a recording, after which every index
re-lists as if it had never been stored). Older messages are **kept on disk** and pruned
oldest-first only when free space is low. All output is newline-free for use in `${system(...)}`.
See [§4.2](#42-bella-messages) for the full command list.

### 3.6 The periodic ring
At a random interval between **15 and 45 minutes** a systemd timer runs
[`scripts/bella-ring`](scripts/bella-ring), which picks
one of the two lines (101/102) at random and, if it is registered, `originate`s a call to it via
the local event socket. When the handset is answered it is routed to extension `700` — the main
menu. If the line isn't registered (ATA unplugged, off-hook, FreeSWITCH down) it logs and exits
quietly. The schedule lives in
[`system/etc/systemd/system/bella-ring.timer`](system/etc/systemd/system/bella-ring.timer) /
[`bella-ring.service`](system/etc/systemd/system/bella-ring.service); `install.sh` enables the
timer.

### 3.7 Hidden — the branching story (`9`)
Dialing **`9`** (never announced) opens **"The Ember"**, a short branching fable Bella reads aloud
from her lounge. Each node narrates and collects one digit; the choices lead to one of **five
endings**, each a small moral that reflects the path taken. An invalid key plays a story-specific
prompt and re-offers the node, so the caller stays inside the story; endings return to the menu.
The nodes live in [`60_option9_tale.xml`](conf/dialplan/default/60_option9_tale.xml); the tree,
choice table, and full prompt scripts are in [`STORY.md`](STORY.md). Prompts: `prompts/tale-*.wav`.

### 3.8 Hidden — "guess my number" (`5`)
Dialing **`5`** (never announced) starts a keypad guessing game. Bella picks a secret number
**1–9**; each single keypress is a guess, and she answers with a random *higher* / *lower* until
the caller wins or runs out of tries (default **3**, tunable via `game_tries_max` in
[`conf/vars.xml`](conf/vars.xml)). She never reveals the number on a loss. The intro, win, lose,
and higher/lower prompts each have several interchangeable variants, chosen at random per call.
The comparison, randomness, and variant selection live in
[`scripts/bella-game`](scripts/bella-game) (`secret` / `verdict` / `incr` / `hint` / `pick`),
driven by [`70_option5_game.xml`](conf/dialplan/default/70_option5_game.xml); see
[`GAME.md`](GAME.md). Prompts: `prompts/game-*.wav`.

### 3.9 Hidden — the message drawer & delete (`9`, then `7`)
When the curated listen session (§3.3) reaches the end — after the newest ten messages — Bella
plays a reflective sign-off (`prompts/playback-end.wav`). Pressing **`9`** while it plays opens
**"Bella's drawer of secrets"**: the **full** message archive, newest-first, continuing past the
curated window into every stored recording (no lead-in announcements; a short tone separates each
message). Inside the drawer, **1** = next, **2** = previous, **7** = **delete** the current
message, any other key replays it, and no key auto-advances. Because
[`scripts/bella-messages`](scripts/bella-messages) re-lists the store on every call, a delete
takes effect immediately and the indices renumber as if the message had never existed. Reaching
the oldest message signs off and returns to the menu. Lives in
[`30_option2_listen.xml`](conf/dialplan/default/30_option2_listen.xml) (`PLAYBACK_END_KEY`,
`DRAWER_*`), backed by `bella-messages` `resolve-all` / `step-all` / `delete-all` / `drawer-start`.

---

## 4. The scripts

The project-specific helpers in [`scripts/`](scripts/) back the dialplan and the build/deploy
tooling. The IVR calls the runtime helpers via `${system(...)}`; the two prompt tools run at
build/deploy time. All output from the runtime helpers is newline-free so it can be dropped
straight into dialplan variables.

### 4.1 `disco-relay`
Drives the **Waveshare 3-relay HAT** that moves the linear actuator ("disco ball") and its spot
lights. It sets the active-low GPIO lines via `pinctrl` (or `raspi-gpio`): **K1/K2** form the
motor's direction control and **K3** switches the spot lights. `raise`/`lower` take a non-blocking
`flock` and run the timed movement in the **background** (printing `started`, or `busy` if a
movement already holds the lock); `brake` preempts an in-progress movement. The tracked position
lives in `/run` (tmpfs), so it reads `unknown` at boot and after a brake. Needs `sudo` (GPIO
access); the IVR is granted passwordless sudo to just this script.

| Command | Arguments | What it does |
|---|---|---|
| `raise` | `<seconds> [on_after_percent]` | Drive the motor up for `<seconds>`; turn the spot lights **on** after `on_after_percent`% of that time (default 50) and leave them on. Records position `up`. |
| `lower` | `<seconds> [off_after_percent]` | Drive the motor down for `<seconds>`; lights start on and turn **off** after `off_after_percent`% of that time (default 50). Records position `down`. |
| `brake` | — | Immediately stop the motor and cancel any movement; reset position to `unknown`. |
| `status` | — | Print the relay states, the tracked position, and whether a movement is running. |
| `position` | — | Print `up`, `down`, or `unknown`. |

```sh
sudo disco-relay raise 120 75     # raise over 120s; lights on after 75%
sudo disco-relay lower 120 5      # lower over 120s; lights off after 5%
sudo disco-relay brake
sudo disco-relay status
```

### 4.2 `bella-messages`
The IVR message store over `recordings/messages/` (recorded as `msg_<timestamp>_<uuid>.wav`, so a
lexical sort is chronological). Runs as the `freeswitch` user — no sudo. The IVR plays back the
newest `PLAYBACK_LIMIT` (**10**) messages; older ones are kept on disk and pruned oldest-first
only when free space drops below `MIN_FREE_MB` (**200**). The `*-all` commands back the hidden
message drawer (§3.9) over the full archive.

| Command | Arguments | What it does |
|---|---|---|
| `rotate` | — | Prune the oldest messages **only** when disk space is low (never the newest 10). |
| `count` | — | Number of playable messages (≤ 10). |
| `resolve` | `<index>` | Absolute path of the 1-based Nth playable message (newest-first). |
| `announcement` | `<index>` | Lead-in announcement WAV for the Nth message, or empty if none. |
| `step` | `<index> next\|prev` | Next/previous clamped index (`0` = past the end). |
| `count-all` | — | Total number of stored messages (full archive). |
| `resolve-all` | `<index>` | Like `resolve`, but over the full archive. |
| `step-all` | `<index> next\|prev` | Like `step`, but clamped to the full archive. |
| `delete-all` | `<index>` | Delete the Nth full-archive message; remaining indices renumber at once. |
| `drawer-start` | — | Full-archive index just past the playback window (`PLAYBACK_LIMIT+1`), or `0`. |
| `invalid-prompt` | — | Random `invalid-entry-*.wav` (one of ten). |
| `short-menu-prompt` | — | Random `main-menu-short-variant-*.wav` (one of nine). |

### 4.3 `bella-game`
Stateless helper for the hidden guess-my-number game (menu option 5). The dialplan holds the
per-call state (secret, tries) in channel variables and calls this for the secret, the verdict,
the counter bump, and the random prompt variants. Runs as the `freeswitch` user.

| Command | Arguments | What it does |
|---|---|---|
| `secret` | `<min> <max>` | Random integer in `[min,max]` (empty on bad args). |
| `verdict` | `<min> <max> <secret> <guess> <tries> <maxtries>` | One of `bad` / `hit` / `high` / `low` / `lose`. |
| `incr` | `<n>` | Print `n+1` (missing/invalid `n` treated as 0). |
| `hint` | `high\|low` | Path of a random `game-higher-*.wav` / `game-lower-*.wav`. |
| `pick` | `<prefix>` | Path of a random `<prefix>-*.wav` (e.g. `game-intro`, `game-win`, `game-lose`). |

### 4.4 `bella-ring`
The periodic-ring helper (no arguments). Invoked by the `bella-ring.timer` systemd timer at a
random interval (15–45 min), it picks one of the two participant lines (**101**/**102**) at
random and, over the local event socket (`127.0.0.1:8021`), `originate`s a call to it; on answer
the phone is routed to the menu (`700`). If the chosen line isn't registered it logs and exits
quietly. Tunable via the environment: `FS_CLI`, `BELLA_DOMAIN`, `BELLA_RING_TIMEOUT`.

### 4.5 `bella-convert-prompts`
Rebuilds the prompt **WAVs** (8 kHz mono) from their MP3 sources in `prompts/`. By default it only
(re)generates WAVs that are missing or older than their MP3; pass `--force` to rebuild every WAV.
Run by [`install.sh`](install.sh) and by `bella-regen-prompts` after synthesis.

```sh
bella-convert-prompts            # only missing/changed
bella-convert-prompts --force    # rebuild all
```

### 4.6 `bella-regen-prompts`
Re-synthesizes the voice prompts from [`PROMPTS.md`](PROMPTS.md) using the custom **Bella Novella**
voice on ElevenLabs, then rebuilds the WAVs via `bella-convert-prompts`. It diffs each prompt
against [`PROMPTS.baseline.md`](PROMPTS.baseline.md) so only edited prompts are regenerated.
**Run it on a developer machine, not the appliance** (it needs network + an API key).

| Option | What it does |
|---|---|
| `--all`, `--force` | Regenerate every prompt, ignoring the baseline diff. |
| `--prompt NAME` | Regenerate only the named prompt (repeatable), bypassing the diff. |
| `--dry-run` | Show what would change; don't call the API or write files. |
| `--list` | List every prompt parsed from `PROMPTS.md` and exit. |
| `--no-convert` | Skip the MP3 → WAV conversion step. |
| `--model ID` | ElevenLabs model id (default `eleven_v3`). |
| `--voice NAME` | Look up the voice by name instead of the built-in id. |
| `--voice-id ID` | Use this voice id directly. |
| `-h`, `--help` | Show help. |

Environment: `ELEVENLABS_API_KEY` (required unless `--dry-run`/`--list`), `BELLA_VOICE_NAME`,
`BELLA_VOICE_ID`, `BELLA_TTS_MODEL`, `BELLA_PROMPTS_DIR`.

```sh
export ELEVENLABS_API_KEY=...
bella-regen-prompts              # regenerate only what changed
bella-regen-prompts --list       # list every parsed prompt
bella-regen-prompts --all        # regenerate everything
```

---

## 5. Open in GitHub Codespaces

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

## 6. Quick deployment

The fastest path from a blank SD card to a working appliance. Every persistent step is baked
into [`install.sh`](install.sh); only the OS image and the ATA web UI are configured by hand.

### 6.1 Create the OS image

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

### 6.2 Clone this repo to the FreeSWITCH prefix

The repository **is** `/usr/local/freeswitch`, so clone it directly to that path:

```sh
sudo mkdir -p /usr/local/freeswitch
sudo chown "$USER":"$USER" /usr/local/freeswitch
git clone https://github.com/k-anderson/bella-novella.git /usr/local/freeswitch
cd /usr/local/freeswitch
```

### 6.3 Run the installer

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

### 6.4 Configure the Grandstream HT814 ATA

Plug the ATA into `eth0`; it receives `192.168.50.100–192.168.50.150` from the Pi's DHCP scope.
Find its lease and open its web UI (tunnel from your laptop if needed):

```sh
cat /var/lib/misc/dnsmasq.leases
ssh -N -L 8080:192.168.50.<lease-ip>:80 bella@bella-novella.local   # then open http://localhost:8080
```

Set (see [7.11](#711-configure-the-grandstream-ht814-manual) for the full field list):

```text
Primary SIP Server: 192.168.50.1     SIP Transport: UDP     Registration: Yes
FXS 1: SIP User ID 101, Off-hook Auto-Dial 700
FXS 2: SIP User ID 102, Off-hook Auto-Dial 700
FXS 3: SIP User ID 103, Off-hook Auto-Dial 700
FXS 4: SIP User ID 104, Off-hook Auto-Dial 700
Vocoders: PCMU only     DTMF: RFC2833
```

Apply and reboot the ATA. Lift a handset — you should hear the IVR.

### 6.5 Verify

```sh
fs_cli -x "status"
fs_cli -x "sofia status profile ata"
fs_cli -x "show registrations"       # 101–104 registered
sudo /usr/local/freeswitch/scripts/disco-relay status
```

---

## 7. Manual deployment

This section reproduces **exactly what [`install.sh`](install.sh) does**, step by step, with the
real commands so you can copy them to the Pi one block at a time and see what each stage changes
(and why). Running the installer is the fast path; doing it by hand is the learning path — the
end state is identical.

All commands assume you are `root` and sitting in the repo. Start each session with:

```sh
sudo -i
cd /usr/local/freeswitch
```

> Steps 7.1, 7.3, 7.4, and 7.6 map to the `--fresh`, `--build-spandsp`, `--build-sofia`, and
> `--network` flags respectively. Steps 7.2 and 7.5–7.10 run on **every** `install.sh` invocation.

### 7.1 Fresh-Pi bootstrap (`--fresh`)

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

### 7.2 Install system files

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

# Periodic-ring timer/service: ring a random line every 15-45 min -> the menu.
install -D -m 0644 system/etc/systemd/system/bella-ring.service /etc/systemd/system/bella-ring.service
install -D -m 0644 system/etc/systemd/system/bella-ring.timer   /etc/systemd/system/bella-ring.timer

systemctl daemon-reload
systemctl enable --now bella-ring.timer
```

Load the new PATH/PKG_CONFIG in your current shell without logging out:

```sh
source /etc/profile.d/freeswitch-path.sh
source /etc/profile.d/freeswitch-pkgconfig.sh
```

### 7.3 Build SpanDSP (`--build-spandsp`)

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

### 7.4 Build Sofia-SIP (`--build-sofia`)

Optional. Same rationale — compiled from source into `/usr/local`. The persisted
`PKG_CONFIG_PATH` from [7.2](#72-install-system-files) is what lets FreeSWITCH find it:

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

### 7.5 Validate required modules

Confirm every module the appliance loads is present under [`mod/`](mod/) before continuing — a
missing `.so` means FreeSWITCH won't start with this config:

```sh
cd /usr/local/freeswitch
for mod in mod_console mod_logfile mod_timerfd mod_posix_timer mod_event_socket \
           mod_sofia mod_commands mod_dptools mod_dialplan_xml \
           mod_native_file mod_sndfile mod_tone_stream mod_say_en; do
  if [ -f "mod/${mod}.so" ]; then echo "OK: ${mod}"; else echo "MISSING: ${mod}" >&2; fi
done
```

### 7.6 Configure the isolated ATA network (`--network`)

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

nmcli con add type ethernet ifname eth0 con-name bella-ata-eth0 \
  connection.autoconnect yes \
  ipv4.method manual ipv4.addresses 192.168.50.1/24 \
  ipv4.never-default yes ipv4.ignore-auto-dns yes ipv6.method disabled \
  2>/dev/null \
|| nmcli con mod bella-ata-eth0 \
  connection.interface-name eth0 connection.autoconnect yes \
  ipv4.method manual ipv4.addresses 192.168.50.1/24 \
  ipv4.never-default yes ipv4.ignore-auto-dns yes ipv6.method disabled
nmcli con up bella-ata-eth0
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

### 7.7 Relay script permissions and sudoers

Lock down [`scripts/disco-relay`](scripts/disco-relay) and grant the `bella` and `freeswitch`
users passwordless `sudo` to **only** that script (so the IVR can drive the actuator):

```sh
chown root:root scripts/disco-relay
chmod 0755 scripts/disco-relay

install -m 0440 system/etc/sudoers.d/disco-relay /etc/sudoers.d/disco-relay
visudo -c    # validate sudoers syntax
```

### 7.8 Initialize the relays

Put the actuator into the known brake/default state (K1/K2 off) before FreeSWITCH starts:

```sh
scripts/disco-relay brake
scripts/disco-relay status
```

### 7.9 Prompts and message directories

The custom voice prompts — menu greeting (and its short variants), disco-ball, message,
invalid-entry, playback-announcement, story (`tale-*`), and game (`game-*`) — ship in `prompts/`
as 8 kHz mono WAV and are tracked in the repo. Just create the runtime directory the IVR records
caller messages into:

```sh
mkdir -p /usr/local/freeswitch/prompts /usr/local/freeswitch/recordings/messages
```

### 7.10 Install FreeSWITCH configuration and start

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
test -f /usr/local/freeswitch/conf/dialplan/default/10_inbound_and_menu.xml

systemctl enable freeswitch
systemctl restart freeswitch
sleep 2
systemctl --no-pager --full status freeswitch

fs_cli -x status
fs_cli -x "sofia status profile ata"
fs_cli -x "show registrations"
```

### 7.11 Configure the Grandstream HT814 (manual)

The one step that cannot be scripted — the ATA is configured through its own web UI. In the
HT814:

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
FXS Port 3: SIP User ID 103, Authenticate ID 103, Off-hook Auto-Dial 700
FXS Port 4: SIP User ID 104, Authenticate ID 104, Off-hook Auto-Dial 700
```

Apply and reboot the ATA, then confirm with `fs_cli -x "show registrations"`.

---

## 8. Updating an existing deployment

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

## 9. Optional: build FreeSWITCH from scratch

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

> **Audio note:** this appliance ships **no stock sound set** — every prompt is a custom 8 kHz
> mono WAV under `prompts/`, and hold music is silence. `make sounds-install`/`make moh-install`
> are therefore not needed. The ATA path is narrowband G.711/PCMU, so any prompt you add should be
> 8 kHz mono WAV (or at least tested through the ATA).

SpanDSP and Sofia-SIP are dependencies of this build — install them first with
`sudo ./install.sh --build-spandsp --build-sofia` (see [7.3](#73-build-spandsp---build-spandsp)
and [7.4](#74-build-sofia-sip---build-sofia)).

---

## 10. Optional: Wi-Fi fallback and hotspot

An **optional** convenience for a roaming appliance (e.g. on an art car): keep the Pi reachable
over Wi-Fi by auto-joining a known network when one is in range, and otherwise starting its own
access point. This is **not** run by [`install.sh`](install.sh) — the unit and script ship in
[`system/`](system/) and are wired up by hand.

[`wifi-fallback.sh`](system/usr/local/bin/wifi-fallback.sh) runs every **2 minutes** (via
[`wifi-fallback.timer`](system/etc/systemd/system/wifi-fallback.timer)). It rescans `wlan0`,
connects to the highest-priority known NetworkManager profile that is in range, and if none are
found brings up a hotspot profile instead. The profile names it looks for are set at the top of
the script (`KNOWN_CONS=("Location1" "Location2")`, `HOTSPOT_CON="Hotspot"`).

**1. Define your known networks** (repeat per site; highest `autoconnect-priority` wins) and the
fallback hotspot AP. The `con-name`s must match the names in the script:

```sh
# A known network (add Location2, Location3, … the same way).
sudo nmcli connection add type wifi ifname wlan0 con-name "Location1" ssid "YOUR_SSID" \
  wifi-sec.key-mgmt wpa-psk wifi-sec.psk "YOUR_PASSWORD" \
  connection.autoconnect yes connection.autoconnect-priority 100

# The fallback hotspot (NetworkManager shares the wlan0 radio as an AP).
sudo nmcli connection add type wifi ifname wlan0 con-name "Hotspot" ssid "bella-novella" \
  802-11-wireless.mode ap 802-11-wireless.band bg \
  ipv4.method shared connection.autoconnect no
```

**2. Install the script and timer:**

```sh
sudo install -D -m 0755 system/usr/local/bin/wifi-fallback.sh /usr/local/bin/wifi-fallback.sh
sudo install -D -m 0644 system/etc/systemd/system/wifi-fallback.service /etc/systemd/system/wifi-fallback.service
sudo install -D -m 0644 system/etc/systemd/system/wifi-fallback.timer   /etc/systemd/system/wifi-fallback.timer
sudo systemctl daemon-reload
sudo systemctl enable --now wifi-fallback.timer
```

**3. Test it once immediately:**

```sh
sudo systemctl start wifi-fallback.service
journalctl -t wifi-fallback -n 20
```