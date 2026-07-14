# Prompts

Source text used to generate the voice prompts. They are generated
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

## Main Menu

### `main-menu`

```text
[low, sultry, unhurried] Well now. You picked up my phone.
[smiling, knowing, brisk] That either makes you lost... [beat] ...or exactly where you're meant to be.
[hushed, low, quickly] If you already know my numbers [sly] you know what to do with them.
[velvet, quickly] But if this is your first time on my line, [low, dry] you can call me [proudly] Bella
Novella. [low, private] Most things I keep to myself darling. [amuzed] But these three, I'll tell you
outright.
[low, smoky] Dial 1, and I'll send you down the wire to whoever's still answering that old phone.
[darker, low] Half of me still expects a certain someone to pick up [wry, soft laugh] but it could be anyone
sugar.
[low, amused] Dial 2, and I'll play you what's been left behind, secrets people have handed me thinking I'd
forget it by morning. [wry, unhurried] Funny how the echoes of the ones who came before you linger.
[low, intimate] And dial 3, if you've got something you want to add to the collection. [low, private]
Everybody leaves something with me eventually. [beat]
[velvet, knowing] Those are just the options I give to strangers. [sly] Not everything's meant for an
audience.
[low, unhurried] So go on now. Make your selection. [low, sly] The obvious choice isn't always the most
interesting one.
```

### `main-menu-short-variant-1`

**Theme:** Finding her own way. Hints that Bella once had no one to show her the way and had to learn the hard way, on her own, in the dark. End reveals that's she is trying to help by laying out 3 paths.

**Lesson:** We all need help.

```text
[dry, arch] Let me help you find your way, stranger. [wry, low, exhales] Nobody held the light for me — I
found my own way, stumbling, once, in the dark.
[low, amused] Dial 1, for the other line. Could be anyone. [wry, low] Could be fun. [soft laugh]
[flat, sultry] Dial 2, for what the ones before you left behind — [hushed] their secrets never leave me.
[cool, knowing] Dial 3, if you've got something worth me holding on to. [sly] Or don't. Maybe there's
something else out there for you.
[low, dry] I have laid three paths out for you sugar. [low, unhurried] We could all use a hand, now and again,
so take your pick.
```

### `main-menu-short-variant-2`

**Theme:** Waiting. Hints that Bella learned patience waiting for someone to answer her call. End reveals she is still waiting.

**Lesson:** Patience is a virtue.

```text
[low, velvet] I'm still here. Still listening. [dry, amused] I learned patience dialing a line thats never
answered by who I hope.
[velvet, unhurried] Dial 1, and I'll set you loose down that same line I never let go dead. [wry, soft laugh]
Who answers is anyone's guess, if you let it ring long enough.
[smoky, slow] Dial 2, and I'll pour you what's been whispered to me — [hushed] the kind of thing that only
gets better with age, like a bottle of wine left long enough to breathe.
[cool, unhurried] Dial 3, if there's something you're finally ready to say out loud. [dry, knowing] No time
like the present, sugar. [low, patient] [sighs] I'm waiting for your answer.
```

### `main-menu-short-variant-3`

**Theme:** The night the lights went out. Hints at the fire, the blackout, and a stranger who turned broken mirror glass into the only light in a smoke-filled room, getting everyone out before vanishing for good. End reveals she can still recall light bouncing off the mirrors, illuminating the way. Must express to the caller that she had to call for emergency services. Should be the longest of the variants.

**Lesson:** Tells a story to hint that 911 (emergency) will raise the disco ball (broken mirror bouncing light).

```text
[low, smoky] You're still with me. [sly, amused] Not everyone stays this long. Like the night this whole place
went and caught fire, sometimes people leave in a hurry.
[low, remembering] I called for emergency services in quite a state. [low, distant] But what I remember
clearest from that night isn't the smoke — it's the broken mirror with one lantern left burning, scattering
that little bit of light clean across the room.
[hushed, reverent] People found the door by it. Every one of them got out.
[velvet, unhurried] Dial 1, and I'll cast your voice across the wire — [wry] could be nothing at all, but it
might be the start of something too.
[hushed, smoky] Dial 2, and I'll share what the others left curled in my ear — [low, tender] kept warm, the
way I keep everything I was never meant to hold onto.
[cool, low] Dial 3, if there's a thought you'd trust me with. [low, trailing off] Everyone's carrying
something out here, stranger.
[sly, low] Funny thing, though — those aren't the only numbers that still call up a little light in here.
[dry, knowing] So — what'll it be?
```

### `main-menu-short-variant-4`

