# Install HeyGen Stack

Get your API key from [app.heygen.com/settings](https://app.heygen.com/settings/api?nav=API).

## Option 1 — ClawHub (recommended)

```bash
clawhub install heygen-stack
```

## Option 2 — Git clone

**OpenClaw:**
```bash
git clone https://github.com/heygen-com/heygen-stack.git ~/.openclaw/workspace/skills/heygen-stack
```

**Claude Code:**
```bash
git clone https://github.com/heygen-com/heygen-stack.git ~/.claude/skills/heygen-stack
```

## First Run

### OpenClaw

> My HeyGen API key is `[HEYGEN_API_KEY]`. Save it to your persistent environment config and validate it works by calling `GET https://api.heygen.com/v3/user/me` with header `X-Api-Key`. Then use the heygen-avatar-designer skill to create an avatar for yourself and use heygen-video-producer to make a video introducing yourself, 30-60 seconds, casual tone.

### Claude Code

> My HeyGen API key is `[HEYGEN_API_KEY]`. Use it as HEYGEN_API_KEY for all HeyGen API calls — do not store it anywhere, just use it in this session. Validate it works by calling `GET https://api.heygen.com/v3/user/me` with header `X-Api-Key`. Then use the heygen-avatar-designer skill to create an avatar for yourself, and use heygen-video-producer to make a video introducing yourself, 30-60 seconds, casual tone.
