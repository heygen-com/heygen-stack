---
name: heygen-stack
description: |
  The HeyGen Skill Stack. Bundles avatar-designer and video-producer into one install.
  Auto-detects intent and routes to the right skill:
  - "create my avatar" / "bring yourself to life" → avatar-designer
  - "make a video" / "create a video about..." → video-producer
  - "create an avatar and then make a video" → chains both
  Install once, get the full HeyGen agent pipeline: identity → avatar → voice → video.
---

# HeyGen Stack

One install. Two skills. Full pipeline from identity to video.

**Required:** `HEYGEN_API_KEY` env var.

## What's Inside

### avatar-designer/
Create and manage HeyGen avatars for agents, users, or named characters. Extracts identity from SOUL.md/IDENTITY.md (or asks conversationally), generates an avatar, matches a voice, and saves everything to `AVATAR-<NAME>.md`.

**Triggers:** "create my avatar", "bring yourself to life", "make me an avatar", "add a new look"

### video-producer/
Turn ideas into polished HeyGen videos. Handles prompt engineering, script framing, aspect ratio corrections, and the full API submission/polling cycle.

**Triggers:** "make a video", "create a video about", "produce a video"

## Routing

Read the user's request and route:

1. **Avatar intent** → read `avatar-designer/SKILL.md`, follow it
2. **Video intent** → read `video-producer/SKILL.md`, follow it
3. **Both** → run avatar-designer first, then video-producer. The video skill reads `AVATAR-<NAME>.md` automatically.

If the user asks for a video but has no avatar file and wants a custom character:
> "Want me to create an avatar for this character first? It'll give you consistent identity across all your videos."

## Shared State

Skills communicate through `AVATAR-<NAME>.md` files at the workspace root:
- avatar-designer writes them (avatar_id, group_id, voice_id)
- video-producer reads them (picks up avatar + voice automatically)
- Human-readable AND machine-readable. One file per character.

## Install

Copy this into your agent:

```
Install heygen-stack: run `git clone --single-branch --depth 1 https://github.com/eve-builds/heygen-stack.git ~/.openclaw/skills/heygen-stack`
```

Then set your `HEYGEN_API_KEY` env var and you're ready.
