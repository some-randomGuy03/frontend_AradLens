# AGENTS.md — AradLens_frontend

Single-file static AR tourism app for Arad. All app code lives in `index.html` (~1900 lines, inline CSS + JS). No package.json, no build, no tests.

## Structure
- `index.html` — entire app: UI, CSS (`<style>`), logic (single `<script>` at ~line 810). Entry data: `const REPERE` (~line 820, 5 landmarks with lat/lon; only Primăria has full metadata + `foto`).
- `primaria-1901.jpg` — only historic photo asset, referenced by `REPERE[2].foto`.
- `fonts/` — self-hosted OFL display face (AradLens Display) + license; must be committed or `@font-face` 404s in prod.
- `docker-compose.yml` + `deploy.sh` — prod serving only.
- `docs/codebase.md` — full codebase walkthrough (read this before large changes).
- `.opencode/commands/` — 53 slash commands (one per skill in `.agents/skills/`); skills themselves stay gitignored, commands are committed.

## Run locally
- Static only: `docker compose up --build` → http://localhost:8010, or `python3 -m http.server 8010`.
- Sensors (camera, GPS, compass) require **HTTPS + mobile + user gesture** (`#startBtn` handler requests motion permission first, then camera/geo). Desktop shows `#desktopPlaceholder`; `Continuă în mod previzualizare` bypasses for layout work.
- No lint/typecheck/test commands exist.

## Conventions / gotchas
- State is in-memory globals + 2 `localStorage` keys: `aradlens_theme` (dark/light), `aradlens_user_photos` (captured dataURLs, per-landmark). No backend; "save permanently" TODO is in `executePhotoCapture()` / capture modal text.
- Photo capture is canvas snapshot from `<video id="cam">`, not native camera API. Proximity gate is 50 m (`checkLandmarkProximity`), `notifiedLandmarksInSession` Set prevents repeat toasts.
- Album map (`#albumModal` SVG pins `mapPin0-4`) is **schematic demo, not GPS-projected** — labeled as such in UI, keep that disclaimer.
- File has broken Romanian diacritics (mojibake, e.g. `E>`, `ETi`). Preserve existing text byte-for-byte unless fixing encoding repo-wide; do not "fix" single strings.
- Do not split `index.html` into bundles or add a framework without explicit approval — deploy expects a flat static root served by nginx.

## Deploy
- Push to `main` triggers `.github/workflows/deploy.yml` → SSH to server, runs `sudo -n $DEPLOY_PATH/deploy.sh` (`git pull && docker compose down/build/up -d`). Needs secrets: `SSH_HOST/USER/PRIVATE_KEY`, `DEPLOY_PATH`, optional `SSH_PORT`.
- Never commit AI local dirs (see `.gitignore`): `.agents/`, `.codex/`, `.impeccable/`, `skills-lock.json`, `.github/agents|hooks|skills/`.