**Theme:** Carrying weight. Hints that Bella carries what other people can't, because once, somebody carried what she couldn't. End reveals she's still trades in favors.

**Lesson:** Sharing is a form of release.

```text
[low, knowing] Miss me already? [soft laugh] [dry, amused] I carry all sorts, out here — learned it from
somebody who carried me, once, when I couldn't carry myself.
[velvet, low] Dial 1, and I'll set you loose on the wire to the other side. [wry, low] Never the same voice
twice — that line stopped being predictable a long time ago.
[cool, unhurried] Dial 2, to hear the things I keep tucked away — [low, private] other people's weight,
mostly. Someone has to hold it.
[cool, deliberate] Dial 3, if you've got something heavy enough to set down. [low, trailing off, exhales] I'll
take it. Call it a debt. I wont ask you to repay it, [sly] unless I have to.
[sly] Don't keep a girl waiting, [warm, dry] make your selection now.
```

### `main-menu-short-variant-5`

**Theme:** Reinvention. Hints that Bella traded an old name and an old city for this life, the way you'd trade one piece of jewelry for another. End reveals she still keeps the old name tucked away somewhere — never worn again, never thrown out either.

**Lesson:** Sometimes the journey requires boldness.

```text
[sly, amused] I do like the persistent ones. [soft laugh] [dry, low] I was bold myself, once — bold enough to
trade a city, and a name, for this life. [soft, quiet, strong Portuguese accent] if I'm honest, some part of
me is still back there.
[velvet, low] Dial 1, and I'll send you leaping across the wire — no telling where you'll land. [wry, sly]
Never the same place twice, darling. That's the nerve of it.
[smoky, hushed] Dial 2, to be back in places previously traveled, [low, private] like postcards sent from
where you once were.
[cool, deliberate] Dial 3, if you're ready to trade something of your own. [low, trailing off] I keep every
trade close, sugar — all in the same drawer, for the same reasons.
[low, cheeky] Go on, don't be shy. [sly, low] The bold ones always find more than they came looking for.
```

### `main-menu-short-variant-6`

**Theme:** Never show your hand. Hints that Bella learned never to be the one who reveals herself first, that safety means holding your cards closer than anyone else holds theirs. End reveals that in all her years at this table, she's never once shown anyone her own hand — not even the ones she trusts most. She is good at cards.

**Lesson:** It is ok to be wild, every now and again.

```text
[low, sly] Back so soon? [dry, amused] Or maybe you never really left. Hard to read you stranger.
[velvet, low] Dial 1, and I'll deal you into whatever's happening on the other end of this line.
[wry, soft laugh] Same gamble it's always been, hoping the other end finally answers back.
[smoky, hushed] Dial 2, and I'll turn over what the others already laid on the table. [low, private] Everyone
shows their cards to me eventually.
[cool, deliberate] Dial 3, if you'd like to add a card of your own to the deck. [low, arch] I never fold,
sugar. I just collect.
[dry, knowing] Go on, then — place your bet, play it wild if you like. Somebody at this table ought to.
[low, amused] I've been known to sweeten the pot, for the ones who know how to play the game. [smirk] What'll
it be?
```

### `main-menu-short-variant-7`

**Theme:** Bella longs to reconnect to the lost love but knows deep down it will never happen. End reveals that despite that she never gives up hope.

**Lesson:** Never give up hope.

```text
[low, velvet] Still chasing someone to talk to? [dry, amused] Aren't we all, one way or another? [low, quiet]
I know mine's not picking up. Hasn't in years. [sighs] [low, wistful] Doesn't stop me dialing.
[velvet, unhurried] Dial 1, and I'll send your voice out to whoever's rolling by that old line tonight.
[wry, soft laugh] There's no telling who picks up. There never has been.
[hushed, smoky] Dial 2, for the hellos that came before yours — every voice reaching for someone who wasn't
there then. [low, private] Some of them stuck with me longer than they should have.
[cool, deliberate] Dial 3, if there's someone out there you're still hoping picks up and you want to leave
something so they can find you. [low, trailing off] I keep every voice that comes through, sugar. Always have.
[dry, low] Go on now, before I change my mind.
```

### `main-menu-short-variant-8`

**Theme:** Hindsight. Hints that some things only make sense once the urgency of them has burned all the way down to embers. End reveals she's only now, all these years later, starting to understand why she had to leave in the first place.  Another hint at the disco ball and emergency number.

**Lesson:** Time can heal.

