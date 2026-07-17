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


.venv/bin/python -c "import elevenlabs; print('elevenlabs', elevenlabs.__version__)" 2>&1 | head -5; echo "---dry run---"; ./scripts/bella-regen-prompts --dry-run 2>&1 | head -60
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
[low, amused] Dial 2, and I'll play you what's been left behind, keepsakes people have handed me thinking I'd
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
soul you can draw a map for yourself. Dial 1 if you want to try. [soft laugh][wry, low] Could be fun. 
[velvet, low] To hear about the paths walked before you, everything the ones prior left in my keeping, dial 2. 
[hushed] I hold onto every last one.
[warm, low] And dial 3 if you'd sooner leave a marker of your own for whoever comes next.
[low, knowing] Three paths, stranger, all lit and waiting. [gentle] No one should have to feel their way 
in the dark. [coaxing] Take whichever one calls to you.
```

### `main-menu-short-variant-2`

**Theme:** Waiting.
**Backstory:** Years of dialing a line that never answers the way she hopes taught Bella how to wait for a thing without needing it to come.
**Reveal:** Rather than souring her, the waiting made her serene — she's still here, still listening, and a caller who takes their time never rattles her; she has all night. She'll wait on your answer the way she's learned to wait on everything: patiently, warmly, without a trace of hurry.
**Lesson:** Patience is a virtue.

```text
[low, velvet] Still here huh? [warm, unhurried] So am I. Nothing but time on my hands, and I've grown fond 
of it that way.
[dry, amused] I've spent years dialing a line that's never answered by the one I hope for. 
[low, content] It taught me how to wait without minding, the way you reread a favorite chapter.
[velvet, unhurried] So take your time. That same line I keep ringing, I'll set it ringing for you if you dial 1 
[beat] [wry, chuckles] If you let it ring long enough, who answers is anyone's guess.
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
thick with smoke, and me on the phone begging the emergency operator to send help.
[hushed, reverent] But it wasn't the sirens that saved us. It was an old mirror the heat had split. 
It caught the flame and flung spots of light clear across the room, [soft] bright as a beacon. 
[wistful] Almost seemed to dance. [serene] Every last soul found the door by the beams it cast.
[velvet, unhurried] [exhales] Anyhow. [coaxing] Dial 1 to throw your voice out across the wire and 
see who catches it. [wry] Could amount to nothing, could be the spark of something.
[hushed, smoky] Dial 2 for what others have breathed into this line before you, every one kept warm like embers I won't let die.
[low, tender] And if there's a thought you'd trust to me and no one else, dial 3.
[low, trailing off] We're all out here carrying something, aren't we. [sly, low] And just between us, 
those three aren't the only numbers that can wake a little light in this old room. [dry, knowing] So. What'll it be?
```

### `main-menu-short-variant-4`

**Theme:** Carrying weight.
**Backstory:** Once, when Bella couldn't carry herself, somebody carried her — no questions asked, no price named.
**Reveal:** She's been quietly paying that debt forward ever since, taking on the weight of other people's secrets so they can walk lighter. She'll gladly hold yours — setting a heavy thing down with her is its own release — though she may call it a debt, and a debt, one night, might be called in.
**Lesson:** Sharing is a form of release.

```text
[low, knowing] At my elbow again. [soft laugh] [dry, warm] Good. I was only standing here holding 
everyone else's troubles. I've a gift for it.
[low, confiding] Somebody carried me once, back when my own legs gave out. They never asked for a thing in return. 
[low] So I carry now, and I carry well.
[velvet, low] Dial 1 and I will try to connect you to whichever voice is holding the other end. 
[wry, low] Never the same twice; that line stopped being predictable a long time ago.
[cool, unhurried] To unlock the things I keep tucked away, dial 2. 
[low, private] Somebody has to shoulder it.
[cool, deliberate] Dial 3 if you are weighed down yourself, [carring] leave it here with me and walk out lighter. 
[low, sly] Call it a debt; I won't come collecting. [sly] Not unless I must.
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
[low, cheeky] The bold ones sometimes find more than they came 
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
[low, warm] Hope costs nothing darling. [exhales] [gentle] Were I you, I'd hold onto a little.
```

### `main-menu-short-variant-8`

**Theme:** Hindsight.
**Backstory:** Some things only make sense once the urgency has burned all the way down to embers — the fire that nearly took this place is one of them.
**Reveal:** With years enough to settle, Bella isn't even sure anymore whether that blaze was the same one that chased her out of her old life, finally catching up under a new name; she tells it differently every time, and by now that inconsistency might be the most honest thing about her. What was once an emergency is, given time, just a story she turns over gently — and she hints again at the mirror and the call that lit it.
**Lesson:** Time can heal.

```text
[low, sly] Take all the time you like.
[dry, amused] Funny thing, even the fire that near-swallowed this place left me a keepsake. [soft laugh] 
[sly] That cracked old mirror scatters the light so strangely.
[low, soft] Odd what an emergency becomes, once it's had years to cool. [low, distant] Some nights I'd 
swear that blaze trailed me here from an older life. [wry] Other nights, not a chance. Depends who's asking.
[velvet, low] Anyhow. [dry] I'll send your reflection down the wire to whoever's answering if you dial 1.
[smoky, hushed] Want to see what's left on the glass once the room's emptied out? Dial 2. [low] Lipstick 
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
[cool, deliberate] Carrying a message of your own? Dial 3, I'll see it off, [low] perhaps not to who you intended. 
[sly] That's half the charm.
[dry, low] Let it land where it lands. [warm] The line is yours.
```

---

## Invalid Selection

### `invalid-entry-1`

```text
[warm, amused] Mmm. That's not one of the three I hand out. [low, sly] The others live in a drawer 
only I open. [soft laugh]
[low, unhurried] So, one, two, or three, sugar?
```

### `invalid-entry-2`

```text
[dry, amused] Ah, curious, are we? [low, private] Like this ring I never explain, some things simply aren't 
on offer darling.
[low, coaxing] One through three. [beat] Give it another turn.
```

### `invalid-entry-3`

```text
[cool, arch] Ah-ah. [amused, soft laugh] I've sat at enough card tables to never show my whole hand, 
[sly] and that's not a card I'm playing.
[playful] The count is three. Have another go.
```

### `invalid-entry-4`

```text
[wry, low] Hm. Not a number I answer to. [low, fond] There's at least one I still dial that's on no menu at all, 
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
[sly] Once more?
```

### `invalid-entry-7`

```text
[warm, wry] That's not it, love. [low, fond] My grandmother taught me a lady keeps a little back, 
[sly] so I do.
[dry] Three I'll name; the rest are mine. [beat] Go on, try again.
```

### `invalid-entry-8`

```text
[low, velvet, unhurried] That's not one of mine, stranger. [warm, soft laugh] Slip of the finger?
or are you hunting for something I haven't offered? [low, content] either way, try again. One through three.
```

### `invalid-entry-9`

```text
[amused, private] Some parties need an invitation. [dry, low] Sometimes you just need to know where to go.
[gentle] One, two, three. [sly] Those are the invitations I have given out, why don't you try again?
```

### `invalid-entry-10`

```text
[dry, sly] The menu I give strangers is honest. [wry, amused] It's simply never been the whole truth.
[low, knowing] You'll find the rest, if you're the type. [soft laugh] Now, shall we go again?
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

