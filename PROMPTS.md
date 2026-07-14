# Prompts

Source text used to generate the voice prompts. The bracketed cues and spoken
lines below are reproduced verbatim and must not be altered.  They are generated
by a custom voice on https://elevenlabs.io.

## Regenerating prompts

[`scripts/bella-regen-prompts`](scripts/bella-regen-prompts) re-synthesizes the
prompts in this file whose text has changed, using the custom **Bella Novella**
voice under *My Voices* on ElevenLabs. It compares each prompt against a
baseline copy kept in the repo ([`PROMPTS.baseline.md`](PROMPTS.baseline.md)) so
only edited prompts are regenerated, then rebuilds the WAVs via
[`scripts/bella-convert-prompts`](scripts/bella-convert-prompts).

Run it on a developer machine (not the appliance):

```sh
pip install elevenlabs
export ELEVENLABS_API_KEY=...        # your ElevenLabs key
./scripts/bella-regen-prompts        # regenerate only what changed
./scripts/bella-regen-prompts --list # list every parsed prompt
./scripts/bella-regen-prompts --all  # regenerate everything
```

The heading id in backticks (e.g. `main-menu`) is the prompt's filename stem in
[`prompts/`](prompts/). The `Invalid` heading is special: its six blocks map to
`invalid-entry-1`..`invalid-entry-6`. After a successful run the baseline is
updated to match this file.

## Main Menu

### `main-menu`

```text
[exhales] [low, sultry, unhurried] Well now. You picked up my phone.
[smiling, knowing, brisk] That either makes you lost... [beat] ...or exactly where you're meant to be.
[hushed, low, quickly] If you already know my numbers... [sly] ...you know what to do with them.
[velvet, quickly] But if this is your first time on my line, [low, dry] here's how it works.
[low, smoky] Dial 1, and I'll send you down the wire to whoever's still answering that old phone. [darker, low] Half of me still expects a certain someone to pick up [wry, soft laugh] but it could be anyone, darling.
[low, amused] Dial 2, and I'll play you what's been left behind, secrets people have handed me thinking I'd forget it by morning. [wry, unhurried] Funny how the echoes of the ones who came before you linger.
[low, intimate] And dial 3, if you've got something you want to add to the collection. [low, private] Everybody leaves something with me eventually. [beat]
[velvet, knowing] Those are just the options I give to strangers. [sly] Not everything's meant for an audience.
[low, unhurried] So go on now. Make your selection. [low, sly] The obvious choice isn't always the most interesting one.
```

### `main-menu-short-variant-1`

**Theme:** Finding her own way. Hints that Bella once had no one to show her the way and had to learn the hard way, on her own, in the dark. End reveals that's exactly why she never lets a stranger walk away with less than three doors to try.

**Lesson:** We all need help.

```text
[dry, arch] Let me help you find your way, darling. [wry, low, exhales] Nobody held the light for me — I found my own way, stumbling, once, in the dark. [low, amused] Dial 1, for the other line. Could be anyone. [wry, low] Could be fun. [soft laugh] [flat, sultry] Dial 2, for what the ones before you left behind — [hushed] their secrets never leave me. [cool, knowing] Dial 3, if you've got something worth me holding on to. [sly] Or don't. Maybe there's something else out there for you. [low, dry] I have laid three paths out for you sugar. [low, unhurried] We could all use a hand, now and again, so take your pick.
```

### `main-menu-short-variant-2`

**Theme:** Waiting. Hints that Bella learned patience waiting for someone to answer her call. End reveals she is still waiting.

**Lesson:** Patience is a virtue.

```text
[low, velvet] I'm still here. Still listening. [dry, amused] I learned patience dialing a line thats never answered by who I hope. [velvet, unhurried] Dial 1, and I'll set you loose down that same line I never let go dead. [wry, soft laugh] Who answers is anyone's guess, if you let it ring long enough. [smoky, slow] Dial 2, and I'll pour you what's been whispered to me — [hushed] the kind of thing that only gets better with age, like a bottle of wine left long enough to breathe. [cool, unhurried] Dial 3, if there's something you're finally ready to say out loud. [dry, knowing] No time like the present, darling. [low, patient] [sighs] I'm waiting for your answer.
```

