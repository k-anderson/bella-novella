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
[low, sultry, smoke-curling] Well now. You picked up my phone.
[half-smile, knowing] That either makes you lost... [chuckle][long beat, unhurried] ...or exactly where you're meant to be.
[hushed, almost a whisper] If you already know my numbers... [sly, lips-curled] ...you know what to do with them.
[velvet, commanding but unhurried] But if this is your first time on my line, [slow, sultry] here's how it works.
[low, deliberate] Dial 1, and I'll send you down the wire to whoever's still answering that old phone.  [darker, low] Half of me still expects a certain someone to pick up [wry, half-laughing] but it could be anyone, darling.
[low, amused, private] Dial 2, and I'll play you what's been left behind, secrets people have handed me thinking I'd forget it by morning. [sad, quiet] Funny how the echoes of the ones who came before you linger.
[intimate, leaning in, almost touching the mic] And dial 3, if you've got something you want to add to the collection. [low, private, trailing off] Everybody leaves something with me eventually. [beat]
[low, velvet, quiet] Those are just the options I give to strangers. [sly] Not everything's meant for an audience.
[warm, low, half-dismissive] So go on now, darling. Make your selection. [low, sly] The obvious choice isn't always the most interesting one.
```

### `main-menu-short-variant-1`

**Theme:** Finding her own way. Hints that Bella once had no one to show her the way and had to learn the hard way, on her own, in the dark. End reveals that's exactly why she never lets a stranger walk away with less than three doors to try.

**Lesson:** We all need help.

```text
[dry, arch] Let me help you find your way, darling. [wry, low] Nobody held the light for me — I found my own way, stumbling, once, in the dark. [low, a little amused] Dial 1, for the other line. Could be anyone. [playful] Could be fun. [flat, sultry] Dial 2, for what the ones before you left behind — [low, almost a whisper] their secrets never leave me. [cool, half-smiling] Dial 3, if you've got something worth me holding on to. [sly, half-smile] Or don't. Maybe there's something else out there for you. [warm, dry] I have laid three paths out for you, sugar. [beat, quiet] We could all use a hand, now and again, so take your pick.
```

### `main-menu-short-variant-2`

**Theme:** Waiting. Hints that Bella learned patience waiting for someone to answer her call. End reveals she is still waiting.

**Lesson:** Patience is a virtue.

```text
[low, velvet] I'm still here. Still listening. [dry, amused] I learned patience dialing a line thats never answered by who I hope. [velvet, unhurried] Dial 1, and I'll set you loose down that same line I never let go dead. [wry, half-laughing] Who answers is anyone's guess, if you let it ring long enough. [smoky, slower] Dial 2, and I'll pour you what's been whispered to me — [hushed] the kind of thing that only gets better with age, like a bottle of wine left long enough to breathe. [cool, deliberate] Dial 3, if there's something you're finally ready to say out loud. [warm, dry] No time like the present, darling. [beat, quiet] I'm waiting for your answer.
```

### `main-menu-short-variant-3`

**Theme:** The night the lights went out. Hints at the fire, the blackout, and a stranger who turned broken mirror glass into the only light in a smoke-filled room, getting everyone out before vanishing for good. End reveals she can still recall light bouncing off the mirrors, illuminating the way. Must express to the caller that she had to call for emergency services. Should be the longest of the variants.

**Lesson:** Tells a story to hint that 911 (emergency) will raise the disco ball (broken mirror bouncing light).

```text
[low, smoke-curled] You're still with me. [sly, amused] Not everyone stays this long. I didn't either, once — when the night this whole place went black. [low, remembering] I called for emergency services in quite a state. [low, distant] What I remember clearest from that night isn't the smoke — it's the broken mirror, strung up over the one lantern left burning, scattering that little bit of light clean across the room. [hushed] People found the door by it. Every one of them got out. [velvet, unhurried] Dial 1, and I'll cast your voice across the wire — [wry] could be nothing at all, but it might be the start of something too. [hushed, smoky] Dial 2, and I'll share what the others left curled in my ear — [low, reverent] kept warm, the way I keep everything I was never meant to hold onto. [cool, inviting] Dial 3, if there's a thought you'd trust me with. [low, trailing off] Everyone's carrying something out here, darling. [sly, low] Funny thing, though — those aren't the only numbers that still call up a little light in here. [warm, dry] So — what'll it be?
```

### `main-menu-short-variant-4`

**Theme:** Carrying weight. Hints that Bella carries what other people can't, because once, somebody carried what she couldn't. End reveals she's still paying off a debt nobody's ever actually asked her to repay.

**Lesson:** Sharing is a form of release.

```text
[low, playful] Miss me already? [dry, amused] I carry all sorts, out here — learned it from somebody who carried me, once, when I couldn't carry myself. [velvet, low] Dial 1, and I'll set you loose on the wire to the other side. [wry, half-smiling] Never the same voice twice — that line stopped being predictable a long time ago. [cool, deliberate] Dial 2, to hear the things I keep tucked away — [low, private] other people's weight, mostly. Someone has to hold it. [cool, deliberate] Dial 3, if you've got something heavy enough to set down. [low, trailing off] I'll take it, sugar. I'm good at that. [warm, dry] Make your selection now. [sly] Don't make a girl wait. [low, quiet] Call it a debt. I never ask anybody to repay it, unless I have to.
```

### `main-menu-short-variant-5`

**Theme:** Reinvention. Hints that Bella traded an old name and an old city for this life, the way you'd trade one piece of jewelry for another. End reveals she still keeps the old name tucked away somewhere — never worn again, never thrown out either. Hint at what that name was.

**Lesson:** Sometimes the journey requires boldness.

```text
[sly, happy] I do like the persistent ones. [dry, warm] I was bold myself, once — bold enough to trade a city, and a name, for this life. [beat, soft] Some part of me is still back there, if I'm honest. [velvet, low] Dial 1, and I'll send you leaping across the wire — no telling where you'll land. [wry, half-smiling] Never the same place twice, darling. That's the nerve of it. [smoky, hushed] Dial 2, to be back in places previously traveled, [low, private] like postcards sent from where you once were. [cool, deliberate] Dial 3, if you're ready to trade something of your own. [low, trailing off] I keep every trade close, sugar — all in the same drawer, for the same reasons. [warm, cheeky] Go on, don't be shy. [sly, low] The bold ones always find more than they came looking for.
```

### `main-menu-short-variant-6`

**Theme:** Never show your hand. Hints that Bella learned never to be the one who reveals herself first, that safety means holding your cards closer than anyone else holds theirs. End reveals that in all her years at this table, she's never once shown anyone her own hand — not even the ones she trusts most. She is good at cards.

**Lesson:** It is ok to be wild, every now and again.

```text
[low, sly] Back so soon? [dry, amused] Or maybe you never really left. Hard to read you sugar. [velvet, low] Dial 1, and I'll deal you into whatever's happening on the other end of this line. [wry, half-laughing] Same gamble it's always been, hoping the other end finally answers back. [smoky, hushed] Dial 2, and I'll turn over what the others already laid on the table. [low, private] Everyone shows their cards to me eventually. [cool, deliberate] Dial 3, if you'd like to add a card of your own to the deck. [low, trailing off] I never fold, sugar. I just collect. [warm, dry] Go on, then — place your bet, play it wild if you like. Somebody at this table ought to. [low, amused] I've been known to sweeten the pot, for the ones who know how to play the game.
```

### `main-menu-short-variant-7`

**Theme:** Bella longs to reconnect to the lost love but knows deep down it will never happen. End reveals that despite that she never gives up hope.

**Lesson:** Never give up hope.

```text
[low, velvet] Still chasing someone to talk to? [dry, amused] Aren't we all, one way or another? [beat, quiet] I know mine's not picking up. Hasn't in years. [low, warm] Doesn't stop me dialing. [velvet, unhurried] Dial 1, and I'll send your voice out to whoever's rolling by that old line tonight. [wry, half-laughing] There's no telling who picks up. There never has been. [hushed, smoky] Dial 2, for the hellos that came before yours — every voice reaching for someone who wasn't home. [low, private] Some of them stuck with me longer than they should have. [cool, deliberate] Dial 3, if there's someone out there you're still hoping picks up and you want to leave something so they can find you. [low, trailing off] I keep every voice that comes through, darling. Always have. [warm, dry] Go on now, before I change my mind. [low, distant] A girl can know better and still keep hoping. I do, most nights.
```

### `main-menu-short-variant-8`

**Theme:** Hindsight. Hints that some things only make sense once the urgency of them has burned all the way down to embers. End reveals she's only now, all these years later, starting to understand why she had to leave in the first place.

**Lesson:** Time can heal.

```text
[warm, sly] There you are again. [playful] Or still — hard to say, out here. [beat, quiet] Some things only make sense once the fire's burned down to embers. [low, private] Took me years to understand why I left the first time — only starting to, now. [velvet, low] Dial 1, and I'll powder you off down the wire to whoever's answering. [wry, half-smiling] Never quite who you expect, darling. [smoky, hushed] Dial 2, for what's left on the mirror after everyone else has gone home. [low, private] Lipstick and secrets — they both stain, if you're not careful. [cool, deliberate] Dial 3, if there's something you'd like to leave on the glass yourself. [low, trailing off] I never wipe it clean, sugar, and I never show everything on a first pass. [low, distant] There's a whole ball of mirrors hanging over this room — left behind by somebody who never came back for it. My wilder guests like to switch it on. [sly, low] I just like to watch it turn. [warm, cheeky] Go on, then — don't keep the night waiting. [low, soft] Given enough time, most things come clear.
```

### `main-menu-short-variant-9`

**Theme:** Sent anyway. Hints that not every message finds the person it was meant for, but that's never once stopped her from sending them. End reveals she's kept every message that's ever come through that old phone, still hoping, against all odds, that one of them finds its way home eventually.

**Lesson:** Sometimes life is best when your not in control

```text
[amused] Good. I was starting to think you'd wandered off into the dark without me. [velvet, unhurried] Dial 1, and I'll wire you through to whoever's picking up out there — I don't choose for you, I just connect. [wry] Not knowing's is half the charm, darling. [hushed, low] Dial 2, for the messages that never quite made it anywhere else. [low, private] I don't sort them, I just keep them — in case somebody ever comes looking for theirs. [cool, deliberate] Dial 3, if you've got a message of your own. [low, trailing off] I deliver everything eventually — just maybe not to who you meant. [beat, distant] There's an old phone somewhere out there that taught me that lesson, and one more besides. [low, quiet] The night I stopped trying to aim where things landed was the night this whole line finally got good. [low, distant] Some nights, I still think my message might find its way home. [warm, dry] Go on, then. [sly, low] The line's still open — whether or not anybody's steering it.
```

---

## Invalid Selection

### `invalid-entry-1`

```text
[dry, flat] Darling, that's not one of the numbers I mentioned. [low, sultry] Nor one of the ones I don't say out loud. [beat] Try again.
```

### `invalid-entry-2`

```text
[low, amused] Mmm, no. [wry] One, two, or three — there could be more. [playful] I'll never tell, not to a stranger. [low] But that wasn't any of them.
```

### `invalid-entry-3`

```text
[cool, arch] Careful now, a girl could take that personally. [beat, dry] One, two, three — that's the count. [low, sly] Some things I keep to myself: a name, a ring I never explain. [beat, playful] That wasn't any of them, though.
```

### `invalid-entry-4`

```text
[low, tired-but-warm] Not it, darling. [beat] One, two, three, that's what I hand out. [low, teasing] The rest is just for me, and for whoever it is I keep expecting to answer that old phone. [beat] But that wasn't one of those, was it.
```

### `invalid-entry-5`

```text
[low, playful, slow] Wrong number, stranger. [beat, low, teasing] There's more than three, if you're clever enough to find them. [low] The desert keeps its own accounts, darling. Maybe you'll find those too, eventually. [dry, amused] Give it another shot.
```

### `invalid-entry-6`

```text
[flat, clipped] That's not a choice. [dry, pointed] One, two, three. [beat, low, sly] There might be a few I've never mentioned, burned up long before you ever picked up this phone. [flat, playful] But that wasn't one of them. [beat] Try again, darling.
```

### `invalid-entry-7`

```text
[dry, amused] Not one of mine, sugar. [beat, low] I only ever count to three out loud. [wry, private] Whatever else I count, I keep to myself. [low, teasing] Care to try that again?
```

### `invalid-entry-8`

```text
[low, wry, private] Mm-mm. Wrong key, darling. [beat, sly] A girl keeps a few things just for herself — a name from before this one, for instance. [wry] Have another go, sugar.
```

### `invalid-entry-9`

```text
[flat, dry] That's not on tonight's menu. [beat, sly] One, two, three, the rest is just for me to know. Same as a promise I made once, and never broke. [low] Go on, darling. Try again.
```

### `invalid-entry-10`

```text
[low, amused, private] Some parties need an invitation. [beat, dry] Sometimes you just need to know where to go. [beat] One, two, three. That's what's on offer tonight.
```

## Voicemail

### `vm-record_message`

```text
[gentle, low] A secret's only heavy until you hand it to me. After that, it's mine to carry. [matter-of-fact, gentle] You've got sixty seconds to say what you need to say. [low] When you're done, just stop talking, or dial any key, [private, sexy] and it's mine to keep, darling.
```

### `vm-saved`

```text
[warm, low] Got it, stranger. [beat, soft] Safe with me now. [low, private] I don't keep photographs, darling. I keep memories. Much longer shelf life.
```

### `vm-no_more_messages`

```text
[low, a little wistful] That's all of them, darling [beat] for now.
[warm, dry] Come back later. The desert keeps its own accounts, and somebody's always got something they need to settle. [beat, playful] Or... you could leave one now yourself. [low, warm] Just a thought, sugar.
```

## Disco Ball

### `disco-raise`

```text
[low, sly, building energy] Oh-ho. Now that's a number I didn't expect tonight.
[playful, a little breathless] Go on... [beat] look up, darling.
[warm, building excitement] Somebody hung that thing up for me once, and never came back to take it down. [wry, low] Their loss. [beat, delighted] Lucky for you.
```

### `disco-already-up`

```text
[beat, sultry] The ball's up, darling — it's been spinning this whole time, waiting on you to notice.
[sly, low] What more do you want from me, hm? [beat, jokingly] Fireworks? [playful] I don't do fireworks. Not anymore.
[warm, low, building] But this— [beat] this one's mine to give. All that light, just for you. [sultry, slow] So what's it going to be, darling?
[low, warm, inviting] Shall we dance?
```

### `disco-lower`

```text
[low, wistful, a little sly] Mmm. All good things end, darling. [beat] Even the brightest ones — I've made peace with that.
[soft, low] Watch — [beat, slow] she's coming back down to earth.
[warm, dry, affectionate] Don't look so heartbroken. [beat, teasing] She'll rise again. Everything worth having does, eventually.
```

### `disco-already-down`

```text
[low, wry, amused] Mmm, sugar, look again. [beat] She's already tucked in for the night.
[dry, playful] No light to give you right now. [beat, low, teasing] Come back when there's something worth looking up for.
```

### `disco-stop`

```text
[low, delighted, sly] Ohhh. Look at you. [beat, amused] Found something.
[playful, teasing] Shame it doesn't do a thing, hm? [beat, warm, wry] Not every secret's got a prize behind it, darling. Believe me, I've looked.
[low, sultry, dismissive] Some things I just keep... because I can, and because somebody once taught me to. [beat] Try another.
```

## No Answer

### `no-answer`

```text
[low, wry, amused] Mmm. Rang and rang, darling. [beat] Out there in the dark, somewhere — nobody's picking up.
[low, wistful] Could be they're dancing. [beat, playful] Could be they wandered off with someone more interesting than a ringing phone. [dry] Out here, that happens more than you'd think — wouldn't be the first time somebody did that to me either.
[warm, low] Either way — [beat] that line's gone quiet on me tonight.
[warm, dry, affectionate] Try again later, sugar. [beat, teasing] Or leave a little something behind for whoever it is. [low, private] The desert keeps its own accounts, darling. Everybody answers eventually. [beat] I know I would.
```

## Playback Announcements

### `playback-announcement-1`

```text
[low, private] These are the traces they left in the wire. [low, trailing off] Dial 1 anytime you'd like to move on to the next one — no need to sit with a stranger's secret longer than you want to. Here is the first.
```

### `playback-announcement-2`

```text
[low, amused] Amusing, wasn't it? [wry] And if you'd like to hear something again, dial 2 at anytime. [playful] lets listen to the second.
```

### `playback-announcement-3`

```text
[dry, arch, warm] That one'll stay with you. [wry, light] Dial 1 or 2, as you listen — onward, or back. [low, amused] Some secrets deserve a second listen. Others... not so much. [sly] how about number three then?
```

### `playback-announcement-4`

```text
[playful, low] That one recorded the message five times, each one a little less honest than the last. [amused, husky] I only kept the first. [playful] I can be a cheeky thing.
```

### `playback-announcement-5`

```text
[low, intimate, playful] That was was left thinking no one was listening. [wry, light] Someone always is — that's the whole trick of this line. [amused] on to the fifth shall we?
```

### `playback-announcement-6`

```text
[low, wry, fond] Now that one's a classic. [low] Reminded me of someone, if I'm honest. [dry, low] Onward to number six, then.
```

### `playback-announcement-7`

```text
[low, amused] Funny, the things people tell a dial tone. [low, private, trailing off] I've never forgotten a single one. That's the trouble with a memory like mine. [sly, low] Seven, then — if you're ready for it.
```

### `playback-announcement-8`

```text
[low, private] That one wasn't meant for anyone. [wry, low] Lucky it found me instead. [wry, low] Shall we listen to number eight, darling?
```

### `playback-announcement-9`

```text
[low, amused] Careful with that one, darling. [low, private, trailing off] Some of these I keep closer than others — closer than I keep most people.
```

### `playback-announcement-10`

```text
[wry, low] Down to the last of them. Shall we?
```

### `playback-end`

```text
[low, warm, private] Thats all of them that I care to share right now. [wry, trailing off] Funny thing, isn't it — how much of them I've kept, [low, almost tender] every voice that ever trusted this line with something. [low, private] Mine included, once, though that's a story for a night when the drinks are stronger. [beat] And now you care those too.
```
