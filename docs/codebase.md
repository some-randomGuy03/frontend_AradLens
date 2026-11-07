# AradLens_frontend — codebase explanation

Tourism AR web app for Arad (Romanian-language UI). Points the phone camera at
the city, shows distance + direction to a selected landmark, lets the user view
historic info, compare 1901 vs now, and "capture" a photo when close.

No framework, no bundler, no backend. One HTML file served as static content.

## 1. Tracked files

| File | Purpose |
|---|---|
| `index.html` (3634 lines, ~162 KB) | The entire app. `<style>` in `<head>` (lines 8–989), body markup lines ~990–1471, single `<script>` lines ~1472–3633 |
| `primaria-1901.jpg` | Only historic asset. Used by `REPERE[2].foto` (Primăria Arad, 1901) |
| `docker-compose.yml` | `web: nginx:alpine`, maps repo root read-only to `/usr/share/nginx/html`, host port `8010:80` |
| `deploy.sh` | Server-side: `git pull` + `docker compose down/build/up -d` |
| `.github/workflows/deploy.yml` | On push to `main` (or manual dispatch): SSH to server and run `sudo -n $DEPLOY_PATH/deploy.sh`. Secrets: `SSH_HOST`, `SSH_USER`, `SSH_PRIVATE_KEY`, `DEPLOY_PATH`, optional `SSH_PORT` |
| `README.md` | One-line project description |

Untracked (do not commit, see `.gitignore`): `.agents/`, `.codex/hooks.json`,
`.impeccable/config.local.json`, `skills-lock.json`, `.github/agents|hooks|skills/`,
and two `Mobile*isDesktop*` files (accidental `man less` dumps, 1.6 KB / 16 KB).

## 2. `index.html` — UI layers (bottom to top)

1. `<video id="cam">` — live camera background. Blurred/dim by default (`opacity .28, blur(6px)`), class `camera-clear` removes the filter in capture mode.
2. `#overlay` — main AR HUD: `.top` (brand `AradLens`, `#routeStep` + `#compassWarningBadge`, `#storyObjectiveBanner`/`#storyObjectiveText`, `#diag` debug readout), `.center` (`#steerArrow` chevron + `#steerEdge` degree readout when the target is behind), `#rail` action rings (`#detailsBtn`, `#photoCaptureBtn`, `#albumBtn`, `#gamemodeRailBtn` + `#railModeDot` state dot, `#themeToggleBtn`), `#captureDistLabel`, `.bottom`: `#caption`/`#arLabel` (target name, "Mergi spre …" phrase, distance), `#distNum` + `#routeStepBottom`, `#coords`/`#flipBtn` (debug only), `.hint` and `#snapRail` — the bottom **compass band** (curved, draggable stop selector; see §4).
3. Overlays (hidden by default): `#start` (permission gate + `#startBtn`), `#desktopPlaceholder` (+ `#desktopPreviewBtn` bypass), `#gamemodeModal` (`#selectStoryModeCard` / `#selectFreeModeCard`), `#chapterModal` (`#chaptersList`), `#storyLoreModal` (`#loreStepBadge`, `#loreStoryText`), `#rewardModal` (`#diplomaRewardName`, `#rewardNextChapterBtn`, `#rewardViewAlbumBtn`), `#compassWarning`, `#proximityToast` (`#toastCaptureBtn`), `#captureScreen` (`#shutterBtn`, `#cancelCaptureBtn`), `#captureFlash`, `#captureModal`, `#card` (info + `#speakBtn` TTS + `#photoBtn`), `#photoCmp` (1901/now slider: `canvas#cmpNow`, `img#cmpOld`, `input#cmpRange`), `#albumModal` (vertical linear level map in modules: `#albumModuleBar` chips, stop nodes rendered into `#albumLevelTrack` by `renderLevelMap()`, first stop at the bottom, scroll upward) + `#albumCompareModal` (Then/Now cards `#albumThenBox`/`#albumNowBox` popup, opened by tapping a stop), `#arLabel` floating AR tag, `#albumBtn` / `#photoCaptureBtn` FABs, `#status` bar.

Theming: CSS variables on `:root` + `body.light-theme` override. Persisted in `localStorage["aradlens_theme"]` via `applyTheme()` / `toggleTheme()`.

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
landmark. Coordinates are static OSM/Wikipedia approximations (comment in
source says verify on-site). To add a landmark: append to `REPERE`, add a
the linear album map (it renders all stops from `REPERE` directly; `renderAlbumCompare()` fills the Then/Now popup), and give it `foto`/`descriere` if it
needs info/compare features.

Photos users take are stored in `localStorage["aradlens_user_photos"]` as
`{ [nume]: { dataUrl, timestamp } }` (`USER_PHOTOS_STORAGE_KEY`). No backend —
capture modal explicitly says permanent album save "will be available later".

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
- Capture: `enterCaptureMode/exitCaptureMode` (toggles `#captureScreen` + `camera-clear`), `executePhotoCapture` (flash + canvas → localStorage + modal), `showCaptureFeedback/hideCaptureModal`.
- Album: `openAlbum/closeAlbum`, `selectAlbumLandmark` (exposed on `window` for SVG `onclick`), `renderAlbum` (pins + Then/Now boxes), `guideToSelectedLandmark` (selects target, closes album).

## 5. How to work on it

- Edit `index.html` directly; verify by serving the directory and opening on a phone (or desktop preview bypass). There is no build step to keep in sync.
- Keep the schematic-map disclaimer on the album ("Traseu schematic pe module, nu o proiecție GPS") — the level map reflects the module’s chronological order, not GPS positions.
- `index.html` is UTF-8 (CRLF, no BOM); Romanian diacritics are intact. A tool that decodes it with a legacy codepage (PowerShell `Get-Content` without `-Encoding UTF8`, some editors) shows mojibake (`ș` → `ET`, `ț` → `E>`); that is a display artifact, not corruption — read/write UTF-8 and never "fix" strings from a garbled view.
- Tuning the compass band: `BAND_SLOT` (108 px) sets stop spacing, `BAND_SAG` (26 px) the arc depth, `rotateX(13deg)` on `#snapRail` the tilt; `updateBandHalfWidth()` keeps fade/curve matched to the rail width, `renderCompassBand()` re-centres on `activeWheelIndex` after every story update.
- Adding backend later: replace `USER_PHOTOS_STORAGE_KEY` persistence in `executePhotoCapture()` and the `foto`-only `renderAlbum()` Then-box with real API calls; landmarks 1, 2, 4, 5 still need historic assets.
