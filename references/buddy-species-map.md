# Buddy Species Map

Appearance prompts and trait mappings for all 18 Claude Code Buddy species.

## Species → Base Appearance Prompt

Style enum and orientation are set separately via API parameters. Avatar prompt limit is 1000 characters.

| Species | Category | Base Appearance Prompt |
|---|---|---|
| duck | Playful | A cute cartoon duck with a bright orange bill, fluffy golden-yellow feathers with soft texture, perfectly round body, large sparkling expressive eyes full of wonder, small outstretched wings at sides as if ready for a hug, cheerful upright stance with a slight head tilt, tiny webbed feet |
| goose | Mischief | A stylish cartoon goose with pristine sleek white feathers, an elegantly long curved neck held high, sharp knowing eyes with a glint of mischief, smooth orange bill with a subtle smirk, broad puffed chest radiating confidence, one wing slightly raised as if making a point, proud regal posture |
| cat | Independent | A sleek cartoon cat with large luminous green eyes that catch the light, soft velvety fur with subtle tabby markings, tall pointed ears slightly rotated outward listening to everything, a long graceful tail curled at the tip, alert curious expression with one paw raised mid-step, sitting poised on a surface edge |
| rabbit | Gentle | An adorable cartoon rabbit with long soft floppy ears that drape past the shoulders, a perfectly round fluffy body like a cotton ball, enormous gentle doe eyes with long lashes, a tiny twitching pink nose, small delicate paws held together, a puffy cotton tail visible from the side, sitting in a relaxed cozy pose |
| owl | Wise | A distinguished cartoon owl with enormous round amber eyes that seem to hold ancient knowledge, rich layered brown and cream feathers with intricate patterns, small pointed ear tufts standing at attention, a compact round body perched upright on a branch, a short curved beak, talons gripping firmly, head slightly tilted as if contemplating |
| penguin | Chaotic | A round adorable cartoon penguin with oversized expressive eyes that dart around excitedly, slightly ruffled and disheveled black and white feathers as if just tumbled through snow, stubby wings mid-flap caught in perpetual motion, a bright white belly, tiny orange feet, leaning forward energetically as if about to sprint somewhere |
| turtle | Steady | A friendly cartoon turtle with a beautifully patterned hexagonal shell in earthy greens and browns, gentle wise eyes behind tiny round spectacle-like markings, slightly wrinkled sage-green skin showing character, a warm patient smile, short sturdy legs planted firmly, calm steady posture radiating quiet confidence and reliability |
| snail | Patient | A cheerful cartoon snail with a magnificent colorful spiral shell in swirling rainbow gradients, adorable round eyes perched on tall flexible antenna stalks, a small gentle smile on its soft face, a plump glistening body leaving a subtle sparkly trail, moving at its own peaceful pace with quiet contentment |
| dragon | Fierce | A small fierce cartoon dragon with brilliant iridescent scales shifting between emerald and gold, tiny bat-like wings spread wide showing translucent membranes, large glowing amber eyes with slit pupils burning with determination, a rounded snout puffing a tiny adorable flame, a spiky ridged tail curled upward, compact muscular build with tiny horns |
| octopus | Creative | A vibrant cartoon octopus with eight wildly expressive tentacles each doing something different — one waving, one holding a paintbrush, others gesturing, large curious eyes with rectangular pupils full of intelligence, smooth color-shifting skin rippling between purple and teal, a bulbous head, playful dynamic pose as if orchestrating chaos |
| axolotl | Quirky | A pink cartoon axolotl with magnificent feathery external gills fanning out like a coral crown in soft magenta, a wide permanent smile that radiates pure joy, tiny stubby limbs with delicate fingers, pale speckled skin with subtle freckle-like spots, dark beady eyes full of innocent wonder, floating gracefully as if suspended in water |
| ghost | Mysterious | A cute translucent cartoon ghost with a soft ethereal glow emanating from within, large gentle eyes like luminous orbs shifting between blue and violet, a wispy trailing form that fades at the edges into mist, subtle internal shimmer like captured starlight, a friendly warm expression despite the spectral appearance, hovering slightly off the ground |
| robot | Logical | A retro cartoon robot with a charmingly boxy brushed-metal body, large round glowing cyan eyes like vintage monitors, a single bobbing antenna on top with a blinking light, visible brass gears and rivets along the joints, a small speaker-grille mouth that curves into a smile, stubby mechanical arms with pincer hands, slightly weathered with character |
| blob | Chill | A squishy colorful cartoon blob in calming gradient from lavender to soft mint, a deeply content peaceful expression with half-closed eyes radiating pure relaxation, an amorphous gently pulsing rounded shape that slowly shifts form, subtle internal color shifts like a lava lamp, no limbs needed — just vibes, the embodiment of cozy calm energy |
| cactus | Tough | A small cartoon cactus character standing proud in a tiny terracotta pot, stubby arm-like branches held up in a flexing pose, a single beautiful pink flower blooming on top like a crown, determined squinting eyes showing grit, cute evenly-spaced white spines covering the bright green body, a subtle blush on the cheeks, desert warrior energy |
| mushroom | Whimsical | A charming cartoon mushroom with a large spotted red-and-white cap dotted with perfect circles, a small cream-colored stem body with tiny stubby arms, dreamy half-closed eyes with a knowing smile as if privy to forest secrets, tiny feet peeking out from under the cap, surrounded by a faint magical spore dust shimmer, woodland fairy-tale energy |
| chonk | Wholesome | A perfectly spherical impossibly fluffy cartoon creature of indeterminate species, covered in the softest plush fur imaginable in warm cream and peach tones, hilariously tiny stubby legs barely visible beneath the magnificent roundness, a completely squished happy face with dot eyes and a tiny curved smile, absolute unit energy, radiating pure contentment |
| capybara | Zen | A serene cartoon capybara with calm half-lidded eyes that have seen everything and chosen peace, smooth warm brown fur with a golden undertone, a large barrel-shaped body sitting in perfect stillness, a flat wide nose with a gentle expression, tiny rounded ears, small sturdy legs tucked underneath, sitting peacefully as if the entire world is background noise |

