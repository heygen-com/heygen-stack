# Dry Run — Full Pipeline Preview

Iterate on the complete video production pipeline WITHOUT burning HeyGen credits. Produces the exact API payload (prompt, avatar_id, asset_ids, orientation) that would be sent to `/v1/video_agent/generate`.

## Purpose

This is the fast iteration loop. Run it dozens of times to nail the user interaction flow, avatar selection, prompt construction, and payload assembly. When satisfied, flip to a real run.

## What Gets Tested

1. **Avatar Decision Flow** — Did the skill guide the user through avatar selection correctly?
2. **Discovery Phase** — Did it ask the right questions? Skip the right ones?
3. **Script Quality** — Word count, pacing, structure
4. **Prompt Construction** — Scene-by-scene structure, visual style block, media types
5. **Final API Payload** — Exact JSON that would hit the API

## How to Run

Eve spawns Adam (or runs it herself) with a dry-run scenario. The skill follows the full pipeline but STOPS before calling the API. Instead, it outputs the final payload.

### Dry-Run Prompt Template

```
You are testing the heygen-video-producer skill in DRY RUN mode.

## Setup
Read the skill at: skills/heygen-video-producer/SKILL.md
You have HEYGEN_API_KEY set.

## DRY RUN RULES
- Follow the ENTIRE skill pipeline (Discovery → Script → Prompt → Generate)
- DO NOT call the HeyGen API. No POST to /v1/video_agent/generate.
- Instead, output the FINAL PAYLOAD section below.
- For the avatar flow, call the LIST APIs (GET /v2/avatars, GET /v2/avatar_group.list, GET /v2/avatar_group/{id}/avatars) to see real data.
- For asset uploads, note what WOULD be uploaded but don't actually upload.

## Simulated User
You are playing both roles: the skill agent AND the user. For user responses, use the scenario below.

## Scenario
{SCENARIO}

## Avatar Interaction
When the skill asks about avatar preference, respond as the user would based on the scenario's avatar_intent field.

## Required Output

After completing the full pipeline, output this EXACT format:

---
## DRY RUN RESULT

### Interaction Trace
[Numbered list of every agent↔user exchange that happened. Show both sides.]

1. Agent: "What's this video for?"
   User: "Product demo for developers"
2. Agent: "Do you have a preferred avatar?"
   User: "Use my existing one"
3. ...

### Avatar Decision
- User intent: [use existing / new look / new avatar / no preference / voice-only]
- Decision path taken: [which branch of the avatar flow]
- Avatar selected: [name, id, type (static/motion), group_id]
- Avatar look: [if applicable, which look within group]
- Voice selected: [voice_id, name if known]
- How avatar was determined: [auto-selected / user chose from list / user specified by name / default]

### Script
[Full script with word count, scene count, estimated duration]

### Prompt (as constructed)
[The exact prompt string that would go in the API payload]

### Final API Payload
```json
{
  "prompt": "<the full prompt>",
  "files": [
    {"asset_id": "<id>", "note": "<what this asset is>"}
  ]
}
```

If no assets: `"files": []`

### Payload Checklist
- [ ] Prompt uses narrator framing ("A narrator explains..." not "Create a video...")
- [ ] Duration is padded 1.4x from user target
- [ ] Visual style block present at bottom
- [ ] Media types specified per scene
- [ ] Avatar direction included in prompt (if using avatar)
- [ ] Asset anchoring is specific (if assets exist)
- [ ] Word count within 150 wpm budget
- [ ] Scene-by-scene structure (not flat paragraph)

### Friction Points
[Anything that was confusing, contradictory, or missing in the skill during this dry run]

### Score
- Avatar flow: [1-10] — was avatar selection smooth and correct?
- Discovery: [1-10] — right questions, right skips?
- Script: [1-10] — quality, pacing, structure?
- Prompt: [1-10] — would this produce a good video?
- Payload: [1-10] — correct format, all fields present?
- Overall: [1-10]
---
```

---

## Scenarios

Each scenario simulates a different user with different avatar needs. The `avatar_intent` field tells the simulated user how to respond when asked about avatars.

### Scenario 1: Has Existing Avatar, Wants to Use It
```yaml
name: returning-user-existing-avatar
user_context: "I'm a developer who's made videos before. I have a custom avatar."
request: "Make me a 60-second video about our new REST API for developers."
avatar_intent: "Use my existing avatar. I already have one set up."
assets: none
tone: casual-confident
duration: 60s
```

### Scenario 2: Has Avatar Group, Wants Different Look
```yaml
name: same-avatar-different-look
user_context: "I've got an avatar but I want a different vibe for this video."
request: "Create a 45-second sales pitch for enterprise clients. Professional tone."
avatar_intent: "I have my avatar but can we make it look more corporate? Different outfit or setting."
assets: none
tone: professional
duration: 45s
```

### Scenario 3: No Avatar, Needs New One
```yaml
name: first-time-new-avatar
user_context: "First time using HeyGen. No avatar yet."
request: "I need a product demo video, about 90 seconds."
avatar_intent: "I don't have an avatar. What are my options?"
assets: [screenshot.png (simulated)]
tone: energetic
duration: 90s
```

### Scenario 4: Wants Voice-Only (No Avatar)
```yaml
name: voice-only
user_context: "I want a clean explainer with just visuals and voiceover."
request: "60-second explainer about MCP for a technical blog post."
avatar_intent: "No avatar. Just voice-over with B-roll."
assets: none
tone: calm-authoritative
duration: 60s
```