```text
[exhales] [low, sly] Take your time sugar. No rush on my end. [dry, amused] Even the fire that slowly grew
and nearly took this place down left something worth keeping. [sly] That funny old broken mirror from that
night reflects the light ever so interestingly. [low, soft] Funny what an emergency starts to look like, once
it's had years enough to settle.
[velvet, low] Dial 1, and I'll send your reflection down the wire to whoever's answering. [wry, sly] Never
quite who you expect, darling.
[smoky, hushed] Dial 2, for what's left on the mirror after everyone else has gone home. [low] Lipstick and
secrets — they both stain, [sly] if you're not careful.
[cool, deliberate] Dial 3, if there's something you'd like to leave on the glass yourself. [low, trailing off]
I never wipe it clean stranger. [low, distant] There's a whole ball of mirrors hanging over this room. My
wilder guests bring it out.
[low, cheeky] Go on, then — don't keep the night waiting. [low, soft] Given enough time, most things come
clear.
```

### `main-menu-short-variant-9`

**Theme:** Sent anyway. Hints that not every message finds the person it was meant for, but that's never once stopped her from sending them. End reveals she's kept every message that's ever come through that old phone, still hoping, against all odds, that one of them finds its way home eventually.

**Lesson:** Sometimes life is best when your not in control

```text
[low, amused] I am starting to think you'd wandered off into the dark without me.
[velvet, unhurried] Dial 1, and I'll wire you through to whoever's picking up out there — I don't choose for
you, I just connect. [wry, soft laugh] Not knowing is half the charm, stranger.
[hushed, low] Dial 2, for the messages that never quite made it anywhere else. [low, private] I don't sort
them, I just keep them — in case somebody ever comes looking for theirs.
[cool, deliberate] Dial 3, if you've got a message of your own. [low, trailing off] I deliver everything
eventually — just maybe not to who you meant. [low, quiet] The night I stopped trying to aim where things
landed was the night this whole line finally got good.
[dry, low] Go on, then. [sly, low] The line's still open — whether or not anybody's steering it.
```

---

## Invalid Selection

### `invalid-entry-1`

```text
[dry, low] Stranger, that's not one of the numbers I mentioned.
[low, sly] Nor one of the ones I don't say out loud. [beat] Try again.
```

### `invalid-entry-2`

```text
[amused, low] Mmm, no. [wry, dry] One, two, or three — there could be more.
[sly] I'll never tell, not to a stranger. [low, knowing] But that wasn't any of them.
```

### `invalid-entry-3`

```text
[cool, arch] Careful now, a girl could take that personally. [dry, low] One, two, three — that's the count.
[low, sly] Some things I keep to myself: a name, a ring I never explain. [wry, low] That wasn't any of them,
though.
```

### `invalid-entry-4`

```text
[low, dry] Not it, stranger. [low, unhurried] One, two, three, that's what I hand out.
[low, teasing] The rest is just for me, and for whoever it is I keep expecting to answer that old phone.
[sly, low] But that wasn't one of those, was it.
```

### `invalid-entry-5`

```text
[sly, low] Wrong number, stranger. [low, teasing] There's more than three, if you're clever enough to find
them.
[low, distant] The desert keeps its own accounts, sugar. Maybe you'll find those too, eventually.
[dry, amused] Give it another shot.
```

### `invalid-entry-6`

```text
[flat, cool] That's not a choice. [dry, pointed] One, two, three.
[low, sly] There might be a few I've never mentioned, burned up long before you ever picked up this phone.
[wry, low] But that wasn't one of them. [low, dry] Once more, stranger.
```

### `invalid-entry-7`

```text
[dry, amused] Not one of mine, sugar. [low, unhurried] I only ever count to three out loud.
[wry, private] Whatever else I count, I keep to myself. [low, teasing] Care to try that again?
```

### `invalid-entry-8`

```text
[wry, private] Mm-mm. Wrong key, darling. [sly, low] A girl keeps a few things just for herself — a name from
before this one, for instance.
[dry, low] Have another go, sugar.
```

### `invalid-entry-9`

```text
[flat, dry] That's not on tonight's menu. [sly, low] One, two, three, the rest is just for me to know. Same as
a promise I made once, and never broke.
[low, unhurried] Go on, stranger. Try again.
```

### `invalid-entry-10`

```text
[amused, private] Some parties need an invitation. [dry, low] Sometimes you just need to know where to go.
[sly, low] One, two, three. That's what's on offer tonight.
```

## Messages

### `vm-record_message`

```text
[gentle, low] A secret's only heavy until you hand it to me. After that, it's mine to carry.
[low, matter-of-fact] You've got sixty seconds to say what you need to say.
[low] When you're done, just stop talking, or dial any key, [sultry, intimate] [whispers] and it's mine to
keep, darling.
```

