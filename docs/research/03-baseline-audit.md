# 03 — AradLens Baseline Audit (pre-redesign PASS/FAIL rubric)

**Audited commit/worktree:** `0783e08` + uncommitted working tree (Fraunces font swap, `#gameModeBadge` removed, forced-free entry mode already applied — see §0).
**Subject:** `index.html` (3722 lines) — `<style>` 9–1070, markup 1072–1548, `<script>` 1550–3720.
**Baseline date:** 2026-10-22.
**Companion:** `docs/research/03-baseline-checklist.md` (57 binary assertions, the machine-checkable rubric).

> This file is the **PASS/FAIL rubric** for the visual-redesign loop. A later worker+checker iteration edits `index.html` and must not regress any item below. The two "already applied" changes in §0 are intentional and must **not** be reverted.

---

## 0. Baseline state (intentional, do not revert)

| # | Change | Where | Notes |
|---|---|---|---|
| B-1 | Top-bar chapter chip `#gameModeBadge` **deleted** | grep `gameModeBadge` → 0 hits in `index.html` | Mode/chapter state moved to `#railModeDot` on `#gamemodeRailBtn` + that button's `title`/`aria-label`. |
| B-2 | Entry mode forced to `"free"` | `index.html:1729` `storyState.currentMode = "free";` | Must stay **after** the `localStorage` parse block (1706–1725). See fragile-code map §F-06. |

Verified intact in the baseline:
- `#railModeDot` exists — `index.html:1433`; toggled by `.rail-state-dot.is-story` (`index.html:188`) and `updateStoryUI()` (`index.html:1898`, `1913`).
- `gamemodeRailBtn` `title`/`aria-label` rewritten per mode — `index.html:1900–1901` (story) / `1915–1916` (free).

---

## 1. Method & measurement model

**Tooling note.** The browser toolchain was unavailable for this pass (`[browser.disconnected] — no desktop browser is connected to this session`; retried 3×). Every number below is therefore **computed from the source CSS/JS**, not read from a live DOM. The model is fully specified so a checker can reproduce it byte-for-byte and so no claim is unverifiable.

**Contrast model (WCAG 2.1).**
1. Resolve each layer's alpha by compositing over its real parent surface (not over white).
2. Composite the foreground (with its alpha / `opacity`) over the resolved background.
3. `L = 0.2126·R + 0.7152·G + 0.0722·B` on linearised sRGB; `ratio = (L_hi + .05)/(L_lo + .05)`.
4. Text threshold **4.5:1** (normal), **3:1** for non-text UI components and ≥24px / ≥18.66px-bold.

**Lens-text model (camera is unbounded).** `#cam` is full-bleed live video. The bottom scrim is `linear-gradient(0deg, rgba(5,7,10,.88), rgba(5,7,10,0))` over the `.bottom` block (≈304 px tall on 390×844), so scrim alpha at a row `d` px above the bottom edge is `α = 0.88·(1 − d/304)`. Worst case = white pavement (`#ffffff`), best case = black (`#000000`). Every HUD row is reported as a **range** — that range *is* the finding: the HUD has **no contrast floor over live footage**.

---

## 2. Findings (narrative, ranked)

### F-1 — The HUD has no contrast floor over live footage (highest impact)
The bottom scrim's alpha is `0` at the top of `.bottom` and `.88` only at the very bottom edge — but the bottom edge is where the compass band lives, while the **primary guidance text sits in the weakest part of the scrim**.

| Element | Selector | scrim α | white pavement | black frame |
|---|---|---|---|---|
| `.al-name` 26px bone (stop name) | `index.html:301` | .10 | **1.01:1 FAIL** | 18.75:1 |
| `.al-meta` 15px bone (distance/phrase) | `index.html:305` | .10 | **1.01:1 FAIL** | 18.75:1 |
| `.cap-author` 16px bone | `index.html:293` | .10 | **1.13:1 FAIL** | 18.72:1 |
| `.dist .num` 26px amber (distance numeral) | `index.html:322` | .47 | **1.67:1 FAIL** | 9.83:1 |
| `.hint` 12px bone `opacity:.75` | `index.html:437` | .54 | **2.29–2.92:1 FAIL** | 10.20:1 |
| `.cb-name` 10px bone `opacity:.82` | `index.html:254` | .67 | **4.31:1 FAIL (10px ⇒ needs 4.5)** | 12.16:1 |
| `.cb-name` current stop, amber | `index.html:269` | .67 | **2.93:1 FAIL** | 9.77:1 |
| `.cb-dist` 10px bone `opacity:.55` | `index.html:260` | .83 | **3.58:1 FAIL (10px ⇒ needs 4.5)** | 5.71:1 |
| `.route-step` 18px/600 amber (top bar) | `index.html:134` | .68 (top scrim) | **3.49:1 FAIL** (18px/600 is *not* "large") | 9.75:1 |
| `.brand` 22px bone (top bar) | `index.html:127` | .68 | 6.55:1 pass | 18.28:1 |

`DESIGN.md` states the premise: *"Camera full-bleed, no blur, no dimming … readability comes from the two scrims only."* The scrims are correct **in shape** but the alpha ramp is tuned for the band, not for the caption. Under sunlit pavement — the app's stated operating context (`PRODUCT.md`: *"on foot, outdoors, one-handed, in sunlight"*) — the stop name and the distance numeral are effectively invisible. **A redesign that does not add a scrim/texture behind the caption block regresses nothing but also fixes nothing; a redesign that moves the caption lower silently changes every ratio in this table.**

### F-2 — No modal can be dismissed with `Escape`; no focus trap; no focus restore
`grep` over the whole file finds **zero** `Escape` handlers and **zero** focus-trap / `focus()`-on-open / focus-restore code. The only `focus()` call in the file is `btn.focus({preventScroll:true})` at `index.html:2397` (band keyboard nav).