### `main-menu-short-variant-3`

**Theme:** The night the lights went out. Hints at the fire, the blackout, and a stranger who turned broken mirror glass into the only light in a smoke-filled room, getting everyone out before vanishing for good. End reveals she can still recall light bouncing off the mirrors, illuminating the way. Must express to the caller that she had to call for emergency services. Should be the longest of the variants.

**Lesson:** Tells a story to hint that 911 (emergency) will raise the disco ball (broken mirror bouncing light).

```text
[low, smoky, exhales] You're still with me. [sly, amused] Not everyone stays this long. Like the night this whole place went caught fire, sometimes people leave in a hurry. [low, remembering] I called for emergency services in quite a state. [low, distant] But what I remember clearest from that night isn't the smoke — it's the broken mirror, strung up over the one lantern left burning, scattering that little bit of light clean across the room. [hushed, reverent] People found the door by it. Every one of them got out. [velvet, unhurried] Dial 1, and I'll cast your voice across the wire — [wry] could be nothing at all, but it might be the start of something too. [hushed, smoky] Dial 2, and I'll share what the others left curled in my ear — [low, tender] kept warm, the way I keep everything I was never meant to hold onto. [cool, low] Dial 3, if there's a thought you'd trust me with. [low, trailing off] Everyone's carrying something out here, darling. [sly, low] Funny thing, though — those aren't the only numbers that still call up a little light in here. [dry, knowing] So — what'll it be?
```

### `main-menu-short-variant-4`

**Theme:** Carrying weight. Hints that Bella carries what other people can't, because once, somebody carried what she couldn't. End reveals she's still paying off a debt nobody's ever actually asked her to repay.

**Lesson:** Sharing is a form of release.

```text
[low, knowing] Miss me already? [soft laugh] [dry, amused] I carry all sorts, out here — learned it from somebody who carried me, once, when I couldn't carry myself. [velvet, low] Dial 1, and I'll set you loose on the wire to the other side. [wry, low] Never the same voice twice — that line stopped being predictable a long time ago. [cool, unhurried] Dial 2, to hear the things I keep tucked away — [low, private] other people's weight, mostly. Someone has to hold it. [cool, deliberate] Dial 3, if you've got something heavy enough to set down. [low, trailing off, exhales] I'll take it. Call it a debt. I wont ask you to repay it, [sly] unless I have to. [dry, arch] Don't make a girl wait, make your selection now.
```

### `main-menu-short-variant-5`

**Theme:** Reinvention. Hints that Bella traded an old name and an old city for this life, the way you'd trade one piece of jewelry for another. End reveals she still keeps the old name tucked away somewhere — never worn again, never thrown out either. Hint at what that name was.

**Lesson:** Sometimes the journey requires boldness.

```text
[sly, amused] I do like the persistent ones. [soft laugh] [dry, low] I was bold myself, once — bold enough to trade a city, and a name, for this life. [soft, quiet, strong Portuguese accent] if I'm honest, some part of me is still back there. [velvet, low] Dial 1, and I'll send you leaping across the wire — no telling where you'll land. [wry, sly] Never the same place twice, darling. That's the nerve of it. [smoky, hushed] Dial 2, to be back in places previously traveled, [low, private] like postcards sent from where you once were. [cool, deliberate] Dial 3, if you're ready to trade something of your own. [low, trailing off] I keep every trade close, sugar — all in the same drawer, for the same reasons. [low, cheeky] Go on, don't be shy. [sly, low] The bold ones always find more than they came looking for.
```

### `main-menu-short-variant-6`

**Theme:** Never show your hand. Hints that Bella learned never to be the one who reveals herself first, that safety means holding your cards closer than anyone else holds theirs. End reveals that in all her years at this table, she's never once shown anyone her own hand — not even the ones she trusts most. She is good at cards.

**Lesson:** It is ok to be wild, every now and again.

