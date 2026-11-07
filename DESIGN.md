---
name: AradLens — Full-Bleed Feed HUD
description: Camera-first field HUD where guidance is a caption on the living street.
colors:
  ground: "#0b0e12"
  bone: "#f6f2e9"
  amber: "#c8b088"
  amber-ink: "#1c1409"
  amber-deep: "#7a6038"
  scrim-ink: "rgba(5,7,10,1)"
  hairline: "rgba(246,242,233,.22)"
  deep-teal: "#14655a"
  world-surface: "#141a21"
  text-muted: "rgba(246,242,233,.72)"
  river: "#1f6f65"
  map-grid: "rgba(246,242,233,0.06)"
  cmp-well: "rgba(246,242,233,.07)"
  veil: "rgba(0,0,0,.7)"
  flash: "#fff"
  light-main: "#f6f2e9"
  light-surface: "#fffdf7"
  light-card: "#ffffff"
  light-muted: "#4a4234"
  light-hairline: "rgba(23,17,6,.2)"
  glass-tint: "rgba(18,23,30,.46)"
  glass-tint-thick: "rgba(16,20,27,.7)"
  glass-solid: "rgba(17,22,29,.95)"
  glass-edge: "rgba(255,255,255,.16)"
  glass-sheen: "linear-gradient(158deg, rgba(255,255,255,.2) 0%, rgba(255,255,255,.06) 24%, rgba(255,255,255,0) 50%, rgba(255,255,255,.05) 78%, rgba(255,255,255,.13) 100%)"
  glass-blur: "26px"
  glass-saturate: "185%"
  optic-warm: "rgba(255,198,148,.55)"
  optic-cool: "rgba(148,212,255,.5)"
  optic-violet: "rgba(198,168,255,.42)"
typography:
  display:
    fontFamily: "\"AradLens Display\", Georgia, \"Times New Roman\", serif"
    fontSize: "26px"
    fontWeight: 600
    lineHeight: 1.12
    letterSpacing: "-0.005em"
  title:
    fontFamily: "\"AradLens Display\", Georgia, \"Times New Roman\", serif"
    fontSize: "22px"
    fontWeight: 600
    letterSpacing: "-0.005em"
  stat:
    fontFamily: "\"AradLens Display\", Georgia, \"Times New Roman\", serif"
    fontSize: "20px"
    fontWeight: 600
    letterSpacing: "-0.005em"
  headline:
    fontFamily: "\"AradLens Display\", Georgia, \"Times New Roman\", serif"
    fontSize: "19px"
    fontWeight: 600
  label:
    fontFamily: "\"AradLens Display\", Georgia, \"Times New Roman\", serif"
    fontSize: "18px"
    fontWeight: 600
    letterSpacing: "0.02em"
    fontFeature: "tabular-nums"
  action:
    fontFamily: "'Segoe UI', system-ui, sans-serif"
    fontSize: "17px"
    fontWeight: 800
  subhead:
    fontFamily: "\"AradLens Display\", Georgia, \"Times New Roman\", serif"
    fontSize: "16px"
    fontWeight: 600
  body:
    fontFamily: "'Segoe UI', system-ui, sans-serif"
    fontSize: "15px"
    fontWeight: 700
    lineHeight: 1.35
  body-sm:
    fontFamily: "'Segoe UI', system-ui, sans-serif"
    fontSize: "14px"
    fontWeight: 700
  caption:
    fontFamily: "'Segoe UI', system-ui, sans-serif"
    fontSize: "13px"
    fontWeight: 600
  fine:
    fontFamily: "'Segoe UI', system-ui, sans-serif"
    fontSize: "12px"
    fontWeight: 400
  tag:
    fontFamily: "'Segoe UI', system-ui, sans-serif"
    fontSize: "11px"
    fontWeight: 800
    letterSpacing: "1px"
  overline:
    fontFamily: "\"AradLens Display\", Georgia, \"Times New Roman\", serif"
    fontSize: "10px"
    fontWeight: 600
    letterSpacing: "0.02em"
  icon-hero:
    fontFamily: "\"Apple Color Emoji\", \"Segoe UI Emoji\", sans-serif"
    fontSize: "64px"
    fontWeight: 400
  icon-lg:
    fontFamily: "\"Apple Color Emoji\", \"Segoe UI Emoji\", sans-serif"
    fontSize: "36px"
    fontWeight: 400
  icon-md:
    fontFamily: "\"Apple Color Emoji\", \"Segoe UI Emoji\", sans-serif"
    fontSize: "32px"
    fontWeight: 400
