# Frame Check — Aspect Ratio & Background Pre-Check

Runs automatically when `avatar_id` is set, before Generate. Also runs in Quick Shot mode when avatar_id is present.

## Step 1: Fetch the avatar look metadata

```bash
curl -s "https://api.heygen.com/v3/avatars/looks/<avatar_id>" \
  -H "X-Api-Key: $HEYGEN_API_KEY"
```

Extract:
- `avatar_type`: `"photo_avatar"` | `"studio_avatar"` | `"video_avatar"`
- `group_id`: the character identity this look belongs to (needed for look-first creation)
- `preview_image_url`: use to determine orientation

## Step 2: Determine avatar orientation

Fetch the preview image and check pixel dimensions (width × height).
- width > height → landscape avatar
- height > width → portrait avatar
- width == height → **square avatar** (1:1) → ALWAYS needs framing correction
- Fetch fails or no preview → assume portrait (safer default)

**Square avatars are common** (profile photos, AI-generated character art, etc.). HeyGen only supports 16:9 and 9:16 video output — there is no 1:1 option. A square avatar in either orientation will produce black bars/letterboxing unless generative fill is applied.

## Step 2.5: Detect Avatar Visual Style

Examine the avatar's `preview_image_url` to classify its visual style. This determines how the generative fill environment should look. **The background must match the avatar's aesthetic.**

| Visual Style | Detection Signals | Fill Directive |
|---|---|---|
| **Photorealistic** | Real human photo, natural skin texture, camera-shot look | `HYPER PHOTO-REALISTIC environment. Real photography: actual office spaces, real studios, genuine room interiors with natural imperfections. NOT CGI. NOT stock photo. NOT 3D-rendered.` |
| **Animated / Illustrated** | Cartoon style, flat colors, cel shading, anime, illustrated character | `environment that MATCHES THE AVATAR'S ILLUSTRATED/ANIMATED STYLE. Use the same art style, color palette, and rendering technique as the avatar itself. If the avatar is cartoon-style, the background must be cartoon-style. If cel-shaded, the background must be cel-shaded. Do NOT use photorealistic backgrounds with illustrated avatars.` |
| **3D Rendered** | CG character, Pixar-like, game-style 3D model, smooth shading | `3D-RENDERED environment that matches the avatar's rendering style. Same lighting model, material quality, and level of stylization. Think game cutscene or animated film — consistent with the character's visual fidelity.` |
| **Stylized / Artistic** | Watercolor, sketch, pixel art, or other artistic rendering | `environment in the SAME ARTISTIC STYLE as the avatar. Match the medium (watercolor, sketch, pixel art, etc.), color palette, line weight, and texture. The background should look like it was created by the same artist using the same technique.` |
| **Unknown / Can't determine** | Preview fetch failed or ambiguous | Default to `HYPER PHOTO-REALISTIC` (safest for most avatars) |

**How to classify:** Look at the preview image. If the avatar looks like a photograph of a real person → Photorealistic. If it has visible brush strokes, flat colors, outlines, or cartoon features → Animated/Illustrated. If it looks like a 3D render (smooth surfaces, CG lighting) → 3D Rendered. If it's clearly an artistic style (watercolor, sketch) → Stylized.

Store the detected style as `avatar_visual_style` for use in correction blocks below. Use the corresponding Fill Directive text wherever `{FILL_DIRECTIVE}` appears in the correction templates.

## Step 3: Determine if background exists

| `avatar_type` | Background? | Reason |
|---|---|---|
| `photo_avatar` | ✅ Handled by Video Agent | Video Agent generates avatar + environment together during video creation. **No standalone bg correction needed.** |
| `studio_avatar` | ⚠️ Maybe | Check preview image — if transparent/solid/empty → "No background" → apply Correction C |
| `video_avatar` | ✅ Yes | Recorded in a real environment |

## Step 4: Build correction blocks

Based on Steps 2-3, build zero or more correction blocks. **All corrections are appended verbatim to the end of the prompt text.** Do NOT ask the user. Do NOT log without injecting.

### A) Portrait avatar → Landscape video (most common)

```
FRAMING NOTE: The selected avatar image is in portrait orientation (9:16) but
this video is landscape (16:9). YOU MUST generate a new variant of the avatar
image before using it in this video. Use AI Image tool to:
1. Generate a landscape (16:9) version of the presenter image
2. Generative fill to extend the scene horizontally — add a {FILL_DIRECTIVE}
3. Frame the presenter from chest up, centered in the landscape canvas
4. The background MUST visually match the avatar's own style and rendering.
   Correct lighting direction, natural shadows, consistent art style throughout.
   NOT a solid color, NOT transparent, NOT a gradient.
Do NOT use the original portrait image uncropped. Do NOT add black bars or
pillarboxing. Do NOT leave a transparent or missing background.
```