Consequences:
- `Tab` from any open modal walks straight into the HUD behind it (`#rail` rings, `#snapRail` stops are all still tabbable — no `inert`, no `aria-hidden` swap).
- `#storyLoreModal` (`index.html:1336`) has **no close button** — only `#loreContinueBtn`, which always *commits* an action. Keyboard users cannot dismiss it without advancing the story.
- Closing a modal (`display:none`) strands focus on a hidden element → focus resets to `<body>`.
- `#card` (info sheet, `index.html:1492`) and `#photoCmp` (compare view, `index.html:1505`) carry **no** `role="dialog"` / `aria-modal` at all.

### F-3 — Live-region spam
`#humanStatus` (`index.html:1415`, `aria-live="polite"`) and `.dist` (`index.html:1477`, `aria-live="polite"`) are both rewritten **every animation frame** by `update()` (`index.html:2682`, `2706`). A screen reader will try to announce the walking distance continuously. `#routeStep` (`index.html:1403`) is also live but changes rarely — that one is fine.

### F-4 — Four touch targets below the app's own 44 px floor
`PRODUCT.md`: *"Field-first a11y floor: 44px minimum touch targets."* `DESIGN.md`: *"Don't shrink rail rings below 52px or snap targets below 44px."*

| Target | Size | Where |
|---|---|---|
| `#compassWarningBadge` | **34 × 34 px** | `index.html:547–554` |
| `.modal-close-btn` (×3: gm/chapter/…) | **36 × 36 px** | `index.html:828–833` |
| `.schematic-pin` circle (`r=16`) | **32 px diameter** | `index.html:1194–1216` |
| `.story-objective-banner` | **≈29 px tall** (`12px` font + `6px 12px` padding + `1.5px` border) | `index.html:792–799` |

Everything else passes: rail rings 52×52 (`index.html:171`), `.btn` ≥44 (`441`), `.cw-close` 44 (`539`), `.pt-close` 44 (`576`), `.card-x` 44 (`467`), `.album-close-btn` 44 (`598`), `.album-tab-btn` 44 (`1010`), `.album-action-btn` 52 (`683`), `.cs-cancel-btn` 44 (`736`), `.cs-shutter` 72 (`725`), `#startBtn` 52 (`392`), `.compass-stop` 104×68 (`230`).

### F-5 — Locked reward cards fail text contrast
`.reward-badge-card.locked { opacity: .55 }` (`index.html:1029`) dims the whole card, including its body copy:
- `.rbc-desc` (`--text-muted` @ .72) → **2.20:1 FAIL**
- `.rbc-title` (`--text-main`) → **2.84:1 FAIL**