rounded:
  ring: "50%"
  caption: "12px"
  focus: "6px"
  snap: "6px"
  chip: "8px"
  control: "10px"
  panel: "14px"
  sheet: "16px"
  pill: "20px"
  glass-panel: "22px"
  glass-sheet: "28px"
motion:
  spring: "cubic-bezier(.32, 1.18, .34, 1)"
  spring-snappy: "cubic-bezier(.30, 1.26, .38, 1)"
  spring-bouncy: "cubic-bezier(.34, 1.42, .44, 1)"
  spring-soft: "cubic-bezier(.25, .92, .28, 1)"
  press: "110ms"
  sheet: "460ms"
spacing:
  rail-gap: "9px"
  rail-right: "14px"
  rail-top: "22%"
  caption-clearance: "68px"
  bottom-pad: "14px 16px calc(20px + env(safe-area-inset-bottom)) 16px"
components:
  hud-ring:
    backgroundColor: "{colors.scrim-ink}"
    textColor: "{colors.bone}"
    rounded: "{rounded.ring}"
    padding: "0"
    size: "46px"
  hud-ring-capture-ready:
    backgroundColor: "{colors.scrim-ink}"
    textColor: "{colors.bone}"
    rounded: "{rounded.ring}"
    padding: "0"
    size: "46px"
  theme-switch:
    track: "56×30px glass capsule (56×34px hit area), blur(18px) saturate(185%), 1px white .22 edge, sheen gradient"
    knob: "24px bone disc sliding horizontally between sun (left) and moon (right) slots, spring on translateX"
    hitArea: "56×34px, role=switch + aria-checked"
  brand-lens:
    size: "27px top bar / 38px start gate"
    underlay: "primaria-1901.jpg at 230% zoom, saturate(.82) contrast(1.06)"
    overlay: "specular radial highlight + warm/cool diffraction, screen blend"
    rim: "conic warm→cool→violet at 2px, masked ring"
    sweep: "lensSweep 7s — light travels across the lens and rests"
  hud-snap-dot:
    backgroundColor: "{colors.hairline}"
    rounded: "{rounded.snap}"
    size: "10px"
  hud-snap-dot-active:
    backgroundColor: "{colors.amber}"
    rounded: "{rounded.snap}"
    size: "10px"
    height: "28px"
  hud-caption:
    backgroundColor: "{colors.scrim-ink}"
    textColor: "{colors.bone}"
    rounded: "{rounded.caption}"
    padding: "10px 12px"
  hud-caption-arrived:
    backgroundColor: "{colors.amber}"
    textColor: "{colors.amber-ink}"
    rounded: "{rounded.caption}"
    padding: "10px 12px"
  hud-dist-num:
    textColor: "{colors.amber}"
    typography: "{typography.body}"
  world-surface:
    backgroundColor: "{colors.world-surface}"
    textColor: "{colors.bone}"
    rounded: "{rounded.caption}"
    padding: "14px"
  map-pin:
    backgroundColor: "{colors.deep-teal}"
    textColor: "{colors.bone}"
    rounded: "{rounded.ring}"
    padding: "0"
    size: "32px glass node on the level map"
  map-pin-active:
    backgroundColor: "{colors.amber}"
    textColor: "{colors.amber-ink}"
    rounded: "{rounded.ring}"
    padding: "0"
    size: "32px glass node, current stop"
  glass-sheet:
    backgroundColor: "{colors.glass-tint-thick}"
    textColor: "{colors.bone}"
    rounded: "{rounded.glass-sheet}"
    padding: "18px 18px 16px"
    border: "1px {colors.glass-edge}"
    blur: "blur(26px) saturate(185%)"
  glass-panel:
    backgroundColor: "{colors.glass-tint}"
    textColor: "{colors.bone}"
    rounded: "{rounded.glass-panel}"
    padding: "14px"
    blur: "blur(20px) saturate(185%)"
  glass-chip:
    backgroundColor: "{colors.glass-tint-thin}"
    textColor: "{colors.text-muted}"
    rounded: "999px"
    padding: "7px 13px"
  glass-chip-active:
    backgroundColor: "{colors.amber}"
    textColor: "{colors.amber-ink}"
    rounded: "999px"
  toast:
    backgroundColor: "{colors.world-surface}"
    textColor: "{colors.bone}"
    rounded: "{rounded.caption}"
    padding: "12px 14px"
  cmp-card:
    backgroundColor: "transparent"
    textColor: "{colors.bone}"
    rounded: "{rounded.caption}"
    padding: "12px"
  capture-modal-card:
    backgroundColor: "{colors.world-surface}"
    textColor: "{colors.bone}"
    rounded: "{rounded.caption}"
    padding: "22px 20px"
  start-cta:
    backgroundColor: "{colors.amber}"
    textColor: "{colors.amber-ink}"
    rounded: "{rounded.caption}"
    padding: "15px 34px"
  viewfinder-frame:
    backgroundColor: "transparent"
    textColor: "{colors.amber}"
    rounded: "{rounded.sheet}"
    padding: "0"
