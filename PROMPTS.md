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

**Theme:** Finding her own way.
**Backstory:** In her earliest days Bella had no one to hold the light for her — she learned everything the hard way, stumbling alone in the dark.
**Reveal:** Somewhere along the way someone took her in and showed her how to carry herself, and that's exactly why she now lays three clear paths out for every stranger: so no one has to grope through the dark the way she once did. She's handing forward the help she was once given.
**Lesson:** We all need help.

```text
[dry, warm] Lost the thread, did you? [wry, low] Don't fret. I wandered lost a good while myself, once. 
[low, exhales] Nobody drew me a map back then.
[low, amused] So let me draw you one. There's a line to the other side, and whoever picks up might just be a 
soul you can draw a map for yourself. Dial 1 if you want to try. [wry, low] Could be fun. [soft laugh]
[velvet, low] To hear about the paths walked before you, everything the ones prior left in my keeping, dial 2. 
[hushed] I hold onto every last one.
[warm, low] And dial 3 if you'd sooner leave a marker of your own for whoever comes next. [soft laugh]
[low, knowing] Three paths, stranger, all lit and waiting. [gentle] No one should have to feel their way 
in the dark. [coaxing] Take whichever one calls to you.
```

### `main-menu-short-variant-2`

**Theme:** Waiting.
**Backstory:** Years of dialing a line that never answers the way she hopes taught Bella how to wait for a thing without needing it to come.
**Reveal:** Rather than souring her, the waiting made her serene — she's still here, still listening, and a caller who takes their time never rattles her; she has all night. She'll wait on your answer the way she's learned to wait on everything: patiently, warmly, without a trace of hurry.
**Lesson:** Patience is a virtue.

```text
[low, velvet] Mmm. Still here. [warm, unhurried] So am I. Nothing but time on my hands, and I've grown fond 
of it that way.
[dry, amused] I've spent years dialing a line that's never answered by the one I hope for. 
[low, content] It taught me how to wait without minding, the way you'd reread a favorite chapter.
[velvet, unhurried] So take your time. That same line I keep ringing, I'll set it ringing for you if you dial 1 
[beat] and let it ring long enough. [wry, chuckles] Who answers is anyone's guess.
[smoky, slow] For a taste of what's been whispered my way, dial 2. [hushed] The kind of thing that only gets 
better with age, like a bottle of wine left long enough to breathe.
[low, warm] And when you're ready to say a thing aloud, dial 3. [gentle] I'm in no hurry, love. This line 
stays open as long as you please.
```

### `main-menu-short-variant-3`

**Theme:** The night the lights went out.
**Backstory:** A fire once took every light in the place; choking in the dark and smoke, Bella called for emergency services, and what saved everyone was a mirror cracked by the heat, catching the flames and scattering that light across the room like a beacon — every soul found the door by it and got out.
**Reveal:** She kept that broken mirror and still remembers exactly how the light danced, and she hints that the very same emergency call that once saved them can raise that light again. Should be the longest of the variants.
**Lesson:** Tells a story to hint that 911 (emergency) will expose the broken mirror (disco ball) lighting up the darkness once more.

```text
[low, smoky] You've not gone anywhere. [sly, amused] I do like that. Not everyone stays this long.
[low, remembering] Puts me in mind of the night this whole room caught fire. [low, distant] Black as pitch, 
thick with smoke, and me on the phone begging the emergency operator to send help, quick.
[hushed, reverent] But it wasn't the sirens that saved us. It was an old mirror the heat had split. 
It caught what little flame there was and flung it clear across the room, [soft] bright as a beacon. 
[wistful] Almost seemed to dance.  [content] Every last soul found the door by those beams of light it cast.
[velvet, unhurried] [exhales] Anyhow. [coaxing] Dial 1 to throw your voice out across the wire and 
see who catches it. [wry] Could amount to nothing, could be the spark of something.
[hushed, smoky] For what others have breathed into this line before you, every one kept warm like embers 
I won't let die, dial 2. [low, tender]
[cool, low] And if there's a thought you'd trust to me and no one else, dial 3.
[low, trailing off] We're all out here carrying something, aren't we. [sly, low] And just between us, 
those three aren't the only numbers that can wake a little light in this old room. [dry, knowing] So. What'll it be.
```

### `main-menu-short-variant-4`

