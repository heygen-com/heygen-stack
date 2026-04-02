# heygen-stack

The HeyGen Skill Stack for AI agents. One install, two skills, full pipeline from identity to video.

## What it does

| Skill | What | Trigger |
|-------|------|---------|
| **avatar-designer** | Create avatars from identity files or conversation. Manages looks, voices, and persistent `AVATAR-<NAME>.md` files. | "create my avatar", "bring yourself to life" |
| **video-producer** | Turn prompts into polished HeyGen videos. Handles script framing, aspect ratio corrections, style selection, and API polling. | "make a video about...", "produce a video" |

The stack auto-routes to the right skill based on intent. When chained, avatar-designer creates the identity and video-producer picks it up automatically.

## Install

### OpenClaw

```bash
clawhub install heygen-stack
```

Or manually:
```bash
git clone --single-branch --depth 1 https://github.com/eve-builds/heygen-stack.git ~/.openclaw/skills/heygen-stack
```

### Claude Code

```bash
git clone --single-branch --depth 1 https://github.com/eve-builds/heygen-stack.git ~/.claude/skills/heygen-stack
```

Then add to your CLAUDE.md:
```
Use heygen-stack skills for all HeyGen avatar and video tasks.
```

## Setup

Set your HeyGen API key:
```bash
export HEYGEN_API_KEY=your_key_here
```

That's it. No other dependencies.

## How it works

```
SOUL.md / IDENTITY.md          AVATAR-EVE.md              Final Video
 (who you are)          →      (avatar + voice IDs)    →  (polished output)
       ↓                            ↓                          ↓
  avatar-designer            shared state file           video-producer
```

**avatar-designer** reads your identity files (or asks you conversationally), creates a HeyGen avatar, matches a voice, and saves everything to `AVATAR-<NAME>.md`.

**video-producer** reads that file, picks up your avatar and voice, and handles the entire video creation pipeline: prompt engineering, script framing, aspect ratio corrections, style selection, and polling.

Each skill works standalone too. You don't need an avatar to make a video (stock avatars work), and you don't need to make videos to create an avatar.

## API

v3 only. Both skills use `https://api.heygen.com` with `X-Api-Key` auth. No v1/v2 endpoints.

## License

MIT