---

# Design System: AradLens — Full-Bleed Feed HUD

Scope: the full-bleed field HUD in `index.html` **plus every spread surface,
all converted to the same world** (near-black ground, bone type, hairline
rules, beige reserved for live/arrival/capture). Per-surface coverage:
- **Start gate** (`#start`): archive photo full-bleed under a scrim, bone
type, one beige action — flow grammar, not a navy page.
- **Desktop gate** (`#desktopPlaceholder`): same world (near-black, bone);
light theme maps to bone ground + amber-ink type.
- **Album + schematic map** (`#albumModal`, `.schematic-box`): world surface
with hairline rules; beige marks only the active pin.
- **Then/Now** (`.album-detail`, `.cmp-card`): transparent ruled cards on the
world surface; content wells carry a dashed hairline border.
- **Info card** (`#card` bottom sheet): world surface, hairline top border,
beige primary + transparent secondary actions.
- **Photo compare** (`#photoCmp`): media-dark ground, beige divider, scrim tags.
- **Capture screen + modal** (`#captureScreen`, `#captureModal`): lens scrims
stay dark; modal card is a world surface, never navy.
- **Toasts + status + compass warning** (`#proximityToast`, `#status`,
`#compassWarning`): dark by design over the lens in both themes.
- **Favicon**: near-black tile with a beige `A` (data-URI SVG).

## Overview

**Creative North Star: "The Caption on the Living Street"**

The lens owns the screen; guidance is a caption written on the living street,
not a dashboard parked over a blurred wallpaper. The camera runs full-bleed and
unfiltered edge to edge; interface is bone-white glyphs on a near-black media
ground, with exactly one beige reserved for live direction and arrival. Type is
an archival serif with an optical-size axis for stop names; every meter is
tabular so distance never jitters while walking.

**Key Characteristics:**
- Camera full-bleed, no dimming; interface floats as liquid glass above it.
- Bone glyphs are the only interface color; beige means live/arrival, nothing else.
- 46px glass ring rail on the right with a horizontal sun/moon capsule at its top;
  the compass band along the bottom edge carries every objective as a stop.
- Arrival floods the caption rail beige like a postmark landing on the frame.
- Every coordinate the visitor reads is a **street**, never a latitude: the API
  ships no street field, so `streetFor()` resolves a curated table first and the
  description text second.

## Colors