```text
[exhales] [low, sly] Back so soon? [dry, amused] Or maybe you never really left. Hard to read you stranger. [velvet, low] Dial 1, and I'll deal you into whatever's happening on the other end of this line. [wry, soft laugh] Same gamble it's always been, hoping the other end finally answers back. [smoky, hushed] Dial 2, and I'll turn over what the others already laid on the table. [low, private] Everyone shows their cards to me eventually. [cool, deliberate] Dial 3, if you'd like to add a card of your own to the deck. [low, arch] I never fold, sugar. I just collect. [dry, knowing] Go on, then — place your bet, play it wild if you like. Somebody at this table ought to. [low, amused] I've been known to sweeten the pot, for the ones who know how to play the game. [smirk] What'll it be?
```

### `main-menu-short-variant-7`

**Theme:** Bella longs to reconnect to the lost love but knows deep down it will never happen. End reveals that despite that she never gives up hope.

**Lesson:** Never give up hope.

```text
[low, velvet] Still chasing someone to talk to? [dry, amused] Aren't we all, one way or another? [low, quiet] I know mine's not picking up. Hasn't in years. [sighs] [low, wistful] Doesn't stop me dialing. [velvet, unhurried] Dial 1, and I'll send your voice out to whoever's rolling by that old line tonight. [wry, soft laugh] There's no telling who picks up. There never has been. [hushed, smoky] Dial 2, for the hellos that came before yours — every voice reaching for someone who wasn't there then. [low, private] Some of them stuck with me longer than they should have. [cool, deliberate] Dial 3, if there's someone out there you're still hoping picks up and you want to leave something so they can find you. [low, trailing off] I keep every voice that comes through, darling. Always have. [dry, low] Go on now, before I change my mind.
```

### `main-menu-short-variant-8`

**Theme:** Hindsight. Hints that some things only make sense once the urgency of them has burned all the way down to embers. End reveals she's only now, all these years later, starting to understand why she had to leave in the first place.

**Lesson:** Time can heal.

```text
[exhales] [low, sly] Take your time, darling. No rush on my end. [dry, amused] Even the fire that slowly grew and nearly took this place down left something worth keeping. [sly] That funny old broken mirror from that night reflects the light ever so interestingly. [low, soft] Funny what an emergency starts to look like, once it's had years enough to settle. [velvet, low] Dial 1, and I'll send your reflection down the wire to whoever's answering. [wry, sly] Never quite who you expect, darling. [smoky, hushed] Dial 2, for what's left on the mirror after everyone else has gone home. [low] Lipstick and secrets — they both stain, [sly] if you're not careful. [cool, deliberate] Dial 3, if there's something you'd like to leave on the glass yourself. [low, trailing off] I never wipe it clean, stranger. [low, distant] There's a whole ball of mirrors hanging over this room. My wilder guests bring it out. [low, cheeky] Go on, then — don't keep the night waiting. [low, soft] Given enough time, most things come clear.
```

### `main-menu-short-variant-9`

**Theme:** Sent anyway. Hints that not every message finds the person it was meant for, but that's never once stopped her from sending them. End reveals she's kept every message that's ever come through that old phone, still hoping, against all odds, that one of them finds its way home eventually.

**Lesson:** Sometimes life is best when your not in control

```text
[low, amused] I am starting to think you'd wandered off into the dark without me. [velvet, unhurried] Dial 1, and I'll wire you through to whoever's picking up out there — I don't choose for you, I just connect. [wry, soft laugh] Not knowing's is half the charm, darling. [hushed, low] Dial 2, for the messages that never quite made it anywhere else. [low, private] I don't sort them, I just keep them — in case somebody ever comes looking for theirs. [cool, deliberate] Dial 3, if you've got a message of your own. [low, trailing off] I deliver everything eventually — just maybe not to who you meant. [low, distant] There's an old phone somewhere out there that taught me that lesson, and one more besides. [low, quiet] The night I stopped trying to aim where things landed was the night this whole line finally got good. [low, distant, wistful] Some nights, I still think my message might find its way home. [dry, low] Go on, then. [sly, low] The line's still open — whether or not anybody's steering it.
```