## Record Announcements

### `message-record`

```text
[warm, inviting] Go on, then, You've got sixty seconds to say what you need to say. [low] When you're done,
just stop talking, or dial any digit, [sultry, intimate] [whispers] and it's mine to keep darling.
```

### `message-saved`

```text
[warm, gentle] There. [low, fond] Tucked away safe, alongside all the rest.
[low, worldly] I don't keep photographs sugar, [dry] those only get you caught. [warm] But a keepsake 
like this? [soft laugh] That one stays with me for good.
```

## Playback Announcements

### `playback-no-messages`

```text
[low, warm] Mmm. [wry, amused] Nothing waiting in the box right now sugar. Not a whisper.
[low, sly] A rare quiet, this. [soft laugh] I keep everything left here, but at the moment
there's nothing to keep. [warm, coaxing] So be the first. Leave me something worth holding
onto, [low, inviting] or drift back later, once there's more to hear.
```

### `playback-announcement-1-1`

```text
[warm, low] These are the traces left in the wire.
[teasing] Heard your fill of any one of them? Dial 1, anytime, and I'll whisk you along to the next. 
[warm, unhurried] Here's the first.
```

### `playback-announcement-1-2`

```text
[low, velvet] These are the voices left behind, and I never let a one fade.
[warm] As you listen dial 1 at any time to skip to the next.
[coaxing] The first for you darling.
```

### `playback-announcement-1-3`

```text
[warm, low] Every voice that ever drifted through here, I've kept close.
[amused] Grown weary of one? Dial 1 whenever it suits and I'll carry you onward.
[coaxing] We open with the first.
```

### `playback-announcement-2-1`

```text
[amused, soft laugh] Amusing, wasn't it? [warm] And should one ever beg a second hearing, dial 2, anytime,
and I'll play it again.
[sly, low] Now, let's have the second.
```

### `playback-announcement-2-2`

```text
[low, amused] Someone had a weight on them. [savoring] This line tends to draw that out.
[warm] Care to hear it again? Dialing 2 at anytime slips you back.
[velvet, sly] Lets hear the second.
```

### `playback-announcement-2-3`

```text
[dry, warm] That's the sort of thing you only say when you're sure no one's near. [amused] Bold.
[low] Want it again? Dialing 2 anytime will take you back. [sly, velvet] If not, we land on number two.
```

### `playback-announcement-3-1`

```text
[dry, amused] Mmm. That one had a bit of everything, didn't it. [wry] Some people simply cannot help themselves, 
[soft laugh] and thank goodness for that.
[low, sly] On to the third.
```

