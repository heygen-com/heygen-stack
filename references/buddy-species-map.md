# Buddy Species Map

Appearance prompts and trait mappings for all 18 Claude Code Buddy species.

## Species → Base Appearance Prompt

Each prompt is under 200 characters (HeyGen avatar API limit). Style enum and orientation are set separately.

| Species | Category | Base Appearance Prompt |
|---|---|---|
| duck | Playful | A cute cartoon duck with bright orange bill, fluffy yellow feathers, round body, expressive eyes, small wings at sides, cheerful stance |
| goose | Mischief | A stylish cartoon goose with sleek white feathers, long elegant neck, sharp knowing eyes, orange bill, confident proud posture |
| cat | Independent | A sleek cartoon cat with large luminous eyes, soft fur, pointed ears, long graceful tail, alert curious expression, sitting poised |
| rabbit | Gentle | An adorable cartoon rabbit with long floppy ears, soft round body, big gentle eyes, small twitching nose, fluffy cotton tail |
| owl | Wise | A distinguished cartoon owl with large round wise eyes, rich brown feathers, small tufted ears, compact round body, perched upright |
| penguin | Chaotic | A round adorable cartoon penguin with big expressive eyes, ruffled feathers, stubby wings mid-flap, black and white coloring |
| turtle | Steady | A friendly cartoon turtle with a patterned shell, gentle wise eyes, slightly wrinkled green skin, calm steady posture |
| snail | Patient | A cheerful cartoon snail with a colorful spiral shell, cute antenna eyes on stalks, small gentle smile, glistening trail |
| dragon | Fierce | A small fierce cartoon dragon with bright scales, tiny wings spread wide, glowing eyes, puffing a tiny flame, spiky tail |
| octopus | Creative | A vibrant cartoon octopus with eight expressive tentacles, large curious eyes, color-shifting skin, playful dynamic pose |
| axolotl | Quirky | A pink cartoon axolotl with feathery external gills, wide permanent smile, tiny limbs, speckled skin, floating gracefully |
| ghost | Mysterious | A cute translucent cartoon ghost with glowing gentle eyes, wispy trailing form, subtle shimmer, friendly ethereal expression |
| robot | Logical | A retro cartoon robot with boxy body, round glowing eyes, antenna on head, visible gears, friendly mechanical expression |
| blob | Chill | A squishy colorful cartoon blob with a content peaceful expression, amorphous rounded shape, subtle color shifts, relaxed vibe |
| cactus | Tough | A small cartoon cactus character with tiny arms, flower on top, determined eyes, cute spines, standing in a tiny pot |
| mushroom | Whimsical | A charming cartoon mushroom with a large spotted cap, small stem body, tiny arms, dreamy half-closed eyes, woodland setting |
| chonk | Wholesome | A perfectly round chonky cartoon creature, impossibly fluffy, tiny stubby legs, squished happy face, absolute unit energy |
| capybara | Zen | A serene cartoon capybara with calm half-lidded eyes, smooth brown fur, barrel-shaped body, sitting peacefully, unbothered |

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
