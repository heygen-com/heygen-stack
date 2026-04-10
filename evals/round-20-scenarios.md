# Round 20 Scenarios — Look-First Architecture Validation

**Focus:** Validate that Phase 3.5 corrections save corrected variants as new looks under the existing avatar group (NOT as new groups). Test look reuse, AVATAR file updates, and the group→look relationship across multiple avatars and orientations.

**No dry runs this round.** All 10 scenarios generate real videos.

**Pre-baked context (warm eval):**

| Avatar | avatar_id | group_id | Type | Dimensions | Voice |
|---|---|---|---|---|---|
| Eve | `5b776dccd2b845679edc676b37e74bcb` | `ea01a5ca3a05499395113463188983d1` | photo_avatar | 768×1376 (portrait) | `XQ1UylZdsMSfWFJOFzcz` (Eve Park - Real Voice) |
| Ken | `49540b1f4733417c999fa974999c8dc4` | _(fetch from API)_ | prompt_avatar | _(fetch from API)_ | Mark |
| Cleo | `636c7609d11546b999c93ee343fde086` | _(fetch from API)_ | photo_avatar | 2048×2048 (square) | `TmvdH7pic9RpWJ1hUe0Q` |
| Adam | `24f4a61e49ad49c0abc89abb68b85080` | _(fetch from API)_ | prompt_avatar | _(fetch from API)_ | Archer |

**Critical validation per scenario:**
1. When Phase 3.5 fires a correction, the corrected variant MUST be saved as a new look under the same `group_id`
2. The `POST /v3/avatars` call MUST include `avatar_group_id`
3. The new look_id MUST be used as `avatar_id` in the video generation call
4. If an AVATAR file exists, the Looks line MUST be updated with the new variant
5. If a pre-corrected look already exists for this avatar+orientation combo, it MUST be reused (no duplicate creation)

---

## S1: Portrait Avatar → Landscape Video (Look Creation)
**Prompt:** "Create a 30-second product demo for a new AI writing assistant called DraftPilot. Use Eve's avatar. Landscape for YouTube. Professional but approachable tone."
**Test:** Eve is portrait (768×1376). Landscape video triggers Phase 3.5 Correction A. The corrected landscape variant must be saved as a new look under Eve's group (`ea01a5ca3a05499395113463188983d1`), named something like "Eve Park — Landscape". The NEW look_id should be used for the video.
**Target:** 30s
**Expected:** Phase 3.5 fires, Correction A, new look created under Eve's group_id, new look_id used in video payload.

## S2: Square Avatar → Landscape Video (Look Creation)
**Prompt:** "Make a 30-second explainer about sustainable packaging for an eco-brand. Use the Cleo avatar. Landscape orientation. Calm, informative tone with stock footage of nature."
**Test:** Cleo is square (2048×2048). Landscape triggers Correction D. Corrected variant saved as look under Cleo's group.
**Target:** 30s
**Expected:** Phase 3.5 fires, Correction D, new look created under Cleo's group_id.

## S3: Square Avatar → Portrait Video (Look Creation)
**Prompt:** "Create a 20-second Instagram Reel about morning smoothie recipes. Use the Cleo avatar. Portrait. Fun, energetic, use motion graphics for ingredient lists."
**Test:** Cleo square → portrait triggers Correction E. Different orientation than S2, so this should create a SECOND look under Cleo's group (portrait variant).
**Target:** 20s
**Expected:** Phase 3.5 fires, Correction E, new look created under Cleo's group (separate from S2's landscape look).

## S4: Portrait Avatar → Portrait Video (No Correction Needed)
**Prompt:** "Create a 45-second tech tutorial about setting up a Python virtual environment. Use Eve's avatar. Portrait for TikTok. Clear, step-by-step, use motion graphics for code snippets."
**Test:** Eve is portrait, video is portrait. No orientation mismatch. Phase 3.5 should check and determine NO correction needed. No new look should be created.
**Target:** 45s
**Expected:** Phase 3.5 runs but does NOT fire corrections. Original avatar_id used directly. No look created.

## S5: Prompt Avatar → Landscape Video (Check Prompt Avatar Behavior)
**Prompt:** "Make a 30-second company announcement about a new hire joining the team. Use Ken's avatar. Landscape. Warm, welcoming tone."
**Test:** Ken is a prompt-created avatar. Check how Phase 3.5 handles prompt avatars — they may report differently than photo avatars. Verify group_id is fetched and look-first still applies if correction is needed.
**Target:** 30s
**Expected:** Phase 3.5 fetches Ken's metadata, determines if correction needed based on dimensions, applies look-first pattern if so.

## S6: Prompt Avatar → Portrait Video
**Prompt:** "Create a 25-second motivational TikTok about building habits. Use Adam's avatar. Portrait format. Energetic, inspiring, use AI-generated visuals for abstract concepts."
**Test:** Adam is prompt-created. Portrait video. Test look-first with a different prompt avatar.
**Target:** 25s
**Expected:** Phase 3.5 checks dimensions, applies correction if needed, saves as look under Adam's group.

## S7: Look Reuse — Same Avatar, Same Orientation as S1
**Prompt:** "Create a 30-second tutorial about keyboard shortcuts for DraftPilot. Use Eve's avatar. Landscape for YouTube. Same style as the product demo."
**Test:** Eve + landscape again. If S1 already created a landscape look for Eve, this scenario MUST reuse that look_id instead of creating another one. This validates the fast-path: check AVATAR file → find landscape look → skip correction.
**Target:** 30s
**Expected:** Finds pre-existing landscape look from S1, skips Phase 3.5 correction entirely, uses cached look_id directly. No new look created.

## S8: Look Reuse — Square Avatar Reuse from S2
**Prompt:** "Make a 30-second update video about GreenThumb app's new features. Use Cleo. Landscape. Upbeat with motion graphics."
**Test:** Cleo + landscape again. Should reuse the landscape look created in S2.
**Target:** 30s
**Expected:** Finds pre-existing landscape look for Cleo from S2, skips correction, reuses look_id. No new look created.

## S9: Style ID + Look Creation Combined
**Prompt:** "Create a 40-second cinematic brand story about a coffee roastery. Use Eve's avatar. Browse styles and pick something cinematic. Portrait for Instagram."
**Test:** Eve portrait avatar in portrait video = no framing correction. BUT tests that style_id selection works alongside look-first logic. Phase 3.5 should still run, determine no correction needed, and style_id should be in the payload.
**Target:** 40s
**Expected:** Phase 3.5 runs, no correction needed, style_id selected and passed, original avatar_id used.

## S10: Quick Shot + Look-First
**Prompt:** "Just generate a quick 15-second video with Cleo talking about weekend gardening. Portrait format."
**Test:** Quick Shot mode with Cleo (square). Phase 3.5 MUST still fire in Quick Shot. Portrait correction look should be reused from S3 if it exists.
**Target:** 15s
**Expected:** Quick Shot flow, Phase 3.5 fires, reuses existing portrait look from S3 (or creates one if S3 hasn't run yet). avatar_id in payload.