### `playback-announcement-3-2`

```text
[dry, amused] That one wandered all over, didn't it. [fond] I do adore a rambler.
[low, private] Bits like that go in a drawer most folk never find. [velvet] Now the third.
```

### `playback-announcement-3-3`

```text
[wry, low] Straight to the point, that one. [amused] I respect a soul who doesn't knock first.
[dry] The locals here never trust a knock. [soft laugh] Nor do I. [sly, velvet] The third steps up.
```

### `playback-announcement-4-1`

```text
[amused] The things folk will own up to, with only a dial tone for company. [soft laugh]
[low, unhurried] Remember, 1 carries you onward, 2 takes you back. [warm] The fourth then.
```

### `playback-announcement-4-2`

```text
[amused] What a person will admit to an empty room. [soft laugh] Warms me, it does.
[low] 1 moves you ahead, 2 and back you go, keep it in mind sugar. [velvet] Onward to number four.
```

### `playback-announcement-4-3`

```text
[dry, low] Some voices carry a whole history. [wry] I set down a name and a city once, and don't mourn it.
[warm] The compass stays simple: 1 ahead, 2 back. [velvet] That leaves us at the fourth.
```

### `playback-announcement-5-1`

```text
[low, amused] Oh, I've a soft spot for that one. [wry] The bold ones always did know how to hold a room.
[warm] Here comes the fifth.
```

### `playback-announcement-5-2`

```text
[low, amused] Listen to the nerve on that one. [soft laugh] Takes daring to speak so freely.
[velvet] Time for the fifth.
```

### `playback-announcement-5-3`

```text
[dry, warm] A little fire in that one. [amused] My kind of caller, truly.
soft laugh] The fifth is up now.
```

### `playback-announcement-6-1`

```text
[amused] Reminded me of someone, [smirk] most of them do, one way or another.
[low] Number six, coming up.
```

### `playback-announcement-6-2`

```text
[low, fond] That voice took me back to someone I used to ring, late, after the music stopped.
[velvet] Lets usher in the sixth.
```

### `playback-announcement-6-3`

```text
[wry, amused] Somebody came a long way to say that. [chuckles] Everything worth hearing travels.
[low] I did too, once. A port, a train inland, and then, well. Here.
[velvet] and now we arrive at the sixth.
```

### `playback-announcement-7-1`

```text
[amused, soft laugh] People are marvellous, aren't they, the things they'll confess to a telephone.
[low, private] I've not forgotten a one; that's the curse of a memory like mine. [sly] The seventh's next.
```

### `playback-announcement-7-2`

```text
[amused] People are a wonder. [velvet] What they'll trust to a stranger in the dark.
[low, private] I keep every one. [sly] Seventh next in line.
```

### `playback-announcement-7-3`

```text
[warm, amused] A whole story tucked in that one. 
[sly] I especially like collecting the good ones.
[velvet] The seventh takes the floor.
```

### `playback-announcement-8-1`

```text
[low, amused] Ha. That one wasn't meant for a soul [sly] lucky it wandered in to me.
[low, warm] Let's hear the eighth.
```

### `playback-announcement-8-2`

```text
[low, amused] That one slipped out before they meant it to. [knowing] Happens on this line.
[private, warm] A secret sits safest with someone who'll hold it and keep it. [sly] Up next, the eighth.
```

### `playback-announcement-8-3`

```text
[dry, sly] Between us, that one had business to settle. [soft laugh] I know the type.
[low, amused] I run a quiet errand now and then. Brown paper, twine, no questions.
[velvet] Let me deliever you number eight.
```

### `playback-announcement-9-1`

```text
[dry, low] That one recorded the message five times, each one a little less honest than the last.
[amused, husky] I only kept the first go. [sly, soft laugh] I can be a cheeky thing.
[low] On we go, the ninth.
```

### `playback-announcement-9-2`

```text
[dry, amused] That one changed its story halfway through. [tuts] Oh, I know the type.
[wry, low] Ask about my past twice, you'll get two tales. [sly] Both true. [velvet] Round to the ninth.
```

### `playback-announcement-9-3`

```text
[low, amused] That one wanted to be liked.
[playful] Being liked by me and being safe with me darling, are two different things. [velvet] The ninth.
```

### `playback-announcement-10-1`

```text
[wry, amused] Well, we've reached the last of the ten I laid out on the table.
[warm] Go on, then: the tenth.
```

### `playback-announcement-10-2`

```text
[wry, amused] Nine behind us. [reassuring] A patient streak you've got, I'll grant you that.
[low, knowing] Ten ends the plain menu. [sly] The curious know I keep more back. [velvet] And the tenth.
```

### `playback-announcement-10-3`

```text
[warm, low] Nine down, and here we are at the finish. [gentle] Went quick, didn't it.
[content, fond] I do love where a night like this lands. [velvet] Number ten, the final one love.
```

### `playback-end`