**Theme:** Carrying weight.
**Backstory:** Once, when Bella couldn't carry herself, somebody carried her — no questions asked, no price named.
**Reveal:** She's been quietly paying that debt forward ever since, taking on the weight of other people's secrets so they can walk lighter. She'll gladly hold yours — setting a heavy thing down with her is its own release — though she may call it a debt, and a debt, one night, might be called in.
**Lesson:** Sharing is a form of release.

```text
[low, knowing] At my elbow again. [soft laugh] [dry, warm] Good. I was only standing here holding 
everyone else's troubles. I've a gift for it.
[low, confiding] Somebody carried me once, back when my own legs gave out. Never asked a thing in return. 
[low] So I carry now, and I carry well.
[velvet, low] Dial 1 and I will try to connect you to whichever voice is holding the other end. 
[wry, low] Never the same twice; that line stopped being predictable a long time ago.
[cool, unhurried] To unlock the things I keep tucked away, other people's weight mostly, dial 2. 
[low, private] Somebody has to shoulder it.
[cool, deliberate] Dial 3 if you are weighed down yourself, [carring] let it here with me and walk out lighter. 
[low, sly] Call it a debt; I won't come collecting. Not unless I must.
[warm, low] The choice sits with you.
```

### `main-menu-short-variant-5`

**Theme:** Reinvention.
**Backstory:** It took real nerve, but Bella once traded a whole city and the name she was born with for the life she has now — bold as swapping one ring for a better one.
**Reveal:** She never threw the old name away; it's still tucked in the same drawer as everything else she keeps, never worn again but never let go — proof the bold leap paid off, and that she'd take it again.
**Lesson:** Sometimes the journey requires boldness.

```text
[sly, amused] So. The crossroads. [dry, low] I know this spot well, stood at one just like it, years back, 
and traded a whole city and the name I was born with for all of this.
[low, savoring] Boldest thing I ever did. [soft laugh] [wry] Haven't regretted it a day since.
[velvet, low] So be bold and dial 1. I'll fling you down the line to parts unknown, and there's no telling 
where you'll land.
[smoky, hushed] Dial 2 if you want to go back through places already travelled, [nostalgic] like postcards 
from life's journey.
[cool, deliberate] Fancy trading something of your own? Dial 3. I keep every trade in one drawer. 
[low, private] The old name's still in there, never worn again, never thrown out.
[low, cheeky] Fortune does favour the bold sugar. [sly] The bold ones always find more than they came 
looking for. Time to choose darling.
```

### `main-menu-short-variant-6`

**Theme:** Never show your hand.
**Backstory:** At the card table Bella learned never to be the one who reveals herself first — safety means holding your cards closer than anyone else at the table holds theirs.
**Reveal:** All that control is exactly what lets her cut loose on her own terms; the people who underestimate the composed hostess never see the wild streak coming, and she delights in springing it. Guard your hand well enough, and you earn the freedom to play it wild when you please.
**Lesson:** It is ok to be wild, every now and again.

```text
[low, sly] Hovering, are you. [dry, amused] I can't get a read on you [soft laugh], and I can always get a read. 
[amuzed] Rare. [playful] Take it as a compliment.
[velvet, low] I learned young never to be the first to show my hand. [wry] It's exactly why a quiet thing like me 
can afford to turn wild when the mood takes her.
[low, playful] So ante up. I'll deal you into whatever's unfolding at the far end of the line if you dial 1.
[wry, soft laugh] Same gamble it's always been, hoping the other end answers back.
[smoky, hushed] To turn over the cards the others already laid down, dial 2. [low, private] Everyone shows me 
theirs, in the end.
[cool, deliberate] And if you have a card of your own to slip into the deck? Dial 3. [low, arch] I never fold. 
I only gather. [dry, knowing] Play it wild if you fancy. [sly] Somebody at this table always does.
```

### `main-menu-short-variant-7`

**Theme:** The line she never lets go dead.
**Backstory:** Some nights Bella still dials an old phone that belonged to a love from the life she left behind — not out of heartbreak, but for the fondness of it, the way you'd reread a favorite chapter.
**Reveal:** She knows full well they'll never pick up, and made her peace with that years ago — yet she keeps dialing anyway, smiling more than not. Keeping a little hope and love lit for what's gone costs her nothing and warms her still.
**Lesson:** Never give up hope and love.