Every other dark-theme pair passes with margin (bone/#141a21 = 15.67, amber/#0b0e12 = 9.23, amber-ink/amber = 8.69, text-muted/#141a21 = 8.58, accent-green/#141a21 = 8.36, bone/deep-teal = 6.19). Every light-theme pair passes (18.45 / 9.74 / 5.80 / 8.69 / 6.22 …). The locked-card case is the **only** in-surface text failure.

### F-6 — Hairlines are below the 3:1 non-text floor
- dark `--border-color rgba(246,242,233,.22)` on `--bg-surface #141a21` → **1.94:1**
- light `--border-color rgba(23,17,6,.2)` on `#fffdf7` / `#ffffff` → **1.55:1**
- `.btn` border `rgba(246,242,233,.35)` over its scrim → **2.93:1** (black camera) / **1.76:1** (white camera)

These are *rules*, not the sole affordance for their controls (the glyph carries it), so they are **PARTIAL**, not FAIL. But a redesign that makes a hairline the *only* boundary of a control would convert these to FAIL.

### F-7 — `env(safe-area-inset-*)` is dead on iOS
The viewport meta is `content="width=device-width, initial-scale=1.0"` (`index.html:5`) — **no `viewport-fit=cover`**. On iOS, `env(safe-area-inset-*)` returns `0` unless the viewport opts in. All 14 `env()` call sites (`index.html:120, 284, 350, 416, 433, 458, 494, 504, 507, 511, 526, 560, 587, 698`) are therefore no-ops in Safari, and the HUD sits under the notch / home indicator. Additionally `#rail` (`right:14px`), `#compassWarning` (`left/right:14px`) and `#proximityToast` (`left/right:14px`) use a **fixed** gutter and never consult `env(safe-area-inset-right)`.

### F-8 — The "68px caption clearance" rule is documentation-only
`DESIGN.md` mandates it three times (*"caption clears them by 68px"*, *"Do clear the right rails with the 68px caption margin"*, spacing token `caption-clearance: 68px`). **There is no `68px` anywhere in `index.html`.** The bottom rows survive only because they are left-aligned and the rail is 66 px wide (52 + 14 gutter). Right-aligning any bottom row, or widening the rail, silently collides.

### F-9 — The band can overlap the bottom block on short viewports
`#rail { top: 22% }` (`index.html:167`) with 5 rings × 52 px + 4 × 12 px gap = **308 px** tall. On a 320×568 viewport the rail spans y = 125 → 433 px, while `.bottom` starts at ≈264 px. There is **no landscape or short-viewport media query for the HUD** — the only media query in the file is the start-gate landscape rule (`index.html:412–428`, `max-height: 560px`). The caption/dist rows survive only because they are left-aligned and the band is the lowest element.

### F-10 — Tabular-numeral rule is only partly honoured
`DESIGN.md`: *"Every distance, count, and meta numeral carries `font-variant-numeric: tabular-nums`."* Compliant: `.dist .num`/`.unit`/`.sep` (`321–323`), `.al-meta` (`307`), `.route-step` (`137`), `.cb-dist` (`260`), `#captureDistLabel` (`200`), `.album-landmark-meta` (`646`), `.cmp-card-credit` (`673`), `.diploma-meta` (`995`), `#diag`/`#coords` (`1416`/`1483`), `.schematic-badge` (`618`), `.start-credit` (`375`).
**Violations:** `.lore-year-stamp` (20px year numeral, `index.html:923`), `#rewardsCountBadge` (count, `index.html:1164`), `.chapter-period-badge` (year range, `index.html:885`), `.chapter-number` (`881`).

### F-11 — Type floor violations in the band
`DESIGN.md`: *"Nothing drops below 12px for running text; 10px and 11px are reserved for uppercase, tracked, non-reading labels."* `.cb-name` (10px) and `.cb-dist` (10px) are **reading** text — the landmark name and its distance — not tracked micro-labels. `.cl-item` (11px), `.rbc-meta` (11px), `.diploma-meta` (11px) and `.chapter-period-badge` (11px) are also reading text below the floor.

### F-12 — Light theme: translucent "card" surfaces are invisible
`.mode-select-card` / `.chapter-card` use `background: rgba(246,242,233,.04)` — a **bone** wash hard-coded to the dark palette. In light theme it composites to `#fffdf6` on a `#fffdf7` surface → **no visual separation** (ΔL ≈ 0). Same for `.chapter-card`. Text contrast is unaffected (18.68 / 9.86 / 5.88 — all pass); it is a *surface* defect, not a contrast defect.

### F-13 — Album tab switch is not announced
`#tabMapBtn` / `#tabRewardsBtn` (`index.html:1163–1164`) are toggle buttons with `aria-pressed`, not a `role="tablist"` / `role="tab"` pair; the panels `#albumMapTab` / `#albumRewardsTab` have no `role="tabpanel"`, no `aria-labelledby`, and the swap (`switchAlbumTab`, `index.html:3318`) toggles `display` with no live region → a screen-reader user gets no confirmation that the panel changed.

### F-14 — The display face is not committed to git
`fonts/fraunces-latin.woff2` and `fonts/fraunces-latin-ext.woff2` exist on disk but are **untracked** (`git status` → `??`; `git ls-files fonts` → only `OFL.txt` + the deleted `oswald-*`). `deploy.sh` runs `git pull`, so **production would 404 the `@font-face` and silently fall back to Georgia**. `AGENTS.md` states the rule explicitly: *"must be committed or `@font-face` 404s in prod."* `fonts/OFL.txt` **is** tracked ✓.

### F-15 — Documentation drift
`docs/codebase.md:38–41` and `:45` claim *"Only Primăria has `descriere/an/arhitect/stil/foto`"*. **This is false in the current code** — all five `REPERE` entries carry `an/anNumeric/epoca/arhitect/stil/descriere/loreStory/loreSnippet` (`index.html:1559–1627`); only `foto`/`fotoCredit` are exclusive to Primăria (`index.html:1596–1597`). `targetHasInfo()` (`index.html:2504`) therefore returns true for **every** landmark, so `#detailsBtn` is enabled for all of them — the doc's claim that info card / TTS / Then-Now are Primăria-only is wrong. **Trust the code, not the doc.** (The honesty rules in §5 are still satisfied: only `foto` is missing for 4 landmarks, and those render honest placeholders.)

---

## 3. Contrast table (computed)

### 3.1 Dark theme (`body`, no `.light-theme`)

| # | Foreground | Background | Resolved bg | Ratio | Verdict |
|---|---|---|---|---|---|
| 1 | `#f6f2e9` bone | `#0b0e12` bg-main | `#0b0e12` | 17.31 | PASS |
| 2 | `#f6f2e9` bone | `#141a21` bg-surface | `#141a21` | 15.67 | PASS |
| 3 | `#f6f2e9` bone | `#0b0e12` bg-modal | `#0b0e12` | 17.31 | PASS |
| 4 | `#c8b088` amber | `#0b0e12` | `#0b0e12` | 9.23 | PASS |
| 5 | `#c8b088` amber | `#141a21` | `#141a21` | 8.36 | PASS |
| 6 | `#1c1409` amber-ink | `#c8b088` amber | `#c8b088` | 8.69 | PASS |
| 7 | `rgba(246,242,233,.72)` text-muted | `#141a21` | `#141a21` | 8.58 | PASS |
| 8 | `#c8b088` accent-green | `#141a21` | `#141a21` | 8.36 | PASS |
| 9 | `#f6f2e9` bone | `#14655a` deep-teal badge | `#14655a` | 6.19 | PASS |
| 10 | `#171106` | `#c8b088` active map pin | `#c8b088` | 8.95 | PASS |
| 11 | `#c8b088` accent-green | `.mode-select-card` `.04` over `#141a21` | `#1d2329` | 7.59 | PASS |
| 12 | `#c8b088` accent-green | `.cl-item.current` `.2` over `#141a21` | `#383836` | 5.61 | PASS |
| 13 | `#c8b088` accent-green | `.lore-next-preview` `.1` over `#141a21` | `#26292b` | 6.98 | PASS |
| 14 | `#c8b088` accent-green | `.reward-ribbon` `.15` over `#141a21` | `#2f3130` | 6.28 | PASS |
| 15 | `#f6f2e9` | `.cl-item.done` `.3` teal over `#141a21` | `#143132` | 12.47 | PASS |
| 16 | `rgba(246,242,233,.72)` | `.cmp-card-content` `.07` over `#141a21` | `#24292f` | 7.52 | PASS |
| 17 | `#f6f2e9` | `.cmp-card-content` `.07` over `#141a21` | `#24292f` | 13.11 | PASS |
| 18 | `rgba(246,242,233,.72)` | `.chapter-reward-snippet` `.25` black over `#141a21` | `#0f1419` | 8.93 | PASS |
| 19 | `#f6f2e9` | `.lore-story-box` `.05` over `#141a21` | `#1f252b` | 13.86 | PASS |
| 20 | `#c8b088` | `.lore-story-box` `.05` over `#141a21` | `#1f252b` | 7.39 | PASS |
| **21** | **`rgba(246,242,233,.72)` `.rbc-desc` locked** | **card `opacity:.55`** | `#90918f` | **2.20** | **FAIL** |
| **22** | **`#f6f2e9` `.rbc-title` locked** | **card `opacity:.55`** | `#90918f` | **2.84** | **FAIL** |
| 23 | `#1c1409` amber-ink | `#c8b088` status bar | `#c8b088` | 8.69 | PASS |
| 24 | `#f6f2e9` bone | `#141a21` toast / warning / cm-card | `#141a21` | 15.67 | PASS |
| 25 | `#c8b088` toast border | `#141a21` | `#141a21` | 8.36 | PASS (non-text) |
| 26 | `#f6f2e9` | `.cs-badge` scrim `.78` | `#06090c` | 17.89 | PASS |
| 27 | `#f6f2e9` | `.btn` on lens scrim `.55` | `#080a0e` | 17.73 | PASS |
| **28** | **`rgba(246,242,233,.22)` hairline** | **`#141a21`** | `#464a4d` | **1.94** | **FAIL (non-text)** |
| **29** | **`rgba(246,242,233,.35)` `.btn` border** | **`.btn` bg `.55`** | `#7c7b78` | **2.93** | **FAIL (non-text)** |

### 3.2 Light theme (`body.light-theme`)

| # | Foreground | Background | Resolved bg | Ratio | Verdict |
|---|---|---|---|---|---|
| 30 | `#171106` text-main | `#fffdf7` bg-surface | `#fffdf7` | 18.45 | PASS |
| 31 | `#171106` text-main | `#ffffff` bg-card | `#ffffff` | 18.76 | PASS |
| 32 | `#4a4234` text-muted | `#fffdf7` | `#fffdf7` | 9.74 | PASS |
| 33 | `#4a4234` text-muted | `#ffffff` | `#ffffff` | 9.91 | PASS |
| 34 | `#7a6038` accent-green | `#fffdf7` | `#fffdf7` | 5.80 | PASS |
| 35 | `#7a6038` accent-green | `#ffffff` | `#ffffff` | 5.90 | PASS |
| 36 | `#1c1409` amber-ink | `#c8b088` primary btn | `#c8b088` | 8.69 | PASS |
| 37 | `#1c1409` amber-ink | `#f6f2e9` light start gate | `#f6f2e9` | 16.30 | PASS |
| 38 | `rgba(23,17,6,.82)` start-detail | `#f6f2e9` | `#f6f2e9` | 10.17 | PASS |
| 39 | `rgba(23,17,6,.68)` start-credit | `#f6f2e9` | `#f6f2e9` | 6.22 | PASS |
| 40 | `#7a6038` | `.cl-item.current` `.2` over `#fffdf7` | `#f4eee1` | 5.09 | PASS |
| 41 | `#4a4234` | `.cmp-card-content` `.07` over `#fffdf7` | `#fefcf6` | 9.68 | PASS |
| 42 | `#7a6038` | `.lore-story-box` `.05` over `#fffdf7` | `#fffcf6` | 5.78 | PASS |
| 43 | `#f6f2e9` bone | `#14655a` deep-teal badge | `#14655a` | 6.19 | PASS |
| 44 | `#f6f2e9` bone | `#0b0e12` schematic map ground | `#0b0e12` | 17.31 | PASS (stay-dark) |
| **45** | **`rgba(23,17,6,.2)` hairline** | **`#fffdf7`** | `#d1cec7` | **1.55** | **FAIL (non-text)** |
| **46** | **`rgba(23,17,6,.2)` hairline** | **`#ffffff`** | `#d1cfcd` | **1.55** | **FAIL (non-text)** |

### 3.3 Focus ring

| Theme | Ring | Adjacent bg | Ratio | Verdict |
|---|---|---|---|---|
| dark | `#c8b088` | lens `#0b0e12` | 9.23 | PASS |
| light | `#7a6038` | bone `#f6f2e9` | 5.28 | PASS |
| light | `#7a6038` | white `#ffffff` | 5.90 | PASS |

### 3.4 Over live camera (worst case = white pavement) — see F-1

| Element | scrim α | ratio over white | ratio over black | Verdict |
|---|---|---|---|---|
| `.al-name` 26px bone | .10 | **1.01** | 18.75 | FAIL |
| `.al-meta` 15px bone | .10 | **1.01** | 18.75 | FAIL |
| `.cap-author` 16px bone | .10 | **1.13** | 18.72 | FAIL |
| `.dist .num` 26px amber | .47 | **1.67** | 9.83 | FAIL |
| `.hint` 12px bone .75 | .54 | **2.29** | 10.20 | FAIL |
| `.cb-name` 10px bone .82 | .67 | **4.31** | 12.16 | FAIL (needs 4.5) |
| `.cb-name` current (amber) | .67 | **2.93** | 9.77 | FAIL |
| `.cb-dist` 10px bone .55 | .83 | **3.58** | 5.71 | FAIL (needs 4.5) |
| `.route-step` 18px amber (top) | .68 | **3.49** | 9.75 | FAIL |
| `.brand` 22px bone (top) | .68 | 6.55 | 18.28 | PASS |

---

## 4. Keyboard & ARIA detail

### 4.1 Keyboard inventory

| Element | Reachable | Operable | Notes |
|---|---|---|---|
| `#startBtn` | ✓ button | ✓ | tap-gesture handler `index.html:3701` |
| `#rail` 5 rings | ✓ buttons | ✓ | `#rail .ring` 52 px, `aria-label` each |
| `#compassWarningBadge` | ✓ button | ✓ | 34 px only |
| `#snapRail` stops | ✓ buttons | ✓ click | `aria-label` + `aria-current` set in `updateBandData()` `index.html:2333`, `2283` |
| `#snapRail` arrow keys | ✓ | ✓ | `index.html:2382–2399`; Left/Right/Up/Down, clamped at both ends, skips locked steps, moves focus to the new stop |
| `#snapRail` Home/End | ✓ | **✗** | not implemented |
| Schematic map pins | ✓ `tabindex="0" role="button"` | ✓ Enter/Space | `index.html:3539–3547`; **Safari SVG2 `tabindex` support** is the risk |
| Album tabs | ✓ buttons | ✓ | `aria-pressed`, no `role="tab"` |
| `#cmpRange` | ✓ native range | ✓ | `aria-label` `index.html:1516` |
| All modals | ✓ | ✓ **except** `#storyLoreModal` (no close button, `index.html:1336–1364`) | |
| `Escape` to close | — | **✗ everywhere** | zero handlers |
| Focus trap | — | **✗ everywhere** | |
| Focus restore on close | — | **✗ everywhere** | |

### 4.2 ARIA inventory

Present and correct: `html lang="ro"` (`:2`); `nav#rail aria-label` (`:1426`); `role="group" aria-label` on `#snapRail` (`:1488`); `role="dialog" aria-modal="true" aria-labelledby` on `#captureModal` (`:1132`), `#albumModal` (`:1152`), `#gamemodeModal` (`:1267`), `#chapterModal` (`:1316`), `#storyLoreModal` (`:1336`), `#rewardModal` (`:1367`) — **every `aria-labelledby` target exists**; `role="status"` on `#status` (`:1521`); `role="alert"` on `#compassWarning` (`:1082`) and `#proximityToast` (`:1096`); `aria-live` on `#routeStep` (`:1403`) and `#storyObjectiveText` (`:1412`); `aria-current` on band stops; `aria-hidden` on every decorative SVG and on `#steerEdge`, `#captureDistLabel`, `#railModeDot`; `aria-label` on every icon-only button.

Defects: `#humanStatus` and `.dist` live-region spam (§F-3); no `role="dialog"` on `#card` (`:1492`) or `#photoCmp` (`:1505`); `nav#snapRail role="group"` overrides the navigation landmark (`:1488`); album tabs are not a `tablist` and the panel swap is unannounced (§F-13); `#captureModal` combines `role="dialog"` with `aria-live="polite"` (`:1132`).

---

## 5. Content-honesty audit (non-negotiable per `PRODUCT.md`)

| Rule | Status | Evidence |
|---|---|---|
| Schematic-map disclaimer stays | **PASS** | `index.html:1220` — *"Pozițiile de pe această hartă sunt demonstrative și orientative (fără proiecție GPS reală)."*; badge `:1172` *"Hartă schematică temporară (Demo)"*; header `:1156` *"Hartă schematică demonstrativă…"* |
| The map is a demo, not GPS-projected | **PASS** | pin coords are hand-placed SVG attributes (`:1194–1216`), never derived from `REPERE[].lat/lon` |
| 1901 photo credit stays | **PASS** | `:1533` start gate, `:1597` `fotoCredit`, rendered at `:3584` (album Then-box) and `:2584` (`#cmpCredit`) |
| The 4 landmarks without archive photos show honest placeholders | **PASS** | `renderAlbum()` `:3586–3592` — *"Fotografia istorică va fi disponibilă ulterior"* / *"Arhiva fotografică pentru acest obiectiv este în curs de completare."* Only `REPERE[2].foto` exists (`:1596`) |
| No fabricated history | **PASS** | all 5 entries carry real, sourced attributes (years 1865/1874/1876/1896/1913, architects Czigler / Lechner-Pekar / Ybl / Szántay); the 4 missing items are *photos*, and they are declared missing |
| Sensor-permission priming names the sensors | **PASS** | `:1537–1543` — Cameră · Locație · Busolă + *"Prima apăsare cere permisiunea de mișcare (busola), apoi camera și locația."* |
| "No backend / local only" honesty | **PASS** | `:1545` *"Fără cont, fără server: fotografiile rămân pe telefonul tău."*; `:3199` *"(fotografiile sunt păstrate local, pe acest dispozitiv)"* |
| Storage-full honesty | **PASS** | `:3198` *"e păstrată doar pentru sesiunea curentă"* + `sessionOnly:true` flag (`:3150`) |
| 50 m capture gate is stated in the copy | **PASS** | `:3096`, `:3106`, `:3611` all say *50 m*; constant `PROXIMITY_RADIUS_METERS = 50` (`:2946`) |
| **Explicit "permanent save will come later" statement** | **FAIL** | The AGENTS.md-claimed TODO marker does not exist as text. `grep -i "TODO\|permanent\|definitiv"` over `index.html` → 0 hits. The *situation* is honestly described ("kept locally, on this device"), but a visitor is never told that a permanent album save is pending backend work. **Add one honest line; do not remove the local-only copy.** |

---

## 6. Stay-dark set (light theme must not touch it)

`DESIGN.md` "Stay-Dark Standing Rules" + the master CSS comment at `index.html:61–64`.

| Element | Light-theme override? | Verdict | Evidence |
|---|---|---|---|
| `#overlay` lens HUD (`.top`, `.bottom`, `#rail`, `#snapRail`) | none — hard-coded `var(--bone)` / `var(--amber)` | **PASS** | `:116` `color: var(--bone)`; `:170–180` `#rail .ring` hard-coded |
| `#captureScreen` | none | **PASS** | `:695–739` |
| `#photoCmp` | none | **PASS** | `:479` `background: var(--ground)`; `:497` `.cmp-tag` scrim |
| `#proximityToast` | none — `#141a21` hard-coded | **PASS** | `:559–567` |
| `#compassWarning` | none — `#141a21` hard-coded | **PASS** | `:525–532` |
| `#status` | none — `var(--amber)` ground | **PASS** | `:432–436` |
| `.schematic-svg-wrap` map ground | none — `#0b0e12` hard-coded | **PASS** | `:623–627` |
| `.cm-card` (capture modal) | **yes** — `background:#fffdf7; color:var(--amber-ink)` | **PASS** | `:758` — it is a *modal*, explicitly allowed |
| `.story-objective-banner` | **yes** — `rgba(255,253,247,.95)` + amber-ink | **PARTIAL** | `:801–803` — this is a HUD element (lives in `.top` over the lens), not a modal. `DESIGN.md` says "lens HUD … stays dark by design". Its text is `var(--amber-ink)` = `#1c1409` on a near-white pill → 15:1, so it is legible, but it is a light chip **over the lens in light theme**. Flag it, don't let the redesign add more. |

Light theme correctly light-themes: `--bg-main #f6f2e9`, `--bg-surface #fffdf7`, `--bg-card #ffffff`, `--bg-modal #f6f2e9`, `--text-main #171106`, `--text-muted #4a4234`, `--border-color rgba(23,17,6,.2)`, `--accent-green #7a6038`, `--btn-bg/border/text` ink washes (`:65–81`).

---

## 7. Fragile-code map

Legend: **why** = why it breaks; **breaks** = what visibly breaks if disturbed.

### F-A. Compass band arc math — `index.html:2072–2118`, `209–236`, `2135–2153`
`BAND_SLOT = 108` (`:2072`), `BAND_SAG = 26` (`:2073`), `bandCurveR()` = `max(320, hw²/(2·BAND_SAG))` (`:2110`), `bandDrop()` = `min(BAND_SAG·1.3, dx²/2r)` (`:2113`), `bandArcDeg()` = `atan2(dx, r)` (`:2118`), plus `transform: perspective(760px) rotateX(13deg)` + `transform-origin: 50% 100%` on `#snapRail` (`:215–216`).
- **why:** four independent constants define one curve. The reticle sits at `left:50%` (`:221`), stops are laid at `tx = step · BAND_SLOT` (`:2259`), the fade curve is `1-(adx/fade)^1.6` with `fade = max(150, hw+24)` (`:2136`, `2148`), the scale is `max(0.74, 1-adx/1100)` (`:2144`), and the visibility cut is `op < 0.05 → hidden` (`:2151`). `updateBandHalfWidth()` (`:2173`) re-derives `bandHalfWidth` from `rail.clientWidth/2` — so the arc depth is **screen-width dependent** and any change to the rail's width silently re-shapes every stop.
- **breaks:** stops drift out of alignment with the amber reticle; the fade no longer matches the visible width (stops visibly pop at the edges); distant stops fall below the `0.05` opacity cut and become `visibility:hidden` → **unreachable by keyboard**; the arc flattens or folds.

### F-B. Band DOM is fully rebuilt — `renderCompassBand()` `:2207–2264`
- **why:** `rail.innerHTML = ""` then it re-appends the reticle `<span class="cb-reticle">`, the scale ticks `<span class="cb-scale-tick">`, and one `<button class="compass-stop">` per stop. Called from `renderRouteDots()` (`:2267`), which `updateStoryUI()` calls (`:1922`). Any redesign markup placed *inside* `#snapRail` is destroyed on the next story update.
- **breaks:** injected band chrome (e.g. a redesigned tick rail, a legend, a custom cursor) vanishes on any state change; stop buttons lose any new attributes.

### F-C. Inline transform ownership — `renderBand()` `:2135–2153`
- **why:** it writes `item.el.style.transform = "translateX() translateY() rotate() scale()"` and `item.el.style.opacity` on every frame of a drag. It also *reads* `item.el.classList.contains("locked")`.
- **breaks:** any CSS `transform`/`opacity` on `.compass-stop` is silently overwritten during drag (looks fine at rest, breaks while dragging). `.compass-stop` already carries `will-change: transform` (`:235`) — stacking/paint cost if more elements get it.

### F-D. Band drag / wheel arbitration — `:2403–2488`
- **why:** `pointerdown` on the rail → `pointermove`/`pointerup` on **window** with `{passive:false}` and `e.preventDefault()` when `moved` (`:2436`); rubber-band factor `0.32` (`:2428–2429`); inertia `vel * 130` (`:2446`); `bandSuppressClickUntil = Date.now() + 320` arbitrates drag-vs-click (`:2459`).
- **breaks:** changing `touch-action` on `#snapRail`/`.compass-stop` (currently `none` at `:213`/`:93`) lets the browser pan/zoom instead of dragging → the band stops scrolling. Re-parenting the buttons out of `#snapRail` kills the drag entirely (the listener is on the rail). Adding a `click` handler that fires before `bandSuppressClickUntil` is honoured → a flick selects a stop the user never pointed at.

### F-E. Band keyboard nav — `:2382–2399`
- **why:** a single `keydown` listener **on `#snapRail`** relying on event bubbling from the stop buttons; it walks `next -= dir` to skip locked steps (`:2391`) and calls `btn.focus({preventScroll:true})` (`:2397`).
- **breaks:** re-parenting the stops, renaming `data-step`, or removing `data-step` kills arrow navigation; the "skip locked" loop can infinite-loop if `dir` sign and the lock pattern disagree; focus is moved to a `visibility:hidden` stop if the fade cut hides it.

### F-D2. Single source of truth for band state — `setWheelActiveIndex()` `:2269–2290`
- **why:** it clamps to unlocked steps, writes `aria-current` on every stop, calls `updateRouteSteps()` + `updateBandData()`, and re-centres the tape (`centerBandOnIndex` → `bandAnimate()` → `renderBand()`). `updateStoryUI()` → `renderRouteDots()` → `renderCompassBand()` → `setWheelActiveIndex()`.
- **breaks:** any reordering of that call chain desynchronises the band from `storyState` (reticle on one stop, `aria-current` on another, route counter showing a third).

### F-E2. The dial SVG is mutated by class name and by attribute — `compassDialMarkup()` `:2180–2205`, `updateBandData()` `:2309–2347`
- **why:** CSS targets `.cb-halo .cb-ring .cb-tick .cb-ahead .cb-rot .cb-tip .cb-tail .cb-hub .cb-lock`; JS writes `rotEl.setAttribute("transform", "rotate(deg 22 22)")` on `.cb-rot` and toggles `.no-dir` on the button.
- **breaks:** renaming or removing any `cb-*` class silently kills the dial's styling or the needle rotation; the needle stops pointing at the bearing; `.locked` padlock (`.cb-lock { display:none }` → `display:block`) disappears.

### F-F. `#overlay` flex column + absolutely-positioned rail — `:116–123`, `:166–202`, `:283–330`
- **why:** `#overlay` is `display:flex; flex-direction:column`; `.center { flex:1 }` absorbs the slack so `.bottom` is pinned to the viewport bottom. `#rail` and `#captureDistLabel` are `position:absolute` children of `#overlay` (not in the flex flow) → they are anchored to the **viewport**, not to `.top`/`.bottom`.
- **breaks:** adding a row to `.bottom` changes `.bottom`'s height → the scrim's alpha ramp shifts → **every ratio in §3.4 changes** (F-1). Adding a row to `.top` does **not** move the rail. Changing `.center { flex:1 }` to `flex:0` collapses the middle and pushes `.bottom` up under the rail.

### F-G. z-index ladder and DOM-order tie-breaks
`#cam` 0 · `#overlay` 1 · `#card` 4 · `#photoCmp` 5 · `#captureScreen` 5 · `#start` 5 · `#status` 6 · `#albumModal` 6 · `#proximityToast` 7 · `#compassWarning` 10 · `#captureFlash` 20 · `#captureModal` 25 · `.full-modal` 30 · `#desktopPlaceholder` 9999.
- **why:** equal z-index values resolve by **DOM order**, not intent — `#status` (`:1521`) paints *above* `#albumModal` (`:1152`); `#start` (`:1523`) paints above `#captureScreen` (`:1111`); `#captureModal` (25) paints *below* `.full-modal` (30).
- **breaks:** inserting any new element between two equal-z siblings flips the tie-break silently — e.g. the status bar would appear over the album, or the capture modal would be covered by the story-lore modal.

### F-H. `.modal-card` sizing — `:811–817`
`max-width: 440px`; `.modal-card.wide { max-width: 520px }`; `max-height: 90vh; overflow-y: auto; overscroll-behavior: contain`.
- **why:** `.wide` is applied only to `#gamemodeModal` (`:1268`) and `#chapterModal` (`:1317`); the base width still governs the other three. `90vh` is not `90dvh` → on mobile browsers with collapsing chrome the card can exceed the visible viewport.
- **breaks:** changing the base `max-width` silently resizes the "wide" modals too (and vice-versa); the story-lore / reward cards overflow on short phones.

### F-I. The 68 px caption clearance — **documentation only**
`DESIGN.md` mandates it 3×; `index.html` contains **no `68px`**. The bottom rows survive only because `.dist`/`.caption`/`.hint` are left-aligned and `#rail` occupies exactly `right:14px` + 52 px = 66 px.
- **breaks:** right-aligning any bottom row, widening a ring, or moving the rail → text runs under the rings on a phone in sunlight.

### F-J. `storyState` persistence — `:1694–1735`
- **why:** `Object.assign(storyState, parsed)` merges the persisted blob wholesale; the per-chapter normalisation loop (`:1712–1722`) sanitises `currentStep`/`completed`/`photos`; **`:1729 storyState.currentMode = "free";`** is the intentional "entry is always free" rule and must stay *after* the parse. `saveStoryState()` is called from `selectGamemode` (`:1939`), `selectChapter` (`:1956`) and `executePhotoCapture` (`:3176`).
- **breaks:** moving `:1729` above the parse re-enables booting in Story mode (reverts B-2); dropping a `saveStoryState()` call loses chapter progress, rewards and `prog.photos`; renaming a localStorage key silently resets user data.

### F-K. `applyTheme()` — `:1820–1835`
- **why:** the light theme is a **class on `<body>`** that remaps CSS custom properties only (`:65–81`). `applyTheme()` toggles the class, updates `<meta name="theme-color">` and swaps the sun/moon icons by **inline `style.display`** (`:1829–1830`); the icons' initial states are inline in the markup (`:1450`, `:1461`).
- **breaks:** a new colour written as a literal hex instead of a variable **will not switch themes**. Removing the inline `display:none` on `#themeIconSun` shows both icons at once. `currentTheme` is initialised from `localStorage["aradlens_theme"]` (`:1812–1818`) — renaming that key resets the user's theme.

### F-L. LocalStorage keys — `aradlens_theme` (`:1812`), `aradlens_user_photos` (`:3031`), `aradlens_story_state` (`:1694`)
- **why:** `aradlens_user_photos` holds the user's **captured photos** as data URLs; the quota fallback (`:3138–3153`) re-writes the entry with `sessionOnly: true` when `setItem` throws and the UI then says "kept only for the current session" (`:3198`).
- **breaks:** renaming the key deletes every captured photo; dropping the `sessionOnly` flag makes the app claim a permanence it does not have (honesty regression).

### F-M. The start-gate no-scroll contract — `:337–428`
`.start-inner { min-height: 100dvh; display:flex; flex-direction:column; gap: clamp(10px,2.2vh,20px) }` with `margin-top:auto` on **both** `.start-head` (`:359`) and `.start-foot` (`:378`); `#start { overflow-y: auto }` is the safety net (`:339`).
- **why:** the two `auto` margins **split** the free space — removing either one throws the copy to one extreme; growing any copy block pushes the CTA below the fold, which the design forbids at 320×568 / 360×740 / 390×844 / 412×915 / 1440×900.
- **breaks:** CTA off-screen at thumb height; the whole "flow grammar" premise of the gate collapses. The landscape two-column switch lives in a single media query (`:412–428`, `max-height:560px`) — editing the copy can break only the landscape branch.

### F-N. The schematic map's colours are set by **attribute**, not CSS — `renderAlbum()` `:3553–3572`
`pin.setAttribute("fill", "#c8b088" | "#14655a")`, `setAttribute("stroke", …)`, `setAttribute("stroke-width", …)` on every `renderAlbum()` call.
- **why:** any CSS change to `.schematic-pin` (`:629`) is **overridden by the JS attribute writes** the next time the album renders.
- **breaks:** restyling the pins in CSS appears to work in dev and reverts in the app; the active/inactive pin distinction can vanish. The pin coordinates are hand-placed SVG coordinates (`:1194–1216`) and must stay in sync with the disclaimer at `:1220`.

### F-O. `#cam` + `html,body { overflow:hidden }` — `:84`, `:106–110`
- **why:** the document can never scroll; the camera is `position:fixed; inset:0; object-fit:cover; opacity:1; filter:none`. `filter:none` is a **deliberate** departure from the older blurred camera (`DESIGN.md`: *"Do keep the camera unfiltered and full-bleed"*).
- **breaks:** re-adding `filter: blur()`/`opacity` breaks the design contract; removing `overflow:hidden` makes the camera's fixed layer scroll with the page and reveals a gap.

### F-P. `@font-face` + the `fonts/` directory — `:14–25`
- **why:** the family alias is `"AradLens Display"` and `--display` (`:40`) references it; ~15 rules hard-code `var(--display)`. `font-display: swap` (`:17`, `:24`) means the fallback (Georgia) renders first — so a 404 is **silent**. The two woff2 files are **untracked in git** (F-14) → `deploy.sh`'s `git pull` would not deliver them.
- **breaks:** production silently falls back to Georgia (no visual error, but the whole "archival serif" identity disappears) — and `fonts/OFL.txt` must travel with them.

### F-Q. The desktop gate — `checkDeviceType()` `:1851–1873`
`isMobile = hasTouch && innerWidth <= 1024`; `#desktopPlaceholder` is `z-index: 9999` (`:771`) and is removed **only** by `#desktopPreviewBtn` (`:1865–1868`).
- **why:** the gate keys off `pointer:coarse` / `maxTouchPoints` — a touch laptop or an iPad in desktop mode lands on the wrong branch; the bypass button is the only escape and there is no URL flag for it.
- **breaks:** the HUD is unreachable on touch-capable desktops; any new full-screen overlay with a z-index below 9999 is hidden behind the placeholder.

### F-R. The 50 m proximity gate — `PROXIMITY_RADIUS_METERS` `:2946`, `checkLandmarkProximity()` `:2985–2998`
- **why:** the constant is a **product promise repeated in four pieces of copy** (`:3096`, `:3106`, `:3611`, plus the toast at `:2968`). `notifiedLandmarksInSession` (`:2949`) suppresses repeat toasts for the whole session — so a landmark never re-notifies even after walking away and back.
- **breaks:** changing the constant desynchronises the code from the copy; clearing the set changes field behaviour (repeat toasts).

### F-S. The global `:focus-visible` rule — `:88`
`outline: 2px solid var(--accent-green); outline-offset: 3px; border-radius: 6px;`
- **why:** it is a **global** rule with no per-component override, so it is the only focus affordance in the app. `var(--accent-green)` flips to `#7a6038` in light theme (9.23:1 / 5.28:1 — both fine). `#snapRail` has `overflow: clip` (`:212`), so the ring on an off-centre stop is **clipped by the rail**.
- **breaks:** a redesign that adds `outline: none` anywhere without re-supplying a focus indicator breaks the only keyboard affordance; the band ring needs `overflow: visible` or an inner ring.

### F-T. `update()` writes to three live regions every frame — `:2663–2710`
`$("#humanStatus").textContent = …` (`:2682`) and `#distNum`/`#distUnit` (`:2706`) run on every `requestAnimationFrame` tick while walking; `#diag` also updates in debug mode (`:2686`).
- **why:** `#humanStatus` is `aria-live="polite"` (`:1415`) and `.dist` is `aria-live="polite"` (`:1477`).
- **breaks:** screen-reader users get a continuous stream of distance announcements (F-3); any redesign that adds a third live region compounds it. Throttling is the fix, but it changes when the value updates.

---

## 8. What a redesign MUST NOT break (short list, derived from §3–§7)

1. The 68 px caption clearance contract (`DESIGN.md`) — implement it explicitly this time.
2. The stay-dark set (§6) — lens HUD, capture screen, compare view, toasts, status, compass warning, schematic map ground.
3. All honesty strings (§5), including the missing "permanent save pending backend" line.
4. `#railModeDot` + `gamemodeRailBtn` `title`/`aria-label` as the mode indicator (B-1) and `storyState.currentMode = "free"` (B-2).
5. The band arc constants and its DOM contract (§F-A…F-E).
6. The 44 px / 52 px floors (§F-4) — every floor violation above should be *fixed*, not preserved.
7. `tabular-nums` on every meter (§F-10).
8. The focus ring (§F-S) and the compass band's arrow-key navigation (§F-E).
9. `fonts/` must be committed (F-14) and `fonts/OFL.txt` must travel with them (F-P).
