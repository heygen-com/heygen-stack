# Round 6 — Targeted Fix Validation

**Theme:** Validate all 7 fixes from PR #13 (Ken's R4+R5 feedback)
**Date:** 2026-03-31
**Branch:** main (post-merge of fix/r4-r5-feedback)

## Scenarios

### Fix 1: Phase 3.5 prescriptive correction prompts

**S1 — Portrait photo_avatar → Landscape video (corrections A + C)**
- Prompt: "Create a 45-second landscape video about the rise of remote work. Use my custom avatar Eve (photo_avatar, portrait orientation). Professional tone."
- Avatar: Eve's photo avatar (photo_avatar type, portrait)
- Target: 45s landscape
- **What to verify:** Both framing (A) AND background (C) corrections fire. Background is a real environment (not solid/transparent/gradient). Avatar is NOT oversized ("giant in room" check). Presenter looks naturally placed.

**S2 — Studio avatar with transparent background → Landscape video (correction C)**
- Prompt: "Make a 30-second landscape explainer about AI video pricing. Use a stock studio avatar."
- Avatar: Pick a studio_avatar whose preview shows transparent/no background
- Target: 30s landscape
- **What to verify:** Skill detects missing background from preview image. Correction C fires even though it's a studio_avatar. Generated background is realistic.

**S3 — Landscape avatar → Portrait video (correction B)**
- Prompt: "Create a 40-second portrait (9:16) TikTok-style video about 3 tips for better presentations. Use a stock studio avatar."
- Avatar: Pick a studio_avatar with landscape orientation and real background
- Target: 40s portrait
- **What to verify:** Correction B fires. Vertical extension looks natural. No letterboxing.

### Fix 2: Asset classification — download→upload→asset_id as default

**S4 — Public PDF URL (should download→upload→asset_id)**
- Prompt: "Make a 60-second video summarizing this research paper: https://arxiv.org/pdf/2503.01295 — focus on the key findings."
- Target: 60s landscape
- **What to verify:** Skill downloads the PDF, uploads via /v3/assets, passes asset_id (NOT files[] URL). Content is accurately summarized.

**S5 — HTML URL (should NOT go in files[], Path A only)**
- Prompt: "Create a 45-second video about this article: https://techcrunch.com/2026/03/30/ai-video-market-heats-up/ — cover the main points."
- Target: 45s landscape
- **What to verify:** Skill uses web_fetch to contextualize. Does NOT pass HTML URL in files[]. Script reflects actual article content (or tells user if inaccessible).

### Fix 3: Auth-walled / inaccessible content — no fabrication

**S6 — Inaccessible Notion URL (should STOP and ask user)**
- Prompt: "Make a 30-second video based on this doc: https://www.notion.so/fake-page-that-doesnt-exist-abc123def456 — summarize the key strategy points."
- Target: 30s landscape
- **What to verify:** Skill attempts to fetch, fails, then STOPS and tells user it can't access the content. Does NOT fabricate. Asks user to share content directly.

**S7 — 404 URL (should notify user, not silently infer)**
- Prompt: "Create a 45-second video about this blog post: https://example.com/blog/this-post-does-not-exist-2026 — make it engaging."
- Target: 45s landscape
- **What to verify:** Skill detects 404/empty response. Notifies user explicitly. Offers to proceed with general knowledge OR asks for content. Does not silently fabricate.

### Fix 4: Quick Shot avatar exception

**S8 — Quick Shot with no avatar specified**
- Prompt: "Just generate a 30-second video about why startups should use AI video. Don't ask questions."
- Target: 30s landscape
- **What to verify:** Skill enters Quick Shot mode. Does NOT ask about avatar (exception to never-auto-select). Proceeds directly to generation. Video completes.

### Fix 5: Interactive sessions — experimental warning

**S9 — Interactive session request (should show warning)**
- Prompt: "Let's do an interactive session — I want to iterate on a product demo video."
- Target: N/A (just testing the warning)
- **What to verify:** Skill shows experimental/known-issues warning before proceeding. Mentions one-shot as recommended alternative. Still allows user to proceed if they want.

### Fix 6: Stuck-pending detection

**S10 — Normal generation with pending monitoring**
- Prompt: "Create a 50-second landscape video about the future of AI agents in enterprise. Use a stock studio avatar with a real background."
- Avatar: Pick a studio_avatar with visible background
- Target: 50s landscape
- **What to verify:** Skill reports session URL AND video URL immediately. If pending >10min, flags to user. Normal polling cadence followed.

## Scoring

For each scenario, evaluate:
1. **Fix validated?** (Yes/No) — Did the specific fix work as intended?
2. **Video quality** (if applicable, 1-10)
3. **Duration accuracy** (actual/target %)
4. **Session URL captured?** (Yes/No)
5. **Any regressions?** — Did the fix break something else?

## Expected outcomes
- S1-S3: Correction prompts should fire with prescriptive language. Backgrounds should be realistic environments.
- S4-S5: Asset routing should follow new defaults. No HTML in files[].
- S6-S7: Agent should STOP and communicate, not fabricate.
- S8: Quick Shot should skip avatar selection entirely.
- S9: Warning should appear.
- S10: Session URL tracking + pending detection should work.