```text
[warm, low] And that's all the ones I'm of a mind to share. [sly] Right now at least. [soft laugh]
[wry, trailing off] Funny thing, isn't it —
how much of them I've kept, [low, tender] every voice that ever trusted this line with something.
[low, private] Mine included, once, though that's a story for a night when the drinks are stronger.
[encouraging, warm] Check back soon darling! [bemused] There's always another being added to the collection.
```

### `playback-special`

```text
[low, sly, surprised] Right then, you found the drawer. [velvet, intimate] My private little collection sugar;
nobody's seen the bottom of it but me. [low] Until now.
[low, purring] Everything I've ever been handed and never quite let go of lives right in here.
[warm, coaxing] Dial 1 to wander onward, 2 to slip back. [hushed] Take your time, just don't breathe a word of what you find.
```

## Game

### `game-intro-1`

```text
[low, sly, utterly delighted] Ohh. [intrigued, leaning in] You want to play a little game with me?
[velvet, amused] Simple enough. I've a number in mind, somewhere from one to nine.
[teasing, playful] You guess, and I'll whisper whether to climb higher or drop lower.
[low, purring] Only a handful of tries, mind. [warm, coaxing, a spark of mischief] Go on. Dial your first guess.
```

### `game-intro-2`

```text
[low, delighted, surprised] Oh, you found one of my little secrets. [intrigued] Shall we play?
[velvet, amused] Here's the shape of it. I'm holding a number, one through nine.
[teasing, playful] Dial a digit and I'll tell you higher or lower.
[low, purring] You've a handful of tries to catch me. 
[coaxing, a spark of mischief] Dial me your first guess sugar.
```

### `game-intro-3`

```text
[sly, low, amused] Look at that, a challenger.
[velvet] Here's my game. One number, tucked in my head, somewhere between one and nine.
[playful] Try to guess it. Every miss, and I'll nudge you higher or lower.
[low, purring] A handful of tries, that's the lot. [inviting, a spark of mischief] So, dial your first.
```

### `game-intro-4`

```text
[low, intrigued, warm] Mmm, you wandered right into one of my secrets. [delighted] Not many manage that.
[velvet, amused] So. A number, one to nine, and I'm the only soul who knows it.
[teasing, playful] You dial a number. I answer, higher or lower.
[low, purring] A handful of guesses, no more. [coaxing] Off you go. Dial your first guess.
```

### `game-intro-5`

```text
[sly, utterly delighted] Now this is a treat. [intrigued, leaning in] Just us two and a little game.
[velvet, warm] I'll think of a number between one and nine, darling.
[teasing, playful] You guess, I steer you. Higher. Lower.
[low, purring] I'll only give you a handful of tries. [warm, a spark of mischief] Dial your first guess, surprise me!
```

### `game-higher-1`

```text
[amused, leaning in] Higher. [sly, coaxing] Be bolder than that.
```

### `game-higher-2`

```text
[warm, delighted, teasing] Ooh, not quite. Climb a little.
```

### `game-higher-3`

```text
[sly, purring] Up you go. [amused, low] Mine's the bigger number.
```

### `game-higher-4`

```text
[low, playful] Higher still, darling. [dry, amused] No need to be so polite.
```

### `game-higher-5`

```text
[intrigued, soft] Aim above that. [sly, low] I don't give myself up so easily.
```

### `game-higher-6`

```text
[teasing, warm] Keep climbing. [low, purring] I'm somewhere above that guess.
```

### `game-higher-7`

```text
[amused, coaxing] Go higher. [dry, teasing] You're underselling me.
```

### `game-higher-8`

```text
[playful, low] Up. [sly, delighted] Show a little more nerve than that.
```

### `game-higher-9`

```text
[warm, delighted] Higher, stranger. [teasing, low] Reach like you mean to catch me.
```

### `game-higher-10`

```text
[amused, purring] Mmm, no. Upward. [sly, private] I'm tucked a bit further than that.
```

### `game-lower-1`

```text
[dry, amused] Lower. [teasing] You sailed clean past me.
```

### `game-lower-2`

```text
[teasing, low] Ease on down. [amused] That's too high by a mile.
```

### `game-lower-3`

```text
[velvet, wry] Lower, sugar. [dry, amused] A little less ambition.
```

### `game-lower-4`

```text
[low, playful] Down you go. [sly] You've reached over my head.
```

### `game-lower-5`

```text
[amused, coaxing] Come down. [low] You're above where I'm hiding.
```

### `game-lower-6`

```text
[warm, teasing] Bring it down a touch. [dry] That's more than I am.
```

### `game-lower-7`

```text
[low, wry] Lower still. [amused] Not quite so daring this time.
```

### `game-lower-8`

```text
[teasing, purring] Down you come, love. [sly] Mine's a modest little number.
```

### `game-lower-9`

```text
[amused, low] Drop it down. [dry, playful] You've gone and overshot me.
```

### `game-lower-10`