One accent on a near-black ground; bone is the only interface color, beige is
the only signal.

### Primary
- **Signal Beige** (#c8b088): live direction (chevron stroke, route step, distance
numerals) and the arrival flood. Never decorative, never disabled-state.
- **Archive Ink** (#1c1409): text on the beige arrival flood only.

### Neutral
- **Media Ground** (#0b0e12): the `#cam` video element background — what shows
before the camera resolves, never a panel fill.
- **Bone** (#f6f2e9): all HUD glyphs, captions, ring strokes, hairlines-at-opacity.
- **Scrim Ink** (rgba(5,7,10)): top scrim to .68 opacity, bottom scrim to .88
opacity; ring wash at .55, edge pill at .78. One ink, varied alpha — no second black.
- **Hairline Bone** (rgba(246,242,233,.22)): 1px rules only (scrim-row divider,
edge pill border, distance-label border).

### Named Rules (optional, powerful)
**The One Beige Rule.** Beige (#c8b088) appears only for live direction and
arrival. Its rarity is the point — if it is not steering or celebrating, it is bone.
On spread surfaces beige extends strictly to capture/arrival-adjacent states:
active map pin, primary album/capture actions, compare divider, shutter inner.

### Spread tokens (exact values from built CSS, nothing invented)
- **World Surface** (#141a21): `--bg-surface` / `--bg-card` — album modal,
info card, toast/compass grounds, capture-modal card. Never the old navy.
- **Muted Bone** (rgba(246,242,233,.72)): `--text-muted` — card meta, map note.
- **Deep Beige** (#7a6038): `--amber-deep` — light-theme `--accent-green`
remap so beige-on-bone keeps contrast; also the light-theme range accent and
the reward-diploma rule colour.
- **River** (#1f6f65): schematic Mureș stroke, 26px, opacity .85, round cap.
- **Map Grid** (rgba(246,242,233,0.06)): schematic grid-pattern stroke, 1px.
- **Avenue** (rgba(246,242,233,0.28)): Bd. Revoluției axis, 5px, dash `6 4`.
- **Compare Well** (rgba(246,242,233,.07)): `.cmp-card-content` fill behind a
1px dashed hairline border; card itself is transparent with a 1px solid
hairline border and a hairline title rule.
- **Veil** (rgba(0,0,0,.7)): `#captureModal` ground + `blur(4px)`.
- **Flash** (#fff): `#captureFlash` ground, peaks at opacity .9.
- **Start Scrim** (`linear-gradient(180deg, rgba(5,7,10,.84) 0%,
rgba(5,7,10,.58) 42%, rgba(5,7,10,.9) 100%)`): archive-photo legibility wash.
- **Capture Scrim** (`linear-gradient(180deg, rgba(5,7,10,.6) 0%,
rgba(5,7,10,0) 25%, rgba(5,7,10,0) 70%, rgba(5,7,10,.75) 100%)`): lens-only
top/bottom wash, clear glass in the middle.
- **Viewfinder Frame**: 2px dashed rgba(200,176,136,.65), 16px radius, outer
fill `0 0 0 9999px rgba(5,7,10,.15)`; shutter 72px bone over a 56px beige inner.
- **Sensor Row** (`.start-sensors`): 16px bone stroke icons, 12px/700 labels
separated by `·`; the note under it runs at 12px/.75 opacity.
- **Favicon** (data-URI SVG): 64px tile #0b0e12 at 14px radius, beige `A`.

### Light lens mappings (overlays, modals, cards only)
`body.light-theme` remaps the world vars and nothing else: `--bg-main` →
#F6F2E9 (frontmatter `light-main`), `--bg-surface` → #FFFDF7, `--bg-card` →
#FFFFFF, `--bg-modal` → #F6F2E9, `--text-main` → #171106, `--text-muted` →
#4A4234 (`light-muted`), `--border-color` → rgba(23,17,6,.2), `--accent-green`
→ #7A6038 (`amber-deep`), `--btn-*` → ink-at-alpha washes. Resting shadows
drop to ink: `2px 8px 22px rgba(23,17,6,.18)` (schematic/album) and
`rgba(23,17,6,.25)` (primary actions, capture-modal card). The start scrim
flips to a bone wash (`rgba(246,242,233,.94 → .82 → .95)`); the desktop gate
maps to bone ground + amber-ink type.

## Liquid Glass layer (iOS 26)

Every floating surface above the lens is one material, not a collection of
styles. The recipe, in one place (`index.html`, the block commented
`STRATUL „LIQUID GLASS"`):

| Layer | Value |
| --- | --- |
| Fill | `--glass-tint` (.46) for panels, `--glass-tint-thick` (.70) for sheets |
| Blur | `backdrop-filter: blur(26px) saturate(185%)` (sheets 26–30px, caption 22px) |
| Sheen | `--glass-sheen` — a 158° white gradient that peaks top-left and returns at the bottom edge |
| Edge | 1px `--glass-edge` (white .16 dark / white .80 light) |
| Inner light | `inset 0 1px 0 var(--glass-inner-hi)` |
| Inner shadow | `inset 0 -1px 0 var(--glass-inner-lo)` |
| Lift | `--glass-shadow` — `0 18px 48px rgba(0,0,0,.46)` + a tight 2px contact shadow |

### The One Blur Rule

**Exactly one `backdrop-filter` per stacking path.** Veils (`.full-modal`,
`#captureModal`) have none — they are plain scrims. The sheet inside them owns
the blur. `#albumModal` owns its blur; the sticky module bar inside it is
therefore *not* blurred — it is filled with `--bar-solid` plus the sheen, so it
still reads as the same material while the map scrolls beneath it.
Double-blurring is a Safari defect and burns GPU on a phone.

### Motion: Apple springs, not easings

Springs are declared once and reused:

| Token | Curve | Feels like |
| --- | --- | --- |
| `--spring` | `cubic-bezier(.32, 1.18, .34, 1)` | default — sheets, chips, level nodes |
| `--spring-snappy` | `cubic-bezier(.30, 1.26, .38, 1)` | small controls, the theme knob |
| `--spring-bouncy` | `cubic-bezier(.34, 1.42, .44, 1)` | reward medallion only |
| `--spring-soft` | `cubic-bezier(.25, .92, .28, 1)` | lens sweep, no visible overshoot |

Press feedback is 110ms scale (.92–.97) — the surface reacts before the finger
leaves. Sheets enter with `sheetIn` (opacity + 22px rise + .955 scale), level
stops with `stopIn` staggered 40ms apart from the bottom up, veils with a 260ms
opacity fade. Under `prefers-reduced-motion: reduce` every duration is zeroed by
the pre-existing global block.

### Transparency fallbacks

Two reserves keep the material honest where the effect is unavailable:

- `prefers-reduced-transparency: reduce` (what Windows reports with
  "transparency effects" off) — blur is dropped, but the sheen, the 1px edge and
  the inset highlights stay, and the fill becomes `--glass-solid`. The surface
  stops being see-through; it never stops looking like glass.
- `@supports not (backdrop-filter)` — same treatment without the media query.

### Brand lens

The wordmark carries the product metaphor: `.brand-lens` is a 27px disc (38px on
the start gate) whose **background is the archival photograph** (`primaria-1901.jpg`,
230% zoom, warmed down), with a specular white highlight and a cool/warm
diffraction overlay in `screen` blend, a 2px **chromatic rim** from a conic
gradient (warm → cool → violet), and a `lensSweep` highlight that crosses the
glass every 7 seconds. The favicon is the same idea in inline SVG (amber `A`
behind a lens ring), so the tab matches the lockup.

## Typography

**Display Font:** AradLens Display (self-hosted Fraunces, `fonts/fraunces-latin.woff2`
+ `fonts/fraunces-latin-ext.woff2`, SIL OFL 1.1 per `fonts/OFL.txt`, variable
weight range 100 900 with all four axes (`opsz`, `wght`, `SOFT`, `WONK`),
`font-display: swap`, and `SOFT`/`WONK` pinned to 0 on the `@font-face` so the
current letterforms hold while the axes stay available) with
Georgia / "Times New Roman" / serif fallback. The family alias stays
"AradLens Display" — only the matter changes.
**Body Font:** system stack ('Segoe UI', system-ui, sans-serif) — display face is
names-only, body stays on the system stack for offline.
**Label/Mono Font:** no separate face; numerals use tabular figures instead.

**Character:** Archival serif with an optical-size axis — the old-archive
"lettering" of a 1901 city plate rather than a condensed grotesque. Tracking
is near-neutral (-0.005em on display, +0.01em on the wordmark) because a
serif already carries its own width; heavy tabular numerals for every meter so
the distance readout holds still.

### Hierarchy
- **Display** (600, 26px, 1.12, -0.005em): stop name (`.al-name`). Caption rail only.
- **Title** (600, 22px, -0.005em): brand wordmark (`.top .brand`).
- **Stat** (600, 20px, -0.005em): HUD distance + arrival number, landmark name, lore year stamp.
- **Headline** (600, 19px): mode-card title, diploma name.
- **Label** (600, 18px, 0.02em, tabular-nums): route step (`1 / 5`).
- **Action** (800, 17px): start CTA, compass warning badge.
- **Subhead** (600, 16px, -0.005em): caption author, album dialog title.
- **Body** (700, 15px): caption meta (`.al-meta`), album card title, description.
- **Body-sm** (700, 14px): secondary buttons, warning title, status line.
- **Caption** (600, 13px): dialogs, album tabs, toast body, lore text.
- **Fine** (400, 12px): start copy, chips, metadata rows.
- **Tag** (800, 11px, 1px tracking): uppercase micro tags, badges, card meta.
- **Overline** (600, 10px, 0.02em): compass band slot name, diploma seal.
- **Icon-hero / -lg / -md** (400, 64 / 36 / 32px): reward medallion, reward badge, game-mode glyph.
- **Distance numeral** (800, 26px, line-height 1, tabular-nums, beige): `.dist .num`.
- **Start headline** (600, clamp(26px, 7vw, 32px), 1.08): `#start h1` — one
sentence, balanced, the only large serif on the gate.

Fluid steps interpolate only between documented rungs: brand
`clamp(19px, 5vw, 22px)`, promise `clamp(13px, 3.7vw, 15px)`, detail
`clamp(12px, 3.4vw, 14px)`, landscape headline `clamp(19px, 3vw, 26px)`, modal
title `clamp(26px, 6vw, 32px)`. Nothing drops below 12px for running text; 10px
and 11px are reserved for uppercase, tracked, non-reading labels.

### Named Rules (optional)
**The Tabular Meters Rule.** Every distance, count, and meta numeral carries
`font-variant-numeric: tabular-nums` (`.tnum` utility plus explicit declarations
on route-step, dist, al-meta, capture label). A meter readout that shifts width
while walking is a defect.

## Layout

Full-bleed camera (`#cam` fixed inset 0, `object-fit: cover`) with a flex column
overlay: thin top row (brand left, step count right), pointer-events-none center,
caption block bottom-left. The right rail (`#rail`, right 14px, top 12%, 9px gap)
floats over the lens as glass rings; the compass band (`#snapRail`) is the last
child of `.bottom` and arcs along the bottom edge. On short viewports
(630–720px tall) the rail compresses: 7px gap, 44px rings. Center holds exactly
one slim chevron (72px) and nothing else; the edge-case pill (`#steerEdge`)
replaces it only when the bearing is behind the walker. Bottom scrim pads
14px 16px plus safe-area.

### Start gate layout (no-scroll contract)
`#start` is a fixed, full-viewport column: `.start-inner` is a flex column with
`min-height: 100dvh`, `gap: clamp(10px, 2.2vh, 20px)`, and `margin-top: auto` on
both `.start-head` and `.start-foot` — so the copy floats in the middle and the
CTA pins low, at thumb height. The column fits exactly (0 px of scroll) at
320×568, 360×740, 390×844, 412×915 and 1440×900. Landscape phones
(`orientation: landscape and max-height: 560px`) switch to a two-column grid —
text left, action right — so nothing is ever clipped. Vertical scroll stays
available as a safety net (large text zoom, very short viewports) but is never
needed in the shipped sizes.

## Elevation & Depth

Hybrid: liquid glass floats above the lens, and scrims do the readability work
where there is no surface. Depth is never a generic drop shadow: each raised
element carries an inner top highlight, an inner bottom shadow, a 1px edge and
one offset ambient shadow.

### Shadow Vocabulary (if applicable)
- **Chevron lift** (`filter: drop-shadow(2px 6px 12px rgba(0,0,0,.55))`): keeps the
beige chevron readable over bright pavement.
- **Ring lift**: every rail ring at rest; capture-ready pulses at the 1.6s
  shutter keyframe midpoint.
- **Glass lift** (`--glass-shadow`): `0 18px 48px rgba(0,0,0,.46)` plus a 2px
  contact shadow; light theme swaps to `rgba(23,17,6,.18)`.
- **Edge pill wash** (`background: rgba(5,7,10,.78)` + 1px hairline border): the
only filled HUD chip besides rings.

### Named Rules (optional)
**The Offset-Blur Rule.** Shadows are always offset down — never a centered glow,
never colored, except the beige press-dot on an active chip.

## Shapes

Circular actions, rounded sheets, pill chips. Rings are perfect circles
(50%, 46px, glass with a 1px white edge) with the 56×30 horizontal sun/moon
capsule taking the first slot. Sheets are 26–28px rounded rectangles that stop
short of the viewport edge; panels 18–22px; chips fully round. The active stop
on the compass band is an amber reticle, not a fill. Hairlines are 1px at
`--glass-hairline` — rules separate, they never box.

## Components

### Ring rail (signature)
- **Shape:** perfect circle (50%, 46px) of liquid glass — 1px white edge, sheen,
  `blur(20px) saturate(185%)`, ring-lift shadow.
- **Rest:** translucent dark wash, bone 20px stroke glyph.
- **Press:** scale .92 on `--spring-snappy`. Disabled: .5 opacity. Capture-ready
  (≤200 m): beige border + 1.6s shutter pulse.
- **Slots (top to bottom):** theme capsule, game mode, details, photo, album.
  Route and location/category browsing moved out of the rail: tours live as album
  modules, and a location page opens on **long-press** of an objective.
- **Theme switch:** a horizontal 56×30px glass capsule (`#themeToggleBtn`,
  `role="switch"`, `aria-checked` kept in sync by `applyTheme`): sun slot left,
  moon slot right, a 24px bone knob that springs between them. State is
  CSS-driven from `body.light-theme`; the meta theme-color and the
  `aradlens_theme` key follow.

### Compass band (objective selector)
- **Style:** curved tape of stops (`#snapRail` + `renderCompassBand`), 108px slot
  spacing, sag + `rotateX(13deg)` for the arc, drag / wheel / arrow keys.
- **State:** amber reticle on the selected stop; story stops render `.locked`
  (padlock, not selectable), `.completed` (teal) or current (amber).
- **Content:** all objectives merged from the API in free mode; only the active
  chapter's steps in story mode.
- **Long-press (460ms):** opens the objective page (`#locationsModal`) with the
  location detail, its street and its AR guide action. A normal tap still just
  selects the stop.

### Level map (album)
- **Shape:** vertical level-select — first stop at the bottom, scroll upward;
  amber = current, teal = photographed, padlock = locked (story order).
- **Node:** 32px glass disc carrying the year (`an`) for heritage stops or the
  tour position (`Oprirea n`) for tour modules; street as the subtitle.
- **Modules:** `Liber`, `Cap. I–III`, plus every tour from the API, in one sticky
  chip bar the header never hides.

### Caption rail (signature)
- **Shape:** 12px rectangle, 10px 12px padding, transparent 1px border at rest.
- **Rest:** bone author + 26px stop name + 15px tabular meta over the bottom scrim.
- **Arrived (`body.has-arrived`):** rail floods beige; all caption text goes
amber-ink; distance numerals flip from beige to bone.

### Bottom scrim + distance row
- **Style:** `linear-gradient(0deg, rgba(5,7,10,.88), transparent)` behind the block.
- **Row:** 1px hairline top border, 10px padding; 26px/800 beige numerals with 15px
beige unit, `·` separator, step count; arrival line (19px/700 beige) hidden until arrival.

### Chevron
- **Style:** single 72px open chevron (`M18 44 L36 20 L54 44`, 6px round stroke),
beige stroke, chevron-lift shadow, .12s linear rotation tracking.

### Selection / focus / caret (system)
- **Selection:** beige ground, amber-ink text (`::selection`).
- **Focus:** 2px `--accent-green` outline, 3px offset, 6px radius
  (`:focus-visible`) — the surface accent, so the ring stays legible on bone
  surfaces in the light theme (5.3:1) and on the lens in the dark theme.
- **Caret:** `--accent-green` in all inputs, for the same reason.

## Stay-Dark Standing Rules (already in code)

Lens HUD + map + toasts + compare stay dark by design — bone on scrim is the
readability system over live footage, in both themes. CSS-comment locations
in `index.html`:
- **Master rule** (~line 63): `Light lens: overlays, modals and cards only.
The camera field (.top/.bottom rails, capture screen, compare view, toasts,
status, compass warning) stays dark by design`.
- **Status bar** (~line 426): beige ground + amber-ink text stays dark over
the lens in both themes.
- **Rail buttons** (~line 435): scrim pills with bone type stay dark over the
lens in both themes.
- **Compass warning** (~line 497) and **proximity toast** (~line 531): #141a21
grounds with beige borders stay dark over the lens in both themes.
- **Schematic map** (replaced): the old SVG pin map is gone; the album's level
  map is the only map, and it stays a dark glass surface in both themes.
- **Photo compare** (`#photoCmp`, ~line 474): media-dark ground with scrim
tags; no light-theme override exists — intentional.

## Do's and Don'ts

### Do:
- **Do** keep the camera unfiltered and full-bleed — `opacity: 1; filter: none`
on `#cam`; readability comes from the two scrims only.
- **Do** reserve beige strictly for live direction and arrival flood.
- **Do** keep exactly one `backdrop-filter` per stacking path: veils are scrims,
  sheets own the blur, and a sticky child gets a solid fill instead of a second blur.
- **Do** read every coordinate on screen as a street (`streetFor`), never as a
  latitude — the API has no street field, so curated table first, description second.
- **Do** keep press feedback at 110ms and sheet entry at 460ms on `--spring`;
  new motion should reuse a token, not invent a curve.
- **Do** set every meter, count, and meta numeral tabular — re-verify after any
  new readout is added.
- **Do** clear the compass band with the caption's bottom padding on any new
  bottom-row content.
- **Do** keep the OFL note with the self-hosted display face (`fonts/` + `fonts/OFL.txt`).
- **Do** keep the start gate scroll-free in the shipped sizes; re-check
320×568, 360×740, 390×844 and 1440×900 after any copy change.

### Don't:
- **Don't** nest `backdrop-filter` (blur inside blur) — Safari breaks and phones burn GPU.
- **Don't** spend beige on decoration, branding, or disabled states.
- **Don't** add a second black or a second hairline color — vary scrim-ink alpha instead.
- **Don't** shrink rail rings below 46px or tap targets below 44px (field a11y floor).
- **Don't** light-theme the stay-dark set (lens rails, capture screen,
compare view, toasts, status, compass warning, album level map) — the
master light-lens comment (~line 63) reserves the light lens for overlays,
modals, and cards only.
- **Don't** reintroduce a condensed grotesque with negative tracking — the
display face is now a serif and the tracking stays near-neutral.