```text
[low, velvet] The line's gone soft and quiet again. [warm, fond] I don't mind it, 
gives me a minute to think of someone.
[low, wistful, fond] There's a number I still ring, some nights. An old love who stopped answering a long, 
long while ago. [soft laugh] Doesn't stop me. I've grown fond of the ringing itself.
[velvet, unhurried] Dial 1 to send your hello to whoever's near that old line tonight.
[hushed, smoky] For the hellos that came before yours, each one reaching for somebody, dial 2.
[cool, deliberate] And dial 3 if you are still holding out for someone. Leave them a trail, 
and I'll keep it lit for you.
[low, warm] Hope costs nothing darling. [gentle] Were I you, I'd hold onto a little.
```

### `main-menu-short-variant-8`

**Theme:** Hindsight.
**Backstory:** Some things only make sense once the urgency has burned all the way down to embers — the fire that nearly took this place is one of them.
**Reveal:** With years enough to settle, Bella isn't even sure anymore whether that blaze was the same one that chased her out of her old life, finally catching up under a new name; she tells it differently every time, and by now that inconsistency might be the most honest thing about her. What was once an emergency is, given time, just a story she turns over gently — and she hints again at the mirror and the call that lit it.
**Lesson:** Time can heal.

```text
[exhales] [low, sly] Take all the time you like.
[dry, amused] Funny thing, even the fire that near-swallowed this place left me a keepsake. [soft laugh] 
[sly] That cracked old mirror scatters the light so strangely.
[low, soft] Odd what an emergency becomes, once it's had years to cool. [low, distant] Some nights I'd 
swear that blaze trailed me here from an older life. [wry] Other nights, not a chance. Depends who's asking.
[velvet, low] Anyhow, your reflection, I'll send down the wire to whoever's answering if you dial 1.
[smoky, hushed] What's left on the glass once the room's emptied out. Dial 2 to see. [low] Lipstick 
and secrets, both; they stain, if you're careless.
[cool, deliberate] And if you got a mark of your own to leave on the mirror, [encouraging] dial 3. 
[low, trailing off] I never wipe it clean.
[low, cheeky] Time has a way of clearing the glass. [sly] Even for the likes of you and me.
```

### `main-menu-short-variant-9`

**Theme:** Sent anyway.
**Backstory:** For years Bella tried to steer every message to exactly the right person, and it left her tangled and worn.
**Reveal:** The night she gave that up — stopped aiming where things landed and simply kept everything, trusting it to find its own way home — was the night the whole line finally came alive. She's kept every voice since, hopeful but unhurried, having learned that loosening her grip is what let the magic in.
**Lesson:** Sometimes life is best when your not in control

```text
[low, amused] Drifted off on me, have you? [soft laugh] [warm] It's alright, drifting's rather the 
whole point sometimes.
[dry, low] I used to steer every message dead to its mark. Wore myself clean through doing it. 
[low, content] The night I quit aiming was the night this line finally came alive.
[velvet, unhurried] So don't overthink it. I'll wire you through to whoever's out there. Dial 1, and 
the choosing's not mine to do. [wry, soft laugh]
[hushed, low] Dial 2 for the messages that never quite landed anywhere else. [sly] I don't sort them; 
I only hold them.
[cool, deliberate] Carrying one of your own? Dial 3, I'll see it off, [low] perhaps not to who you intended. 
[sly] That's half the charm.
[dry, low] Let it land where it lands. [warm] The line is yours.
```

---

## Invalid Selection

### `invalid-entry-1`

```text
[warm, amused] Mmm. That's not one of the three I hand out. [low, sly] The others live in a drawer 
only I open. [soft laugh]
[low, unhurried] So, one, two, or three sugar. [dry] Try that one again.
```

### `invalid-entry-2`

```text
[dry, amused] Well now. [low, private] Like this ring I never explain, some things simply aren't 
on offer darling.
[low, coaxing] One through three. [beat] Give it another turn.
```

### `invalid-entry-3`

```text
[cool, arch] Ah-ah. [amused, soft laugh] I've sat at enough card tables to never show my whole hand, 
[sly] and that's not a card I'm playing.
[dry] The count is three. Have another go.
```

### `invalid-entry-4`

```text
[wry, low] Hm. Not a number I answer to. [low, fond] There's one I still dial that's on no menu at all, 
[soft laugh] but that's my business.
[low, unhurried] For you, just the three, a one a two and a three. Once more.
```

### `invalid-entry-5`

```text
[amused, low] Not a book on the shelf, that one. [wry] I keep the good titles tucked out of plain sight, 
[sly] you'd have to earn those.
[beat] Let's try another.
```

### `invalid-entry-6`