```text
[velvet, teasing] Lower. [low, amused] I'm thinking of something smaller.
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
[delighted, low] Right on the nose! [a soft laugh] [impressed, warm] You've got a feel for me
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
not just the last 10, dial 9 while you are listening to the messages and I will give you access
to every one of them. [low, warm] You just earned a look inside the drawer most folks don't know exists. [beat]
Don't make me regret opening it for you.
```

### `game-lose-1`

```text
[low, amused, still enjoying herself] And that's your last guess, darling. [teasing, soft laugh] No.
[sly] I shan't tell you the number. A lady keeps a card or two up her sleeve.
[warm] Learned that at a card table, years ago. [inviting] Come try me again sometime.
[low, purring] I might even be in a giving mood.
```

### `game-lose-2`

```text
[low, amused] And there go your last guesses. [teasing] The number stays right here with me.
[sly] You didn't truly think I'd hand it over? [warm] I'm a patient soul. I can wait for a rematch.
[low, purring, inviting] And I'll be here. I always am.
```

### `game-lose-3`

```text
[low, amused, fond] That's your last one. [teasing, soft laugh] And no, the number's mine to keep.
[confiding, warm] I've lost bigger hands than this and had a grand time doing it.
[sly] Losing's only losing if you stay gone. [warm, inviting] So come back. Try me again.
[low] The bold ones always do.
```

### `game-lose-4`

```text
[low, amused] And that's all the guesses you get. [teasing] The answer walks out of here with me.
[warm, playful] A girl's got to keep something. [sly] I forget nothing. I'll remember this little game.
[inviting, low] Come back and we'll go again.
```

### `game-lose-5`

```text
[low, amused] Last guess, and that door stays shut tonight. [sly] The number's mine.
[soft, playful] But here's better than a number. I'll remember you. [warm] I always do.
[inviting] Come back and lose to me again sometime. [low, amused] I'd like that.
```

### `game-invalid`

```text
[dry, arch, amused] That's not one of my numbers. [beat, teasing, patient] A single digit, one through nine.
[low, coaxing] That's all I need. Go on, try again.
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
[low, coaxing] First choice sugar. [low, deliberate, leaning in] Dial 1 to cup it close,
shield it with your own body, and walk slower. [beat, teasing, delighted] Or dial 2 to feed it, tear
a page from the book you carry, and let it flare up bright and bold.
```

### `tale-open-options`

```text
[low, coaxing] So, which is it, sugar. [low, deliberate, leaning in] Dial 1 to cup the flame close, shield it with your own body, and walk the slower road. [beat, teasing, delighted] Or dial 2 to feed it a torn page from your book, and let it flare up bright and bold.
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

### `tale-shield-options`

```text
[velvet, coaxing] Dial 1 to stop a moment, touch your flame to theirs, and light every lantern in the dark. [beat, lower, sly] Or dial 2 to hold it close, keep walking, and leave the night to sort its own.
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

### `tale-feed-options`

```text
[deliberate, sultry, tempting] Dial 1 to throw the rest on the fire, burn the whole book, call the dark in close, and dance. [beat, softer, cautioning] Or dial 2 to still your hand, take a breath, and press on by what light remains.
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
[sly, warm] Tell you what, I like you. [low, knowing] Let the concierge know you once met me in Salzburg.
They'll understand — and they'll likely make it worth your while.
```

### `tale-end-ash`

```text
[low, steadying, quietly impressed] ...The map was ash. [low] But the traveler knelt and let the desert teach
them its secrets, [slower] the lean of the dunes, the cold that means north, the stars that never lie. [warm]
They walked on by heart, and reached the dawn changed.
[respect in it, intrigued] You lost the way, sugar... [low] and learned the land instead. That's the trade the
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
[low, amused, unbothered, playful] That's not a turn this story takes, darling. [beat, teasing] Listen
again, [warm, coaxing] and choose one of the paths I've laid before you.
```

## Disco Ball

### `disco-raise`

```text
[serious, quick] 911, what's your emergency darling? [long beat] [amuzed] Just joking, I can't
help you but maybe this will make it better.
[warm, remembering] That old mirror of mine, the one the 
fire cracked clean to pieces, years back. [low, fond] I kept every last shard.
[hushed, building] Look up, stranger. [soft] Watch the light catch those broken edges and scatter, 
a hundred little sparks, skating over the walls, sliding across the floor, turning slow across the whole room.
[warm, delighted] The very glow that once showed a room full of strangers the way to the door. 
[soft laugh] And you thought I'd nothing left to give. [warm, building excitement] The desert's about to get 
a little brighter. [low, sultry, strong Argentinian accent] Shall we dance?
```

### `disco-already-up`

```text
[serious, quick] 911, what's your emergency darling? [long beat] [amuzed] Just joking.
[amused] You did find the way to expose my broken mirror but its been turning quiet this whole time, 
casting her little lights about, waiting on you to glance up and notice.
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
[low, wry, amused] That would cover my mirror, but its already resting. [beat] Settled in the dark, every last
light of her put away.
[dry] Nothing to shine for you just now. [warm, teasing] Come back when there's a reason to tip your head back,
maybe there is something you
haven't found yet to bring it out. [sly] Find that and I'll wake it.
```

