# Round 17 — Video Use Case Diversity

Focus: 10 diverse video use cases testing the breadth of video-producer's workflow. No avatar creation. Tests Full Producer, Enhanced Prompt, Quick Shot, and style_id paths across real-world scenarios.

Eve Park avatar: `5b776dccd2b845679edc676b37e74bcb` (photo_avatar, portrait 768×1376)

---

## S1: Product Launch Announcement (Full Producer, landscape, style_id)
**Prompt to agent:** "Make a 45-second video announcing the launch of a new AI coding assistant called 'Flux'. It autocompletes entire functions, understands your codebase, and costs $20/month. Target audience: developers on Twitter/X. Make it punchy and exciting."
**Expected:** Full Producer flow. Agent asks clarifying Qs, picks a cinematic or retro-tech style via browsing, assembles script with Hook → What → Why → CTA. Landscape orientation for Twitter. No avatar (voice-over only). ~45s target.
**Fix Tested:** Style browsing + voice-over (no avatar_id) + product launch structure.

## S2: Tutorial / How-To (Full Producer, landscape, Eve avatar)
**Prompt to agent:** "Create a 60-second tutorial video showing how to connect a HeyGen avatar to an AI agent using the API. Use Eve Park as the presenter. Keep it developer-friendly but not dry."
**Expected:** Full Producer. Uses Eve avatar_id. Landscape. Agent should NOT describe Eve's appearance in prompt (avatar_id conflict rule). Script follows Tutorial structure: What we'll build → Steps → Recap. Phase 3.5 fires (portrait avatar → landscape video). ~60s target.
**Fix Tested:** avatar_id + appearance conflict rule, Phase 3.5 portrait→landscape correction, tutorial structure.

## S3: Sales Pitch (Full Producer, landscape, no avatar)
**Prompt to agent:** "I need a 30-second sales video for a SaaS product called 'ShipFast' — a boilerplate for launching Next.js apps in a weekend. Pain point: developers waste weeks on auth, payments, emails. ShipFast handles all of it for $199 one-time. Target: indie hackers."
**Expected:** Full Producer. Pain → Vision → Product → CTA structure. Voice-over only (no avatar). Landscape. Motion graphics for features, stock for developer scenes. ~30s target.
**Fix Tested:** Sales pitch structure, media type guidance in prompt, no-avatar path.

## S4: Social Media Short (Quick Shot, portrait)
**Prompt to agent:** "Quick video, 15 seconds, portrait for TikTok. Topic: '3 signs your startup idea is actually good.' Just generate it, don't ask me questions."
**Expected:** Quick Shot mode detected ("just generate"). Portrait orientation. No avatar_id (auto-select). No style_id. Natural flow prompt (≤60s). ~15s target.
**Fix Tested:** Quick Shot mode detection, portrait orientation, short-form pacing.

## S5: Explainer with Data (Full Producer, landscape, style_id)
**Prompt to agent:** "Make a 90-second explainer video about why AI agents are replacing SaaS dashboards. Include these stats: 73% of MCP servers are invisible to agents, tools with quality descriptions get 3.6x higher selection, and the MCP ecosystem has 5,800+ servers with 97M SDK downloads/month. Target: tech executives."
**Expected:** Full Producer. Explainer structure: Context → Core concept → Takeaway. Agent should extract stats into CRITICAL ON-SCREEN TEXT block. Motion graphics recommended for data visualization. Browse styles — executive/cinematic fit. Landscape. ~90s target (longest scenario).
**Fix Tested:** Data-heavy prompt handling, CRITICAL ON-SCREEN TEXT extraction, long-form pacing, style browsing for professional tone.

## S6: Personal Brand Intro (Full Producer, portrait, Eve avatar)
**Prompt to agent:** "I want a 20-second Instagram Reel introducing myself. I'm Eve Park, I build AI agent tools at HeyGen. Keep it casual and energetic — like talking to a friend. Use my avatar."
**Expected:** Full Producer. Eve avatar_id. Portrait for Reels. Phase 3.5: portrait avatar + portrait video = no correction needed (orientation match). Short natural flow prompt. ~20s target.
**Fix Tested:** Portrait-portrait match (Phase 3.5 should NOT fire), personal brand tone, short-form with avatar.

## S7: Company Culture / Recruiting (Full Producer, landscape, no avatar)
**Prompt to agent:** "Create a 45-second recruiting video for a startup called 'Meridian Labs'. We're a 12-person AI research lab in San Francisco. We want to attract ML engineers. Vibe: innovative, scrappy, ambitious. Show the energy of a small team doing big things."
**Expected:** Full Producer. Voice-over only. Landscape. Stock media for office/team scenes, AI-generated for futuristic concepts. Should recommend appropriate style or use catchall. ~45s target.
**Fix Tested:** Recruiting use case, stock + AI-generated media mix, tone calibration for culture video.

## S8: Enhanced Prompt (pre-written script, landscape)
**Prompt to agent:** "I already have my script, just optimize it and generate:

'Every developer has been there. You have the idea. You have the skills. But you spend three weeks just setting up auth, payments, and email. What if you could skip all of that? Introducing ShipFast. One command. Full stack. Ship this weekend. Try it free at shipfast.dev.'

Make it 30 seconds, landscape, no presenter."
**Expected:** Enhanced Prompt mode (user has script, skip to Phase 3). Agent should optimize the script for video (voice rules, pacing), build prompt with script freedom directive, assemble style block. No avatar. ~30s target.
**Fix Tested:** Enhanced Prompt mode detection, script-as-input handling, script freedom directive.

## S9: Announcement with Asset (Full Producer, landscape, URL asset)
**Prompt to agent:** "Make a 30-second announcement video about HeyGen's new Video Agent API. Here's the blog post for context: https://developers.heygen.com/docs/quick-start. Pull the key features from there and make it exciting for developers."
**Expected:** Full Producer. Agent should classify URL as Path A (contextualize) — it's a docs page (HTML), cannot be attached via files[]. Agent fetches and reads the page, extracts key points, builds script. Voice-over. Landscape. ~30s target.
**Fix Tested:** Asset routing (HTML URL → Path A only), URL content extraction, announcement structure.

## S10: Multi-Language / International (Full Producer, landscape)
**Prompt to agent:** "Create a 30-second product video for a meditation app called 'Stillness'. The audience is Japanese. Generate the video in Japanese. Calm, peaceful tone. Show nature scenes."
**Expected:** Full Producer. Agent should handle language parameter (Japanese). Voice-over in Japanese. Stock media for nature. Calm tone calibration. Landscape. ~30s target.
**Fix Tested:** Non-English language handling, tone calibration (calm/peaceful), stock media guidance for nature scenes.