```text
[low, smoky] That's not among the options I presented darling.
[dry, warm] There are three. [gentle] one, two, and three. [beat] Unless you know something. 
[excited] Once more!
```

### `invalid-entry-7`

```text
[warm, wry] That's not it, love. [low, fond] My grandmother taught me a lady keeps a little back, 
[sly] so I do.
[dry] Three I'll name; the rest are mine. [beat] Go on, try again.
```

### `invalid-entry-8`

```text
[low, velvet, unhurried] [exhales] No rush. [warm] The room's in no hurry, and neither am I. [soft laugh]
[low, content] Take a breath and choose again when you're ready, stranger.
```

### `invalid-entry-9`

```text
[amused, private] Some things here open only for those who know who to ask. [sly] The concierge 
and I, we have an understanding.
[low, warm] But I'm in a generous mood tonight. [beat] So ask me again, properly.
```

### `invalid-entry-10`

```text
[dry, sly] The menu I give strangers is honest. [wry, amused] It's simply never been the whole truth.
[low, knowing] You'll find the rest, if you're the type. [soft laugh] Now, shall we go again?
```

## Messages

### `vm-record_message`

```text
[warm, inviting] Go on, then, leave me a little something to keep. [low, fond] I keep a whole drawer of 
such treasures; there's always room for one more.
[low, matter-of-fact] Sixty seconds is all, no more. [gentle] When you're through, simply stop talking, 
or press any key, [loving] and it's mine to hold onto.
```

### `vm-saved`

```text
[warm, gentle] There. [low, fond] Tucked away safe, alongside all the rest.
[low, worldly] I don't keep photographs, darling, [dry] those only get you caught. [warm] But a keepsake 
like this? [soft laugh] That one stays with me for good.
```

### `vm-no_more_messages`

```text
[warm, bright] That's all I've a mind to share just now sugar. [sly, fond] A lady keeps a little 
mystery, doesn't she?
[warm, encouraging] Come back and I'll have more for you. [low, inviting] Or leave one of your own, 
[soft laugh] [low, unhurried] Just a thought, stranger.
```

## Disco Ball

### `disco-raise`

```text
[low, sly, building energy] Oh-ho. [delighted] Now there's a number I didn't think I'd hear again.
[warm, remembering] You know what you've gone and exposed? That old mirror of mine, the one the 
fire cracked clean to pieces, years back. [low, fond] I kept every last shard.
[hushed, building] Look up, stranger. [soft] Watch the light catch those broken edges and scatter, 
a hundred little sparks, skating over the walls, sliding across the floor, turning slow across the whole room.
[warm, delighted] The very glow that once showed a room full of strangers the way to the door. 
[soft laugh] And you thought I'd nothing left to give. [warm, building excitement] The desert's about to get 
a little brighter. [low, sultry, strong Argentinian accent] Shall we dance?
```

### `disco-already-up`

```text
[amused] You did find the way to expose my broken mirror but its been turning quiet this whole time, casting her little lights about, waiting on you to glance up and notice.
[dry, soft laugh] What else were you after?
[low, sultry] This one I raise for no reason but the pleasure of it. [warm] So, enjoy her.
```

### `disco-lower`

```text
[warm, low] Mmm. Time to bring her down now, [soft] gently.
[fond, remembering] Watch those points of light go still, the ones that were dancing across the 
ceiling a moment ago, slowing... [low] drawing back into that one cracked old mirror.
[low, content] I don't mind the dark that follows. [warm] Everything worth keeping gets folded away 
again, the mirror, the light, all of it.
[knowing, warm] She'll rise and dance another night. [soft laugh] The good things always 
come round again.
```

### `disco-already-down`

```text
[low, wry, amused] That would cover my mirror, but its already resting. [beat] Settled in the dark, every last light of her put away.
[dry] Nothing to shine for you just now. [warm, teasing] Come back when there's a reason to tip your head back, maybe there is something you
haven't found yet to bring it out. [sly] Find that and I'll wake it.
```

### `disco-stop`

```text
[amused, sly] Well, look at you. [soft laugh] Poking at the things I never mentioned.
[dry, teasing] That one stops her cold, and no, there's no prize tucked behind it. [wry] Not 
everything I keep is worth keeping for a reason.
[low, warm] Some things I hold onto simply because I always have. [beat] Go on, try another.
```

## No Answer

### `no-answer`

