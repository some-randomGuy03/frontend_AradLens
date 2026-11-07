# AGENTS.md — AradLens_frontend

Single-file static AR tourism app for Arad. All app code lives in `index.html` (~3630 lines, inline CSS + JS). No package.json, no build, no tests.

## Structure
- `index.html` — entire app: UI, CSS (`<style>` lines 8–989), logic (single `<script>` at ~line 1472). Entry data: `const REPERE` (~line 1481, 5 landmarks with lat/lon; only Primăria has full metadata + `foto`); story chapters `const CHAPTERS` (~line 1558), `storyState` (~line 1616).
- `primaria-1901.jpg` — only historic photo asset, referenced by `REPERE[2].foto`.
- `fonts/` — self-hosted OFL display face (AradLens Display) + license; must be committed or `@font-face` 404s in prod.
- `docker-compose.yml` + `deploy.sh` — prod serving only.
- `docs/codebase.md` — full codebase walkthrough (read this before large changes).
- `.opencode/commands/` — 54 slash commands (one per skill in `.agents/skills/`); skills themselves stay gitignored, commands are committed.

## Run locally
- Static only: `docker compose up --build` → http://localhost:8010, or `python3 -m http.server 8010`.
- Sensors (camera, GPS, compass) require **HTTPS + mobile + user gesture** (`#startBtn` handler requests motion permission first, then camera/geo). Desktop shows `#desktopPlaceholder`; `Continuă în mod previzualizare` bypasses for layout work.
- No lint/typecheck/test commands exist.

## Conventions / gotchas
- State is in-memory globals + 3 `localStorage` keys: `aradlens_theme` (dark/light), `aradlens_user_photos` (captured dataURLs, per-landmark), `aradlens_story_state` (mode story/free, per-chapter `currentStep`/`completed`, rewards). No backend; "save permanently" TODO is in `executePhotoCapture()` / capture modal text.
- Photo capture is canvas snapshot from `<video id="cam">`, not native camera API. Proximity gate is 50 m (`checkLandmarkProximity`), `notifiedLandmarksInSession` Set prevents repeat toasts.
- Album map (`#albumModal` SVG pins `mapPin0-4`) is **schematic demo, not GPS-projected** — labeled as such in UI, keep that disclaimer.
- Stop selector is the curved **compass band** (`<nav id="snapRail">`, last child of `.bottom`; CSS ~line 175, JS `renderCompassBand` ~line 2116): an amber reticle marks the selected stop, drag / mouse wheel / arrow keys scroll the tape, `BAND_SLOT` (108 px spacing) + `BAND_SAG`/`perspective rotateX(13deg)` shape the arc. It is story-aware — chapter steps render as `.locked` (padlock, not selectable), `.completed` (teal) or current (amber).
- Story mode (`CHAPTERS` ~line 1558, `storyState` ~line 1616, `#gamemodeModal`): captures must follow chapter order (`showCaptureFeedback` warns otherwise), each shot opens `#storyLoreModal`, the last step opens `#rewardModal` + `#albumRewardsTab`; free mode ignores order.
- `index.html` is UTF-8 (CRLF, no BOM) with intact Romanian diacritics. Tools that decode it with a legacy codepage (e.g. PowerShell `Get-Content` without `-Encoding UTF8`) show mojibake (`ș`→`ET`, `ț`→`E>`) — a display artifact, not corruption. Never "fix" strings based on a garbled view.
- Do not split `index.html` into bundles or add a framework without explicit approval — deploy expects a flat static root served by nginx.

## Deploy
- Push to `main` triggers `.github/workflows/deploy.yml` → SSH to server, runs `sudo -n $DEPLOY_PATH/deploy.sh` (`git pull && docker compose down/build/up -d`). Needs secrets: `SSH_HOST/USER/PRIVATE_KEY`, `DEPLOY_PATH`, optional `SSH_PORT`.
- Never commit AI local dirs (see `.gitignore`): `.agents/`, `.codex/`, `.impeccable/`, `skills-lock.json`, `.github/agents|hooks|skills/`.