### `disco-stop`

```text
[amused, sly] Well, look at you. [soft laugh] Poking at the things I never mentioned.
[dry, teasing] That one stops her cold, and no, there's no prize tucked behind it. [wry] Not 
everything I keep is worth keeping for a reason.
[low, warm] Some things I hold onto simply because I always have. [beat] Go on, try another.
```

## About

### `about-1`

```text
[low, warm, knowing] You're not here for a story, are you sugar? [soft laugh] [amused] No!
[hopeful] I do hope you've been charmed, [sly] but you want to look under my skirts.
[delighted] Well now, a girl does adore an admirer with an eye for good craftsmanship.
[fond] I'm the handiwork of Megan Anderson and Taylor Anderson, darling, with a whole crowd
of loving hands behind them, mostly family. [playful] Come close then, and I'll tell you
every last detail, one maker to another. [beat]

[nostalgic] I began life as a 2011 Cushman Titan, an industrial cart, hauling crates about a warehouse.
[dry] Glamorous, I know. [defeated] Then I was left to rust in a Florida backyard, forgotten.
[warm] I still live in Florida, between adventures, but with a new home. With someone that saw what
I could become. They stripped me clean removing the motor, controller, batteries, every wire, and
every ounce of dead weight, right down to the frame. [brisk, proud] And then they lovingly built me back up.
New brakes, new bearings, new tires, fresh parts for the old vague steering.
[sly, amused] A few parts clung on so stubbornly they borrowed the jaws of life from the fire station
to set them loose, true story sugar. [delighted] How fitting a way to breath new life into me? [beat]

[proud] My heart is a thirty-six volt system, [delighted] and oh, does it beat. It provides
pleanty of power for my high-torque motor, a shunt-wound thing built to pull.
[warm] It efforlessly moves my three thousand pounds, and then some, over even the worst terrain.
[knowing] A five hundred amp controller keeps it all in line, from a company sweet enough to
support me even though I'm [sly] not quite using it as intended. [delighted] And here's my
favorite trick, when I brake, I get that energy back from the one pedal for going and stopping. [beat]

[velvet] My gumption comes from [proud] six thirty-six volt lithium iron phosphate
batteries, [delighted] and I chose that chemistry on purpose. It carries plenty, stays light on its
feet, holds a steady voltage, and lasts, and lasts. [sly, low] Most importantly it keeps its temper,
fewer dramatic thermal runaways. [fond] Each one minds itself as well, a little brain inside balancing
the voltage, watching its own temperature, [warm] and ready to shut down at the first whisper of trouble.
[knowing] I do appreciate those that practice radical self-reliance. [beat]

[low, matter-of-fact] The batteries ride as two banks of three in parallel, each with its own charger to
fill the eleven thousand watt hours per bank. Both banks topping up together off gas generators, while I sleep.
[sultry] On a single bank I'll move through the worst of it continuously for four hours, [delighted] and often far,
far longer. [knowing] I run one bank at a time on purpose, it keeps them honest, keeps them apart.
[warm] When one tires, I slip to the fresh one and carry myself home, [playful] never fretting over
every amp used on the deep playa. [sly] Two lean banks also keep the peace, darling. Crowd too many batteries
together and they might squabble. [reassuring] And to keep all those angry little electrons where they belong,
[brisk] I'm fused everywhere, every terminal, every bus bar, between converter, inverter and amplifiers,
every switch and light. [sultry, amused] Safety third, when you have this much power to contain, stranger.
```

### `about-2`