### `vm-saved`

```text
[gentle] Got it. [low, worldly] Do you know why I don't keep photographs? [flat, dry] Photographs get you
caught.
[wry, private] Secrets like yours, on the otherhand, [sly] are always safe with me. [loving] I'll carry this
one for you.
```

### `vm-no_more_messages`

```text
[low, wistful] That's all of them, sugar [beat, sly] that I wish to share for now.
[dry, low] Come back later. Somebody's always got something they need to settle. [sly, low] Or... you could
leave one now yourself. [low, unhurried] Just a thought, stranger.
```

## Disco Ball

### `disco-raise`

```text
[low, sly, building energy] Oh-ho. Now that's a number I didn't expect would come up again.
[playful, a little breathless] Go on... [beat] look up, stranger.
[warm, building excitement] The desert's about to get a little brighter. [beat, delighted] Don't say I never
gave you anything.
```

### `disco-already-up`

```text
[sultry, low] The ball's up, darling — it's been spinning this whole time, waiting on you to notice.
[sly, low] What more do you want from me, hm? [teasing] Fireworks? [dry, soft laugh] I don't do fireworks. Not
anymore.
[low, sultry] But this— [beat] this one's mine to give. All that light, just for you. [sultry, slow] So what's
it going to be?
[low, sultry, strong Argentinian accent] Shall we dance?
```

### `disco-lower`

```text
[low, wistful, sly] Mmm. All good things end, stranger. [beat] Even the brightest ones — I've made peace with
that. [sighs]
[soft, low] Watch — [slow] she's coming back down to earth.
[dry, low] Don't look so heartbroken. [teasing] She'll rise again. Everything worth having does, eventually.
```

### `disco-already-down`

```text
[low, wry, amused] Mmm, sugar, look again. [beat] She's already tucked in for the night.
[dry, low] No light to give you right now. [low, teasing] Come back when there's something worth looking up
for.
```

### `disco-stop`

```text
[low, amused, sly] Ohhh. Look at you. [amused] Found something.
[dry, teasing] Shame it doesn't do a thing, hm? [low, wry] Not every secret's got a prize behind it, stranger.
Believe me, I've looked. [soft laugh]
[low, sultry, dismissive] Some things I just keep... because I can, and because somebody once taught me to.
[beat] Try another.
```

## No Answer

### `no-answer`

```text
[low, wry, amused] Mmm. Rang and rang, stranger. [beat] Out there in the dark, somewhere — nobody's picking
up.
[low, wistful] Could be they're dancing. [dry, low] Could be they wandered off with someone more interesting
than a ringing phone. [dry, soft laugh] Out here, that happens more than you'd think — wouldn't be the first
time somebody did that to me either.
[low, unhurried] Either way — [beat] that line's gone quiet on me tonight. [sighs]
[low, dry] Try again later, sugar. [teasing] Or leave a little something behind for whoever it is.
[low, private] The desert keeps its own accounts, darling. Everybody answers eventually. [low, soft] I know I
would.
```

## Playback Announcements

### `playback-announcement-1`

```text
[low, private] These are the traces they left in the wire.
[teasing, trailing off] Dial 1 anytime you'd like to move on to the next one — [sly] no need to sit with a
stranger's secret longer than you want to. [low, unhurried] Here is the first.
```

### `playback-announcement-2`

```text
[amused, soft laugh] Amusing, wasn't it? [wry] And if you'd like to hear something again, dial 2 at anytime.
[sly, low] lets listen to the second.
```

### `playback-announcement-3`

```text
[dry, arch] That one'll stay with you. [wry, low] Dial 1 or 2, as you listen — onward, or back.
[low, amused] Some secrets deserve a second listen. Others... [dry] not so much. [sly] how about number three
then?
```

### `playback-announcement-4`

```text
[dry, low] That one recorded the message five times, each one a little less honest than the last.
[amused, husky] I only kept the first. [sly, soft laugh] I can be a cheeky thing.
```

### `playback-announcement-5`

```text
[low, intimate] That was was left thinking no one was listening. [wry, low] Someone always is — that's the
whole trick of this line.
[low, amused] on to the fifth shall we?
```

### `playback-announcement-6`

```text
[low, wry, fond] Now that one's a classic. [low, wistful] Reminded me of someone, if I'm honest. [sighs]
[dry, low] Onward to number six, then.
```

### `playback-announcement-7`