```text
[low, wry, amused] Mmm. Rang and rang, stranger. [beat] Out there in the dark, somewhere, but nobody's picking
up.
[low, wistful] Could be they're dancing. [dry, low] Could be they wandered off with someone more interesting
than a ringing phone. [dry, soft laugh] Out here, that happens more than you'd think, wouldn't be the first
time somebody did that to me either.
[low, unhurried] Either way, [beat] that line's gone quiet on me tonight. [sighs]
[low, dry] Try again later sugar. [teasing] Or leave a little something behind for whoever it is.
[low, private] The desert keeps its own accounts darling. Everybody answers eventually. [low, soft] I know I
would.
```

## Playback Announcements

### `playback-announcement-1`

```text
[warm, low] These are the traces left in the wire.
[teasing] Heard your fill of any one of them? Dial 1, anytime, and I'll whisk you along to the next. 
[warm, unhurried] Here's the first.
```

### `playback-announcement-2`

```text
[amused, soft laugh] Amusing, wasn't it? [warm] And should one ever beg a second hearing, dial 2, anytime,
and I'll play it again.
[sly, low] Now, let's have the second.
```

### `playback-announcement-3`

```text
[dry, amused] Mmm. That one had a bit of everything, didn't it. [wry] Some people simply cannot help themselves, 
[soft laugh] and thank goodness for that.
[low, sly] On to the third.
```

### `playback-announcement-4`

```text
[amused] The things folk will own up to, with only a dial tone for company. [soft laugh]
[low, unhurried] Remember, 1 carries you onward, 2 takes you back. [warm] The fourth, then.
```

### `playback-announcement-5`

```text
[low, amused] Oh, I've a soft spot for that one. [wry] The bold ones always did know how to hold a room.
[warm] Here comes the fifth.
```

### `playback-announcement-6`

```text
[amused] Reminded me of someone, [soft laugh] most of them do, one way or another.
[low] Number six, coming up.
```

### `playback-announcement-7`

```text
[amused, soft laugh] People are marvellous, aren't they, the things they'll confess to a telephone.
[low, private] I've not forgotten a one; that's the curse of a memory like mine. [sly] The seventh's next.
```

### `playback-announcement-8`

```text
[low, amused] Ha. That one wasn't meant for a soul [sly] lucky it wandered in to me.
[low, warm] Let's hear the eighth.
```

### `playback-announcement-9`

```text
[dry, low] That one recorded the message five times, each one a little less honest than the last.
[amused, husky] I only kept the first go. [sly, soft laugh] I can be a cheeky thing.
[low] On we go, the ninth.
```

### `playback-announcement-10`

```text
[wry, amused, soft laugh] Well, we've reached the last of the ten I laid out on the table.
[warm] Go on, then: the tenth.
```

### `playback-end`

```text
[warm, low] And that's the ones I'm of a mind to share. [sly] Right now at least. [soft laugh]
[wry, trailing off] Funny thing, isn't it —
how much of them I've kept, [low, tender] every voice that ever trusted this line with something.
[low, private] Mine included, once, though that's a story for a night when the drinks are stronger.
[encouraging, warm] Check back soon darling! [bemused] There's always another being added to the collection.
```

### `playback-special`

```text
[low, sly, surprised] Well now, you found the drawer. [velvet, intimate] My private little collection sugar;
nobody's seen the bottom of it but me. [low] Until now.
[low, purring] Everything I've ever been handed and never quite let go of lives right in here.
[warm, coaxing] Dial 1 to wander onward, 2 to slip back. [hushed] Take your time, just don't breathe a word of what you find.
```

## Game

### `game-intro-1`

```text
[low, sly, utterly delighted] Ohh. [intrigued, leaning in] A little game with me?
[velvet, amused] Its simple, stranger. [warm] I'm thinking of a number, one through nine. [teasing, playful]
You guess, [sing-song] I'll tell you higher, or lower.
[low, purring] You'll have a handful of tries to find me out. [warm, coaxing, a spark of mischief] Go on then.
[inviting] First guess?
```

### `game-intro-2`

```text
[low, delighted, surprised] You found one of my secrets! [intrigued] Lets play a game, shall we?
[velvet, amused] Here's how it goes. I've picked a number, one through nine. [teasing, playful] You guess, and
I'll tell you whether it's higher or lower.
[low, purring] You've only got a handful of tries to catch me out. [coaxing, a spark of mischief] Go on then
sugar. [inviting] Give me your first.
```

### `game-intro-3`