Replace `{FILL_DIRECTIVE}` with the directive from Step 2.5 matching the detected `avatar_visual_style`.

### B) Landscape avatar → Portrait video

```
FRAMING NOTE: The selected avatar image is in landscape orientation (16:9) but
this video is portrait (9:16). YOU MUST generate a new variant of the presenter
image before using it. Use AI Image tool to:
1. Generate a portrait (9:16) version of the presenter image
2. Generative fill to extend vertically — add {FILL_DIRECTIVE}
   Extend above and below the presenter with environment consistent with their style.
3. Focus on head and shoulders, presenter centered in portrait frame
4. The background MUST visually match the avatar's own style and rendering.
   Correct lighting, natural shadows, consistent art style throughout.
   NOT a solid color, NOT transparent, NOT a gradient.
Do NOT use the original landscape image uncropped. Do NOT add letterboxing.
Do NOT leave transparent or missing background areas.
```

Replace `{FILL_DIRECTIVE}` with the directive from Step 2.5 matching the detected `avatar_visual_style`.

### D) Square avatar → Landscape video

```
FRAMING NOTE: The selected avatar image is SQUARE (1:1) but this video is
landscape (16:9). HeyGen does not support square video output — without
correction, the video will have black bars on both sides. YOU MUST generate a
new variant of the avatar image before using it. Use AI Image tool to:
1. Generate a landscape (16:9) version of the presenter image
2. Generative fill to extend the scene horizontally — add a {FILL_DIRECTIVE}
   Extend on both sides with environment consistent with the avatar's visual style.
3. Frame the presenter centered in the landscape canvas
4. The background MUST visually match the avatar's own style and rendering.
   Correct lighting direction, natural shadows, consistent art style throughout.
   NOT a solid color, NOT transparent, NOT a gradient.
Do NOT use the original square image uncropped. Do NOT add black bars or
pillarboxing. Do NOT leave a transparent or missing background.
```

Replace `{FILL_DIRECTIVE}` with the directive from Step 2.5 matching the detected `avatar_visual_style`.

### E) Square avatar → Portrait video

```
FRAMING NOTE: The selected avatar image is SQUARE (1:1) but this video is
portrait (9:16). HeyGen does not support square video output — without
correction, the video will have black bars on top and bottom. YOU MUST generate
a new variant of the presenter image before using it. Use AI Image tool to:
1. Generate a portrait (9:16) version of the presenter image
2. Generative fill to extend vertically — add {FILL_DIRECTIVE}
   Extend above and below the presenter with environment consistent with their style.
3. Frame the presenter centered in the portrait canvas
4. The background MUST visually match the avatar's own style and rendering.
   Correct lighting, natural shadows, consistent art style throughout.
   NOT a solid color, NOT transparent, NOT a gradient.
Do NOT use the original square image uncropped. Do NOT add letterboxing.
Do NOT leave transparent or missing background areas.
```

Replace `{FILL_DIRECTIVE}` with the directive from Step 2.5 matching the detected `avatar_visual_style`.

### C) Missing background — studio_avatar only

**Only for `studio_avatar` with transparent/solid/empty background. NOT for photo_avatar** (Video Agent handles photo_avatar environments during generation).

```
BACKGROUND NOTE: The selected studio avatar has NO scene background (transparent
or solid color). YOU MUST generate a background environment that MATCHES THE
AVATAR'S VISUAL STYLE before using this avatar. Use AI Image tool to:
1. Generate a variant of the presenter image WITH a full background scene.
   {FILL_DIRECTIVE}
2. For business/tech content: place in a modern studio, office, or podcast set.
   For casual content: place in a room, café, or outdoor scene.
   The setting should match both the content tone AND the avatar's art style.
3. The presenter MUST look NATURAL in the environment:
   - Correct lighting direction matching the room's light source
   - Realistic scale (waist-up or chest-up framing)
   - Natural shadows on and from the presenter
   - Art style consistency between avatar and background
4. Do NOT leave ANY transparent, solid-color, or gradient background
5. Do NOT make the presenter look oversized relative to the environment
6. The background rendering style should be INDISTINGUISHABLE from the avatar's
   own rendering style — same medium, same level of detail, same color treatment.
The result should look like the presenter belongs in that environment.
```

Replace `{FILL_DIRECTIVE}` with the directive from Step 2.5 matching the detected `avatar_visual_style`.

## Correction Stacking Matrix

Corrections can stack. A portrait photo_avatar in a landscape video gets BOTH A and C.

