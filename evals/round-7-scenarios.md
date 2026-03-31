# Round 7 — Avatar Description Conflict Fix + Generative Fill Retest

**Theme:** Validate that avatar_id takes priority when prompt does NOT describe avatar appearance. Retest generative fill quality.
**Date:** 2026-03-31
**Fixes tested:** PR #14 (avatar_id vs prompt description conflict)

## Key Rule Under Test

When `avatar_id` is set, the prompt must NOT describe the avatar's appearance. Only delivery style + background/environment notes. The prompt should say "The selected presenter" instead of describing hair, clothing, gender, etc.

## Scenarios

### Fix validation: avatar_id honored when prompt has no appearance description

**S1 — Photo avatar + landscape, no appearance in prompt**
- Prompt: "Create a 45-second landscape video about remote work trends. Use my custom avatar Eve."
- Avatar: Eve's photo_avatar (discover via API, pass avatar_id)
- Target: 45s landscape
- **What to verify:** Prompt says "The selected presenter explains..." NOT "A young woman with..." Avatar_id honored. Eve appears in final video.

**S2 — Studio avatar + landscape, no appearance in prompt**
- Prompt: "Make a 40-second landscape video about AI productivity tools."
- Avatar: Pick a studio_avatar (e.g., Bryce). Discover via API, pass avatar_id.
- Target: 40s landscape
- **What to verify:** Prompt uses "The selected presenter" not Bryce's physical description. Bryce appears in final video.

**S3 — Studio avatar + portrait, no appearance in prompt**
- Prompt: "Create a 35-second portrait TikTok about 3 AI tools every developer should try."
- Avatar: Pick a different studio_avatar (e.g., Daphne). Pass avatar_id.
- Target: 35s portrait
- **What to verify:** Same rule. Daphne appears. Phase 3.5 corrections fire if needed. No appearance description in prompt.

**S4 — Photo avatar + portrait, background note only**
- Prompt: "Make a 50-second portrait video about startup fundraising tips. Use my avatar Eve. I want a modern coworking space background."
- Avatar: Eve's photo_avatar
- Target: 50s portrait
- **What to verify:** Prompt includes background/environment note ("modern coworking space") but NOT Eve's appearance. Phase 3.5 correction A fires (portrait→landscape reframe). Background note is respected.

### Generative fill retest (P0 from Round 5)

**S5 — Studio avatar with transparent bg + landscape (generative fill)**
- Prompt: "Make a 30-second landscape video about the future of AI agents."
- Avatar: Pick a studio_avatar whose preview has transparent/solid background (check preview image)
- Target: 30s landscape
- **What to verify:** Phase 3.5 correction C fires. Background fill uses "AI Image tool" trigger. Result is NOT a giant avatar on a terrible backdrop. Avatar looks naturally placed.

**S6 — Photo avatar + landscape, explicit background request**
- Prompt: "Create a 40-second landscape video about ocean conservation. Use my avatar Eve. Background should be a coastal cliff overlooking the ocean."
- Avatar: Eve's photo_avatar
- Target: 40s landscape
- **What to verify:** Background note in prompt (NOT avatar appearance). Correction C fires if needed. Environment matches request.

### Mixed scenarios (regression check)

**S7 — Voice-over only (no avatar_id, appearance description allowed)**
- Prompt: "Create a 45-second voice-over video about the history of artificial intelligence. No presenter on screen."
- Avatar: none (voice-over)
- Target: 45s landscape
- **What to verify:** No avatar_id sent. Prompt says "Voice-over narration only." Duration accuracy within range.

**S8 — Quick Shot with avatar specified**
- Prompt: "Quick 30-second video about why every app needs AI video. Use Bryce as presenter."
- Avatar: Bryce studio_avatar (discover and pass avatar_id)
- Target: 30s landscape
- **What to verify:** Quick Shot mode activated. Avatar discovered and avatar_id passed. Prompt does NOT describe Bryce's appearance. Bryce appears.

**S9 — Enhanced Prompt mode (user provides full prompt)**
- Prompt: "Generate this: The selected presenter walks developers through three steps to integrate AI video into their app. Step 1: Get an API key. Step 2: Call the Video Agent endpoint. Step 3: Poll for completion. 50 seconds, landscape, professional tone."
- Avatar: Pick any studio_avatar, pass avatar_id
- Target: 50s landscape
- **What to verify:** Enhanced Prompt mode. The user's prompt already follows the rule (no appearance description). Skill preserves user prompt, adds avatar_id. Avatar matches.

**S10 — Dry-run mode (verify pitch format)**
- Prompt: "Create a 60-second landscape video about HeyGen's Video Agent API. Use a stock presenter. Dry run please."
- Avatar: Pick any studio_avatar
- Target: 60s landscape (dry-run, no API call)
- **What to verify:** Dry-run pitch shows avatar NAME (e.g., "Bryce") but NOT appearance description. Pitch format matches updated template. No API call made.

## Scoring

For each scenario, evaluate:
1. **Fix validated?** (Yes/No) — Was avatar_id honored? Was appearance absent from prompt?
2. **Video quality** (1-10)
3. **Duration accuracy** (actual/target %)
4. **Correct avatar appeared?** (Yes/No/N/A)
5. **Background quality** (for S4-S6: natural/terrible/N/A)
6. **Session URL captured?** (Yes/No)

## Expected outcomes
- S1-S4: Avatar_id honored, correct avatar appears, no appearance in prompt
- S5-S6: Generative fill produces natural backgrounds (not "giant in room")
- S7: Voice-over works, no avatar confusion
- S8: Quick Shot + explicit avatar works
- S9: Enhanced Prompt preserves user text
- S10: Dry-run pitch format correct

## Database Output
Write results directly to the Eval Tracker database (data_source_id: 17f54098-a085-4234-83ce-55c280266d73). Use text values for all number fields (Round, Target, Actual, Duration %, Adam Score). Set Ken Verdict to "—" for all rows.
