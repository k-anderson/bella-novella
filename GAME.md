# Guess My Number — Bella's hidden game (menu option `5`)

A quick keypad guessing game Bella plays with the caller from her lounge. She
thinks of a number **1–9**; the caller dials one guess at a time and she teases
*higher* or *lower* until they find it — or run out of tries. She never says the
number out loud, so it needs no text-to-speech: only a fixed set of feedback
prompts.

## Overview

- **Premise:** Bella picks a secret number 1–9. Each guess is a single keypress.
  She replies *higher* / *lower* (from a few random variants) until the caller
  hits it (**win**) or uses up their tries (**lose**).
- **Persona:** the 1920s matriarch — teasing, warm, and never gives the secret
  away, even on a loss ("a lady keeps a few secrets").
- **Tries:** default **5**, tunable via the `game_tries_max` var in
  [conf/vars.xml](conf/vars.xml).
- **Voice:** same bracketed emotional-cue style as [PROMPTS.md](PROMPTS.md); this
  file is the source of truth for generating the prompt audio.

## How to reach it

It is a **secret**: at the main menu the caller dials **`5`**. Bella never
announces it. Internally, menu option `5` routes to `GAME_START` (see
[conf/dialplan/default/60_game.xml](conf/dialplan/default/60_game.xml) and the
`dispatch-game` entry in
[conf/dialplan/default/00_inbound_and_menu.xml](conf/dialplan/default/00_inbound_and_menu.xml)).

## Flow

```mermaid
graph TD
    START["GAME_START<br/>pick secret 1-9, play intro"] --> ASK["GAME_ASK<br/>collect one digit (1-9)"]
    ASK --> EVAL["GAME_EVAL"]
    EVAL -->|empty / 0| INV["play game-invalid"] --> ASK
    EVAL --> V{"bella-game verdict"}
    V -->|high| HI["play random game-higher"] --> ASK
    V -->|low| LO["play random game-lower"] --> ASK
    V -->|hit| WIN["GAME_WIN → menu"]
    V -->|lose| LOSE["GAME_LOSE, no reveal → menu"]
```

Every `GAME_ASK` resets `max_forwards` (a long game chains many transfers, which
would otherwise exhaust the per-call budget and drop the call).

## Prompts

| Prompt | When it plays |
|---|---|
| `game-intro.wav` | Once, at the start — the rules. |
| `game-higher-1..3.wav` | Random, when the secret is **higher** than the guess. |
| `game-lower-1..3.wav` | Random, when the secret is **lower** than the guess. |
| `game-win.wav` | Correct guess. |
| `game-lose.wav` | Out of tries (the number is **not** revealed). |
| `game-invalid.wav` | No digit / a `0` / anything outside 1–9. |

## Helper: `scripts/bella-game`

Stateless bash helper (mirrors [scripts/bella-messages](scripts/bella-messages));
all output is newline-free for `${system(...)}`.

| Command | Prints |
|---|---|
| `secret <min> <max>` | a random integer in `[min,max]` |
| `verdict <min> <max> <secret> <guess> <tries> <maxtries>` | `bad` \| `hit` \| `high` \| `low` \| `lose` |
| `incr <n>` | `n+1` (missing/invalid → `1`) |
| `hint high\|low` | absolute path of a random `game-higher/lower-N.wav` |

`verdict` consumes a try only for a valid in-range guess: it computes
`newtries = tries + 1`, then returns `hit` if the guess matches, `lose` if
`newtries` reaches `maxtries`, otherwise `high`/`low`.

## Prompt scripts (source of truth for the audio)

Record each as `prompts/<name>.wav` (8 kHz mono 16-bit — the repo's standard).
Bracketed notes are delivery cues, not spoken.

### game-intro
[low, sly, delighted] Ohh. So you want to play a little game with me. [warm, amused] How could a girl say no.
[velvet, leaning in] It's simple, darling. I'm thinking of a number — somewhere between one and nine. [teasing] You dial a single guess, and I'll tell you if mine is higher... or lower.
[low, purring] You've a handful of tries to find me out. [sly] I won't make it easy. [warm, inviting] Go on, then. Your first guess.

### game-higher-1
[low, teasing] Higher, darling. Don't be shy.

### game-higher-2
[amused, warm] Mmm — reach a little higher than that.

### game-higher-3
[sly, low] Up you go, sugar. My number's bigger than yours.

### game-lower-1
[dry, amused] Lower, darling. You overshot me.

### game-lower-2
[teasing, low] Come down, sugar — that's too high.

### game-lower-3
[velvet, wry] Lower. A touch less ambition.

### game-win
[delighted, low] Well, well. You found me. [impressed, warm] Not many do that, darling — and not so quick. [sly, purring] Beginner's luck... or are you trouble? [beat, warm] Either way — colour me impressed. And I don't impress easy. [sly] Tell the driver you once met me in Salzburg, there might be something in it for you.

### game-lose
[low, amused] And that's the last of your guesses, sugar. [teasing] No — I'm not going to tell you what it was. [sly, warm] A lady keeps a few secrets, doesn't she. [beat, inviting] Come try me again sometime. Perhaps I'll be in a giving mood.

### game-invalid
[dry, arch] That's not a number between one and nine, darling. [beat, teasing] One little digit — that's all I ask of you. [low] Go on, try me again.