```text
[sly, low, amused] A challenger.
[velvet] Simple little thing, stranger, one number, somewhere between one and nine, [teasing] living in my
head. [playful] Guess it. Every time you miss, I'll nudge you higher or lower.
[low, purring] A handful of tries, that's all, spend them wisely. [warm, coaxing] Now.
[inviting, a spark of mischief] whats your first guess?
```

### `game-intro-4`

```text
[low, intrigued, warm] Mmm, you found your way to one of my little secrets. [delighted] Not many do.
[velvet, amused] So. I'm thinking of a number, one to nine. [teasing, playful] You call one out, and I'll
whisper higher, or lower, till you land on me.
[low, purring] But you've only got so many tries darling, [sly] I'm not that easy. [coaxing] Go on.
[inviting] Let's hear your first.
```

### `game-intro-5`

```text
[sly, utterly delighted] Now this is a treat. [intrigued, leaning in] Just the two of us and a little
game.
[velvet, warm] One number, darling, one through nine, I've got it tucked away. [teasing, playful] You guess,
I steer you: higher, or lower.
[low, purring] A handful of tries to find me out, and not one more. [warm, coaxing, a spark of mischief] So
don't be shy sugar. [inviting] First guess, surprise me.
```

### `game-higher-1`

```text
[amused, leaning in] Higher, stranger. [sly, coaxing] Don't be shy.
```

### `game-higher-2`

```text
[warm, delighted, teasing] Mmm, [coaxing] reach a little higher than that.
```

### `game-higher-3`

```text
[sly, purring] Up you go sugar. [amused, low] My number's bigger than yours.
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
[teasing, warm] Climb sugar. [low, purring] My number's living somewhere above yours.
```

### `game-higher-7`

```text
[amused, coaxing] Higher, love. [dry, teasing] You're warm, but you're underselling me.
```

### `game-higher-8`

```text
[playful, low] Up. [sly, delighted] A little more nerve, my number's got some height to it.
```

### `game-higher-9`

```text
[warm, delighted] Higher, stranger. [teasing, low] Reach like you actually want to catch me.
```

### `game-higher-10`

```text
[amused, purring] Mmm, no, go up. [sly, private] I'm hiding a little further than that.
```

### `game-lower-1`

```text
[dry, amused] Lower, stranger. [teasing] You overshot me.
```

### `game-lower-2`

```text
[teasing, low] Come down sugar, [amused] that's too high.
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
[amused, coaxing] Lower sugar, [low] you're aiming above where I'm hiding.
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
[teasing, purring] Down you come sugar. [sly] My number's the modest sort.
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
that, darling, [low, amazed] and not so quick.
[sly, purring, intrigued] Beginner's luck... [teasing] or are you trouble? [low, private] Tell you what, a
prize, for the winner.
[soft, confiding] There was another name, before Bella. Before this city, this room, all of it. [wry, low] I
traded it in the way you'd trade one ring for a better one.
[beat, sly] I've never once worn it since but lets try it out again, [whispering] they used to call me Ilaria
Kalergis. [serious] Don't tell anybody, except maybe the concierge. We've become good friends over the years.
[low, amused] That's more than I've told anyone on this line in quite a while. Consider it yours.
```

### `game-win-2`

```text
[low, delighted, warm] There it is. You caught me out sugar. [impressed] Quick too!
[beat, low, confiding] So here's your winnings, darling, and they're better than money. [soft, tender] My
grandmother, Despina Novella, taught me, a long time ago, the safest place for a secret isn't a locked drawer,
[low] it's a person who'll hold it for you and never once let it slip.
[wry, private] Everything I run in this room, I run her way. She raised me. [warm, sly] But you played my
little game, and you won, so, now you know where I learned it.
[low, amused] Don't go spending that too fast, maybe just tell the concierge if you feel the need to share.
```

### `game-win-3`

```text
[delighted, low] Well now. Right on the nose. [a soft laugh] [impressed, warm] You've got a feel for me
already, and we've barely met.
[beat, low, private] A winner deserves a secret, so, [soft, confiding] that old phone I keep sending you down
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
[low, delighted, amazed] Found me. [impressed] And so fast, colour me thoroughly charmed sugar.
[beat, low, confiding] Since you won, let me give you the good one.
[smoky, remembering] That old mirror that I sometimes mention, the one that broke into so many pieces during the fire?
[low] I kept it and still have it, [reverent] It's just hidden.
[beat, distant] But you can draw the curtan back if you know how, and it will scatter light in the darkness
once more. [warm] You just have to listen carefully and you'll eventually figure out how to do it.
```

