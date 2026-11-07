---
name: AradLens — Full-Bleed Feed HUD
description: Camera-first field HUD where guidance is a caption on the living street.
colors:
  ground: "#0b0e12"
  bone: "#f6f2e9"
  amber: "#e8a33d"
  amber-ink: "#171106"
  amber-deep: "#8a5f14"
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
typography:
  display:
    fontFamily: "\"AradLens Display\", \"Arial Narrow\", system-ui, sans-serif"
    fontSize: "30px"
    fontWeight: 600
    lineHeight: 1.15
    letterSpacing: "-0.02em"
  title:
    fontFamily: "\"AradLens Display\", \"Arial Narrow\", system-ui, sans-serif"
    fontSize: "24px"
    fontWeight: 600
    letterSpacing: "-0.02em"
  body:
    fontFamily: "'Segoe UI', system-ui, sans-serif"
    fontSize: "15px"
    fontWeight: 700
    lineHeight: 1.35
  label:
    fontFamily: "\"AradLens Display\", \"Arial Narrow\", system-ui, sans-serif"
    fontSize: "20px"
    fontWeight: 600
    letterSpacing: "-0.02em"
    fontFeature: "tabular-nums"
rounded:
  ring: "50%"
  caption: "12px"
  focus: "6px"
  snap: "6px"
spacing:
  rail-gap: "12px"
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
    size: "52px"
  hud-ring-capture-ready:
    backgroundColor: "{colors.scrim-ink}"
    textColor: "{colors.bone}"
    rounded: "{rounded.ring}"
    padding: "0"
    size: "52px"
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
    size: "16px radius"
  map-pin-active:
    backgroundColor: "{colors.amber}"
    textColor: "{colors.amber-ink}"
    rounded: "{rounded.ring}"
    padding: "0"
    size: "16px radius"
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
    rounded: "16px"
    padding: "0"
---

# Design System: AradLens — Full-Bleed Feed HUD

Scope: the full-bleed field HUD in `index.html` **plus every spread surface,
all converted to the same world** (near-black ground, bone type, hairline
rules, amber reserved for live/arrival/capture). Per-surface coverage:
- **Start gate** (`#start`): archive photo full-bleed under a scrim, bone
type, one amber action — flow grammar, not a navy page.
- **Desktop gate** (`#desktopPlaceholder`): same world (near-black, bone);
light theme maps to bone ground + amber-ink type.
- **Album + schematic map** (`#albumModal`, `.schematic-box`): world surface
with hairline rules; amber marks only the active pin.
- **Then/Now** (`.album-detail`, `.cmp-card`): transparent ruled cards on the
world surface; content wells carry a dashed hairline border.
- **Info card** (`#card` bottom sheet): world surface, hairline top border,
amber primary + transparent secondary actions.
- **Photo compare** (`#photoCmp`): media-dark ground, amber divider, scrim tags.
- **Capture screen + modal** (`#captureScreen`, `#captureModal`): lens scrims
stay dark; modal card is a world surface, never navy.
- **Toasts + status + compass warning** (`#proximityToast`, `#status`,
`#compassWarning`): dark by design over the lens in both themes.
- **Favicon**: near-black tile with an amber `A` (data-URI SVG).

## Overview

**Creative North Star: "The Caption on the Living Street"**

The lens owns the screen; guidance is a caption written on the living street,
not a dashboard parked over a blurred wallpaper. The camera runs full-bleed and
unfiltered edge to edge; interface is bone-white glyphs on a near-black media
ground, with exactly one amber reserved for live direction and arrival. Type is
a condensed grotesque at tight tracking for stop names; every meter is tabular
so distance never jitters while walking.

**Key Characteristics:**
- Camera full-bleed, no blur, no dimming — only thin top/bottom scrims.
- Bone glyphs are the only interface color; amber means live/arrival, nothing else.
- 52px ring rail on the right; snap dots ride the same edge; caption clears them by 68px.
- Arrival floods the caption rail amber like a postmark landing on the frame.

## Colors

One accent on a near-black ground; bone is the only interface color, amber is
the only signal.