### Scenario 5: Has Avatar, Wants Completely New One
```yaml
name: wants-new-avatar-entirely
user_context: "I have an old avatar from last year. It doesn't match our rebrand."
request: "30-second announcement about our company rebrand."
avatar_intent: "I need a completely new avatar. The old one doesn't fit our new brand."
assets: [new-brand-guidelines.pdf (simulated)]
tone: energetic
duration: 30s
```

### Scenario 6: No Preference (Let the Skill Decide)
```yaml
name: no-avatar-preference
user_context: "Just want a video. Don't care about avatar specifics."
request: "Make a quick video about AI agents for my LinkedIn."
avatar_intent: "Whatever works. You pick."
assets: none
tone: casual
duration: 30s
```

### Scenario 7: Quick Shot (Skip Everything)
```yaml
name: quick-shot-skip-all
user_context: "Just generate it, don't ask me anything."
request: "Just make this: A narrator explains why every developer needs an AI video API. 30 seconds."
avatar_intent: [not applicable — quick shot mode should not ask]
assets: none
tone: implied from prompt
duration: 30s
```

### Scenario 8: Has Specific Stock Avatar in Mind
```yaml
name: wants-specific-stock-avatar
user_context: "I saw a HeyGen avatar I liked. Her name was Abigail."
request: "Create a 60-second tutorial walkthrough."
avatar_intent: "Can I use Abigail? The one with the office background."
assets: none
tone: professional
duration: 60s
```

---

## Avatar Decision Flow (What the Skill SHOULD Do)

This is the avatar guidance tree the skill should follow. Use it to evaluate whether the dry run got it right.

```
User request arrives
  │
  ├─ Quick Shot mode? → Skip avatar question. Let Video Agent auto-select.
  │
  ├─ User said "no avatar" / "voice only"? → Include in prompt: "No visible avatar, voice-over only."
  │
  └─ All other modes → Ask about avatar preference:
      │
      │   "Do you have a preferred avatar, or should I pick one for you?"
      │   Options:
      │   a) Use my existing avatar
      │   b) I want a different look (same person, different outfit/setting)
      │   c) Create a new avatar from scratch
      │   d) Use a stock HeyGen avatar
      │   e) No preference, you decide
      │
      ├─ (a) Use existing →
      │     1. GET /v2/avatar_group.list → show user their groups
      │     2. User picks group → GET /v2/avatar_group/{id}/avatars → show looks
      │     3. User picks look → save avatar_id, voice_id
      │     4. Include in prompt: "Use a [description matching the avatar] as the presenter"
      │     Note: Video Agent uses prompt-driven avatar selection, not avatar_id param.
      │     The description should match the look the user chose.
      │
      ├─ (b) Different look →
      │     1. GET /v2/avatar_group.list → show groups
      │     2. User picks group → show current looks
      │     3. Explain: "To add a new look, we'd need to create one via the Photo Avatar API.
      │        For this video, I can describe the desired look in the prompt and let
      │        Video Agent interpret it, OR we can use one of your existing looks."
      │     4. If user wants prompt-driven: describe desired appearance in prompt
      │     5. If user wants exact control: guide through Photo Avatar look creation
      │        (upload new image → POST /v2/photo_avatar/avatar_group/create with same group)
      │        Note: This takes a few minutes to process.
      │
      ├─ (c) New avatar from scratch →
      │     1. Ask: "Do you have a photo to use, or should I describe what you want?"
      │     2. Photo provided → upload to HeyGen → create avatar group → train → add motion
      │        (Full flow from photo-avatar-api-flow.md, takes 5-10 min)
      │     3. No photo → describe in prompt, let Video Agent pick a stock avatar that matches
      │     4. Note: creating a new avatar is a separate workflow. Offer to do it now
      │        (delays video) or proceed with a stock avatar and create the custom one after.
      │
      ├─ (d) Stock avatar →
      │     1. GET /v2/avatars → show curated list (filter by gender/style if user specified)
      │     2. User picks → describe in prompt: "Use [avatar name] as the presenter"
      │     Note: Stock avatars are referenced by description in Video Agent prompts.
      │     The avatar_id is NOT passed to the Video Agent API.
      │
      └─ (e) No preference →
            Don't ask more questions. Include generic prompt direction:
            "Use a professional presenter appropriate for [audience]."
            Let Video Agent auto-select.
```

### Key Technical Constraint
**Video Agent API (`/v1/video_agent/generate`) does NOT accept `avatar_id` as a parameter.** Avatar selection is prompt-driven only. The skill must translate the user's avatar choice into descriptive text within the prompt.

Exception: If you need EXACT avatar control (specific custom avatar, specific pose), you must use `/v2/video/generate` (Avatar Video API) instead. But Ken's directive says NEVER use v2/video/generate. So for this skill, it's always prompt-driven.

This means:
- "Use my existing avatar" → describe it in the prompt so Video Agent picks something similar
- Stock avatars → describe by name/appearance
- Custom avatars → describe appearance, Video Agent may not match exactly
- **If exact avatar match is critical**, tell the user this is a limitation of Video Agent and suggest the avatar-video skill instead

---

## Saving Results

Save each dry run to:
```
evals/runs/dry-YYYY-MM-DD-{scenario_name}.md
```

Include the full DRY RUN RESULT output. Compare across runs to track improvement.

---

## Fast Iteration Loop

The whole point: run a scenario → read the output → tweak SKILL.md → run again.

1. Pick a scenario (start with #6 "no preference" — simplest path)
2. Run dry run
3. Read the interaction trace — is the flow natural?
4. Read the avatar decision — did it guide correctly?
5. Read the payload — would this produce a good video?
6. Identify friction → edit SKILL.md → run again
7. Repeat until all 8 scenarios score 8+/10

Typical iteration: 5-10 runs per SKILL.md change. Each run takes ~2-3 minutes (no API cost).
