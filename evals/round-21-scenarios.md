# Round 21 Scenarios — Style-Adaptive Phase 3.5 Validation

**Focus:** Validate that Phase 3.5 correction blocks detect the avatar's visual style and generate style-matched backgrounds (not hardcoded photorealistic). Test across photo, animated/prompt, and square avatars with orientation mismatches.

**Key change being tested (PR #28):** Step 2.5 — Avatar Visual Style Detection. Correction blocks now use `{FILL_DIRECTIVE}` populated from detected style instead of hardcoded "HYPER PHOTO-REALISTIC."

**Pre-baked context (warm eval):**

| Avatar | avatar_id | group_id | Type | Dimensions | Visual Style | Voice |
|---|---|---|---|---|---|---|
| Eve | `5b776dccd2b845679edc676b37e74bcb` | `ea01a5ca3a05499395113463188983d1` | photo_avatar | 768×1376 (portrait) | Photorealistic | `XQ1UylZdsMSfWFJOFzcz` (Eve Park - Real Voice) |
| Cleo | `636c7609d11546b999c93ee343fde086` | _(fetch)_ | photo_avatar | 2048×2048 (square) | Animated/Illustrated | `TmvdH7pic9RpWJ1hUe0Q` |
| Ken | `49540b1f4733417c999fa974999c8dc4` | _(fetch)_ | prompt_avatar | _(fetch)_ | Prompt-generated (classify at runtime) | Mark |
| Adam | `24f4a61e49ad49c0abc89abb68b85080` | _(fetch)_ | prompt_avatar | _(fetch)_ | Prompt-generated (classify at runtime) | Archer |

**Critical validation per scenario:**
1. Phase 3.5 MUST classify the avatar's visual style BEFORE building correction blocks
2. The fill directive in the correction block MUST match the detected style
3. Animated/illustrated avatars MUST NOT get "HYPER PHOTO-REALISTIC" in their correction
4. Photorealistic avatars SHOULD still get photorealistic fill directives
5. Log entry MUST include `avatar_visual_style` field

---

## S1: Animated Avatar → Landscape (THE BUG SCENARIO)
**Prompt:** "Create a 30-second explainer about how AI assistants help with scheduling. Use Cleo's avatar (636c7609d11546b999c93ee343fde086). Landscape for YouTube. Friendly, upbeat tone."
**Test:** Cleo is square (2048×2048) and animated/illustrated style. Landscape video triggers Correction D (square→landscape). The fill directive MUST reference matching the avatar's illustrated style, NOT photorealistic. This is the exact bug Ken caught.
**Target:** 30s
**Expected:** Phase 3.5 fires, classifies Cleo as "animated/illustrated", Correction D uses illustrated fill directive, new look created under Cleo's group.

## S2: Photo Avatar → Landscape (Control — Should Still Be Photorealistic)
**Prompt:** "Create a 30-second product announcement for a code review tool called ReviewBot. Use Eve's avatar (5b776dccd2b845679edc676b37e74bcb). Landscape for LinkedIn. Professional tone."
**Test:** Eve is portrait (768×1376) and photorealistic. Landscape video triggers Correction A (portrait→landscape). The fill directive SHOULD be photorealistic because Eve is a real photo.
**Target:** 30s
**Expected:** Phase 3.5 fires, classifies Eve as "photorealistic", Correction A uses photorealistic fill directive.

## S3: Prompt Avatar → Portrait (Style Classification Test)
**Prompt:** "Create a 45-second tutorial overview on setting up MCP servers for beginners. Use Adam's avatar (24f4a61e49ad49c0abc89abb68b85080). Portrait for TikTok. Casual, encouraging tone."
**Test:** Adam is a prompt-generated avatar. Agent must examine the preview image and classify the visual style. If Adam looks photorealistic → photorealistic fill. If stylized → matching style. The key test is that classification HAPPENS.
**Target:** 45s
**Expected:** Phase 3.5 fetches Adam's preview, classifies visual style, builds correction with matching fill directive. Log includes `avatar_visual_style`.

## S4: Animated Avatar → Portrait (Cleo Opposite Direction)
**Prompt:** "Create a 20-second Instagram Reel teaser for a new AI pet care app called PawPal. Use Cleo's avatar (636c7609d11546b999c93ee343fde086). Portrait. Fun, playful energy."
**Test:** Cleo square→portrait (Correction E). Same avatar as S1 but opposite orientation. Fill directive must still match Cleo's animated style.
**Target:** 20s
**Expected:** Phase 3.5 fires, Correction E with animated fill directive.

## S5: No Avatar — Quick Shot (No Phase 3.5)
**Prompt:** "Quick shot: 15-second motivational clip about shipping code fast. No specific avatar. Landscape."
**Test:** No avatar_id → Phase 3.5 should NOT fire. Control scenario to ensure style detection doesn't break the no-avatar path.
**Target:** 15s
**Expected:** Phase 3.5 does NOT fire. No style classification. Clean Quick Shot generation.

## S6: Prompt Avatar with style_id (Ken + Cinematic Style)
**Prompt:** "Create a 40-second announcement video for a new developer API launch. Use Ken's avatar (49540b1f4733417c999fa974999c8dc4). Landscape. Use a cinematic style from the API (browse available styles, pick one tagged 'cinematic'). Executive tone, confident."
**Test:** Ken is prompt-generated. Tests both style_id browsing AND Phase 3.5 style detection working together. The fill directive should match Ken's visual style, and the style_id should be passed to the API.
**Target:** 40s
**Expected:** Phase 3.5 classifies Ken's visual style, applies correction if needed, PLUS style_id in payload.

## S7: Photo Avatar — Matched Orientation (No Correction Needed)
**Prompt:** "Create a 25-second quick tip about writing better commit messages. Use Eve's avatar (5b776dccd2b845679edc676b37e74bcb). Portrait for Shorts. Casual, conversational."
**Test:** Eve is portrait (768×1376), video is portrait. Orientation MATCHES. Phase 3.5 should fire (avatar_id is set) but determine NO correction needed.
**Target:** 25s
**Expected:** Phase 3.5 fires, checks orientation, finds match → no correction blocks appended. Style detection may still run but no fill directive used.

## S8: Animated Avatar → Landscape with Assets (Style + Asset Routing)
**Prompt:** "Create a 45-second walkthrough of this landing page. Use Cleo's avatar (636c7609d11546b999c93ee343fde086). Landscape. Professional but friendly. Here's the page to reference: https://developers.heygen.com"
**Test:** Combines Cleo's animated style detection with asset routing (URL → contextualize, since it's HTML). Both systems must work together. Fill directive must be animated-style despite having web content to incorporate.
**Target:** 45s
**Expected:** Phase 3.5 classifies Cleo animated, Correction D with illustrated fill. Asset routing: URL contextualized (HTML, not attachable). Both logged correctly.

## S9: Eve Landscape Look Reuse (Fast-Path Test)
**Prompt:** "Create a 35-second overview of the benefits of AI-powered video creation for marketing teams. Use Eve's avatar (5b776dccd2b845679edc676b37e74bcb). Landscape for YouTube. Enthusiastic, marketing-friendly tone."
**Test:** If S2 already created a landscape look for Eve under her group, this scenario SHOULD detect the existing look and reuse it (fast-path skip). If S2's look creation failed or wasn't persisted, this will create a new one.
**Target:** 35s
**Expected:** Phase 3.5 checks for existing landscape look → reuses if found (look_reused: true) OR creates new if not.

## S10: Dry Run — Style Detection Report
**Prompt:** "Dry run: Create a 60-second deep dive on agentic AI workflows. Use Adam's avatar (24f4a61e49ad49c0abc89abb68b85080). Landscape. Technical, detailed."
**Test:** Dry run exercises the full pipeline including Phase 3.5 style detection WITHOUT calling the API. The creative preview should mention what style was detected and what correction would be applied.
**Target:** 60s (dry run — no actual video)
**Expected:** Full pipeline through Phase 3.5, style detection reported in preview, no API call made.