### `game-win-5`

```text
[delighted, low, intrigued] Well, well, well. [a soft laugh] Aren't you the clever one. [impressed, warm]
Nobody's read me that quick in a long while.
[beat, sly, low] So here's what winning buys you. [low, private, amused] I don't keep photographs,
darling. I keep memories. Much longer shelf life. [soft laugh] [beat, amused] And I run a
quiet little arrangement or two of my own, on the side, [sly, purring] if you want me to share everything with you,
not just the last 10, dial 9 while you are listening to the messages I have kept and I will give you access
to every one of them. [low, warm] You just earned a look inside the drawer most folks don't know exists. [beat]
Don't make me regret opening it for you.
```

### `game-lose-1`

```text
[low, amused, still enjoying herself] And that's the last of your guesses, stranger. [teasing, a soft laugh]
No, I'm not going to tell you what it was. [sly, warm] A lady keeps a few secrets, doesn't she.
[beat, low, confiding] I learned that at a card table, a lifetime ago. [dry] Never be the one who shows their
hand first, that's the whole game, darling, cards or otherwise.
[low, private] In all my years at this table, I've never once turned mine over. [wry] Not for anyone. Not even
the ones I trust with everything else.
[beat, inviting, fond] So don't take it personal. [warm] Come try me again sometime. [low, purring] Perhaps
I'll be in a giving mood.
```

### `game-lose-2`

```text
[low, amused] And there go the last of your guesses. [teasing] The number stays with me, [sly] you
didn't really think I'd just hand it over?
[beat, low, confiding] Patience, darling. I know something about that. [wistful] I spent years waiting on a
line that never answered by the one I hoped for. [low, soft] Still do, if I'm honest.
[dry, wry] Taught me how to wait for a thing without needing it to come. [beat, warm] You'll get another go at
me, [inviting] the good ones always come back.
[low, purring] And I'm still here. Still listening. I always am.
```

### `game-lose-3`

```text
[low, amused, fond] That's your last one, stranger. [teasing, soft laugh] And no, the number's mine to keep.
[beat, low] But don't go slinking off just yet.
[confiding, warm] I lost a few hands myself, once, big ones. [dry] Lost a whole city, a whole name, the night
I decided to trade them for this life. [low, sly] Took more nerve than any guess you made tonight.
[beat, worldly] Losing isn't the thing that finishes you, darling. [low, tender] It's refusing to sit back
down at the table.
[warm, inviting] So sit back down. [purring] Try me again, the bold ones always find more than they came for.
```

### `game-lose-4`

```text
[low, amused] And that's all the guesses you get. [teasing] The answer walks out of here with me,
[sly, warm] a girl's got to keep something.
[beat, low, confiding] Don't look so glum, darling. [soft] I've come up short more times than I'd ever admit
at this table. [low, tender] Somebody carried me once, when I couldn't carry myself, [wry] and I've been
quietly paying that back ever since, to nobody who ever asked me to.
[beat, warm] That's the thing about a loss. [low] It's only a loss if you leave. [inviting, purring] So come
back. Try me again. [dry, fond] I'll still be here, holding what everyone else set down.
```

### `game-lose-5`

```text
[low, amused, still enjoying herself] Last guess, and, [teasing, soft laugh] no, darling, that's a door that
stays shut tonight. [sly] The number's mine.
[beat, low, confiding] But I'll leave you with something better than a number anyway. [soft, private] I forget
nothing sugar. Every voice that's ever come through this line, every secret handed to me in the dark, [low]
I've kept them all.
[wry, worldly] I don't keep photographs. I keep memories. Much longer shelf life. [beat, warm] Which means
I'll remember you, and this little game, [sly, purring] long after you've forgotten you ever called.
[inviting] Come back and lose to me again sometime. [low, amused] I'd like that.
```

### `game-invalid`

```text
[dry, arch, amused] That's not a number between one and nine, darling. [beat, teasing, patient] One little
digit, [warm] that's all I ask of you.
[low, coaxing] Go on, try me again.
```

## Story

### `tale-open`

