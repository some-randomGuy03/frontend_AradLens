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
- Camera full-bleed, no blur, no dimming — only thin top/bottom scrims.
- Bone glyphs are the only interface color; beige means live/arrival, nothing else.
- 52px ring rail on the right; snap dots ride the same edge; caption clears them by 68px.
- Arrival floods the caption rail beige like a postmark landing on the frame.

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
caption block bottom-left. The right rail (`#rail`, right 14px, top 22%, 12px gap)
and snap rail (`#snapRail`, right 12px, bottom 18%) float over the lens; caption
and scrim rows clear them with a 68px right margin. Center holds exactly one slim
chevron (72px) and nothing else; the edge-case pill (`#steerEdge`) replaces it only
when the bearing is behind the walker. Bottom scrim pads 14px 16px plus safe-area.

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

Hybrid: tonal scrims do the readability work, offset-blur shadows lift only the
glyphs and rings off the live image. No cards, no panels, no resting shadows on
surfaces — depth exists to keep bone legible over sunlit street footage.

### Shadow Vocabulary (if applicable)
- **Chevron lift** (`filter: drop-shadow(2px 6px 12px rgba(0,0,0,.55))`): keeps the
beige chevron readable over bright pavement.
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
Caption is a 12px rectangle with a transparent-at-rest border that takes the beige
flood on arrival. Snap dots are 10px squares-at-6px-radius; the active stop
elongates to 28px tall in solid beige. Focus ring is 6px radius. Hairlines are 1px
bone-at-.22 — rules separate, they never box.

## Components

### Ring rail (signature)
- **Shape:** perfect circle (50%, 52px, 2px `rgba(246,242,233,.85)` stroke).
- **Rest:** `rgba(5,7,10,.55)` wash, bone 22px stroke glyph, ring-lift shadow.
- **Press:** scale .92. Disabled: .55 opacity. Capture-ready (≤200 m): beige border
+ 1.6s shutter pulse. Theme glyph is a 34px circle inside the rail rhythm.

### Snap rail
- **Style:** 44px transparent hit targets; 10px bone-at-.35 dots at 6px radius.
- **State:** active stop (`aria-current="true"`) elongates to 28px solid beige.

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
- **Schematic map** (~line 581): the map stays a dark media surface in both
themes, like the lens (svg-wrap ground #0b0e12; pins #14655a, active #c8b088
via `selectAlbumLandmark`).
- **Photo compare** (`#photoCmp`, ~line 474): media-dark ground with scrim
tags; no light-theme override exists — intentional.

## Do's and Don'ts

### Do:
- **Do** keep the camera unfiltered and full-bleed — `opacity: 1; filter: none`
on `#cam`; readability comes from the two scrims only.
- **Do** reserve beige strictly for live direction and arrival flood.
- **Do** set every meter, count, and meta numeral tabular — re-verify after any
new readout is added.
- **Do** clear the right rails with the 68px caption margin on any new bottom-row content.
- **Do** keep the OFL note with the self-hosted display face (`fonts/` + `fonts/OFL.txt`).
- **Do** keep the start gate scroll-free in the shipped sizes; re-check
320×568, 360×740, 390×844 and 1440×900 after any copy change.

### Don't:
- **Don't** add panels, cards, or blur over the lens in the first viewport.
- **Don't** spend beige on decoration, branding, or disabled states.
- **Don't** add a second black or a second hairline color — vary scrim-ink alpha instead.
- **Don't** shrink rail rings below 52px or snap targets below 44px (field a11y floor).
- **Don't** light-theme the stay-dark set (lens rails, capture screen,
compare view, toasts, status, compass warning, schematic map ground) — the
master light-lens comment (~line 63) reserves the light lens for overlays,
modals, and cards only.
- **Don't** reintroduce a condensed grotesque with negative tracking — the
display face is now a serif and the tracking stays near-neutral.
