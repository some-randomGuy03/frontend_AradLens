# AradLens_frontend — codebase explanation

Tourism AR web app for Arad (Romanian UI with a runtime English translation
layer). Points the phone camera at
the city, shows distance + direction to a selected landmark, lets the user view
historic info, compare 1901 vs now, and "capture" a photo when close.

No framework, no bundler, no frontend backend. One HTML file served as static
content; a same-origin nginx/std-lib reverse proxy (`/api`) relays calls to the
central AradLens API (https://api.aradlens.binarysquad.club) because the API
publishes no CORS headers and browsers would block direct calls.

## 1. Tracked files

| File | Purpose |
|---|---|
| `index.html` (5300 lines, ~229 KB) | The entire app. `<style>` in `<head>` (lines 11–1810, the iOS 26 "liquid glass" layer is the block commented `STRATUL „LIQUID GLASS"` from ~line 1252), body markup lines ~1812–2320, single `<script>` from line 2322 (public API layer + gate, locations UI, tours, preload) |
| `primaria-1901.jpg` | Only historic asset. Used by `REPERE[2].foto` (Primăria Arad, 1901) |
| `docker-compose.yml` | `web: nginx:alpine`, maps repo root read-only to `/usr/share/nginx/html`, host port `8010:80`; also mounts `deploy/nginx/default.conf` over `/etc/nginx/conf.d/default.conf` |
| `deploy/nginx/default.conf` | Prod nginx config: static site + reverse proxy `location /api/ { proxy_pass https://api.aradlens.binarysquad.club/; }` (SNI on, forwards `Authorization`/`Content-Type` untouched, no session/cache state) |
| `dev_server.py` | Local dev substitute for the nginx proxy: stdlib `http.server` on 127.0.0.1:8010 serving static files and relaying `/api/*` to the central API (Python only, no deps) |
| `Start-AradLens.bat` | Local launcher (Windows): starts `dev_server.py` minimized (falls back to `python -m http.server` if missing) and opens http://127.0.0.1:8010/index.html |
| `fonts/` | Self-hosted OFL display face (AradLens Display) + license — must be committed or `@font-face` 404s in prod |
| `deploy.sh` | Server-side: `git pull` + `docker compose down/build/up -d` |
| `.github/workflows/deploy.yml` | On push to `main` (or manual dispatch): SSH to server and run `sudo -n $DEPLOY_PATH/deploy.sh`. Secrets: `SSH_HOST`, `SSH_USER`, `SSH_PRIVATE_KEY`, `DEPLOY_PATH`, optional `SSH_PORT` |
| `README.md` | One-line project description |

Untracked (do not commit, see `.gitignore`): `.agents/`, `.codex/hooks.json`,
`.impeccable/config.local.json`, `skills-lock.json`, `.github/agents|hooks|skills/`,
and two `Mobile*isDesktop*` files (accidental `man less` dumps, 1.6 KB / 16 KB).

## 2. `index.html` — UI layers (bottom to top)

1. `<video id="cam">` — live camera background. Blurred/dim by default (`opacity .28, blur(6px)`), class `camera-clear` removes the filter in capture mode.
2. `#overlay` — main AR HUD: `.top` (brand lockup `AradLens` with the `.brand-lens` disc, `#routeStep` + `#compassWarningBadge`, `#storyObjectiveBanner`/`#storyObjectiveText`, `#diag` debug readout), `.center` (`#steerArrow` chevron + `#steerEdge` degree readout when the target is behind), `#rail` vertical action stack of **glass rings** (46px, 9px gap; compacted to 44px/7px at 630–720px viewport heights): `#gamemodeRailBtn` + `#railModeDot`, `#detailsBtn`, `#photoCaptureBtn`, `#albumBtn`. There are **no** locations/categories/tours rings any more — tours are album modules and the location page opens on long-press of a compass stop. `.bottom`: `#caption`/`#arLabel` (target name, "Mergi spre …" phrase, distance), `#distNum` + `#routeStepBottom`, `#coords`/`#flipBtn` (debug only, now prints the street), `.hint` and `#snapRail` — the bottom **compass band** (curved, draggable stop selector; see §4).
3. Overlays (hidden by default): `#start` (permission gate + `#startBtn`), `#desktopPlaceholder` (+ `#desktopPreviewBtn` bypass), `#gamemodeModal` (`#selectStoryModeCard` / `#selectFreeModeCard`), `#chapterModal` (`#chaptersList`), `#storyLoreModal` (`#loreStepBadge`, `#loreStoryText`), `#rewardModal` (`#diplomaRewardName`, `#rewardNextChapterBtn`, `#rewardViewAlbumBtn`), `#compassWarning`, `#proximityToast` (`#toastCaptureBtn`), `#captureScreen` (`#shutterBtn`, `#cancelCaptureBtn`), `#captureFlash`, `#captureModal`, `#card` (info + `#speakBtn` TTS + `#photoBtn`), `#photoCmp` (1901/now slider: `canvas#cmpNow`, `img#cmpOld`, `input#cmpRange`), `#albumModal` (**album + tours + level map**: full-bleed static header, full-bleed non-sticky `.level-selector` Routes band with `#albumModuleBar` chips, stop nodes rendered into `#albumLevelTrack` by `renderLevelMap()`, first stop at the bottom, scroll upward; only `#albumMapTab` scrolls) + `#albumCompareModal` (Then/Now cards `#albumThenBox`/`#albumNowBox` + `#albumArchiveStrip`, opened by tapping a stop; the only photo surface), `#arLabel` floating AR tag, `#locationsModal` (read-only, public: opens as an **objective page** from a long-press on a compass stop, or as the locations list; `#locDetail` is painted from cache instantly and refreshed silently via `GET /locations/{id}`), `#categoriesModal` (plain read-only list, no rail entry point), `#legalModal` (tabs; the **Cookies** tab contains `#dataSettings` with the destructive `#clearDataBtn` flow), `#status` bar. `#toursModal` still exists in the DOM but is no longer reachable from the rail.

Theming: CSS variables on `:root`, plus `html.dark-theme` overrides for a tinted dark liquid-glass palette. The sun/moon `#themeSwitch` sits at the top of `#rail`; the choice persists in `localStorage["aradlens_theme"]` and a tiny `<head>` script applies the class before paint. On top of the base variables sits one **liquid-glass layer** (iOS 26): `--glass-blur/sat/tint/tint-thick/tint-thin/edge/hairline/inner-hi/inner-lo/shadow/sheen`, `--glass-solid`/`--glass-veil`/`--bar-solid` for the no-transparency fallback, the optic-lens colours (`--optic-warm/cool/violet`) and four spring curves (`--spring`, `-snappy`, `-bouncy`, `-soft`). Layout rules live at the end of `<style>` (~line 1252–1800) so they win the cascade over the original flat rules; `DESIGN.md` documents the material. The top and bottom HUD scrims use short, soft fades so the camera view stays clear.

## 3. Data

```js
const REPERE = [
  { nume: "Turnul de Apă",   lat: 46.16966, lon: 21.30803 },
  { nume: "Palatul Cultural", lat: 46.17411, lon: 21.32017 },
  { nume: "Primăria Arad", lat: 46.17537, lon: 21.31930,
    an, arhitect, stil, descriere, foto: "primaria-1901.jpg", fotoCredit },
  { nume: "Teatrul I. Slavici", lat: 46.17109, lon: 21.31577 },
  { nume: "Catedrala Veche",    lat: 46.17050, lon: 21.31170 }
];
```

Only Primăria has `foto` — so only it enables the Then/Now compare
(`renderAlbum()`). All five have `an/arhitect/stil/descriere/loreStory`, so
`#detailsBtn` (`targetHasInfo()`), the info card and TTS work for every
landmark. Coordinates are static OSM/Wikipedia approximations at rest; at
runtime `applyApiLocations()` / `addApiOnlyObjective()` merge the API locations
into the same array (`apiId`, live `lat`/`lon`, API-only objectives appended), so
chapter indices stay valid. To add a landmark: append to `REPERE` (never reorder
the first five — `CHAPTERS[].landmarkIndices` point at them), add the linear
album map entry (`renderLevelMap()` renders all stops), and give it
`foto`/`descriere` if it needs info/compare features.

**Never show a coordinate to the visitor.** The API has no street field, so
`streetFor(repere)` resolves `STRAZI_REPERE` (curated, hand-verified) →
`STRAZI_API_ID` → a `STREET_RE` match inside the API description → `"Arad"`.
Every surface that used to print `lat/lon` now prints that street: the info card
meta, the `#coords` debug line, location cards and detail, tour stops and the
album's compare header and level-map subtitles.

Photos users take are stored in `localStorage["aradlens_user_photos"]` as
`{ [nume]: { dataUrl, timestamp, sessionOnly? } }` (`USER_PHOTOS_STORAGE_KEY`).
The canvas is downscaled to max 1280 px / JPEG 0.82 so several photos fit in the
~5 MB local quota. Data URLs cannot live in cookies (~4 KB limit), so
`localStorage` is the on-device store; nothing is uploaded. On desktop preview
(when GPS is absent) capture is allowed without the 200 m proximity gate.
Photos are reached by tapping an album stop: the `Atunci/Acum` compare popup
shows the user's photo, the historic photo, and every API image for that
landmark; there is no separate gallery. The legal **Cookies → Setări date**
block deletes all `aradlens_*` keys, the site cookies, and reloads.

**Language (RO ⇄ EN):** the source stays Romanian. An embedded JSON map
(`<script type="application/json" id="i18n-en">`) plus the final script block
translate text nodes and `title`/`aria-label`/`placeholder`/`alt`, and a
`MutationObserver` translates every dynamically rendered view. `I18N_RULES`
covers interpolated strings (counts, distances, dates, tour labels) and
`applyProperNames()` translates landmark/category/tour names inside larger
strings, plus Romanian month names. `formatDistance()`, `formatPhotoDate()` and
`formatTourDate()` use `trLocale()` / `appLang` for decimal separators and
dates. `#langBtn` (HUD top-right) and `#langBtnStart` (start gate, next to
Legal) toggle the language, persist it in `aradlens_lang`, and update
`<html lang>` and the meta description. New UI strings need a map entry or a
rule; unknown future API content falls back to Romanian.

There is deliberately **no admin authentication on this site** — the AradLens
API writes (categories/locations/tours/images) belong to the separate admin
website. This repo only reads public GET endpoints through `/api`.

Story mode adds `const CHAPTERS` (~line 1558): 3 chapters, each
`{ id, index, numar, titlu, perioada, badge, icon, sinopsis, landmarkIndices: [4, 3, 2], reward: { id, badgeTitle, icon, seal, diplomaDesc } }`.
Progress lives in `storyState` (~line 1616), persisted in
`localStorage["aradlens_story_state"]`: `{ currentMode: "story"|"free", activeChapterId, chapters: { capN: { currentStep, completed, completedDate, photos } }, rewards: [] }`.
In story mode a capture only counts if it matches `getCurrentStoryLandmark()`;

**Entry mode is always free.** `storyState.currentMode` is forced to `"free"`
right after the persisted state loads, so the app never starts in Story mode;
chapter progress and rewards still persist and resume. The active mode/chapter
is signalled by `#railModeDot` (amber dot on the `#gamemodeRailBtn` ring) plus
that button's `title`/`aria-label` — there is no chapter chip in the top bar.
other shots are answered with a `showCaptureFeedback` warning.

## 4. JS execution flow

Startup (`#startBtn.onclick`, must be a tap for iOS motion permission):
`requestMotionPermission()` → `startCamera()` (`getUserMedia`, `environment` facing)
→ `startSensors()` → `startGeo()` (`navigator.geolocation.watchPosition`) →
6 s watchdog shows `#compassWarning` if `heading == null`.

Per-frame (`scheduleUpdate()` → `update()`, throttled):
`bearing(userLat/Lon → target)` + `distance()` (haversine) vs smoothed `heading`
→ `#distNum` (`formatDistance`), `#targetName`, `#diag`, `#arLabel`
(`updateArLabel(az)` writes the direction phrase + edge indicator for `|az| > 85°`)
plus `updateBandData()` (band distances and needle angles).
`checkLandmarkProximity()` fires `#proximityToast` once per session per landmark
(`notifiedLandmarksInSession` Set) when within 200 m.

Sensors: `handleOrientation()` consumes `deviceorientationabsolute` (if seen) else
`deviceorientation` fallback + iOS `webkitCompassHeading`; `robustAngle()` /
`robustPitch()` low-pass filter (`SMOOTH = 0.25`), spike guards, `headingOffset`
for the `#flipBtn` 180° debug flip. `showCompassWarning()` explains the
HTTPS + permission + reload checklist.

Key functions by area:
- Bottom compass band (`#snapRail`): `renderCompassBand` (scale ticks + one `compass-stop` button per stop — the 5 `REPERE` in free mode, the chapter's steps in story mode, with `.locked` / `.completed` states; dial SVG from `compassDialMarkup`), `bandStops` (stop list + state), `renderBand` (arc placement — `bandDrop`/`bandArcDeg` give the sag + rotation per element, opacity fades outward), pointer drag handlers + `wheel` (`bandOffset`, rubber band at the ends), `liveSelectNearestStop` / snap on release, `setWheelActiveIndex` (compat name; clamps to unlocked steps, sets `aria-current`, re-centres the tape), `updateBandData` (distances + needle angle `bearing − heading`, 0° = dead ahead), `selectTargetByIndex`. `renderRouteDots` / `updateWheelDistances` remain as compat wrappers.
- Story / mode: `isStoryMode`, `getActiveChapter`, `getActiveChapterProgress`, `getCurrentStoryLandmark`, `selectGamemode`, `selectChapter`, `renderChaptersList`, `updateStoryUI`, `showStoryLockedToast`, `openStoryLoreModal`, `openRewardModal`, `renderAlbumRewards`, `saveStoryState`.
- Info/audio: `openCard/closeCard`, `toggleSpeech/stopSpeech` (Web Speech API, `ro-RO`), `snapshotNow` (video → canvas), `setCmpPos/openPhoto/closePhoto`.
- Capture: `enterCaptureMode/exitCaptureMode` (toggles `#captureScreen` + `camera-clear`), `executePhotoCapture` (flash + canvas snapshot downscaled to 1280 px → `persistUserPhotos()` → localStorage + modal), `showCaptureFeedback/hideCaptureModal`, `userPhotoEntries/formatPhotoDate` (gallery helpers).
- Album: `openAlbum/closeAlbum`, `selectAlbumLandmark` (exposed on `window` for SVG `onclick`), `renderAlbum` (pins + Then/Now boxes), `renderAlbumModuleBar`/`renderLevelMap`, `guideToSelectedLandmark` (selects target, closes album). Photos live inside the compare popup (`#albumArchiveStrip`).
- AradLens API (**public, read-only**, block at ~3880): `apiRequest(path, {timeoutMs})` — shared **GET-only** fetch through `API_PREFIX = "/api"`, JSON in/out (`"json"` content-type else "răspuns neașteptat"), AbortController timeout (default off, 8 s for health), error objects `{kind: network|timeout|offline|http|server, message}` with Romanian UI text that never leaks internals (401 keeps the API's own `detail` string; `console.warn` notes unexpected statuses for debugging); `esc()` escapes API strings before innerHTML. Only public GET endpoints: `ApiHealth.check` (`/health`), `CategoriesApi.list/get`, `LocationsApi.list/get` + `locationImageUrl` (`/locations/images/{id}` — displayed as plain `<img src>`; no lazy attribute: inside `display:flex` modals lazy-load stalls), `ToursApi.list/get` (Tours embed their `locations` array). **No auth, no tokens, no POST/PUT/PATCH/DELETE, no login forms — management lives in the separate admin site.**
- API health gate: `#apiGate` (z 80 over the UI) + `runApiGate()`/`setApiGateState()` — runs at script load, loading spinner → on success hides gate → on failure shows the Romanian "Serverul AradLens nu este momentan disponibil…" message + `#apiGateRetry` ("Încearcă din nou") which re-runs the check manually; no automatic retry loop, no blank screen.
- **Preload before the first tap:** the gate's success handler also runs `preloadAppData()` — `GET /locations`, `/tours`, `/categories` in parallel, `applyApiLocations()`, image warm-up, then it pre-renders the category list, the location list, the compass band, the album module bar and the level map. The gate text reads "Se pregătesc obiectivele, traseele și albumul…" while it runs, so opening a menu never waits on a spinner.
- Public data UI: `#toursModal` (`tourCard`, `openTourDetail` via `GET /tours/{id}`, back button `#tourBackBtn`, now orphaned by the rail change), `#locationsModal` (`renderLocCards`, `openLocDetail` via `GET /locations/{id}`, category name re-fetched fresh via `GET /categories/{id}` with graceful fallback to the embedded name; `#locBackBtn` reads "← Închide" when opened standalone), `#categoriesModal` (plain read-only list). Shared helpers: `locationInfo`/`locationCard`/`tourCard`, `locationFromObjective`/`objectiveForLocation` (map an API location onto a `REPERE` entry and back), `paintLocDetail`, `openLocationPage`, `bindLongPress`, per-modal state/retry (`setXState`/`setXErrorState`), pluralized counts ("un tur", "o locație", "o categorie").

## 5. How to work on it

- Edit `index.html` directly; verify by serving the directory and opening on a phone (or desktop preview bypass). There is no build step to keep in sync.
- Liquid glass rules: exactly one `backdrop-filter` per stacking path (veils are scrims, sheets blur, sticky children get a solid fill); glass values come from the `--glass-*` tokens, never hardcoded in a new component; press/hover motion uses the `--spring*` curves. Both fallbacks (`prefers-reduced-transparency: reduce` — what Windows reports when transparency effects are off — and `@supports not (backdrop-filter)`) must keep the sheen/edge, otherwise the app looks like flat panels on those machines.
- The album's Routes band is a full-bleed static row above the scroll area; only `#albumMapTab` scrolls. It is not sticky, so the map never scrolls behind it. The band's chips scroll horizontally in one row; `scroll-padding-top` is small now that no sticky chip bar overlays the map.
- Keep the schematic-map disclaimer on the album ("Traseu schematic pe module, nu o proiecție GPS") — the level map reflects the module’s chronological order, not GPS positions.
- `index.html` is UTF-8 (CRLF, no BOM); Romanian diacritics are intact. A tool that decodes it with a legacy codepage (PowerShell `Get-Content` without `-Encoding UTF8`, some editors) shows mojibake (`ș` → `ET`, `ț` → `E>`); that is a display artifact, not corruption — read/write UTF-8 and never "fix" strings from a garbled view.
- Tuning the compass band: `BAND_SLOT` (108 px) sets stop spacing, `BAND_SAG` (26 px) the arc depth, `rotateX(13deg)` on `#snapRail` the tilt; `updateBandHalfWidth()` keeps fade/curve matched to the rail width, `renderCompassBand()` re-centres on `activeWheelIndex` after every story update.
- Adding backend later: the `/api` proxy + `apiRequest()` are in place; this site stays read-only. Content management (POST/PUT/PATCH/DELETE, uploads, tokens) is for the admin website, not this repo. Replace `USER_PHOTOS_STORAGE_KEY` persistence in `executePhotoCapture()` and the `foto`-only `renderAlbum()` Then-box with real data (locations now exist server-side); landmarks 1, 2, 4, 5 still need historic assets.
- Never call the API host directly from JS: it publishes no CORS headers (preflight 405), so cross-origin fetch fails in every browser — always go through `/api/...`. In prod that path is nginx (`deploy/nginx/default.conf` + docker-compose mount); locally run `python dev_server.py` (Start-AradLens.bat does this automatically).