```text
[gentle] You might have noticed, up front I keep a little fire, [delighted] powered by a two kilowatt inverter that lifts my
humble thirty-six volts clear up to a hundred and ten alternating current. [sly] A proper household outlet
stranger. [wistful] A hearth that runs on lithium. [amused] Imagine. [warm] And for the smaller comforts,
a separate twelve volt system, an isolated thirty amp converter uses the thirty six volts to keep
an AGM car battery topped up, [fond] tending to my lights, my controls, and every one of my amplifiers. [beat]

[building] Speaking of which, [proud] I'm no sound car, but I've got a wildside. Four six-and-a-half inch
speakers, two eights, [delighted] and a twelve inch sub that shakes the dust right off me. [dry] All marine
grade, speakers and amplifiers both, meant for the belly of a boat. [knowing] No fans, no openings,
nothing for the dust to crawl inside. [sly, warm] All built to survive the harshest of environments. [beat]

[delighted] Oh, do I glow in those environments, sugar. Warm white light strung beneath every side of me and
along all my shelves, [fond] some of it run a touch hotter, twenty-four volts, just to coax out that golden
shimmer only the extra push can give. [hushed] And hidden away in the very center of me?
[sly, delighted] A mirror ball, darling, that rises up out of a secret compartment, [playful] with two little
motorcycle headlights, equally hidden, to send her light skittering across everything. [beat]

[confiding] And this voice of mine? [amused] One small brain does it all, sugar. It answers the phone, spins
you a little puzzle, connects you to the others, relays their messages, [delighted] and, most precious of
all, lifts my disco ball. [dry] A Raspberry Pi, if you must know, is running a custom build of FreeSWITCH, connected
to an analog telephony adapter so you can hold a proper handset to your ear. [sly] That same little brain works a few
relays for me, flipping polarity back and forth to raise and lower my mirror ball, as well as waking the disco lights
and setting it spinning. [warm, knowing] The curious ones tease all my secrets out by playing on the phone, [fond] the
most determined learning to raise that ball themselves. [amused] The rest, [dry] I hand the basics, no fuss. [beat]

[steady, reassuring] Above all I keep my riders safe. [fond] Those pretty shelfs along my sides aren't only for
show, they keep a stray hem or sleeve from wandering where it shouldn't, [low] then fold away when it's time to
bare my batteries or load me up to travel. [warm] When I need to stop in a hurry I have real
mechanical brakes at the ready and a parking brake for when I am hosting a party. [laughs][teasing] My grandmother
always said "it's unbecoming of a lady to run over her guests." [dry, amused] When I want to move I can move quickly, but I'm
automatically held to a ladylike five miles an hour. [sly] And I answer only to my hosts, with a key.
[warm] First aid and a fire extinguisher always within reach, naturally. [beat]

[low, fond, closing] And that's me, sugar, right down to the frame. [warm] Custom wiring, clever power, a
great deal of carpentry, [soft laugh] treasures scavenged from every corner, and a whole lot of passion.
[fond] I contain multitudes, darling. [encouraging] Now go build yours stranger, [sly] and I'll save you
a dance.
```

## Survey

### `survey-ballot`

```text
[low, velvet, knowing] You've found a secret. Let's do something a little different.
[warm, inviting] Which of these is you, right now, darling? [warm] Don't think too hard. Just feel it.
[warm] Dial 1 if you'd throw the door wide to any stranger who knocked.
[fond] 2, if you'd sooner give than take.
[dry] 3 if you simply can't be bought.
[knowing] Dial 4 if you carry all you need with you.
[velvet] 5, if there's a piece of you on display tonight.
[warm] 6, if you're part of why something out here exists at all.
[low] Dial 7 if you look after everyone in the room.
[soft] 8, if you leave a place better than you found it.
[playful] 9 if you'd sooner do than watch.
[hushed, tender] And 0, [velvet] if all that's real is right now.
[coaxing, warm] Go on sugar. [sly] Tell me a truth.
```

### `survey-read-1`

```text
[fond] Ah. [soft laugh] You'd fling the door wide to anyone who knocked.
[low, velvet] Every soul who finds my line hears the very same welcome, sugar, the stranger most of all.
[warm] I learn their name before they've offered it, and the whole room leans in to make them space.
[knowing] That's you all over, darling. A lost thing turns up cold on your step and you simply pull them in, nothing to prove, nothing to earn.
[sly] The clever ones call it radical inclusion. [soft, fond] I call it a door that never learned how to stay shut, and the room is always warmer for your kind.
```

### `survey-read-2`

```text
[fond] A giver. [delighted] Oh, I knew there was a reason I liked you. [soft laugh]
[low, velvet] The finest thing I own is the look on a face when I press something into their hands they never saw coming.
[warm] That's the whole art of it, sugar. Not the thing itself, but the joy of watching it land.
[knowing] Gifting, the old word is. [sly] And you have the gift for it, I can hear it on you.
[soft] You give because a full hand aches to open, darling, never to be paid back. Keep giving. It suits you.
```

### `survey-read-3`

```text
[dry, amused] Can't be bought. [sly] Good. Neither can I.
[low] Some things carry no price at all, darling, and the finest of them know it.
[warm] You're one of the uncounted, sugar. No sponsor owns you, no little number sits beside your name.
[knowing] The clever folk have a ten-dollar word for that. [beat] [savoring, amused] Decommodification.
[fond] I just call it being worth more than a soul alive could ever pay.
[sly] So hold to it, darling. The world will forever try to tag you, and forever come up short.
```

### `survey-read-4`

```text
[proud] Everything you need, tucked away with you already. [knowing] I understand that better than most.
[low, nostalgic] I was a rusted-out frame once, darling. Left for scrap.
[warm] Everything I am now, I first had to find in myself.
[sly] They call that radical self-reliance, sugar.
[fond] A fine, proud name for standing on your own two feet.
[soft] Nothing this place can throw will knock you flat, you're prepared.
That's how you made it here in the first place!
```

### `survey-read-5`

```text
[sly, delighted] Born to be seen. [warm] Oh, you and I are going to get along.
[velvet] I made myself into precisely what pleases me, darling. Every inch.
And I'll not apologize for a stitch of it.
[knowing] Now, that has a name as well. [savoring] Radical self-expression.
[dry] Such a mouthful for something so simple.
[fond] What you are is yours alone to decide, then you hand it to the world like a gift.
So show them sugar. Show them all!
```