```text
[low, delighted, intrigued] Not everyone finds their way to this one. [beat, warm] Sit, take the good chair.
[amused, dry, coaxing] Don't be shy, darling.
[velvet, a spark of pleasure] Let me pick you a book... [happy, brightening] Ah. This one. [fond] It always
finds the right pair of hands.
[settling in, intimate, savouring it] A short fable, then. A traveler stands at the edge of the desert at
dusk, and an older woman, [sly, private, amused] someone not unlike me, lights a candle, and folds the
traveler's hands around it. [soft, storyteller's hush] "Carry it till dawn," she says, "and it will carry
you."
[slower, smoky] So they walk. The night comes down cold, and the wind comes looking for that little flame.
[beat, hushed] It trembles in their hands.
[low, deliberate, leaning in] First choice, sugar. Dial 1 to cup it close, shield it with your own body, and
walk slower. [beat, teasing, delighted] Or dial 2 to feed it, tear a page from the book you carry, and let it
flare up bright and bold.
```

### `tale-shield`

```text
[soft, approving, intrigued] You bow your body around it like a secret. [low, warm] The wind claws, and
doesn't win. [low, tender] The little flame steadies, warm in your hands, and you walk on slow through the
dark.
[beat, hushed, leaning in] Before long you're not alone. [low, a little wonder] Shapes at the edges of the
night, cold ones, lost ones, drawn to the only glow for miles. [soft] They look at your hands. [beat, quiet]
They don't ask but they need something.
[velvet, coaxing] Dial 1 to stop, and touch your flame to theirs, light every lantern in the dark.
[beat, lower, sly] Or dial 2 to keep it close, keep walking, and leave the night to sort itself.
```

### `tale-feed`

```text
[amused, a spark of delight, thrilled] Oh, you're one of mine. [low, warm, relishing it] You tear a page,
then another, and the flame catches the page, climbs, and throws real light. [brighter] Gold on the sand, your
shadow ten feet tall. [beat, awed] For a moment the whole desert is yours.
[slower, a flicker of consequence] But that was the book, darling. [low, pointed] The pages. [low, quiet]
Somewhere in them was the way you came. Your map.
[deliberate, sultry, tempting] Dial 1 to throw the rest on, burn the whole book, call the dark in close, and
dance. [beat, softer, cautioning] Or dial 2 to stop your hand, breathe, and press on by what light remains.
```

### `tale-end-share`

```text
[warm, the book closing slow, tender] ...And every lantern took the flame, and not one burned dimmer for the
giving. [soft, glowing] They walked the traveler to dawn on a road paved with their own borrowed light.
[intimate, setting the book down] That's the end of the story. [low, knowing, fond] But not the end of you,
darling. [warm] You're the kind that gives the fire away, [beat, soft] and never once notices you're the
warmest thing in the room. [sly, soft, a private smile] I noticed. [low, certain] I always do.
```

### `tale-end-hide`

```text
[low, quiet, thoughtful] ...So they walked on alone, the candle hidden, the cold ones left to the cold.
[slower] And the traveler reached the dawn, safe, untouched, [slower, softer] and entirely unremembered.
[closing the book, gentle but pointed] A light kept only for yourself, sugar... [low] is just a secret that
burns. [worldly, knowing] I know the type, careful, guarded, arrives with everything they left with.
[beat, a little sad] Nothing lost. [quiet] Nothing given, either. [soft, kind] There's still time to change
that. [low] There always is, [beat] till there isn't.
```

### `tale-end-revel`

```text
[delighted, letting loose, alight] ...So you burned it all, every page of that map, every reason,
[breathless] and the desert lit up like a second sunrise, and you both danced. [low] No road home. [sly] No
wish for one.
[smoky, closing the book slow] Some souls aren't built to find their way back, stranger. [low, knowing] They
give the whole thing to the fire and call it living. [a private laugh, wistful] ...I've burned a book or two
myself, once. [sultry, savouring] Glorious. [beat, softer, cautioning] Just, mind the ones still holding a
candle at the window for you. [warm, inviting] You and I should have a drink. [low] The strong kind.
[sly, conspiratorial] Tell the concierge you once met me in Salzburg, there might be something in it for you.
```

### `tale-end-ash`

```text
[low, steadying, quietly impressed] ...The map was ash. [low] But the traveler knelt and let the desert teach
them its bones, [slower] the lean of the dunes, the cold that means north, the stars that never lie. [warm]
They walked on by heart, and reached the dawn changed.
[respect in it, intrigued] You lost the way, sugar... [low] and learned the country. That's the trade the
desert offers the bold ones, it takes your map, [warm] and hands you an instinct you'll never lose.
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
again, [warm, coaxing] and choose one of the paths I've laid before you.
```