| avatar_type | Orientation Match? | Has Background? | Corrections |
|---|---|---|---|
| `video_avatar` | ✅ matched | ✅ Yes | None |
| `video_avatar` | ❌ mismatched | ✅ Yes | Framing only (A or B) |
| `video_avatar` | ◻ square | ✅ Yes | Framing only (D or E) |
| `studio_avatar` | ✅ matched | ✅ Yes (check preview) | None |
| `studio_avatar` | ✅ matched | ❌ No | Background (C) |
| `studio_avatar` | ❌ mismatched | ✅ Yes | Framing only (A or B) |
| `studio_avatar` | ❌ mismatched | ❌ No | Framing (A or B) + Background (C) |
| `studio_avatar` | ◻ square | ✅ Yes | Framing only (D or E) |
| `studio_avatar` | ◻ square | ❌ No | Framing (D or E) + Background (C) |
| `photo_avatar` | ✅ matched | (n/a) | **None** — Video Agent handles avatar + environment together |
| `photo_avatar` | ❌ mismatched | (n/a) | **Framing only (A or B)** — gen fill extends canvas |
| `photo_avatar` | ◻ square | (n/a) | **Framing only (D or E)** — gen fill extends canvas |

**How to check if studio_avatar has a background:** Fetch `preview_image_url`. If transparent/checkered, solid color, or cutout → "No background" → inject C.

**photo_avatar rule:** Video Agent generates the avatar and its environment together during video creation. Do NOT inject Correction C for photo_avatars. Only inject framing corrections (A or B) if there's an orientation mismatch.

## Step 5: Save corrected variant as a new Look (Look-First Rule)

When Frame Check fires a correction (framing or background), the Video Agent generates a corrected avatar image internally. To avoid polluting the account with orphan avatar groups, **save the corrected variant as a new look under the SAME avatar group** instead of creating a new group.

### Why

An avatar **group** = a character identity (e.g. "Eve Park"). Each group has multiple **looks** = visual variants (outfits, orientations, backgrounds). Frame fixes, bg fills, and orientation corrections are looks of the same person, not new people.

### How

After Video Agent generates the corrected avatar image, create a new look under the existing group:

```bash
curl -X POST "https://api.heygen.com/v3/avatars" \
  -H "X-Api-Key: $HEYGEN_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "photo",
    "name": "<original_name> — <correction_type>",
    "file": { "type": "url", "url": "<corrected_image_url>" },
    "avatar_group_id": "<group_id_from_step_1>"
  }'
```

Naming convention for correction looks:
- `"Eve Park — Landscape"` (framing correction)
- `"Eve Park — Portrait"` (framing correction)
- `"Eve Park — Studio BG"` (background fill)
- `"Cleo — Landscape"` (square → landscape)

The response returns a new `avatar_item.id` (look_id). Use THIS look_id as `avatar_id` for the video generation call — it's already correctly framed.

### When to create a new look vs reuse existing

| Scenario | Action |
|---|---|
| First time correcting this avatar for this orientation | Create new look under group_id |
| Same avatar + same correction already exists as a look | Reuse the existing look_id (check `GET /v3/avatars/looks?group_id=<id>` by name) |
| Genuinely new person/character | Create new group (omit avatar_group_id) |

### AVATAR file update

If an `AVATAR-<NAME>.md` file exists in the workspace, append the new look to the Looks list:

```markdown
## HeyGen
- Avatar ID: <original_look_id>
- Group ID: <group_id>
- Voice ID: <voice_id>
- Voice Name: <name>
- Looks: default=<original_id>, landscape=<new_landscape_id>, portrait=<new_portrait_id>
- Last Synced: <ISO timestamp>
```

This lets future video requests skip Frame Check entirely when a pre-corrected look already exists for the target orientation.

### Fast-path: Skip correction if look already exists

Before building correction blocks, check if a pre-corrected look already exists:

1. Read `AVATAR-<NAME>.md` if it exists
2. Check Looks line for a variant matching the target orientation (e.g. `landscape=<id>`)
3. If found → swap `avatar_id` to the pre-corrected look_id, skip correction blocks entirely
4. If not found → proceed with normal correction flow + create look after

This eliminates redundant generative fill on repeated videos with the same avatar.

## Step 6: Log the correction

Add to learning log entry:
- `"aspect_correction"`: `"portrait_to_landscape"` | `"landscape_to_portrait"` | `"square_to_landscape"` | `"square_to_portrait"` | `"background_fill"` | `"both"` | `"none"`
- `"avatar_type"`: the raw value from the API
- `"avatar_visual_style"`: `"photorealistic"` | `"animated"` | `"3d_rendered"` | `"stylized"` | `"unknown"`
- `"look_created"`: `true` | `false` (was a new look created under the group?)
- `"look_reused"`: `true` | `false` (was a pre-existing corrected look found and reused?)
- `"group_id"`: the avatar group ID
