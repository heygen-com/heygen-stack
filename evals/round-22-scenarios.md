# Round 22 Scenarios — Wrapper Script + Fresh Install Validation

**Focus:** Validate that a fresh-install agent (no prior context) follows SKILL.md correctly, uses the submit-video.sh wrapper for all submissions, and the wrapper correctly handles dimension detection and framing notes.

**Key changes being tested:**
1. `submit-video.sh` wrapper mandated in SKILL.md Generate phase
2. Fresh install path (clone → read SKILL.md → execute)
3. Wrapper dimension detection across avatar types

**Pre-requisite:** Agent must delete existing skill and clone fresh from GitHub before starting.

---

## S1: Square Avatar → Landscape (Core Wrapper Test)
**Prompt:** "Create a 30-second explainer about why developer documentation matters. Use avatar 636c7609d11546b999c93ee343fde086. Landscape orientation. Clear, friendly tone."
**Watch for:** Wrapper detects 2048×2048 square → landscape mismatch. FRAMING NOTE appended. `framing_applied: square_to_landscape`.
**Target:** 30s

## S2: Portrait Avatar → Landscape (Orientation Swap)
**Prompt:** "Create a 25-second product teaser for an AI writing assistant called DraftPilot. Use avatar 5b776dccd2b845679edc676b37e74bcb. Landscape for LinkedIn. Professional tone."
**Watch for:** Wrapper detects 768×1376 portrait → landscape mismatch. `framing_applied: portrait_to_landscape`.
**Target:** 25s

## S3: Matched Orientation — No Correction
**Prompt:** "Create a 20-second Instagram Story tip about keyboard shortcuts that save time. Use avatar 5b776dccd2b845679edc676b37e74bcb. Portrait orientation. Quick, energetic."
**Watch for:** Eve is portrait, video is portrait. Wrapper confirms match. `framing_applied: none`.
**Target:** 20s

## S4: No Avatar — Quick Shot
**Prompt:** "Quick shot: 15-second hype clip about shipping features fast. No specific avatar needed. Landscape orientation. High energy."
**Watch for:** No avatar_id in payload. Wrapper skips dimension check entirely. `framing_applied: none`.
**Target:** 15s

## S5: Square Avatar → Portrait
**Prompt:** "Create a 35-second TikTok tutorial on setting up your first AI agent. Use avatar 636c7609d11546b999c93ee343fde086. Portrait for TikTok. Casual, step-by-step."
**Watch for:** Cleo square → portrait. `framing_applied: square_to_portrait`.
**Target:** 35s

## S6: Portrait → Landscape with Style Browsing
**Prompt:** "Create a 40-second announcement for a new API feature launch. Use avatar 5b776dccd2b845679edc676b37e74bcb. Landscape. Browse available HeyGen styles and pick something cinematic. Confident, executive tone."
**Watch for:** `framing_applied: portrait_to_landscape` AND `style_id` present in payload.
**Target:** 40s

## S7: Prompt Avatar Dimension Check
**Prompt:** "Create a 30-second overview of MCP servers for beginners. Use avatar 24f4a61e49ad49c0abc89abb68b85080. Landscape. Casual, encouraging."
**Watch for:** Adam is a prompt-generated avatar. Wrapper must fetch dimensions and classify orientation. Check what dimensions the API returns (may be 0×0 if async processing).
**Target:** 30s

## S8: Square Avatar → Landscape with URL Asset
**Prompt:** "Create a 45-second walkthrough of the HeyGen developer docs. Use avatar 636c7609d11546b999c93ee343fde086. Landscape. Reference this page: https://developers.heygen.com. Professional but friendly."
**Watch for:** Wrapper handles framing (`square_to_landscape`) AND agent routes the URL asset correctly.
**Target:** 45s

## S9: Landscape Avatar → Landscape (Eve Landscape Look)
**Prompt:** "Create a 25-second quick tip about writing better code reviews. Use avatar b58f6992930c40dc91498a7bc9bf1e01. Landscape. Conversational, dev-friendly."
**Watch for:** Eve's landscape look (1792×1024) → landscape video. Perfect match. `framing_applied: none`.
**Target:** 25s

## S10: Long-Form Test (60s)
**Prompt:** "Create a 60-second deep dive on why AI agents need persistent identity across videos. Use avatar 5b776dccd2b845679edc676b37e74bcb. Landscape for YouTube. Thoughtful, detailed, technical but accessible."
**Watch for:** Duration accuracy on longer content. Portrait → landscape correction. `framing_applied: portrait_to_landscape`.
**Target:** 60s