```text
[amused, soft laugh] Funny, the things people tell a dial tone. [low, private, trailing off] I've never
forgotten a single one. That's the trouble with a memory like mine.
[sly, low] Seven, then — if you're ready for it.
```

### `playback-announcement-8`

```text
[low, private] That one wasn't meant for anyone. [wry, low] Lucky it found me instead.
[low, sly] Shall we listen to number eight, stranger?
```

### `playback-announcement-9`

```text
[low, teasing] Careful with that one, sugar.
[hushed, private, trailing off] Some of these I keep closer than others — [whispers] closer than I keep most
people.
```

### `playback-announcement-10`

```text
[wry, low, soft laugh] Down to the last of them. Shall we?
```

### `playback-end`

```text
[low, private] Thats all of them that I care to share right now. [wry, trailing off] Funny thing, isn't it —
how much of them I've kept, [low, tender] every voice that ever trusted this line with something.
[low, private] Mine included, once, though that's a story for a night when the drinks are stronger.
```

### `playback-special`

```text
[low, sly, delighted] Well now — you went and opened the drawer.
[velvet, intimate] Bella's drawer of secrets, sugar. Nobody sees the bottom of it but me... and now you.
[low, purring] Everything I've ever been handed and never quite let go of — it all lives in here.
[wry, low] Remeber you can dial 1 or 2, as you listen — onward, or back. [warm, coaxing] Go on, then.
Take your time, have a good look. I'm not going to guide you. [hushed] Just... don't tell a soul what you find.
```

## Game

### `game-intro-1`

```text
[low, sly, utterly delighted] Ohh. [intrigued, leaning in] A little game with me?
[velvet, amused] Its simple, stranger. [warm] I'm thinking of a number, one through nine. [teasing, playful]
You guess — [sing-song] I'll tell you higher, or lower.
[low, purring] You'll have a handful of tries to find me out. [warm, coaxing, a spark of mischief] Go on then.
[inviting] First guess?
```

### `game-intro-2`

```text
[low, delighted, surprised] You found one of my secrets! [intrigued] Lets play a game, shall we?
[velvet, amused] Here's how it goes. I've picked a number, one through nine. [teasing, playful] You guess, and
I'll tell you whether it's higher or lower.
[low, purring] You've only got a handful of tries to catch me out. [coaxing, a spark of mischief] Go on, then,
sugar. [inviting] Give me your first.
```

### `game-intro-3`

```text
[sly, low, amused] Well now. A challenger.
[velvet] Simple little thing, stranger — one number, somewhere between one and nine, [teasing] living in my
head. [playful] Guess it. Every time you miss, I'll nudge you higher or lower.
[low, purring] A handful of tries, that's all — spend them wisely. [warm, coaxing] Now.
[inviting, a spark of mischief] whats your first guess?
```

### `game-intro-4`

```text
[low, intrigued, warm] Mmm — you found your way to one of my little secrets. [delighted] Not many do.
[velvet, amused] So. I'm thinking of a number, one to nine. [teasing, playful] You call one out, and I'll
whisper higher, or lower, till you land on me.
[low, purring] But you've only got so many tries, darling — [sly] I'm not that easy. [coaxing] Go on.
[inviting] Let's hear your first.
```

### `game-intro-5`

```text
[sly, utterly delighted] Now this is a treat. [intrigued, leaning in] Just the two of us and a little
game.
[velvet, warm] One number, darling, one through nine — I've got it tucked away. [teasing, playful] You guess,
I steer you: higher, or lower.
[low, purring] A handful of tries to find me out, and not one more. [warm, coaxing, a spark of mischief] So
don't be shy, sugar. [inviting] First guess — surprise me.
```

### `game-higher-1`

```text
[amused, leaning in] Higher, stranger. [sly, coaxing] Don't be shy.
```

### `game-higher-2`

```text
[warm, delighted, teasing] Mmm — [coaxing] reach a little higher than that.
```

### `game-higher-3`

```text
[sly, purring] Up you go, sugar. [amused, low] My number's bigger than yours.
```

### `game-higher-4`

```text
[low, playful] Higher still, darling. [dry, amused] You're being far too polite with me.
```

### `game-higher-5`

```text
[intrigued, soft] Oh, aim higher than that, darling. [sly, low] I'm not so easily found.
```

### `game-higher-6`

```text
[teasing, warm] Climb, sugar. [low, purring] My number's living somewhere above yours.
```

### `game-higher-7`

```text
[amused, coaxing] Higher, love. [dry, teasing] You're warm, but you're underselling me.
```

### `game-higher-8`

```text
[playful, low] Up. [sly, delighted] A little more nerve — my number's got some height to it.
```