---

## Invalid Selection

### `invalid-entry-1`

```text
[dry, low] Darling, that's not one of the numbers I mentioned. [low, sly] Nor one of the ones I don't say out loud. [beat] Try again.
```

### `invalid-entry-2`

```text
[amused, low] Mmm, no. [wry, dry] One, two, or three — there could be more. [sly] I'll never tell, not to a stranger. [low, knowing] But that wasn't any of them.
```

### `invalid-entry-3`

```text
[cool, arch] Careful now, a girl could take that personally. [dry, low] One, two, three — that's the count. [low, sly] Some things I keep to myself: a name, a ring I never explain. [wry, low] That wasn't any of them, though.
```

### `invalid-entry-4`

```text
[low, dry] Not it, darling. [low, unhurried] One, two, three, that's what I hand out. [low, teasing] The rest is just for me, and for whoever it is I keep expecting to answer that old phone. [sly, low] But that wasn't one of those, was it.
```

### `invalid-entry-5`

```text
[sly, low] Wrong number, stranger. [low, teasing] There's more than three, if you're clever enough to find them. [low, distant] The desert keeps its own accounts, darling. Maybe you'll find those too, eventually. [dry, amused] Give it another shot.
```

### `invalid-entry-6`

```text
[flat, cool] That's not a choice. [dry, pointed] One, two, three. [low, sly] There might be a few I've never mentioned, burned up long before you ever picked up this phone. [wry, low] But that wasn't one of them. [low, dry] Try again, darling.
```

### `invalid-entry-7`

```text
[dry, amused] Not one of mine, sugar. [low, unhurried] I only ever count to three out loud. [wry, private] Whatever else I count, I keep to myself. [low, teasing] Care to try that again?
```

### `invalid-entry-8`

```text
[wry, private] Mm-mm. Wrong key, darling. [sly, low] A girl keeps a few things just for herself — a name from before this one, for instance. [dry, low] Have another go, sugar.
```

### `invalid-entry-9`

```text
[flat, dry] That's not on tonight's menu. [sly, low] One, two, three, the rest is just for me to know. Same as a promise I made once, and never broke. [low, unhurried] Go on, darling. Try again.
```

### `invalid-entry-10`

```text
[amused, private] Some parties need an invitation. [dry, low] Sometimes you just need to know where to go. [sly, low] One, two, three. That's what's on offer tonight.
```

## Voicemail

### `vm-record_message`

```text
[gentle, low] A secret's only heavy until you hand it to me. After that, it's mine to carry. [low, matter-of-fact] You've got sixty seconds to say what you need to say. [low] When you're done, just stop talking, or dial any key, [sultry, intimate] [whispers] and it's mine to keep, darling.
```

### `vm-saved`

```text
[low, knowing] Got it, stranger. [low, reassuring] Safe with me now. [low, private, amused] I don't keep photographs, darling. I keep memories. Much longer shelf life. [soft laugh]
```

### `vm-no_more_messages`

```text
[sighs] [low, wistful] That's all of them, darling [beat] for now.
[dry, low] Come back later. The desert keeps its own accounts, and somebody's always got something they need to settle. [sly, low] Or... you could leave one now yourself. [low, unhurried] Just a thought, sugar.
```

## Disco Ball

### `disco-raise`

```text
[low, sly, amused] Oh-ho. Now that's a number I didn't expect tonight.
[low, teasing] Go on... [beat] look up, darling.
[low, distant] Somebody hung that thing up for me once, and never came back to take it down. [soft laugh] [wry, low] Their loss. [sly, low] Lucky for you.
```

### `disco-already-up`

```text
[sultry, low] The ball's up, darling — it's been spinning this whole time, waiting on you to notice.
[sly, low] What more do you want from me, hm? [teasing] Fireworks? [dry, soft laugh] I don't do fireworks. Not anymore.
[low, sultry] But this— [beat] this one's mine to give. All that light, just for you. [sultry, slow] So what's it going to be, darling?
[low, sultry, strong Argentinian accent] Shall we dance?
```

