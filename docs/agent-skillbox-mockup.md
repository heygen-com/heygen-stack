# Agent Skillbox — UI Mockup

> Wireframe for the "Agentic Skills" tab on the API Settings page (`app.heygen.com/settings/api`).
> For the FE team. Box-drawing chars represent UI containers. Notes in `[brackets]` describe behavior.

---

## Page Location

```
Settings > API > [Tab: API Keys] [Tab: Webhooks] [Tab: Agentic Skills ←]
```

---

## Full Layout

```
┌──────────────────────────────────────────────────────────────────────────┐
│  Agentic Skills                                                          │
│                                                                          │
│  Teach your AI coding agent to create avatars and videos with HeyGen.    │
│                                                                          │
│  ────────────────────────────────────────────────────────────────────     │
│                                                                          │
│  STEP 1 — Set your API key                                               │
│                                                                          │
│  ┌────────────────────────────────────────────────────────────┬───────┐  │
│  │ sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx                │ Copy  │  │
│  └────────────────────────────────────────────────────────────┴───────┘  │
│                                                                          │
│  [NOTE: Pre-filled from the user's key in the API Keys tab above.        │
│   If no key exists, show "Generate an API key first" with a link to      │
│   the API Keys tab. Copy button copies the export command below.]        │
│                                                                          │
│  Then run in your terminal:                                              │
│                                                                          │
│  ┌────────────────────────────────────────────────────────────┬───────┐  │
│  │ export HEYGEN_API_KEY=sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxx      │ Copy  │  │
│  └────────────────────────────────────────────────────────────┴───────┘  │
│                                                                          │
│  ────────────────────────────────────────────────────────────────────     │
│                                                                          │
│  STEP 2 — Install                                                        │
│                                                                          │
│  ┌─────────────────┬─────────────────┬─────────────────────┐             │
│  │  Claude Code    │  OpenClaw       │  Other Agents       │             │
│  └─────────────────┴─────────────────┴─────────────────────┘             │
│                                                                          │
│  [NOTE: Tabs. Each tab shows agent-specific install. Claude Code is      │
│   the default selected tab. Tab selection persists in localStorage.]     │
│                                                                          │
│  ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐  │
│                                                                          │
│  │ CLAUDE CODE TAB                                                   │  │
│                                                                          │
│  │ Copy and paste this into Claude Code:                             │  │
│                                                                          │
│  │ ┌──────────────────────────────────────────────────────┬───────┐  │  │
│    │ Install HeyGen Stack: clone                         │       │       │
│  │ │ https://github.com/heygen-com/heygen-stack.git      │ Copy  │  │  │
│    │ into ~/.claude/skills/heygen-stack and run           │       │       │
│  │ │ ./setup from the cloned directory.                  │       │  │  │
│    └──────────────────────────────────────────────────────┴───────┘       │
│  │                                                                   │  │
│    [NOTE: The entire prompt is copyable. The Copy button copies the      │
│  │  full text. Monospace font, light gray background, rounded box.   │  │
│    The user pastes this directly into their Claude Code chat.]           │
│  │                                                                   │  │
│  └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘  │
│                                                                          │
│  ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐  │
│                                                                          │
│  │ OPENCLAW TAB (hidden by default)                                  │  │
│                                                                          │
│  │ Copy and paste this into OpenClaw:                                │  │
│                                                                          │
│  │ ┌──────────────────────────────────────────────────────┬───────┐  │  │
│    │ Install HeyGen Stack: clone                         │       │       │
│  │ │ https://github.com/heygen-com/heygen-stack.git      │ Copy  │  │  │
│    │ into ~/.openclaw/skills/heygen-stack and run         │       │       │
│  │ │ ./setup from the cloned directory.                  │       │  │  │
│    └──────────────────────────────────────────────────────┴───────┘       │
│  │                                                                   │  │
│  └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘  │
│                                                                          │
│  ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐  │
│                                                                          │
│  │ OTHER AGENTS TAB (hidden by default)                              │  │
│                                                                          │
│  │ Clone the repo and run setup:                                     │  │
│                                                                          │
│  │ ┌──────────────────────────────────────────────────────┬───────┐  │  │
│    │ git clone https://github.com/heygen-com/            │       │       │
│  │ │     heygen-stack.git && cd heygen-stack && ./setup   │ Copy  │  │  │
│    └──────────────────────────────────────────────────────┴───────┘       │
│  │                                                                   │  │
│    Point your agent's skill loader at the cloned directory's             │
│  │ SKILL.md file, or symlink each sub-skill manually.                │  │
│    See INSTALL.md in the repo for details.                               │
│  │                                                                   │  │
│  └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘  │
│                                                                          │
│  ────────────────────────────────────────────────────────────────────     │
│                                                                          │
│  STEP 3 — Verify                                                         │
│                                                                          │
│  Ask your agent:                                                         │
│                                                                          │
│  ┌──────────────────────────────────────────────────────────┬───────┐    │
│  │ Validate my HeyGen setup                                │ Copy  │    │
│  └──────────────────────────────────────────────────────────┴───────┘    │
│                                                                          │
│  Your agent will check the API key, confirm the skills are loaded,       │
│  and list available capabilities.                                        │
│                                                                          │
│  ────────────────────────────────────────────────────────────────────     │
│                                                                          │
│  Installed Skills                                                        │
│                                                                          │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │                                                                    │  │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐         │  │
│  │  │ heygen-avatar │  │ heygen-video │  │ buddy-to-avatar  │         │  │
│  │  │              │  │              │  │                  │         │  │
│  │  │ Create your  │  │ Produce      │  │ Turn your AI     │         │  │
│  │  │ digital twin │  │ avatar       │  │ buddy into a     │         │  │
│  │  │ from a photo │  │ videos with  │  │ video presenter  │         │  │
│  │  │              │  │ full prompt  │  │                  │         │  │
│  │  │              │  │ engineering  │  │                  │         │  │
│  │  └──────────────┘  └──────────────┘  └──────────────────┘         │  │
│  │                                                                    │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                                                                          │
│  [NOTE: These are static info cards, not interactive. They help the      │
│   user understand what they just installed. Each card shows the skill    │
│   name and a one-line description.]                                      │
│                                                                          │
│  ────────────────────────────────────────────────────────────────────     │
│                                                                          │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │ ▸ Quick Setup (includes API key in prompt — not recommended)       │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                                                                          │
│  [NOTE: Collapsed/expandable section. Chevron ▸ rotates to ▾ when        │
│   expanded. Yellow warning icon before the label. Default: collapsed.]   │
│                                                                          │
│  ┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐  │
│                                                                          │
│  │ EXPANDED CONTENT (hidden by default)                              │  │
│                                                                          │
│  │ This generates a one-click install prompt with your API key       │  │
│    embedded. Convenient but less secure — anyone with the prompt         │
│  │ can use your key.                                                 │  │
│                                                                          │
│  │ ┌──────────────────────────────────────────────────────┬───────┐  │  │
│    │ My HeyGen API key is sk-xxxxxxxxx. Install the      │       │       │
│  │ │ HeyGen Stack skill from https://github.com/         │ Copy  │  │  │
│    │ heygen-com/heygen-stack.git — clone it into your     │       │       │
│  │ │ skills directory. Save the API key as                │       │  │  │
│    │ HEYGEN_API_KEY in your environment config.           │       │       │
│  │ │ Validate by calling GET /v3/users/me with header    │       │  │  │
│    │ X-Api-Key. Then use heygen-avatar to create an      │       │       │
│  │ │ avatar for yourself, and heygen-video to make a     │       │  │  │
│    │ 30-60s intro video, casual tone.                    │       │       │
│  │ └──────────────────────────────────────────────────────┴───────┘  │  │
│                                                                          │
│  │ [NOTE: The Copy button calls POST /v1/pacific/agent-prompts       │  │
│    to generate the prompt server-side with the user's real key.          │
│  │ Display a spinner while the request is in flight. On failure,     │  │
│    fall back to a client-side template with the key from Step 1.]        │
│  │                                                                   │  │
│  └ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘  │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## Behavior Notes for FE

| Element | Behavior |
|---------|----------|
| API key field (Step 1) | Read-only. Pre-filled from the API Keys tab. If no key exists, show disabled state with "Generate an API key first" link. |
| `export` command (Step 1) | Substitutes the real key into the command. Copy button copies the full `export HEYGEN_API_KEY=...` string. |
| Agent tabs (Step 2) | Standard tab group. Persist selection in `localStorage`. Default: Claude Code. |
| Prompt boxes (Step 2) | Monospace, `bg-gray-50`, `border-radius: 8px`. Entire text is the copy target. |
| Verify prompt (Step 3) | Single copyable string. Same styling as Step 2 boxes. |
| Skill cards | Static display. Pull name and description from a config or hardcode for v1. |
| Quick Setup section | `<details>`/`<summary>` or equivalent. Collapsed by default. Warning icon (yellow triangle). |
| Quick Setup Copy button | Calls `POST /v1/pacific/agent-prompts` with the user's API key. Returns a generated prompt string. On 4xx/5xx, fall back to client-side template interpolation. |

## Responsive

- On mobile (<768px), stack the agent tabs vertically.
- Skill cards wrap to 1 column.
- Copy buttons remain visible (no hover-only).

## Access

- Only visible to users with an active API plan (same gate as the API Keys tab).
- If the user has no API key yet, Steps 2 and 3 are shown but the prompt boxes display placeholder text with `sk-...` instead of a real key.