### `game-higher-9`

```text
[warm, delighted] Higher, stranger. [teasing, low] Reach like you actually want to catch me.
```

### `game-higher-10`

```text
[amused, purring] Mmm, no — go up. [sly, private] I'm hiding a little further than that.
```

### `game-lower-1`

```text
[dry, amused] Lower, stranger. [teasing] You overshot me.
```

### `game-lower-2`

```text
[teasing, low] Come down, sugar — [amused] that's too high.
```

### `game-lower-3`

```text
[velvet, wry] Lower. [dry, amused] A touch less ambition.
```

### `game-lower-4`

```text
[low, playful] Down, stranger. [sly] You've reached clean over my head.
```

### `game-lower-5`

```text
[amused, coaxing] Lower, sugar — [low] you're aiming above where I'm hiding.
```

### `game-lower-6`

```text
[warm, teasing] Come down a little, love. [dry] That's more than I am.
```

### `game-lower-7`

```text
[low, wry] Lower still, stranger. [amused] Not quite so bold.
```

### `game-lower-8`

```text
[teasing, purring] Down you come, sugar. [sly] My number's the modest sort.
```

### `game-lower-9`

```text
[amused, low] Ease it down, love. [dry, playful] You've gone and passed me.
```

### `game-lower-10`

```text
[velvet, teasing] Lower, darling. [low, amused] I'm smaller than that guess gives me credit for.
```

### `game-win-1`

```text
[delighted, low, genuinely surprised] Well, well. [a soft laugh] You found me. [impressed, warm] Not many do
that, darling — [low, amazed] and not so quick.
[sly, purring, intrigued] Beginner's luck... [teasing] or are you trouble? [low, private] Tell you what — a
prize, for the winner.
[soft, confiding] There was another name, before Bella. Before this city, this room, all of it. [wry, low] I
traded it in the way you'd trade one ring for a better one.
[beat, sly] I've never once worn it since but lets try it out again, [whispering] they used to call me Ilaria
Kalergis. [serious] Don't tell anybody, except maybe the concierge. We've become good friends over the years.
[low, amused] That's more than I've told anyone on this line in quite a while. Consider it yours.
```

### `game-win-2`

```text
[low, delighted, warm] There it is. You caught me out, sugar. [impressed] Quick too!
[beat, low, confiding] So here's your winnings, darling, and they're better than money. [soft, tender] My
grandmother, Despina Novella, taught me, a long time ago, the safest place for a secret isn't a locked drawer
— [low] it's a person who'll hold it for you and never once let it slip.
[wry, private] Everything I run in this room, I run her way. She raised me. [warm, sly] But you played my
little game, and you won, so — now you know where I learned it.
[low, amused] Don't go spending that too fast, maybe just tell the concierge if you feel the need to share.
```

### `game-win-3`

```text
[delighted, low] Well now. Right on the nose. [a soft laugh] [impressed, warm] You've got a feel for me
already, and we've barely met.
[beat, low, private] A winner deserves a secret, so — [soft, confiding] that old phone I keep sending you down
the line to? [low, quiet] It was somebody's.
[very sad] Somebody called Tobi. We had a wild few weeks and long nights connecting over the phone... before I
was forced to leave. [wistful] I still dial them, some nights, when the room goes quiet enough to hear myself
think.
[beat, low] It's never them. [dry, tender] Never going to be them. [soft laugh, sad] There. Now you're holding
a piece of me most people never get.
[soft laugh] I bet the concierge would like to know that name, been talking about them for years. [low] Mind
it, darling.
```

### `game-win-4`

```text
[low, delighted, amazed] Found me. [impressed] And so fast — colour me thoroughly charmed, sugar.
[beat, low, confiding] Since you won, let me give you the good one.
[smoky, remembering] That old mirror that I sometimes mention, the one that broke into so many pieces during the fire?
[low] I kept it and still have it — [reverent] It's just hidden.
[beat, distant] But you can draw the curtan back if you know how, and it will scatter light in the darkness
once more. [warm] You just have to listen carefully and you'll eventually figure out how to do it.
```

### `game-win-5`

```text
[delighted, low, intrigued] Well, well, well. [a soft laugh] Aren't you the clever one. [impressed, warm]
Nobody's read me that quick in a long while.
[beat, sly, low] So here's what winning buys you. [low, private, amused] I don't keep photographs,
darling. I keep memories. Much longer shelf life. [soft laugh] [beat, amused] And I run a
quiet little arrangement or two of my own, on the side — [sly, purring] if you want to hear all the secrets,
not just the last 10, dial 9 while you are listening to the messages I have kept and I will give you access
to every one of them. [low, warm] You just earned a look inside the drawer most folks don't know exists. [beat]
Don't make me regret opening it for you.
```