### `disco-lower`

```text
[low, wistful, sly] Mmm. All good things end, darling. [beat] Even the brightest ones — I've made peace with that. [sighs]
[soft, low] Watch — [slow] she's coming back down to earth.
[dry, low] Don't look so heartbroken. [teasing] She'll rise again. Everything worth having does, eventually.
```

### `disco-already-down`

```text
[low, wry, amused] Mmm, sugar, look again. [beat] She's already tucked in for the night.
[dry, low] No light to give you right now. [low, teasing] Come back when there's something worth looking up for.
```

### `disco-stop`

```text
[low, amused, sly] Ohhh. Look at you. [amused] Found something.
[dry, teasing] Shame it doesn't do a thing, hm? [low, wry] Not every secret's got a prize behind it, darling. Believe me, I've looked. [soft laugh]
[low, sultry, dismissive] Some things I just keep... because I can, and because somebody once taught me to. [beat] Try another.
```

## No Answer

### `no-answer`

```text
[low, wry, amused] Mmm. Rang and rang, darling. [beat] Out there in the dark, somewhere — nobody's picking up.
[low, wistful] Could be they're dancing. [dry, low] Could be they wandered off with someone more interesting than a ringing phone. [dry, soft laugh] Out here, that happens more than you'd think — wouldn't be the first time somebody did that to me either.
[low, unhurried] Either way — [beat] that line's gone quiet on me tonight. [sighs]
[low, dry] Try again later, sugar. [teasing] Or leave a little something behind for whoever it is. [low, private] The desert keeps its own accounts, darling. Everybody answers eventually. [low, soft] I know I would.
```

## Playback Announcements

### `playback-announcement-1`

```text
[exhales] [low, private] These are the traces they left in the wire. [teasing, trailing off] Dial 1 anytime you'd like to move on to the next one — [sly] no need to sit with a stranger's secret longer than you want to. [low, unhurried] Here is the first.
```

### `playback-announcement-2`

```text
[amused, soft laugh] Amusing, wasn't it? [wry] And if you'd like to hear something again, dial 2 at anytime. [sly, low] lets listen to the second.
```

### `playback-announcement-3`

```text
[dry, arch] That one'll stay with you. [wry, low] Dial 1 or 2, as you listen — onward, or back. [low, amused] Some secrets deserve a second listen. Others... [dry] not so much. [sly] how about number three then?
```

### `playback-announcement-4`

```text
[dry, low] That one recorded the message five times, each one a little less honest than the last. [amused, husky] I only kept the first. [sly, soft laugh] I can be a cheeky thing.
```

### `playback-announcement-5`

```text
[low, intimate] That was was left thinking no one was listening. [wry, low] Someone always is — that's the whole trick of this line. [low, amused] on to the fifth shall we?
```

### `playback-announcement-6`

```text
[low, wry, fond] Now that one's a classic. [low, wistful] Reminded me of someone, if I'm honest. [sighs] [dry, low] Onward to number six, then.
```

### `playback-announcement-7`

```text
[amused, soft laugh] Funny, the things people tell a dial tone. [low, private, trailing off] I've never forgotten a single one. That's the trouble with a memory like mine. [sly, low] Seven, then — if you're ready for it.
```

### `playback-announcement-8`

```text
[low, private] That one wasn't meant for anyone. [wry, low] Lucky it found me instead. [low, sly] Shall we listen to number eight, darling?
```

### `playback-announcement-9`

```text
[low, teasing] Careful with that one, darling. [hushed, private, trailing off] Some of these I keep closer than others — [whispers] closer than I keep most people.
```

### `playback-announcement-10`

```text
[wry, low, soft laugh] Down to the last of them. Shall we?
```

### `playback-end`

```text
[low, private] Thats all of them that I care to share right now. [wry, trailing off] Funny thing, isn't it — how much of them I've kept, [low, tender] every voice that ever trusted this line with something. [low, private] Mine included, once, though that's a story for a night when the drinks are stronger.
```
