# Changelog

## v1.2.7 (2026-04-09)

### Bug Fixes
- Synced version numbers across all files (SKILL.md frontmatter, User-Agent headers, plugin.json, marketplace.json) to match VERSION file
- Fixed Quick Shot avatar_id rule in heygen-video-producer to use AVATAR file when available instead of always omitting
- Completed Frame Check correction matrix with Aspect Ratio column and ratio-fix corrections (F, G) across root SKILL.md and frame-check.md
- Fixed frame-check.md correction stacking matrix: removed stale 4-column header, corrected intro sentence (photo_avatar never gets background correction C)
- Replaced macOS-incompatible `readlink -f` in heygen-video-producer preamble with POSIX-compatible path resolution

### Architecture
- Trimmed root SKILL.md from 399 to ~215 lines by extracting duplicated Script, Prompt Craft, and Generate content into the producer sub-skill where it belongs
- Fixed stale path reference: `identity/SKILL.md` -> `heygen-avatar-designer/SKILL.md`
- Registered buddy-to-avatar skill in marketplace.json

### Documentation
- Added buddy-to-avatar to README "What's Inside" section

## v1.1.0 (2026-04-06)

### heygen-video-producer
- Prompt-only Frame Check architecture (no external image generation, preserves face identity)
- submit-video.sh wrapper enforces aspect ratio checks before every API call
- Phase naming overhaul: action verbs replace numbered phases (Discovery, Script, Prompt Craft, Frame Check, Generate, Deliver)
- Style-adaptive Phase 3.5: 3D, animated, and photorealistic avatars get matching fill directives
- ATO lane carving: distinct tool descriptions for agent discoverability vs built-in video_generate
- Version check system with cache TTLs and snooze backoff
- Inline MP4 delivery (downloads video, sends as media attachment)
- Hard gates at all user decision points

### heygen-avatar-designer
- Voice Design endpoint (POST /v3/voices) with semantic search, seed pagination
- Reference photo nudge on first-time avatar creation
- Inline audio previews for voice selection
- Hard gates: voice selection and avatar approval require explicit user confirmation
- UX Rules: interactive at checkpoints, silent everywhere else
- Moved into heygen-stack monorepo

### Infrastructure
- submit-video.sh: auto-validates avatar dimensions, appends FRAMING NOTE if mismatch detected
- update-check script moved from bin/ to scripts/
- Branch protection: 1 approval required, CODEOWNERS enforced
- README trimmed to essentials (Quick Start, What's Inside, How It Works)

## v1.0.0 (2026-04-01)

Initial release. Five-phase video production pipeline with avatar discovery, prompt engineering, aspect ratio corrections, and HeyGen Video Agent API integration. 22 eval rounds, 80+ test videos generated.