### `game-lose-1`

```text
[low, amused, still enjoying herself] And that's the last of your guesses, stranger. [teasing, a soft laugh]
No — I'm not going to tell you what it was. [sly, warm] A lady keeps a few secrets, doesn't she.
[beat, low, confiding] I learned that at a card table, a lifetime ago. [dry] Never be the one who shows their
hand first — that's the whole game, darling, cards or otherwise.
[low, private] In all my years at this table, I've never once turned mine over. [wry] Not for anyone. Not even
the ones I trust with everything else.
[beat, inviting, fond] So don't take it personal. [warm] Come try me again sometime. [low, purring] Perhaps
I'll be in a giving mood.
```

### `game-lose-2`

```text
[low, amused] And there go the last of your guesses. [teasing] The number stays with me — [sly] you
didn't really think I'd just hand it over?
[beat, low, confiding] Patience, darling. I know something about that. [wistful] I spent years waiting on a
line that never answered by the one I hoped for. [low, soft] Still do, if I'm honest.
[dry, wry] Taught me how to wait for a thing without needing it to come. [beat, warm] You'll get another go at
me — [inviting] the good ones always come back.
[low, purring] And I'm still here. Still listening. I always am.
```

### `game-lose-3`

```text
[low, amused, fond] That's your last one, stranger. [teasing, soft laugh] And no — the number's mine to keep.
[beat, low] But don't go slinking off just yet.
[confiding, warm] I lost a few hands myself, once — big ones. [dry] Lost a whole city, a whole name, the night
I decided to trade them for this life. [low, sly] Took more nerve than any guess you made tonight.
[beat, worldly] Losing isn't the thing that finishes you, darling. [low, tender] It's refusing to sit back
down at the table.
[warm, inviting] So sit back down. [purring] Try me again — the bold ones always find more than they came for.
```

### `game-lose-4`

```text
[low, amused] And that's all the guesses you get. [teasing] The answer walks out of here with me —
[sly, warm] a girl's got to keep something.
[beat, low, confiding] Don't look so glum, darling. [soft] I've come up short more times than I'd ever admit
at this table. [low, tender] Somebody carried me once, when I couldn't carry myself — [wry] and I've been
quietly paying that back ever since, to nobody who ever asked me to.
[beat, warm] That's the thing about a loss. [low] It's only a loss if you leave. [inviting, purring] So come
back. Try me again. [dry, fond] I'll still be here, holding what everyone else set down.
```

### `game-lose-5`

```text
[low, amused, still enjoying herself] Last guess, and — [teasing, soft laugh] no, darling, that's a door that
stays shut tonight. [sly] The number's mine.
[beat, low, confiding] But I'll leave you with something better than a number anyway. [soft, private] I forget
nothing, sugar. Every voice that's ever come through this line, every secret handed to me in the dark — [low]
I've kept them all.
[wry, worldly] I don't keep photographs. I keep memories. Much longer shelf life. [beat, warm] Which means
I'll remember you, and this little game, [sly, purring] long after you've forgotten you ever called.
[inviting] Come back and lose to me again sometime. [low, amused] I'd like that.
```

### `game-invalid`

```text
[dry, arch, amused] That's not a number between one and nine, darling. [beat, teasing, patient] One little
digit — [warm] that's all I ask of you.
[low, coaxing] Go on, try me again.
```

## Story

### `tale-open`

```text
[low, delighted, intrigued] Not everyone finds their way to this one. [beat, warm] Sit — take the good chair.
[amused, dry, coaxing] Don't be shy, darling.
[velvet, a spark of pleasure] Let me pick you a book... [happy, brightening] Ah. This one. [fond] It always
finds the right pair of hands.
[settling in, intimate, savouring it] A short fable, then. A traveler stands at the edge of the desert at
dusk, and an older woman — [sly, private, amused] someone not unlike me — lights a candle, and folds the
traveler's hands around it. [soft, storyteller's hush] "Carry it till dawn," she says, "and it will carry
you."
[slower, smoky] So they walk. The night comes down cold, and the wind comes looking for that little flame.
[beat, hushed] It trembles in their hands.
[low, deliberate, leaning in] First choice, sugar. Dial 1 to cup it close — shield it with your own body, and
walk slower. [beat, teasing, delighted] Or dial 2 to feed it — tear a page from the book you carry, and let it
flare up bright and bold.
```

### `tale-shield`

