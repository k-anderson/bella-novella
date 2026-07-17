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

### Contents

- [1. Use case](#1-use-case)
- [2. Discoveries](#2-discoveries)
- [3. Repository layout](#3-repository-layout)
- [4. Current dialplan & call flow](#4-current-dialplan--call-flow)
- [5. The scripts](#5-the-scripts)
- [6. Open in GitHub Codespaces](#6-open-in-github-codespaces)
- [7. Quick deployment](#7-quick-deployment)
- [8. Manual deployment](#8-manual-deployment)
- [9. Updating an existing deployment](#9-updating-an-existing-deployment)
- [10. Optional: build FreeSWITCH from scratch](#10-optional-build-freeswitch-from-scratch)
- [11. Optional: Wi-Fi fallback and hotspot](#11-optional-wi-fi-fallback-and-hotspot)

### Documentation

Other Markdown documents in this repo:

- [`BELLA-NOVELLA.md`](BELLA-NOVELLA.md): Bella's character bible — the personality and backstory every prompt draws from.
- [`PROMPTS.md`](PROMPTS.md): Source text for every voice prompt, plus how to (re)generate them (§5.7).
- [`PROMPTS.baseline.md`](PROMPTS.baseline.md): Baseline snapshot of the prompt text; `bella-regen-prompts` diffs against it to regenerate only what changed.
- [`STORY.md`](STORY.md): Design notes and the full prompt scripts for the hidden branching story "The Ember" (§4.7).
- [`GAME.md`](GAME.md): Design notes and the full prompt scripts for the hidden guess-my-number game (§4.8).
- [`SURVEY.md`](SURVEY.md): Design notes and the prompt scripts for the hidden principles survey (dial `9`).
- [`CODESPACES.md`](CODESPACES.md): GitHub Codespaces / dev-container usage and its limitations (§6).

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
6. **Hidden — Dial a line directly** — dial `101`–`104` to ring that specific phone, or `0` to reach the
   concierge (line 104).
7. **Hidden — Raise / lower / stop the actuator** — dial `911` to raise, `811` to lower, and `11` to stop
   the "disco ball" (the motorized mirror), via the relay HAT.
8. **Hidden — branching story** — dial `7` (never announced) for Bella's branching fable.
9. **Hidden — guess-my-number game** — dial `5` (never announced) to play.
10. **Hidden — principles survey** — dial `9` (never announced) to vote on which of ten
    outlooks fits you right now, hear Bella's take, and where your pick stands with past callers.
11. **Hidden — the message drawer** — dial `9` at any time while messages play (or after the
    last one) to open the full archive at the current message, where `7` deletes the current message.
12. **Hidden — about** — dial `411` (never announced) for Bella's technical details.    

Because everything is local and unauthenticated-by-design, the whole thing works on a closed
network with just the Pi, the ATA, and the phones.

---

## 2. Discoveries

The plain menu only ever offers **1**, **2**, and **3**; everything else is earned through interaction. Bella's hidden
features (§4) don't just *do* things — they hand the persistent caller fragments of her backstory,
and quiet tips toward the phone system's own hidden controls, one secret at a time. Every reveal
ends the same way: she tells you to *"tell the concierge,"* an out-of-band wink that turns a
discovered secret into a real-world passphrase.

**Backstory a caller can uncover:**

| Discovery | What the caller learns | How to reach it |
|---|---|---|
| **Her real name — Ilaria Kalergis** | The name she went by before "Bella", traded away "before this city, this room, all of it" — and never worn since. | Win the guess-my-number game (dial **5**, §4.8) — `game-win-1`. |
| **Her grandmother — Despina Novella** | The grandmother who raised her and taught her that the safest place for a secret is a trusted person; the reason she runs the room the way she does. | Win the game (dial **5**, §4.8) — `game-win-2`. |
| **Her lost love — Tobi** | The owner of "that old phone" she keeps connecting callers to (the intercom line, option 1): a brief, intense romance cut short when she was forced to leave. She still dials it some nights — it's never them. | Win the game (dial **5**, §4.8) — `game-win-3`. |
| **A city she once visited — Salzburg** | Where she once "burned a book or two"; offered explicitly as a passphrase — *"tell the concierge you once met me in Salzburg, there might be something in it for you."* | Reach the **"revel"** ending of the branching story (dial **7**, §4.7): choose **2** (feed the ember) → **1** (burn the whole book) → `tale-end-revel`. |

**Hidden phone features a caller can be tipped off to:** two of the winning prompts don't hand over
backstory — they point the caller toward controls the spoken menu never mentions:

| Tip | What it points to | Prompt |
|---|---|---|
| **The broken mirror / disco ball** | Hints that the mirror salvaged from the fire is "just hidden" and can "scatter light in the darkness once more" if you "listen carefully" — a nudge toward the unspoken disco-ball controls (**911** raise, **811** lower, **11** stop; §4.6). The main-menu greetings (notably short variants 3 and 8) drop the matching hint that an *emergency* number brings the light back. | `game-win-4` |
| **Bella's drawer of secrets** | Tells the winner she keeps *every* message, not just the last ten, and that dialing **9** at the "that's all of the messages I care to share right now" sign-off keeps going into the full archive — the hidden message drawer (§4.4). | `game-win-5` |

A few things worth knowing:

- **The reveals are spread across the five winning prompts** (`game-win-1..5`), and Bella plays
  **one at random** each time you win (`bella-messages pick game-win`, §5.2). Winning repeatedly is how
  you surface all of them — a single win only ever reveals one.
- **The concierge is the recurring thread.** Nearly every secret closes by pointing back to the
  same concierge; sharing what you found with the team gives them the real prize (a drink, 3D printed bella car, 1 hr with Taylor, ect).
- **The discoverable lore and tips live entirely in the prompt scripts** in
  [`PROMPTS.md`](PROMPTS.md). Editing or regenerating those prompts (`bella-regen-prompts`, §5.7)
  changes what — and how much — a caller can find, so keep this list in sync with the `game-win-*`
  and `tale-end-*` scripts.

---

## 3. Repository layout

This is a standard FreeSWITCH install tree. The **project-specific** parts are `conf/` and
`scripts/`; the rest is stock FreeSWITCH runtime kept here so the Pi can be rebuilt from the repo.

| Path | What it is | Custom? |
|---|---|---|
| [`conf/`](conf/) | All FreeSWITCH configuration — the heart of the project (see below). | **Yes** |
| [`scripts/`](scripts/) | Project bash/Python helpers: `disco-relay` (relay HAT), `bella-messages` (message store), `bella-game` (hidden number game), `bella-survey` (principles survey tally), `bella-ring` (periodic ring), `bella-convert-prompts` (MP3→WAV), `bella-regen-prompts` (ElevenLabs TTS). Documented per-script in [§5](#5-the-scripts). | **Yes** |
| [`prompts/`](prompts/) | Custom Bella voice prompts: MP3 sources plus the generated 8 kHz mono WAVs — the full menu greeting and its nine short variants, ten invalid-entry scolds, per-message playback announcements, the disco and message prompts, the branching story (`tale-*`), the game (`game-*`, including randomized intro/win/lose and higher/lower variants), and the principles survey (`survey-*`). | **Yes** |
| [`system/`](system/) | Host files installed by `install.sh`: the `freeswitch` and `bella-ring` systemd units, plus sysctl/limits/sudoers/dnsmasq/NetworkManager drop-ins and helper scripts. Also carries the **optional** `wifi-fallback` unit + script (see [§11](#11-optional-wi-fi-fallback-and-hotspot)). | **Yes** |
| [`build/`](build/) | [`build/modules.conf`](build/modules.conf) — the minimal module list used to (re)build FreeSWITCH from source (see [§10](#10-optional-build-freeswitch-from-scratch)). | **Yes** |
| [`bin/`](bin/) | FreeSWITCH executables (`freeswitch`, `fs_cli`, …), **aarch64**. | stock |
| [`lib/`](lib/) | `libfreeswitch.so`. | stock |
| [`mod/`](mod/) | Loadable modules (`.so`), **aarch64**. Only a minimal set is used. | stock |
| [`include/`](include/) | FreeSWITCH C headers. | stock |
| [`fonts/`](fonts/), [`htdocs/`](htdocs/), [`images/`](images/) | Assets shipped with FreeSWITCH (unused by this appliance). | stock |
| [`certs/`](certs/) | TLS/DTLS certificates. | stock |
| `db/`, `log/`, `run/` | Runtime state (logs, PID). The SQLite core/registration DBs live on **tmpfs** at `/run/freeswitch-db` (set via `-db` in the systemd unit) to avoid SD-card write contention. **Regenerated on boot; git-ignored.** | generated |
| [`recordings/`](recordings/) | Caller messages recorded by the IVR (`recordings/messages/`). **Git-ignored** (the folder is kept via `.gitkeep`). | generated |
| [`.devcontainer/`](.devcontainer/), [`CODESPACES.md`](CODESPACES.md) | GitHub Codespaces setup (see below). | tooling |

### 3.1 `conf/` in detail

Every file under `conf/` is listed below. [`conf/freeswitch.xml`](conf/freeswitch.xml) is the root
document; it pulls in the rest via `X-PRE-PROCESS` includes — `vars.xml`, everything in
`autoload_configs/`, the SIP profile(s) in `sip_profiles/`, the `default` dialplan
(`dialplan/default/*.xml`), and the user directory (`directory/default/*.xml`).

| File | Purpose |
|---|---|
| [`conf/freeswitch.xml`](conf/freeswitch.xml) | Root config. Includes `vars.xml`; the `configuration` section includes `autoload_configs/*.xml`; the `dialplan` section includes `dialplan/default/*.xml` into the `default` context; the `directory` section includes `directory/default/*.xml` inside the `$${domain}` domain (blind auth). |
| [`conf/vars.xml`](conf/vars.xml) | Global pre-processor variables: install paths, the `192.168.50.1` bind IP and `192.168.50.0/24` CIDR, the RTP port range (16384–16484), `PCMU` codec prefs, the actuator commands (`disco_raise`/`disco_lower`/`disco_stop`/`disco_position`), the message-store helper (`bella_messages`), and the number-game helper (`bella_game`, `game_tries_max=3`). |
| [`conf/sip_profiles/ata.xml`](conf/sip_profiles/ata.xml) | The single SIP profile `ata`, bound to `192.168.50.1:5060/udp`. Blind auth/registration, ACL-locked to `bella_ata_only`, PCMU-only media, RFC2833 DTMF, one registration per extension, no NAT/SRV/NAPTR/presence. |
| [`conf/directory/default/101.xml`](conf/directory/default/101.xml) | SIP line **101** — participant (password unused; `Line 101` caller ID). |
| [`conf/directory/default/102.xml`](conf/directory/default/102.xml) | SIP line **102** — participant. |
| [`conf/directory/default/103.xml`](conf/directory/default/103.xml) | SIP line **103** — spare / future expansion. |
| [`conf/directory/default/104.xml`](conf/directory/default/104.xml) | SIP line **104** — concierge (driver/passenger). |
| [`conf/dialplan/default/`](conf/dialplan/default/) | Call routing and the IVR — one file per feature: `00_extensions.xml`, `10_inbound_and_menu.xml`, `20_option1_intercom.xml`, `30_option2_listen.xml`, `40_option3_leave.xml`, `50_disco_controls.xml`, `60_option7_tale.xml`, `70_option5_game.xml`, `80_option9_survey.xml`. Each is detailed in [§4](#4-current-dialplan--call-flow). |
| [`conf/autoload_configs/modules.conf.xml`](conf/autoload_configs/modules.conf.xml) | The **13** modules loaded at boot: loggers (`mod_console`/`mod_logfile`/`mod_timerfd`/`mod_posix_timer`), `mod_event_socket`, `mod_sofia`, the dialplan engine (`mod_dialplan_xml`/`mod_commands`/`mod_dptools`), media playback (`mod_native_file`/`mod_sndfile`/`mod_tone_stream`), and `mod_say_en`. |
| [`conf/autoload_configs/switch.conf.xml`](conf/autoload_configs/switch.conf.xml) | Core settings: small session caps (`max-sessions=10`, `sessions-per-second=5`), the RTP port range, `info` log level, the `core.db` name plus DB-handle pool (`max-db-handles`/`db-handle-timeout`), and `fs_cli` key-bindings. |
| [`conf/autoload_configs/sofia.conf.xml`](conf/autoload_configs/sofia.conf.xml) | Sofia global settings; includes the SIP profiles from `../sip_profiles/*.xml`. |
| [`conf/autoload_configs/acl.conf.xml`](conf/autoload_configs/acl.conf.xml) | The `bella_ata_only` network list (`default="deny"`, allows only `$${ata_network_cidr}` = `192.168.50.0/24`). |
| [`conf/autoload_configs/event_socket.conf.xml`](conf/autoload_configs/event_socket.conf.xml) | ESL bound to `127.0.0.1:8021` (used by `fs_cli` and `bella-ring`); `stop-on-bind-error`. |
| [`conf/autoload_configs/logfile.conf.xml`](conf/autoload_configs/logfile.conf.xml) | File logger → `log/freeswitch.log`, **warnings and above only** (to minimize SD-card wear; live `info`/`debug` stays available over `fs_cli`/ESL), 10 MB rollover, keep 2, `rotate-on-hup`. |
| [`conf/autoload_configs/console.conf.xml`](conf/autoload_configs/console.conf.xml) | Console logger (colorized, `info` level). |

---

## 4. Current dialplan & call flow

The dialplan is a set of XML files under [`conf/dialplan/default/`](conf/dialplan/default/), loaded
in filename order into the `default` context. Every call from the ATA lands in the IVR at `700`,
and each option `transfer`s to a virtual destination handled by one of these files. The IVR is a
**transfer-based state machine**: each hop `transfer`s to a named destination that a `<condition>`
matches on, so `max_forwards` is reset to `70` at loop entry points (every transfer decrements it,
and a long browse/loop would otherwise exhaust the per-call budget and drop the call). One
subsection per file, in load order.

**Dialable numbers** — real `destination_number` values routed at the top level (i.e. a number a
phone can dial, as opposed to a selection collected inside the menu prompt):

| Number | Handled by | Result |
|---|---|---|
| `700` | `10_inbound_and_menu.xml` | Main menu entry (also the ATA off-hook auto-dial). |
| `101`–`104` | `00_extensions.xml` | Ring that SIP line directly (matched before the menu catch-all). |
| *any other digits* | `10_inbound_and_menu.xml` (`all-calls-to-menu`) | Numeric-only catch-all → transferred to the menu (`700`). |

Inside the menu, `play_and_get_digits` additionally collects `0`, `1`, `2`, `3`, `5`, `9`, `11`,
`411`, `811`, `911`, and `101`–`104` (see §4.2) — these are menu selections, not standalone extensions.

**Virtual destinations** — internal `transfer` targets. They are lettered/upper-case so they never
collide with dialable numbers, and are grouped here by the file that handles them:

- **Menu dispatch** (`10_inbound_and_menu.xml`):
  - `DISPATCH` — second routing pass after the menu collects a digit; each `dispatch-*` extension tests `bella_opt` and transfers to the matching handler.
  - `DISPATCH_AFTER_INVALID` — re-entry after an "invalid" prompt collects a key: a valid option goes back through `DISPATCH`, silence (empty `bella_opt`) returns to the menu greeting.
- **Intercom** (`20_option1_intercom.xml`):
  - `CALL_OTHER` — ring the *other* participant line based on the caller's SIP user (101 → 102, 102 → 101); unknown lines get a `no-answer` fallback.
- **Listen & drawer** (`30_option2_listen.xml`):
  - `LISTEN_MESSAGES` — entry point; start curated playback at the newest message.
  - `MESSAGE_ANNOUNCE` — resolve the lead-in announcement file for the current index.
  - `MESSAGE_ANNOUNCE_PLAY` — play that announcement (any key skips straight to the message; `9` opens the drawer).
  - `MESSAGE_ANNOUNCE_KEY` — route a key pressed during the announcement: `9` → open the drawer at the current message, else skip to the message.
  - `MESSAGE_RESOLVE` — map the current index to a message file (resets `max_forwards`).
  - `MESSAGE_PLAY` — play the message and collect one navigation key.
  - `MESSAGE_END` — end of the curated set: reflective sign-off, or the empty-store prompt.
  - `MESSAGE_KEY_PREV` / `MESSAGE_KEY_NEXT` — handle `2` = previous / `1` = next (announcement skipped).
  - `MESSAGE_KEY_DRAWER` — handle `9` = open the drawer at the current message (keeps the index).
  - `MESSAGE_KEY_DEFAULT` — no key = auto-advance *with* announcement; any other key = replay.
  - `PLAYBACK_END_KEY` — interpret the key pressed during the sign-off (`9` → `DRAWER_OPEN` at `drawer-start`).
  - `DRAWER_OPEN` — play the interruptible `playback-special` intro, then `DRAWER_OPEN_PREV`/`_DELETE` dispatch its key (`2` = previous, `7` = delete, `1`/other/none = play the current message).
  - `DRAWER_RESOLVE` — map the current full-archive index to a file.
  - `DRAWER_PLAY` — sound a tone separator, then play the archived message and collect one key.
  - `DRAWER_KEY_PREV` / `DRAWER_KEY_NEXT` — handle `2` = previous / `1` = next in the full archive.
  - `DRAWER_KEY_DELETE` — handle `7` = delete the current message, then re-resolve the slot.
  - `DRAWER_KEY_DEFAULT` — no key = auto-advance; any other key = replay.
  - `DRAWER_END` — reached the oldest message: sign off and return to the menu.
- **Leave a message** (`40_option3_leave.xml`):
  - `LEAVE_MESSAGE` — record up to 60 s, prune only if disk is low, confirm, return to the menu.
- **Disco controls** (`50_disco_controls.xml`):
  - `DISCO_RAISE` — read the tracked position, then branch to `DISCO_RAISE_GO`.
  - `DISCO_RAISE_GO` — raise unless already `up` (else play "already up").
  - `DISCO_LOWER` — read the tracked position, then branch to `DISCO_LOWER_GO`.
  - `DISCO_LOWER_GO` — lower unless already `down` (else play "already down").
  - `DISCO_STOP` — brake any movement and reset the position to `unknown`.
- **Branching story** (`60_option7_tale.xml`):
  - `TALE_OPEN` — first fork of the fable; `TALE_OPEN_D` dispatches the chosen digit, `TALE_OPEN_R` re-offers just the options after an invalid key.
  - `TALE_SHIELD` — "shield the ember" node; `TALE_SHIELD_D` dispatches its choice, `TALE_SHIELD_R` replays only the options on an invalid key.
  - `TALE_FEED` — "feed the ember" node; `TALE_FEED_D` dispatches its choice, `TALE_FEED_R` replays only the options on an invalid key.
  - `TALE_END_SHARE`, `TALE_END_HIDE`, `TALE_END_REVEL`, `TALE_END_ASH`, `TALE_END_STILL` — the five endings; each plays its close and returns to the menu.
- **Guess-my-number game** (`70_option5_game.xml`):
  - `GAME_START` — pick the secret (1–9), reset the try counter, queue the intro.
  - `GAME_ASK` — play the current step's prompt and collect one guess (barge-in-able).
  - `GAME_EVAL` — nudge on empty/invalid input; otherwise ask `bella-game` for a verdict.
  - `GAME_VERDICT` — branch on `hit` → win, `lose` → lose, or `high`/`low` → hint and re-ask.
  - `GAME_WIN` / `GAME_LOSE` — play the closing prompt and return to the menu.
- **Principles survey** (`80_option9_survey.xml`):
  - `SURVEY_START` — play the ten-answer ballot and collect one digit (`0`–`9`, barge-in-able).
  - `SURVEY_EVAL` — empty/invalid → nudge (`survey-invalid`) and re-ask; otherwise record the anonymous vote (`bella-survey vote`).
  - `SURVEY_RESULT` — play the chosen reading (`survey-read-<id>`), then fetch the standing bucket (`bella-survey stats`).
  - `SURVEY_STATS` — play the matching `survey-stats-<bucket>` line and return to the menu.

### 4.1 `00_extensions.xml` — dial a SIP line (101–104)
Explicit extensions for the four lines: dialing **101**–**104** bridges to that phone with a
ringback tone (`ringback=%(2000,4000,440,480)`, `instant_ringback`) and the caller ID set from the
originating line. With `hangup_after_bridge`/`continue_on_fail`, a failed bridge (no answer / busy)
falls through to `no-answer.wav` and a transfer back to the menu (`700`). This file **sorts
first**, so a dialed 101–104 is matched here and rings the phone instead of being swallowed by the
numeric `all-calls-to-menu` catch-all in `10_inbound_and_menu.xml`. These extensions are also the
target of menu option **0** (→ 104, the concierge) and of the intercom in `20_option1_intercom.xml`.

### 4.2 `10_inbound_and_menu.xml` — inbound routing & the main menu (`700`)
The entry point and menu. `all-calls-to-menu` routes `700` (the ATA off-hook auto-dial) or **any**
dialed number from the ATA to the menu; it is numeric-only and placed last so it never shadows the
lettered internal targets (`CALL_OTHER`, `DISCO_RAISE`, …) or the 101–104 extensions in §4.1.

The menu greets and collects one option with `play_and_get_digits` (1–3 digits, `*` terminator,
validated to `^(0|1|2|3|5|9|911|811|411|10[1-4]|11)$`; a 2 s inter-digit timeout resolves `1` vs `11`
vs `101`–`104`). The **full** greeting (`prompts/main-menu.wav`) plays once at the start of the
call (`menu-first`); every later return plays **one of nine random short greetings**
(`prompts/main-menu-short-variant-1..9.wav`, via `bella-messages pick main-menu-short-variant`, §5.2), tracked
by the `menu_greeted` channel variable (`menu-repeat`). The collected option (`bella_opt`) is
dispatched on a second routing pass (`DISPATCH`), where one `dispatch-*` extension per option
transfers away:

| Dial | Transfers to | Action |
|---|---|---|
| **1** | `CALL_OTHER` | Intercom the *other* participant line (101 ↔ 102) — §4.3 |
| **2** | `LISTEN_MESSAGES` | Listen to stored messages — §4.4 |
| **3** | `LEAVE_MESSAGE` | Leave a message (max 60 s) — §4.5 |
| **101**–**104** | `101`…`104` | Dial that SIP line directly — §4.1 |
| **0** | `104` | Dial the concierge (line 104) — §4.1 |
| **911** | `DISCO_RAISE` | *(hidden)* Raise the disco ball — §4.6 |
| **811** | `DISCO_LOWER` | *(hidden)* Lower the disco ball — §4.6 |
| **411** | `dispatch-about` | *(hidden)* Play info about the creators and the build |
| **11** | `DISCO_STOP` | *(hidden)* Stop the disco ball — §4.6 |
| **7** | `TALE_OPEN` | *(hidden)* branching story — §4.7 |
| **9** | `SURVEY_START` | *(hidden)* principles survey — §4.9 |
| **5** | `GAME_START` | *(hidden)* guess-my-number game — §4.8 |

Anything else falls through to `dispatch-invalid`, which plays **one of ten random "invalid"
prompts** (`prompts/invalid-entry-1..10.wav`, via `bella-messages pick invalid-entry`) and re-collects
any keypad entry: a valid option is acted on immediately, another invalid key replays a fresh
scold, and only silence (a timeout, leaving `bella_opt` empty) returns to the menu greeting.
Completed actions transfer back to `700`.

> **Hidden options.** The spoken greeting only offers **1**, **2**, and **3**. Everything else is
> *unannounced*: dialing a line directly (**101**–**104**, or **0** for the concierge), the disco
> controls (**911** raise, **811** lower, **11** stop), the art-car "about" prompt (**411**), the
> branching story (**7**), the principles survey (**9**), the
> guess-my-number game (**5**), and the message drawer reached after listening to everything (§4.4).
> Bella hints there's more — *"one of the ones I don't say out loud"* — but never names them.

### 4.3 `20_option1_intercom.xml` — intercom (option 1)
Routes `CALL_OTHER` to the *other* participant line based on the caller's SIP user: from **101** it
transfers to extension **102**, from **102** to **101** (the actual bridge, ringback, and
no-answer handling live in `00_extensions.xml`, §4.1). A fallback `call-other-unknown-line` covers
option 1 pressed from any unexpected SIP user — it plays `no-answer.wav` and returns to the menu.
Intercom is deliberately limited to the two participant lines; 103/104 are not intercom targets.

### 4.4 `30_option2_listen.xml` — listen to messages (option 2) & the hidden drawer
Two playback experiences over the message store (`bella-messages`, §5.2):

**Curated playback (`LISTEN_MESSAGES`).** Plays the **newest 10** messages **newest-first**, each
preceded by its numbered lead-in announcement (`prompts/playback-announcement-<idx>.wav`). During a
message, **1 = next**, **2 = previous**; navigating by key (or pressing a key during an
announcement) **skips the announcement** and plays the message directly. When a message finishes
with no key it **auto-advances** to the next *with* its announcement. Pressing **9** at any time —
during a message or its announcement — opens the drawer (below) at the **current** message. The browse loop
(`MESSAGE_ANNOUNCE → MESSAGE_ANNOUNCE_PLAY → MESSAGE_RESOLVE → MESSAGE_PLAY →` the
`MESSAGE_KEY_PREV`/`_NEXT`/`_DRAWER`/`_DEFAULT` chain) uses `bella-messages announcement`/`resolve`/`step` to
map the index to files, and resets `max_forwards` each cycle.

**End sign-off & the hidden drawer.** After the last curated message, `MESSAGE_END` plays a
reflective sign-off (`prompts/playback-end.wav`); if the store was empty it instead plays
`playback-no-messages.wav` and returns to the menu. The drawer — **"Bella's drawer of secrets"** —
is opened either by pressing **9** during the sign-off (`PLAYBACK_END_KEY` → `DRAWER_OPEN`, starting
at `drawer-start` = `PLAYBACK_LIMIT+1`, i.e. just past the curated window) **or** by pressing **9**
any time during playback (`MESSAGE_KEY_DRAWER`/`MESSAGE_ANNOUNCE_KEY` → `DRAWER_OPEN`, starting at the
**current** message). `DRAWER_OPEN` plays the `playback-special` intro **interruptibly**: **1** skips it
and plays the current message, **2** = previous, **7** = delete the current message. It then browses the
**full** archive, newest-first — no lead-in announcements, a short tone separating each message —
where **1** = next, **2** = previous, **7** = **delete** the current message (never announced), any other
key replays it, and no key auto-advances. Because `bella-messages` re-lists the store on every call, a
`delete-all` takes effect at once and every index renumbers as if the message never existed; reaching the
oldest signs off and returns to the menu. Backed by `bella-messages` `resolve-all`/`step-all`/`delete-all`.

### 4.5 `40_option3_leave.xml` — leave a message (option 3)
`LEAVE_MESSAGE` answers, plays `message-record.wav` and a beep, then `record`s up to **60 s** to
`recordings/messages/msg_<timestamp>_<uuid>.wav`. `record_min_sec=2` discards no-speech recordings;
any DTMF digit stops the recording (`playback_terminators=any`). It then runs `bella-messages
rotate` (prunes the oldest **only** when disk space is low — everything is kept otherwise), plays
`message-saved.wav`, and returns to the menu.

### 4.6 `50_disco_controls.xml` — hidden disco-ball controls (911 / 811 / 11)
The only "disco" component: three hidden destinations that drive the relay HAT through the `disco_*`
commands in `vars.xml` (which shell out to `scripts/disco-relay`, §5.1). Each reads the tracked
position first via `${system($${disco_position})}` (`up` / `down` / `unknown`):

- **911** (`DISCO_RAISE`) raises unless already `up` (then it plays `disco-already-up.wav` and does
  nothing); otherwise it starts `disco_raise` = `disco-relay raise 120 75` and plays
  `disco-raise.wav` over the movement.
- **811** (`DISCO_LOWER`) lowers unless already `down` (`disco-already-down.wav`); otherwise it
  starts `disco_lower` = `disco-relay lower 120 5` and plays `disco-lower.wav`.
- **11** (`DISCO_STOP`) runs `disco_stop` = `disco-relay brake`, cancelling any movement **and
  resetting the position to `unknown`** so 911 or 811 will run next; plays `disco-stop.wav`.

Every path returns to the menu. Position is `unknown` at boot and after **11** (it lives on `/run`,
tmpfs). Tune the drive seconds and spot-light percentages in [`conf/vars.xml`](conf/vars.xml).

The unrelated **411** "about the art car" option (`dispatch-about`) lives in the menu file
(§4.2): it plays `about.wav` — describing the art car, its creators, and the build — then returns
to the menu.

### 4.7 `60_option7_tale.xml` — hidden branching story "The Ember" (option 7)
Dialing **7** (never announced) opens **"The Ember"**, a branching fable Bella reads aloud. Each
node narrates and collects one digit, then transfers to a per-node dispatch pass that tests the
digit in a `<condition>`. The tree:

- `TALE_OPEN` — 1 = shield → `TALE_SHIELD`, 2 = feed → `TALE_FEED`, 3 = set it down → ending "still"
- `TALE_SHIELD` — 1 = share → ending "share", 2 = keep → ending "hide"
- `TALE_FEED` — 1 = burn → ending "revel", 2 = press on → ending "ash"

That yields **five endings** (`tale-end-{share,hide,revel,ash,still}.wav`), each a small moral;
endings play their close and return to the menu. An invalid key at any node plays `tale-invalid.wav`
and re-offers just that node's choices (an options-only reprompt, `tale-*-options.wav`), keeping the
caller inside the story. Every node resets `max_forwards`.
The tree, choice table, and full prompt scripts are in [`STORY.md`](STORY.md); prompts:
`prompts/tale-*.wav`.

### 4.8 `70_option5_game.xml` — hidden guess-my-number game (option 5)
Dialing **5** (never announced) starts a keypad guessing game. `GAME_START` picks a secret **1–9**
(`bella-game secret 1 9`), resets the try counter, and queues a random intro; `GAME_ASK` plays the
current step's prompt as a barge-in-able `play_and_get_digits` (so a returning caller can guess
over the prompt) and collects one digit. `GAME_EVAL`/`GAME_VERDICT` ask `bella-game verdict …`,
which returns `hit` (→ win), `lose` (out of tries → lose; default **3**, via `game_tries_max` in
`vars.xml`), or `high`/`low` (bump the counter, queue a random *higher*/*lower* hint, re-ask). The
intro, win, lose, and higher/lower prompts each have several interchangeable variants chosen at
random per call (`bella-messages pick`, §5.2). The secret is never spoken and never revealed on
a loss. Win/lose play their close and return to the menu; see [`GAME.md`](GAME.md). Prompts:
`prompts/game-*.wav`.

### 4.9 `80_option9_survey.xml` — hidden "which are you?" principles survey (option 9)
Dialing **9** (never announced) opens a one-question, ten-answer survey with a persistent,
anonymous tally. `SURVEY_START` plays the ballot (`survey-ballot.wav`) inside a barge-in-able
`play_and_get_digits` and collects one digit **0–9**. `SURVEY_EVAL` runs first on an empty or
invalid entry — it plays `survey-invalid.wav` and re-asks — so a vote is only recorded for a real
pick; otherwise it records the vote (`bella-survey vote <id>`, §5.4) **before** the standing is
read, so the caller is counted and a brand-new pick reads as `first`. `SURVEY_RESULT` plays the
chosen reading (`survey-read-<id>.wav`), then asks `bella-survey stats <id>` for a one-word
standing **bucket** (`first`/`top`/`high`/`low`/`rarest`); `SURVEY_STATS` plays the matching
`survey-stats-<bucket>.wav` and returns to the menu (a defensive catch-all falls back to the
`high` line if the helper is unavailable). Every node resets `max_forwards`. The ten counters
(keys `0`–`9`) live in `db/survey.tsv`; no caller data is stored. The option map, buckets, and
full prompt scripts are in [`SURVEY.md`](SURVEY.md); prompts: `prompts/survey-*.wav`.

---

## 5. The scripts

The project-specific helpers in [`scripts/`](scripts/) back the dialplan and the build/deploy
tooling. The IVR calls the runtime helpers via `${system(...)}`; the two prompt tools run at
build/deploy time. All output from the runtime helpers is newline-free so it can be dropped
straight into dialplan variables.

### 5.1 `disco-relay`
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

### 5.2 `bella-messages`
The IVR message store over `recordings/messages/` (recorded as `msg_<timestamp>_<uuid>.wav`, so a
lexical sort is chronological). Runs as the `freeswitch` user — no sudo. The IVR plays back the
newest `PLAYBACK_LIMIT` (**10**) messages; older ones are kept on disk and pruned oldest-first
only when free space drops below `MIN_FREE_MB` (**200**). The `*-all` commands back the hidden
message drawer (§4.4) over the full archive.

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
| `pick` | `<prefix>` | Next `<prefix>-*.wav` from a per-prefix **shuffle-bag** — every variant plays once, in random order, before repeating (no back-to-back duplicates); empty if none. State on tmpfs (`BELLA_PICK_STATE_DIR`, default `/run/bella-novella/pick`); falls back to a plain random draw if unavailable. |

### 5.3 `bella-game`
Stateless helper for the hidden guess-my-number game (menu option 5). The dialplan holds the
per-call state (secret, tries) in channel variables and calls this for the secret, the verdict,
and the counter bump. Runs as the `freeswitch` user. The game's random prompt variants
(intro/win/lose and higher/lower) are chosen with `bella-messages pick` (§5.2), not here.

| Command | Arguments | What it does |
|---|---|---|
| `secret` | `<min> <max>` | Random integer in `[min,max]` (empty on bad args). |
| `verdict` | `<min> <max> <secret> <guess> <tries> <maxtries>` | One of `bad` / `hit` / `high` / `low` / `lose`. |
| `incr` | `<n>` | Print `n+1` (missing/invalid `n` treated as 0). |

### 5.4 `bella-survey`
Backs the hidden **"which are you?"** principles survey (menu option 9, §4.9): a persistent,
anonymous vote tally. The dialplan calls it via `${system(...)}` to record a pick and to fetch a
qualitative standing. It keeps ten counters (keys `0`–`9`) in `$BELLA_DB_DIR/survey.tsv` (default
`db/`), guarded by an `flock` with atomic writes (temp file + `mv`), so it survives reboots and
concurrent calls never see a partial tally. No caller data is stored. Runs as the `freeswitch`
user (no sudo); all single-value output is newline-free for direct use in dialplan variables.

| Command | Arguments | What it does |
|---|---|---|
| `vote` | `<id>` | Atomically record a vote for option `<id>` (`0`–`9`); print the new total votes cast. |
| `stats` | `<id>` | Print one standing bucket for `<id>` **after** its vote is counted: `first` (first-ever vote), `top` (a most-chosen option), `rarest` (a least-chosen option), `high` (at/above the mean), or `low` (below it). |
| `dump` | — | Print every counter and the total (human-readable; for tests). |
| `reset` | — | Zero every counter (for tests). |

Environment: `BELLA_DB_DIR` (tally directory, default `/usr/local/freeswitch/db`).

### 5.5 `bella-ring`
The periodic-ring helper (no arguments). Invoked by the `bella-ring.timer` systemd timer at a
random interval (15–45 min), it picks one of the two participant lines (**101**/**102**) at
random and, over the local event socket (`127.0.0.1:8021`), `originate`s a call to it; on answer
the phone is routed to the menu (`700`). If the chosen line isn't registered it logs and exits
quietly. Tunable via the environment: `FS_CLI`, `BELLA_DOMAIN`, `BELLA_RING_TIMEOUT`.

### 5.6 `bella-convert-prompts`
Rebuilds the prompt **WAVs** (8 kHz mono) from their MP3 sources in `prompts/`. By default it only
(re)generates WAVs that are missing or older than their MP3; pass `--force` to rebuild every WAV.
Run by [`install.sh`](install.sh) and by `bella-regen-prompts` after synthesis.

```sh
bella-convert-prompts            # only missing/changed
bella-convert-prompts --force    # rebuild all
```

### 5.7 `bella-regen-prompts`
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

### 5.8 `install.sh`
The root-level installer/deployer (it lives at the repo root, not in `scripts/`; run as **root**
from the repo). With **no flags** it runs the *every-invocation* steps — install the host files
from [`system/`](system/), install/own [`conf/`](conf/), set the relay-script permissions and
sudoers, initialize the relays, and restart FreeSWITCH — i.e. the fast path behind §7 and the
per-run half of §8. Flags add the one-time or optional stages. The install prefix `$FS_DIR`
(default `/usr/local/freeswitch`) must already exist.

| Option | What it's for |
|---|---|
| `--fresh` | One-time fresh-Pi bootstrap: install the build toolchain + runtime deps + admin tools, create the `freeswitch` user/group, prune desktop/bloat services, and apply the OS tuning (governor, swap, journal, watchdog, …). See §8.1. |
| `--network` | Configure `eth0`'s static `192.168.50.1/24` and the DHCP-only dnsmasq scope for the ATA. See §8.6. |
| `--no-restart` | Install all files but **don't** restart FreeSWITCH (useful for staging changes). |
| `--backup` | Back up each file (`.backup.<timestamp>`) before overwriting it (default: overwrite in place). |
| `--build-spandsp[=BRANCH]` | Build and install SpanDSP from source, optionally from a given branch/tag (default `master`). See §8.3. |
| `--build-sofia[=BRANCH]` | Build and install Sofia-SIP from source, optionally from a given branch/tag (default `master`). See §8.4. |
| `-h`, `--help` | Print usage and exit. |

Environment: `FS_DIR` (install prefix, default `/usr/local/freeswitch`), `FS_USER` / `FS_GROUP`
(the service account, default `freeswitch`).

```sh
sudo ./install.sh                                                   # routine repo-update: files + restart
sudo ./install.sh --fresh --network --build-spandsp --build-sofia   # first install on a blank Pi
sudo ./install.sh --no-restart                                      # stage config without bouncing the service
sudo ./install.sh --build-sofia=v1.13.17                            # rebuild Sofia from a specific tag
```

---

## 6. Open in GitHub Codespaces

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

## 7. Quick deployment

The fastest path from a blank SD card to a working appliance. Every persistent step is baked
into [`install.sh`](install.sh); only the OS image and the ATA web UI are configured by hand.

### 7.1 Create the OS image

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

### 7.2 Clone this repo to the FreeSWITCH prefix

The repository **is** `/usr/local/freeswitch`, so clone it directly to that path:

```sh
sudo mkdir -p /usr/local/freeswitch
sudo chown "$USER":"$USER" /usr/local/freeswitch
git clone https://github.com/k-anderson/bella-novella.git /usr/local/freeswitch
cd /usr/local/freeswitch
```

### 7.3 Run the installer

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

### 7.4 Configure the Grandstream HT814 ATA

Plug the ATA into `eth0`; it receives `192.168.50.100–192.168.50.150` from the Pi's DHCP scope.
Find its lease and open its web UI (tunnel from your laptop if needed):

```sh
cat /var/lib/misc/dnsmasq.leases
ssh -N -L 8080:192.168.50.<lease-ip>:80 bella@bella-novella.local   # then open http://localhost:8080
```

Set (see [8.11](#811-configure-the-grandstream-ht814-manual) for the full field list):

```text
Primary SIP Server: 192.168.50.1     SIP Transport: UDP     Registration: Yes
FXS 1: SIP User ID 101, Off-hook Auto-Dial 700
FXS 2: SIP User ID 102, Off-hook Auto-Dial 700
FXS 3: SIP User ID 103, Off-hook Auto-Dial 700
FXS 4: SIP User ID 104, Off-hook Auto-Dial 700
Vocoders: PCMU only     DTMF: RFC2833
```

Apply and reboot the ATA. Lift a handset — you should hear the IVR.

### 7.5 Verify

```sh
fs_cli -x "status"
fs_cli -x "sofia status profile ata"
fs_cli -x "show registrations"       # 101–104 registered
sudo /usr/local/freeswitch/scripts/disco-relay status
```

---

## 8. Manual deployment

This section reproduces **exactly what [`install.sh`](install.sh) does**, step by step, with the
real commands so you can copy them to the Pi one block at a time and see what each stage changes
(and why). Running the installer is the fast path; doing it by hand is the learning path — the
end state is identical.

All commands assume you are `root` and sitting in the repo. Start each session with:

```sh
sudo -i
cd /usr/local/freeswitch
```

> Steps 8.1, 8.3, 8.4, and 8.6 map to the `--fresh`, `--build-spandsp`, `--build-sofia`, and
> `--network` flags respectively. Steps 8.2 and 8.5–8.10 run on **every** `install.sh` invocation.

### 8.1 Fresh-Pi bootstrap (`--fresh`)

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

### 8.2 Install system files

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
# Also keeps the SQLite DBs on tmpfs via RuntimeDirectory + '-conf/-log/-run/-db' (FreeSWITCH
# needs the dir flags together, incl. -run so the PID file matches PIDFile=) and provides
# /run/bella-novella for pick state.
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

### 8.3 Build SpanDSP (`--build-spandsp`)

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

### 8.4 Build Sofia-SIP (`--build-sofia`)

Optional. Same rationale — compiled from source into `/usr/local`. The persisted
`PKG_CONFIG_PATH` from [8.2](#82-install-system-files) is what lets FreeSWITCH find it:

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

### 8.5 Validate required modules

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

### 8.6 Configure the isolated ATA network (`--network`)

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

### 8.7 Relay script permissions and sudoers

Lock down [`scripts/disco-relay`](scripts/disco-relay) and grant the `bella` and `freeswitch`
users passwordless `sudo` to **only** that script (so the IVR can drive the actuator):

```sh
chown root:root scripts/disco-relay
chmod 0755 scripts/disco-relay

install -m 0440 system/etc/sudoers.d/disco-relay /etc/sudoers.d/disco-relay
visudo -c    # validate sudoers syntax
```

### 8.8 Initialize the relays

Put the actuator into the known brake/default state (K1/K2 off) before FreeSWITCH starts:

```sh
scripts/disco-relay brake
scripts/disco-relay status
```

### 8.9 Prompts and message directories

The custom voice prompts — menu greeting (and its short variants), disco-ball, message,
invalid-entry, playback-announcement, story (`tale-*`), and game (`game-*`) — ship in `prompts/`
as 8 kHz mono WAV and are tracked in the repo. Just create the runtime directory the IVR records
caller messages into:

```sh
mkdir -p /usr/local/freeswitch/prompts /usr/local/freeswitch/recordings/messages
```

### 8.10 Install FreeSWITCH configuration and start

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

### 8.11 Configure the Grandstream HT814 (manual)

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

## 9. Updating an existing deployment

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

## 10. Optional: build FreeSWITCH from scratch

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
`sudo ./install.sh --build-spandsp --build-sofia` (see [8.3](#83-build-spandsp---build-spandsp)
and [8.4](#84-build-sofia-sip---build-sofia)).

---

## 11. Optional: Wi-Fi fallback and hotspot

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

**3. Test it:**

```sh
sudo systemctl start wifi-fallback.service
journalctl -t wifi-fallback -n 20
```