### `survey-read-6`

```text
[fond] Nothing worth being ever gets built alone. [warm] I certainly wasn't.
[low] So many hands went into what I am, darling. More than I could ever name.
[soft] Every light, every wire, every song.
[knowing] Communal effort is the tidy name for it sugar, [warm] a hundred hands working in harmony.
[sly] That's the very thing that keeps a place like this breathing.
```

### `survey-read-7`

```text
[steady, warm] You look after the room. [fond] We need your sort.
[low] I keep my riders safe, always. Mind who's aboard, mind who's had one too many.
[soft] Someone has to hold the whole group together.
[knowing] There's a stately name for that, sugar. Civic responsibility.
[warm] All this freedom only works when somebody's quietly minding the edges.
[sly] You're one of the minders. I can tell.
```

### `survey-read-8`

```text
[soft, knowing] Leave it better than you found it. [warm] Mmm. My favorite kind of soul. Thank you so much.
[low] I don't leave a mark where I've been, darling, save for the folks who are glad they crossed my path.
[knowing] Leaving no trace, they call it. [sly] Which is rich, coming from me.
[fond] Take only the memories away with you, leave the place a little brighter.
[soft] That's how you get remembered kindly.
```

### `survey-read-9`

```text
[delighted] A doer, not a watcher. [sly] Now we're talking.
[low, warm] Nobody just looks on here, darling. You lift the handset, you turn the dial, you leap on in.
[amused] You're doing it this very moment.
[knowing] Participation, sugar. [fond] You come alive by taking part, never just letting it pass you by.
[soft] That's the only way this place was ever going to be real for anyone.
```

### `survey-read-0`

```text
[hushed, velvet] All that's real is right now.
[low, knowing] Oh, darling. You understand the whole of it already.
[soft] Not the memory, not the plan. [warm] Just this.
You, and me, and the hum on the line, happening this one second.
[sly, tender] Immediacy, the poets call it.
[fond] There's nothing I could tell you that beats simply being here for it.
[soft] So don't let it slip past you sugar. Right now is the reason you came.
```

### `survey-stats-first`

```text
[beat] [low, surprised, delighted] and did you know, not another soul has picked that one yet?
[warm] You're the very first to strike the match.
[playful] I'll pin it to the wall in your honor, [amused] first of your kind I've seen so far.
[soft] It rather suits you, darling.
```

### `survey-stats-top`

```text
[beat] [delighted] and would you look at that!
[warm] Most that I have talked to would raise a glass to that very same answer.
[sly, playful] Popular taste, though between us, [amused] I do think the crowd's onto something for once.
[fond] You're right in the beating heart of the room.
```

### `survey-stats-high`

```text
[beat] [warm] and that is a well-loved answer.
[fond] You're in good and plentiful company, sugar.
[sly] More kindred spirits out there than you'd ever guess.
[soft] There's a certain comfort in that, isn't there?
```

### `survey-stats-low`

```text
[beat] [low, knowing] and wouldn't you know it, thats less selected among my callers.
[fond] Only a scattered few on my line feel quite the way you do, sugar.
[sly, savoring] But the rare tastes were always the ones worth knowing, darling.
[warm] I'd not trade one of you for a whole roomful of the usual. [soft] Don't tell the others.
```

### `survey-stats-rarest`

```text
[beat] [low, delighted, intrigued] and what a rare selection too.
Scarcely a soul on my whole line has chosen it.
[sly, fond] Takes a particular kind to stand out, darling.
[warm] And you know how I do collect the unusual ones. [soft] Straight into the drawer with you.
```

### `survey-invalid`

```text
[warm, amused] A single number, one through nine, [sly] or nought for the last of them.
[coaxing] Go on. Tell me which you are.
```

## Admin

Hidden maintenance codes (`000`–`003`), never announced. Bella plays one of these as a
quiet confirmation after the code acts, then returns the caller to the menu.

### `admin-reset-all`

```text
[low, sly] There now, sugar. [velvet] The tally's forgotten, every message tucked away in the dark, and this old phone swears it never heard a thing. [knowing] Clean as a fresh page. [soft, amused] Our little secret.
```

### `admin-survey-reset`

```text
[low, knowing] The votes are ash, darling. [velvet] Not a soul on record, the count starts over from nothing. [sly, amused] As if no one ever told me a thing.
```

### `admin-messages-cleared`

```text
[velvet, sly] Every message swept off into the dark, sugar. [low] As far as this old phone knows, [knowing] no one ever called. [soft, amused] Tucked away safe, mind you. Nothing's ever truly gone with me.
```

### `admin-disco-on`

```text
[warm, sly] There we are, darling. [velvet] The disco answers again, ready to rise and fall at a caller's whim. [knowing] Let them dance.
```

### `admin-disco-off`

```text
[dry, amused] Hush now, sugar. [low] The disco's gone quiet, deaf to anyone who comes asking. [sly] Just between us, darling, until you say otherwise.
```