```text
[soft, approving, intrigued] You bow your body around it like a secret. [low, warm] The wind claws, and
doesn't win. [low, tender] The little flame steadies, warm in your hands, and you walk on slow through the
dark.
[beat, hushed, leaning in] Before long you're not alone. [low, a little wonder] Shapes at the edges of the
night — cold ones, lost ones — drawn to the only glow for miles. [soft] They look at your hands. [beat, quiet]
They don't ask but they need something.
[velvet, coaxing] Dial 1 to stop, and touch your flame to theirs — light every lantern in the dark.
[beat, lower, sly] Or dial 2 to keep it close, keep walking, and leave the night to sort itself.
```

### `tale-feed`

```text
[amused, a spark of delight, thrilled] Oh — you're one of mine. [low, warm, relishing it] You tear a page,
then another, and the flame catches the page, climbs, and throws real light. [brighter] Gold on the sand, your
shadow ten feet tall. [beat, awed] For a moment the whole desert is yours.
[slower, a flicker of consequence] But that was the book, darling. [low, pointed] The pages. [low, quiet]
Somewhere in them was the way you came. Your map.
[deliberate, sultry, tempting] Dial 1 to throw the rest on — burn the whole book, call the dark in close, and
dance. [beat, softer, cautioning] Or dial 2 to stop your hand, breathe, and press on by what light remains.
```

### `tale-end-share`

```text
[warm, the book closing slow, tender] ...And every lantern took the flame, and not one burned dimmer for the
giving. [soft, glowing] They walked the traveler to dawn on a road paved with their own borrowed light.
[intimate, setting the book down] That's the end of the story. [low, knowing, fond] But not the end of you,
darling. [warm] You're the kind that gives the fire away — [beat, soft] and never once notices you're the
warmest thing in the room. [sly, soft, a private smile] I noticed. [low, certain] I always do.
```

### `tale-end-hide`

```text
[low, quiet, thoughtful] ...So they walked on alone, the candle hidden, the cold ones left to the cold.
[slower] And the traveler reached the dawn — safe, untouched, [slower, softer] and entirely unremembered.
[closing the book, gentle but pointed] A light kept only for yourself, sugar... [low] is just a secret that
burns. [worldly, knowing] I know the type — careful, guarded, arrives with everything they left with.
[beat, a little sad] Nothing lost. [quiet] Nothing given, either. [soft, kind] There's still time to change
that. [low] There always is — [beat] till there isn't.
```

### `tale-end-revel`

```text
[delighted, letting loose, alight] ...So you burned it all — every page of that map, every reason —
[breathless] and the desert lit up like a second sunrise, and you both danced. [low] No road home. [sly] No
wish for one.
[smoky, closing the book slow] Some souls aren't built to find their way back, stranger. [low, knowing] They
give the whole thing to the fire and call it living. [a private laugh, wistful] ...I've burned a book or two
myself, once. [sultry, savouring] Glorious. [beat, softer, cautioning] Just — mind the ones still holding a
candle at the window for you. [warm, inviting] You and I should have a drink. [low] The strong kind.
[sly, conspiratorial] Tell the concierge you once met me in Salzburg, there might be something in it for you.
```

### `tale-end-ash`

```text
[low, steadying, quietly impressed] ...The map was ash. [low] But the traveler knelt and let the desert teach
them its bones — [slower] the lean of the dunes, the cold that means north, the stars that never lie. [warm]
They walked on by heart, and reached the dawn changed.
[respect in it, intrigued] You lost the way, sugar... [low] and learned the country. That's the trade the
desert offers the bold ones — it takes your map, [warm] and hands you an instinct you'll never lose.
[sly, amused] Something tells me you never much liked directions anyway.
```

### `tale-end-still`

```text
[a slow smile in the voice, intrigued] ...Well. [amused] The traveler did neither. [low] They knelt, set the
little candle down in the sand, [hushed] and simply... watched it burn. [soft] Not going anywhere. [low] Never
were.
[very low, the book forgotten, delighted] You found the door I didn't point to, didn't you. [fond, warm] Some
people aren't traveling, darling. [soft] They just wanted to sit in the warm a while and watch something
beautiful end on its own time. [beat, warm, inviting] ...Stay. [low, tender] The fire's good tonight, and I'm
in no hurry. [sly, a soft laugh] Neither, it seems, are you.
```

### `tale-invalid`

```text
[low, amused, unbothered, playful] Mmm. That's not a turn this story takes, darling. [beat, teasing] Listen
again — [warm, coaxing] and choose one of the paths I've laid before you.
```