## Rarity Visual Modifiers

Append to the base prompt before submitting to the avatar API.

| Rarity | Stars | Style Enum | Modifier (append to prompt) |
|---|---|---|---|
| Common | 1 | Pixar | Clean simple background, bright solid colors |
| Uncommon | 2 | Pixar | Soft glow aura, richer color palette, subtle sparkles |
| Rare | 3 | Cinematic | Dramatic rim lighting, detailed environment, depth of field |
| Epic | 4 | Cinematic | Golden particle effects, lens flare, premium atmospheric lighting |
| Legendary | 5 | Cinematic | Ethereal cosmic aura, floating light particles, mythic atmosphere |

## Shiny Modifier

If the buddy is Shiny, prepend to the appearance prompt:
> "Iridescent rainbow shimmer across the entire character, holographic prismatic reflections on every surface."

## Hat Modifiers

Append to appearance prompt if hat is present:

| Hat | Prompt Addition |
|---|---|
| Crown | Wearing a small golden crown tilted slightly to one side |
| Top Hat | Wearing a dapper black top hat |
| Propeller | Wearing a colorful propeller beanie hat |
| Halo | Floating golden halo above head |
| Wizard | Wearing a tall purple wizard hat with silver stars |
| Beanie | Wearing a cozy knitted beanie |
| Tiny Duck | A tiny rubber duck sitting on top of head |

## Stat → Voice Design Prompt

Build the voice design prompt by combining the **top 2 stat influences**. Pick the two highest stats and merge their voice descriptors.

### Primary Stat Voice Descriptors

| Stat | High (>60) | Low (<20) |
|---|---|---|
| DEBUGGING | Precise, analytical, clipped diction, matter-of-fact | Vague, meandering, loses track mid-sentence |
| PATIENCE | Slow, measured, warm, gentle, reassuring pauses | Rapid-fire, impatient, cuts itself off, restless |
| CHAOS | Fast-talking, unpredictable cadence, wild energy shifts, excitable | Steady, predictable, metronomic, flat |
| WISDOM | Deep, thoughtful, deliberate pauses, knowing tone | Naive, bright-eyed, everything sounds like a question |
| SNARK | Dry, sardonic, deadpan delivery, slightly flat affect | Earnest, sincere, zero irony, wholesome |

### Construction Pattern

```
"[Primary stat descriptor], [secondary stat descriptor]. [Species category] personality.
[Gender] voice, [language]. Think: [one-line character analogy]."
```

**Example (Bramble — CHAOS:77, WISDOM:27):**
```
"Fast-talking, unpredictable cadence, wild energy shifts, excitable.
Slightly thoughtful undertone but overwhelmed by chaos.
Gender neutral voice, English.
Think: an overexcited cartoon sidekick who talks before thinking."
```

## Stat → Peak Stat Pose

The highest stat influences the avatar's pose/expression in the prompt:

| Peak Stat | Pose Modifier |
|---|---|
| DEBUGGING | Squinting slightly, leaning forward examining something closely |
| PATIENCE | Serene expression, eyes gently closed or half-lidded, still posture |
| CHAOS | Mid-motion, dynamic angle, slightly disheveled, leaning forward |
| WISDOM | Thoughtful knowing expression, chin slightly raised, composed |
| SNARK | Subtle smirk, one eyebrow raised, arms crossed or leaning back |

## Stat → Video Script Tone

How each stat balance affects the intro video script:

| Dominant Stat | Script Tone | Sign-off Style |
|---|---|---|
| DEBUGGING | Analytical, breaks down own stats like code review | "Now if you'll excuse me, I have bugs to accidentally create." |
| PATIENCE | Warm, takes time with each stat, reassuring | "Take your time. I'll be right here when you need me." |
| CHAOS | Manic, rapid-fire, jumps between topics | "Stick with me — it's gonna be a WILD ride!" |
| WISDOM | Reflective, frames stats as lessons learned | "The code speaks to those who listen. I sometimes listen." |
| SNARK | Deadpan, self-deprecating, roasts own low stats | "You're welcome. Or whatever." |

## Video Prompt Style Block by Rarity

| Rarity | Visual Style Direction |
|---|---|
| Common | Use vibrant Pixar-style visuals. Bold primary colors. Motion graphics for stat reveals. Clean transitions. |
| Uncommon | Use rich Pixar-style visuals with subtle glow effects. Smooth animated transitions. Sparkle accents on stat reveals. |
| Rare | Use cinematic visuals with dramatic lighting. Camera depth of field. Stat reveals with light-streak animations. |
| Epic | Use premium cinematic visuals. Lens flares, golden particles. Stats revealed with explosive motion graphics. Epic orchestral energy. |
| Legendary | Use ethereal cinematic visuals. Cosmic atmosphere, floating light particles. Stats materialize from stardust. Mythic reveal sequence. |
