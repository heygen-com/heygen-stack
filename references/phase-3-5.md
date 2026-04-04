# Phase 3.5 — Aspect Ratio & Background Pre-Check

Runs automatically when `avatar_id` is set, before Phase 4. Also runs in Quick Shot mode when avatar_id is present.

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
2. Generative fill to extend the scene horizontally — add a HYPER PHOTO-REALISTIC
   environment. Think real photography: actual office spaces, real studios with
   visible equipment, genuine room interiors with natural imperfections.
   NOT CGI. NOT stock photo. NOT 3D-rendered. Real-world photographic quality.
3. Frame the presenter from chest up, centered in the landscape canvas
4. The background MUST look like a real photograph — correct lighting direction,
   natural shadows, depth-of-field blur on background elements, realistic scale.
   NOT a solid color, NOT transparent, NOT a gradient, NOT synthetic/CGI.
Do NOT use the original portrait image uncropped. Do NOT add black bars or
pillarboxing. Do NOT leave a transparent or missing background.
```

### B) Landscape avatar → Portrait video

```
FRAMING NOTE: The selected avatar image is in landscape orientation (16:9) but
this video is portrait (9:16). YOU MUST generate a new variant of the presenter
image before using it. Use AI Image tool to:
1. Generate a portrait (9:16) version of the presenter image
2. Generative fill to extend vertically — add HYPER PHOTO-REALISTIC environment
   above and below the presenter (real ceiling, real floor, room depth with
   natural imperfections). Think real photography, not CGI or stock imagery.
3. Focus on head and shoulders, presenter centered in portrait frame
4. The background MUST look like a real photograph — correct lighting,
   natural shadows, depth-of-field blur. NOT a solid color, NOT transparent,
   NOT a gradient, NOT synthetic/CGI.
Do NOT use the original landscape image uncropped. Do NOT add letterboxing.
Do NOT leave transparent or missing background areas.
```

### D) Square avatar → Landscape video

```
FRAMING NOTE: The selected avatar image is SQUARE (1:1) but this video is
landscape (16:9). HeyGen does not support square video output — without
correction, the video will have black bars on both sides. YOU MUST generate a
new variant of the avatar image before using it. Use AI Image tool to:
1. Generate a landscape (16:9) version of the presenter image
2. Generative fill to extend the scene horizontally — add a HYPER PHOTO-REALISTIC
   environment on both sides. Think real photography: actual office spaces, real
   studios with visible equipment, genuine room interiors with natural imperfections.
   NOT CGI. NOT stock photo. NOT 3D-rendered. Real-world photographic quality.
3. Frame the presenter centered in the landscape canvas
4. The background MUST look like a real photograph — correct lighting direction,
   natural shadows, depth-of-field blur on background elements, realistic scale.
   NOT a solid color, NOT transparent, NOT a gradient, NOT synthetic/CGI.
Do NOT use the original square image uncropped. Do NOT add black bars or
pillarboxing. Do NOT leave a transparent or missing background.
```

### E) Square avatar → Portrait video

```
FRAMING NOTE: The selected avatar image is SQUARE (1:1) but this video is
portrait (9:16). HeyGen does not support square video output — without
correction, the video will have black bars on top and bottom. YOU MUST generate
a new variant of the presenter image before using it. Use AI Image tool to:
1. Generate a portrait (9:16) version of the presenter image
2. Generative fill to extend vertically — add HYPER PHOTO-REALISTIC environment
   above and below the presenter (real ceiling, real floor, room depth with
   natural imperfections). Think real photography, not CGI or stock imagery.
3. Frame the presenter centered in the portrait canvas
4. The background MUST look like a real photograph — correct lighting,
   natural shadows, depth-of-field blur. NOT a solid color, NOT transparent,
   NOT a gradient, NOT synthetic/CGI.
Do NOT use the original square image uncropped. Do NOT add letterboxing.
Do NOT leave transparent or missing background areas.
```

### C) Missing background — studio_avatar only

**Only for `studio_avatar` with transparent/solid/empty background. NOT for photo_avatar** (Video Agent handles photo_avatar environments during generation).

```
BACKGROUND NOTE: The selected studio avatar has NO scene background (transparent
or solid color). YOU MUST generate a HYPER PHOTO-REALISTIC background environment
before using this avatar. Use AI Image tool to:
1. Generate a variant of the presenter image WITH a full background scene that
   looks like REAL PHOTOGRAPHY — not CGI, not 3D-rendered, not stock imagery
2. For business/tech content: place in a REAL modern studio (visible mic stands,
   actual monitors with content on screen, cable management, real desk surfaces),
   a real office (imperfect bookshelves, actual papers, natural desk clutter),
   or a real podcast set (acoustic panels, real lighting rigs, visible equipment)
3. For casual content: place in a REAL room (actual furniture with wear, real
   plants not perfect renders, natural window light with shadows, genuine
   café/kitchen details)
4. The presenter MUST look NATURAL in the environment:
   - Correct lighting direction matching the room's light source
   - Realistic scale (waist-up or chest-up framing)
   - Natural shadows on and from the presenter
   - Depth-of-field blur on background (shallow DOF, like a real camera)
5. Do NOT leave ANY transparent, solid-color, or gradient background
6. Do NOT make the presenter look oversized relative to the environment
7. The final image should be INDISTINGUISHABLE from a real photograph.
The result should look like the presenter was actually filmed in that location.
```

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

When Phase 3.5 fires a correction (framing or background), the Video Agent generates a corrected avatar image internally. To avoid polluting the account with orphan avatar groups, **save the corrected variant as a new look under the SAME avatar group** instead of creating a new group.

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

This lets future video requests skip Phase 3.5 entirely when a pre-corrected look already exists for the target orientation.

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
- `"look_created"`: `true` | `false` (was a new look created under the group?)
- `"look_reused"`: `true` | `false` (was a pre-existing corrected look found and reused?)
- `"group_id"`: the avatar group ID
