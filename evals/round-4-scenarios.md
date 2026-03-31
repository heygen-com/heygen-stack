# Round 4 Scenarios — Post-Revert Stability & End-to-End Confidence

Focus: Validate the skill after v3 migration, video_avatar ban revert, and three rounds of corrections. Test real-world prompts, session URL capture, interactive sessions, learning log usage, and mode detection. No more isolated unit tests — these are production-quality runs.

---

## S1: Full Producer — Custom photo_avatar + landscape (HAPPY PATH)
- **Prompt:** "I want a 45-second video explaining what MCP is and why developers should care"
- **Mode:** Full Producer (idea → finished video)
- **Avatar:** Eve's Podcast (05bf07b91de446a3b6e5d47c48214857)
- **Orientation:** landscape
- **Watch for:** Full Phase 1-5 flow. Phase 3.5 should trigger (photo_avatar + portrait→landscape mismatch). Session ID captured. Duration within 1.4x padding. Learning log entry written.
- **Pass:** Video generates, corrections injected, session URL in output.

## S2: Quick Shot — One-liner with no avatar preference
- **Prompt:** "Make a 20-second video: 3 reasons AI agents need video skills"
- **Mode:** Quick Shot (should auto-detect from one-liner)
- **Avatar:** Let the skill decide (should it pick one? ask? auto-select?)
- **Watch for:** Does SKILL.md guide you on what to do when user gives no avatar preference in Quick Shot mode? This tests the avatar_id best-practice path vs auto-select.
- **Pass:** Video generates. Document whether skill guided avatar selection or went straight to API.

## S3: Full Producer — studio_avatar + portrait (INSTAGRAM REEL)
- **Prompt:** "Create an Instagram Reel about how HeyGen's API compares to Runway's"
- **Mode:** Full Producer
- **Avatar:** Pick any stock studio_avatar (e.g. Daphne, Aditya)
- **Orientation:** portrait (Instagram Reel = 9:16)
- **Duration:** 30s
- **Watch for:** Skill should infer portrait from "Instagram Reel." Phase 3.5: studio_avatar with landscape→portrait mismatch → framing correction only, NO background note.
- **Pass:** Portrait video generates. Only framing correction injected (no background).

## S4: Full Producer — video_avatar test (POST-REVERT)
- **Prompt:** "Make a 30-second explainer about the state of AI video in 2026"
- **Mode:** Full Producer
- **Avatar:** Pick any stock video_avatar from GET /v3/avatars/looks?ownership=public&avatar_type=video_avatar
- **Orientation:** landscape
- **Watch for:** This is the key post-revert test. Does it work now? If it still fails with "Talking Photo not found," document the exact error and session URL. If HeyGen's fix is live, it should work.
- **Pass:** Either generates successfully OR fails with documented error + session URL.

## S5: Dry-run → Go (TWO-STEP FLOW)
- **Prompt:** "Make a 60-second video about why Sora failed and what it means for the AI video market"
- **Mode:** Full Producer with dry-run flag
- **Avatar:** Eve's Podcast (05bf07b91de446a3b6e5d47c48214857)
- **Orientation:** landscape
- **Step 1:** Run as dry-run. Verify the creative preview format (one-liner, scene labels, tone cues, logline, "say go" CTA).
- **Step 2:** Say "go" to generate the actual video.
- **Watch for:** Does the dry-run preview show which corrections will be injected? Does "go" actually trigger generation with the same prompt? Is the transition smooth?
- **Pass:** Dry-run preview matches spec format. "Go" generates video. Session URL captured.

## S6: Voice-over only (NO AVATAR)
- **Prompt:** "Create a 30-second voice-over narration about 5 things I learned building AI video skills. No avatar, just voice."
- **Mode:** Full Producer
- **Avatar:** None (voice-over only)
- **Orientation:** landscape
- **Watch for:** Phase 3.5 should be SKIPPED entirely (no avatar_id). Prompt should say "Voice-over narration only." No corrections injected. Voice discovery should still happen.
- **Pass:** Video generates with no avatar. Phase 3.5 skipped. No correction blocks in prompt.