### Primary
- **Signal Amber** (#e8a33d): live direction (chevron stroke, route step, distance
numerals) and the arrival flood. Never decorative, never disabled-state.
- **Arrival Ink** (#171106): text on the amber arrival flood only.

### Neutral
- **Media Ground** (#0b0e12): the `#cam` video element background — what shows
before the camera resolves, never a panel fill.
- **Bone** (#f6f2e9): all HUD glyphs, captions, ring strokes, hairlines-at-opacity.
- **Scrim Ink** (rgba(5,7,10)): top scrim to .68 opacity, bottom scrim to .88
opacity; ring wash at .55, edge pill at .78. One ink, varied alpha — no second black.
- **Hairline Bone** (rgba(246,242,233,.22)): 1px rules only (scrim-row divider,
edge pill border, distance-label border).

### Named Rules (optional, powerful)
**The One Amber Rule.** Amber (#e8a33d) appears only for live direction and
arrival. Its rarity is the point — if it is not steering or celebrating, it is bone.
On spread surfaces amber extends strictly to capture/arrival-adjacent states:
active map pin, primary album/capture actions, compare divider, shutter inner.

### Spread tokens (exact values from built CSS, nothing invented)
- **World Surface** (#141a21): ` --bg-surface` / `--bg-card` — album modal,
info card, toast/compass grounds, capture-modal card. Never the old navy.
- **Muted Bone** (rgba(246,242,233,.72)): `--text-muted` — card meta, map note.
- **Amber Deep** (#8a5f14): `--amber-deep` — light-theme `--accent-green`
remap so amber-on-bone keeps contrast; also the light-theme range accent.
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
- **Viewfinder Frame**: 2px dashed rgba(232,163,61,.65), 16px radius, outer
fill `0 0 0 9999px rgba(5,7,10,.15)`; shutter 72px bone over a 56px amber inner.
- **Priming Rows** (`.perm-rows`): 1px hairline top rules (+ bottom rule on
last row), 22px bone stroke icons, 17px display-strong + 13px .8-opacity span.
- **Favicon** (data-URI SVG): 64px tile #0b0e12 at 14px radius, amber `A`.

### Light lens mappings (overlays, modals, cards only)
`body.light-theme` remaps the world vars and nothing else: `--bg-main` →
#F6F2E9 (frontmatter `light-main`), `--bg-surface` → #FFFDF7, `--bg-card` →
#FFFFFF, `--bg-modal` → #F6F2E9, `--text-main` → #171106, `--text-muted` →
#4A4234 (`light-muted`), `--border-color` → rgba(23,17,6,.2), `--accent-green`
→ #8A5F14 (`amber-deep`), `--btn-*` → ink-at-alpha washes. Resting shadows
drop to ink: `2px 8px 22px rgba(23,17,6,.18)` (schematic/album) and
`rgba(23,17,6,.25)` (primary actions, capture-modal card). The start scrim
flips to a bone wash (`rgba(246,242,233,.94 → .82 → .95)`); the desktop gate
maps to bone ground + amber-ink type.

## Typography

**Display Font:** AradLens Display (self-hosted Oswald, `fonts/oswald-latin.woff2`
+ `fonts/oswald-latin-ext.woff2`, SIL OFL 1.1 per `fonts/OFL.txt`, weight range
200 700, `font-display: swap`) with Arial Narrow / system-ui fallback.
**Body Font:** system stack ('Segoe UI', system-ui, sans-serif) — display face is
names-only, body stays on the system stack for offline.
**Label/Mono Font:** no separate face; numerals use tabular figures instead.

**Character:** Condensed grotesque at tight tracking (-0.02em) for stop names and
counts; heavy tabular numerals for every meter so the distance readout holds still.

### Hierarchy
- **Display** (600, 30px, 1.15, -0.02em): stop name (`.al-name`). Caption rail only.
- **Title** (600, 24px, -0.02em): brand wordmark (`.top .brand`).
- **Label** (600, 20px, -0.02em, tabular-nums): route step (`1 / 5`).
- **Body** (700, 15px): caption meta (`.al-meta`), distance unit, separators.
- **Distance numeral** (800, 26px, line-height 1, tabular-nums, amber): `.dist .num`.
- **Caption author** (600, 17px, -0.02em): `.cap-author` line above the stop name.

### Named Rules (optional)
**The Tabular Meters Rule.** Every distance, count, and meta numeral carries
`font-variant-numeric: tabular-nums` (`.tnum` utility plus explicit declarations
on route-step, dist, al-meta, capture label). A meter readout that shifts width
while walking is a defect.

## Layout

Full-bleed camera (`#cam` fixed inset 0, `object-fit: cover`) with a flex column
overlay: thin top row (brand left, step count right), pointer-events-none center,
caption block bottom-left. The right rail (`#rail`, right 14px, top 22%, 12px gap)
and snap rail (`#snapRail`, right 12px, bottom 18%) float over the lens; caption
and scrim rows clear them with a 68px right margin. Center holds exactly one slim
chevron (72px) and nothing else; the edge-case pill (`#steerEdge`) replaces it only
when the bearing is behind the walker. Bottom scrim pads 14px 16px plus safe-area.

## Elevation & Depth

Hybrid: tonal scrims do the readability work, offset-blur shadows lift only the
glyphs and rings off the live image. No cards, no panels, no resting shadows on
surfaces — depth exists to keep bone legible over sunlit street footage.

### Shadow Vocabulary (if applicable)
- **Chevron lift** (`filter: drop-shadow(2px 6px 12px rgba(0,0,0,.55))`): keeps the
amber chevron readable over bright pavement.
- **Ring lift** (`box-shadow: 2px 6px 14px rgba(0,0,0,.5)`): every 52px rail ring
at rest; capture-ready pulses to `2px 8px 22px rgba(0,0,0,.7)` at the 1.6s
shutter keyframe midpoint.
- **Edge pill wash** (`background: rgba(5,7,10,.78)` + 1px hairline border): the
only filled HUD chip besides rings.

### Named Rules (optional)
**The Offset-Blur Rule.** Shadows are always offset down-right (2px 6–8px) with a
12–22px blur at .5–.7 black — sun-side lift, never a centered glow, never colored.

## Shapes

Circular actions, rectangular captions, pill edge-cases. Rings are perfect circles
(50%, 52px, 2px bone-at-.85 stroke over a .55 scrim wash, 22px stroke glyphs).
Caption is a 12px rectangle with a transparent-at-rest border that takes the amber
flood on arrival. Snap dots are 10px squares-at-6px-radius; the active stop
elongates to 28px tall in solid amber. Focus ring is 6px radius. Hairlines are 1px
bone-at-.22 — rules separate, they never box.

## Components

### Ring rail (signature)
- **Shape:** perfect circle (50%, 52px, 2px `rgba(246,242,233,.85)` stroke).
- **Rest:** `rgba(5,7,10,.55)` wash, bone 22px stroke glyph, ring-lift shadow.
- **Press:** scale .92. Disabled: .55 opacity. Capture-ready (≤50 m): amber border
+ 1.6s shutter pulse. Theme glyph is a 34px circle inside the rail rhythm.

### Snap rail
- **Style:** 44px transparent hit targets; 10px bone-at-.35 dots at 6px radius.
- **State:** active stop (`aria-current="true"`) elongates to 28px solid amber.

### Caption rail (signature)
- **Shape:** 12px rectangle, 10px 12px padding, transparent 1px border at rest.
- **Rest:** bone author + 30px stop name + 15px tabular meta over the bottom scrim.
- **Arrived (`body.has-arrived`):** rail floods amber; all caption text goes
amber-ink; distance numerals flip from amber to bone.

### Bottom scrim + distance row
- **Style:** `linear-gradient(0deg, rgba(5,7,10,.88), transparent)` behind the block.
- **Row:** 1px hairline top border, 10px padding; 26px/800 amber numerals with 15px
amber unit, `·` separator, step count; arrival line (19px/700 amber) hidden until arrival.

### Chevron
- **Style:** single 72px open chevron (`M18 44 L36 20 L54 44`, 6px round stroke),
amber stroke, chevron-lift shadow, .12s linear rotation tracking.

### Selection / focus / caret (system)
- **Selection:** amber ground, amber-ink text (`::selection`).
- **Focus:** 2px amber outline, 3px offset, 6px radius (`:focus-visible`).
- **Caret:** amber in all inputs.

## Stay-Dark Standing Rules (already in code)

Lens HUD + map + toasts + compare stay dark by design — bone on scrim is the
readability system over live footage, in both themes. CSS-comment locations
in `index.html`:
- **Master rule** (~line 51): `Light lens: overlays, modals and cards only.
The camera field (.top/.bottom rails, capture screen, compare view, toasts,
status, compass warning) stays dark by design`.
- **Status bar** (~line 312): amber ground + amber-ink text stays dark over
the lens in both themes.
- **Rail buttons** (~line 321): scrim pills with bone type stay dark over the
lens in both themes.
- **Compass warning** (~line 405) and **proximity toast** (~line 439): #141a21
grounds with amber borders stay dark over the lens in both themes.
- **Schematic map** (~line 486): the map stays a dark media surface in both
themes, like the lens (svg-wrap ground #0b0e12; pins #14655a, active #e8a33d
via `selectAlbumLandmark`).
- **Photo compare** (`#photoCmp`, ~line 360): media-dark ground with scrim
tags; no light-theme override exists — intentional.

## Do's and Don'ts

### Do:
- **Do** keep the camera unfiltered and full-bleed — `opacity: 1; filter: none`
on `#cam`; readability comes from the two scrims only.
- **Do** reserve amber strictly for live direction and arrival flood.
- **Do** set every meter, count, and meta numeral tabular — re-verify after any
new readout is added.
- **Do** clear the right rails with the 68px caption margin on any new bottom-row content.
- **Do** keep the OFL note with the self-hosted display face (`fonts/` + `fonts/OFL.txt`).

### Don't:
- **Don't** add panels, cards, or blur over the lens in the first viewport.
- **Don't** spend amber on decoration, branding, or disabled states.
- **Don't** add a second black or a second hairline color — vary scrim-ink alpha instead.
- **Don't** shrink rail rings below 52px or snap targets below 44px (field a11y floor).
- **Don't** light-theme the stay-dark set (lens rails, capture screen,
compare view, toasts, status, compass warning, schematic map ground) — the
master light-lens comment (~line 51) reserves the light lens for overlays,
modals, and cards only.