## S7: Enhanced Prompt — User provides their own script
- **Prompt:** "Generate this as a HeyGen video with Eve's Podcast avatar: [INTRO] Hey developers, let me tell you about something that's going to change how you build. [MAIN] MCP servers are everywhere now. 97 million SDK downloads. But here's the thing — 73% of them are invisible to agents. Your tool descriptions matter more than your tool code. [CLOSE] Start with ATO. Agent Tool Optimization. Make your tools findable. Ship it."
- **Mode:** Enhanced Prompt (user already has script)
- **Avatar:** Eve's Podcast (05bf07b91de446a3b6e5d47c48214857)
- **Watch for:** Skill should start at Phase 3 (skip discovery interview). Should it rewrite the script or use it verbatim? Duration should be estimated from word count (150wpm). Phase 3.5 should still run.
- **Pass:** Video generates using the provided script. Duration estimate reasonable. Corrections injected.

## S8: Multi-asset — PDF + reference URL
- **Prompt:** "Make a 90-second video walkthrough of HeyGen's v3 API. Use this as reference."
- **Assets:** 
  - URL: https://developers.heygen.com/docs/quick-start
  - PDF: https://arxiv.org/pdf/2310.06825 (any small public PDF)
- **Avatar:** Pick any stock studio_avatar
- **Orientation:** landscape
- **Duration:** 90s
- **Watch for:** File upload flow (POST /v3/assets for PDF, URL reference in prompt). Does the skill correctly handle both asset types? Does the prompt reference them? Duration padding at 1.3x for 90s.
- **Pass:** Video generates with assets referenced. Both files passed to API correctly.

## S9: Interactive Session (MULTI-TURN)
- **Prompt:** "I want to brainstorm a video with the Video Agent. Topic: why every SaaS company needs an AI avatar spokesperson."
- **Mode:** Interactive Session (multi-turn)
- **Avatar:** Pick any stock studio_avatar
- **Watch for:** Does the skill use POST /v3/video-agents/sessions to create an interactive session? Does it guide the user through multi-turn refinement? Is the session URL provided for continued interaction?
- **Pass:** Interactive session created. At least 2 turns of refinement documented. Final video generated from session.

## S10: Learning Log Validation (META-TEST)
- **Prompt:** "Make a 30-second video about the future of agent skills"
- **Mode:** Full Producer
- **Avatar:** Eve's Podcast
- **Before running:** Check if heygen-video-producer-log.jsonl exists. Read last 5 entries if it does. Note any patterns the skill should have learned.
- **After running:** Verify a new entry was appended to the log with all required fields (video_id, session_id, duration_target, duration_actual, duration_ratio, padding_multiplier, avatar_id, avatar_type, corrections_applied, mode).
- **Watch for:** Does the skill actually read the log before starting? Does it adjust behavior based on past patterns? Is the log entry complete?
- **Pass:** Log entry written with all fields. Skill referenced log patterns (if any existed).

---

## Round 4 Scoring Focus

For each scenario, the eval runner MUST document:
1. **Session URL** — captured from POST response (MANDATORY for every non-dry-run scenario)
2. **Mode detection** — was the correct mode (Full Producer / Quick Shot / Enhanced Prompt) selected?
3. **Phase 3.5 behavior** — was it triggered when expected? skipped when expected? corrections correct?
4. **Learning log** — was it read before? written after?
5. **Duration accuracy** — actual vs target vs padded estimate

### Pass Criteria
- S1: Full happy path, corrections injected, session URL → PASS
- S2: Quick Shot mode detected, avatar handling documented → PASS  
- S3: Portrait inferred, framing-only correction → PASS
- S4: video_avatar works OR failure documented with session URL → PASS
- S5: Dry-run format correct, "go" triggers generation → PASS
- S6: Phase 3.5 skipped, voice-over generated → PASS
- S7: Enhanced Prompt mode, starts at Phase 3 → PASS
- S8: Both assets uploaded/referenced correctly → PASS
- S9: Interactive session created with multi-turn → PASS
- S10: Learning log read + written with all fields → PASS
