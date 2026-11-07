# 02 — The psychology of interface design & the craft of type, colour, motion

**AradLens research report for the UI redesign.** Agent 2 of 2 (research). Companion file:
`docs/research/02-design-psychology-summary.md` (dense digest, read that one first).

> **Read §0.4 first.** index.html was edited concurrently while this research ran.
> Every line number below was re-verified against the 3 722-line working tree; **the CSS
> selector quoted beside each number is the durable anchor.**

Everything below is either (a) sourced to a peer-reviewed paper, a standards document, or a
primary design-authority document, with the author + URL given inline, or (b) marked
**[OUR OWN MEASUREMENT]** / **[DESIGN JUDGEMENT]** where it is a computation or an opinion
derived from the sources. Where the evidence is weak or contested, it says so.

---

## Contents

0. How to use this document — ground truth, evidence legend, **three corrections to the brief**, line-number drift + anchors
1. Gestalt & perception — grouping laws, figure/ground, Prägnanz, **G1/G2/G3 resolved**, rules
2. Cognitive & behavioural science — the laws table, CLT, SDT, peak–end, testing effect, scanning patterns, rules
3. Typography craft — classification, heritage vs startup, type scale, optical sizing, variable fonts, legibility, numerals, pairing ×10, rules
4. Colour & contrast — colour psychology (and its critiques), OKLCH, WCAG 2.2, glassmorphism, a verified palette, rules
5. Motion & AR-specific — feedback vs decoration, M3 tokens, vestibular risk, magic window, parallax, billboarding, rules
6. Mobile HUD / glass craft — safe areas, thumb zones, sheets, **the compass band critiqued**, drag physics, rules
7. Humour, copy & voice — plain language, voice vs tone, anti-AI-microcopy, rules
8. Audit — 32 line-numbered violations of the above
9. Sources — full index

## 0. How to use this document

### 0.1 Ground truth — what AradLens is *today*

Measured directly from `index.html` and `fonts/` (not from `DESIGN.md`, which is a design
intent doc and in two places disagrees with the code).

**Files**

| Path | Fact |
|---|---|
| `index.html` | **3 722 lines** (see §0.4 — edited concurrently during this research). `<style>` = 9–1070. Body = 1072–1548. Single `<script>` = 1550–3722. UTF-8, CRLF, no BOM. |
| `fonts/fraunces-latin.woff2` | 59 388 B. Real family name **`Fraunces`**. |
| `fonts/fraunces-latin-ext.woff2` | 67 304 B. Same family, Latin‑Ext subset. |
| `fonts/OFL.txt` | SIL OFL 1.1, "Copyright 2018 The Fraunces Project Authors (github.com/undercasetype/Fraunces)". |

**[OUR OWN MEASUREMENT]** — `fontTools` inspection of the two shipped woff2 files:

| Property | Value |
|---|---|
| family (nameID 1) | `Fraunces` (no nameID 16/17 typographic names) |
| axes present | `opsz` 9–144 (default **9**), `wght` 100–900 (default **900**) |
| axes **absent** | `SOFT`, `WONK` (the upstream build is `Fraunces[SOFT,WONK,opsz,wght]`) |
| unitsPerEm | 2000 |
| x-height / cap-height | 964 (0.482 em) / 1400 (0.700 em) |
| GSUB features | `liga`, `rvrn` — **no `tnum`**, no `ss01`/`ss02`, no `case`, no `salt` |
| digit advances (default instance) | 0=1461 1=1024 2=1334 3=1237 4=1397 5=1267 6=1348 7=1145 8=1385 9=1348 → **proportional, not tabular** |

**Four consequences that matter for the redesign:**

1. **The "AradLens Display" family is a CSS alias only.** The real family is **Fraunces**
   (Phaedra Charles & Flavia Zimbardi, Undercase Type). Per the upstream project README,
   Fraunces is *"a display, 'Old Style' soft-serif typeface inspired by the mannerisms of
   early 20th century typefaces such as Windsor, Souvenir, and the Cooper Series"*
   (<https://android.googlesource.com/platform/external/google-fonts/fraunces/+/refs/heads/main/README.md>).
   Aliasing is legal and fine — but the *designer's* mental model must be "Fraunces", because
   the display/serif/heritage connotations come from Fraunces, not from the alias.
2. **Only two axes ship: `opsz` and `wght`.** The upstream variable font is
   `Fraunces[SOFT,WONK,opsz,wght]` — the **SOFT** ("wetness"/inkiness) and **WONK**
   (leaning `n`/`m`/`h`, bulbous `b`/`d`/`h`/`k`/`l`) axes are **not in the shipped files**.
   Same source. So the "chocolate-y" character that makes Fraunces distinctive at display
   size is currently unreachable. **This is the single cheapest upgrade in the whole project**:
   re-download the full 4-axis variable font from Google Fonts and the display voice doubles
   in range at zero architectural cost.
3. **`font-variant-numeric: tabular-nums` is a no-op on Fraunces** — there is no `tnum`
   feature in the file, and the default digit advances are *not* equal width (1024–1461 units).
   `DESIGN.md`'s "Tabular Meters Rule" only actually works on the *body* font (Segoe UI /
   system-ui), which does have real tabular figures. The app applies `tabular-nums` to
   `--display` text at `index.html:931` (`.lore-year-stamp`) and to `.start-credit` /
   `.cb-dist` etc. where the display face is in play — those are decorative, so no bug, but
   the *rule as written* is false for the display face.
4. **`font-optical-sizing: auto` is the CSS initial value**, so `opsz` *is* auto-applied from
   `font-size` (CSS Fonts 4 §8.1: *"User agents are expected to supply a value for the 'opsz'
   axis which is close to the used value for font-size"*, clamped to the font's range,
   <https://www.w3.org/TR/css-fonts-4/#font-optical-sizing-def>). The comment at
   `index.html:10–11` is therefore correct. But note the consequence: **the display face's
   contrast, x-height and width change with every size step.** At 10 px it is a text-cut
   serif; at 26 px it is a high-contrast display serif. Two "the same" headings at 22 px and
   26 px are *not* the same drawing. This is a feature (it is why Fraunces was chosen) and it
   is also a trap (it breaks "one typeface = one voice" assumptions).

**Current palette (from `index.html:27–81`) and its OKLCH / WCAG numbers**
**[OUR OWN MEASUREMENT]** — sRGB → OKLCH (Ottosson matrices, CSS Color 4 values) and
WCAG 2.x relative-luminance contrast ratios:

| Token | Hex | OKLCH | Contrast notes |
|---|---|---|---|
| `--ground` | `#0b0e12` | `oklch(0.162 0.010 255.7)` | — |
| `--bg-surface` / `--bg-card` | `#141a21` | `oklch(0.215 0.017 252.5)` | — |
| `--bone` | `#f6f2e9` | `oklch(0.962 0.013 86.8)` | on ground **17.31:1**; on surface **15.67:1** |
| `--text-muted` | `rgba(246,242,233,.72)` | ≈ `#b4b2ad` on ground | **9.13:1** on ground; 8.62:1 on surface |
| `--amber` | `#c8b088` | `oklch(0.768 0.061 80.3)` | on ground **9.23:1**; on surface 8.36:1; **on mid-grey photo 1.88:1** |
| `--amber-ink` | `#1c1409` | `oklch(0.198 0.024 74.6)` | on `--amber` **8.69:1** |
| `--amber-deep` | `#7a6038` | `oklch(0.506 0.066 77.2)` | on bone **5.28:1** |
| `--deep-teal` / `--accent-teal` | `#14655a` | `oklch(0.458 0.076 181.4)` | on surface **2.53:1 ← FAILS 1.4.11**; on bone 6.19:1 |
| `.completed` ring | `#2f9e8c` | `oklch(0.633 0.102 179.7)` | on bone **2.94:1 ← FAILS 3:1**; on ground 5.33:1 |
| `--border-color` | `rgba(246,242,233,.22)` | ≈ `#3f4041` on ground | **1.86:1** (decorative only — see §4.4) |
| `--btn-border` | `rgba(246,242,233,.35)` | ≈ `#5d5e5d` on ground | **2.97:1 ← borderline FAIL 1.4.11** |
| light `--bg-main` | `#f6f2e9` | `oklch(0.962 0.013 86.8)` | — |
| light `--text-main` | `#171106` | `oklch(0.182 0.023 82.8)` | on light-main **16.79:1** |
| light `--text-muted` | `#4a4234` | `oklch(0.383 0.025 81.6)` | on light-main **8.87:1** |

**Live-video contrast, computed over a pure-white frame (worst realistic case)**
**[OUR OWN MEASUREMENT]**:

| Element | Composite over white frame | Bone-on-it ratio | Verdict |
|---|---|---|---|
| `#rail .ring` 2 px border `rgba(246,242,233,.85)` over the `.55` ink wash (`#757778`) | `#f7f4ec` on `#757778` | **3.41:1** for the stroke; icon glyph **4.03:1** | passes 1.4.11 *only* because of the scrim wash |
| `#rail .ring` border drawn directly on white (no wash) | — | **1.10:1** | **FAIL** — the wash is load-bearing |
| `#steerArrow` `--amber` stroke on mid-grey pavement | — | **1.88:1** | **FAIL** — the drop-shadow at `:153` is doing the work, not the colour |
| `--amber` chevron on white | — | **2.10:1** | **FAIL 1.4.11** |
| bottom scrim `rgba(5,7,10,.88)` | `#232527` | **13.77:1** | pass |
| top scrim `rgba(5,7,10,.68)` | `#555658` | **6.58:1** | pass |
| edge pill `rgba(5,7,10,.78)` | `#3c3e40` | **9.61:1** | pass |
| `.hint` (bone @ .75 opacity, no scrim of its own) | ≈ `#f7f4ec` on white | **~1.06:1** | **FAIL — invisible on bright pavement** |

**Current type stack** — `index.html:40` and `:84`:

```css
--display: "AradLens Display", Georgia, "Times New Roman", serif;   /* = Fraunces */
html, body { font-family: 'Segoe UI', system-ui, sans-serif; }
```

`Segoe UI` is listed *first*, before `system-ui`. On iOS/Android, `Segoe UI` does not
exist, so it falls through to `system-ui` (SF Pro / Roboto). But on **Windows desktop
preview** and any Windows machine the whole product renders in Segoe UI — a humanist
Windows chrome face — which is the least "heritage" thing about the current system.

**Current type scale (from `DESIGN.md` + the CSS)** — display sizes 26/22/20/19/18/17/16 px,
body 15/14/13/12/11/10 px. This is a **14-step scale**, not a modular one. It is the single
biggest typography problem in the app: 14 closely-spaced sizes (10, 11, 12, 13, 14, 15, 16,
17, 18, 19, 20, 22, 26) produce "muddy hierarchy" — you cannot tell 14 from 15 from 16 by
size alone, so weight, colour and position are doing all the work.

**Current motion inventory** (all in `index.html`):

| Where | Duration | Easing | Line |
|---|---|---|---|
| theme switch | `.3s` | `ease` | 84 |
| ring press | `.15s` | `ease` | 146, 178 |
| chevron rotation | `.12s` | `linear` | 154 |
| capture-ready pulse | `1.6s` infinite | `ease-in-out` | 193, 518-521 |
| band snap | `.34s` | `cubic-bezier(.22,.61,.36,1)` | 218 |
| modal open | `.25s` | `ease-out` | 531, 568 |
| capture flash | `.15s` | `ease-out` | 743 |
| reward pop | `.6s` | `cubic-bezier(.34,1.56,.64,1)` | 965 |
| reduced-motion kill switch | all to `.01ms` | - | 1060-1069 |

### 0.2 Evidence legend

- **[STRONG]** — peer-reviewed, replicated, or a normative standard (WCAG 2.2, W3C specs).
- **[MODERATE]** — peer-reviewed but single-lab, context-dependent, or with known boundary
  conditions.
- **[WEAK / CONTESTED]** — widely repeated, heavily cited, but the effect does not replicate
  or the mechanism is unconfirmed. **Treat these as design heuristics, not facts.**
- **[DESIGN JUDGEMENT]** — my inference; defensible but not a research finding.

### 0.3 Three corrections to the brief (read before using the request)

1. **WCAG numbering.** The brief said "1.4.11 non-text contrast and 1.4.12 focus
   appearance". In **WCAG 2.2** (W3C Recommendation, 12 Dec 2024,
   <https://www.w3.org/TR/WCAG22/>): **1.4.11 = Non-text Contrast (AA)**, **1.4.12 =
   Text Spacing (AA)**, and **Focus Appearance is 2.4.13 (AAA)**. Also 2.4.11 / 2.4.12 are
   *Focus Not Obscured* (Minimum / Enhanced). Design against **1.4.11 + 2.4.13**, and treat
   **1.4.12 Text Spacing** as a real constraint: at `line-height: 1.5`, `letter-spacing:
   0.12em`, `word-spacing: 0.16em`, `paragraph-spacing: 2em`, **nothing may clip or overlap**.
   That matters a lot for the compass band, where labels are absolutely positioned inside a
   rotated, clipped container.
2. **"G1 / G2 / G3" is ambiguous and the two readings are unrelated.** Resolved in §1.6.
3. **The self-hosted font is Fraunces, and the shipped build has only 2 of its 4 axes.** See
   §0.1. Any designer brief that says "AradLens Display" is working from an alias and should
   be corrected to "Fraunces (aliased as AradLens Display)".

---

### 0.4 Line-number drift, and the durable anchors

**`index.html` was edited by another session *while this research was running*.** It grew
from **3 634 → 3 722 lines** (the `.mode-badge` / `#gameModeBadge` story badge was removed
and a few rules moved). Every line number in this document was re-verified against the
**3 722-line working tree** on **2026-10-22, ~09:20 local**. That tree will drift again.

**Therefore: the CSS selector / element id quoted next to each number is the durable
anchor; the number is a convenience.** If a number looks wrong, search for the selector.
This is the single most useful thing to know before acting on this document.

**The most-cited anchors, as of the 3 722-line tree:**

| Anchor | Line | Anchor | Line |
|---|---|---|---|
| `@font-face` (Fraunces, latin-ext / latin) | 14, 20 | `#cam` | 106 |
| `--display` | 40 | `#overlay` | 116 |
| `--hud-scrim-top` / `--hud-scrim-bottom` / `--hud-hairline` | 41 / 42 / 43 | `.top` | 119 |
| `--btn-border` | 56 | `.top .brand` | 127 |
| `--deep-teal` | 39 | `.route-step` | 134 |
| `body { font-family }` | 84 | `.theme-toggle-btn` (34 px) | 139 |
| `:focus-visible` | 88 | `#steerArrow` / `#steerEdge` | 151 / 157 |
| `.tnum` | 102 | `#rail` / `#rail .ring` | 166 / 170 |
| `#snapRail` | 209 | `perspective(760px) rotateX(13deg)` | 215 |
| `.cb-reticle` | 220 | `.cb-name` (10 px) | 254–255 |
| `.cb-dist` (10 px) | 260 | `[aria-current="true"] .cb-ring` | 262 |
| `.bottom` | 283 | `#caption` | 288 |
| `#arLabel .al-name` / `.al-meta` | 301 / 305 | `body.has-arrived #caption` | 309 |
| `.dist .num` / `.dist .unit` | 322 / 323 | `#start` / `.start-inner` | 337 / 350 |
| `.hint` | 437 | `.btn` | 441 |
| `#card` | 454 | `#photoCmp` | 479 |
| `#status` | 432 | `#compassWarning` | 525 |
| `#compassWarningBadge` (34 px) | 547 | `#proximityToast` | 559 |
| `#albumModal` | 584 | `.schematic-badge` | 615 |
| `.mode-badge-pill` | 845 | `.chapter-card.completed-chapter` | 875 |
| `.lore-badge` / `.lore-year-stamp` / `.lore-ribbon` | 919 / 923 / 936 | `.reward-ribbon` / `.reward-icon-huge` | 958 / 963 |
| `.diploma-card` / `.diploma-seal` | 977 / 983 | `.modal-close-btn` (36 px) | 828 |
| `.full-modal` (+ `backdrop-filter: blur(5px)`) | 806 (+ 808) | `#captureModal` (+ `blur(4px)`) | 749 (+ 751) |
| `#captureFlash` / `.flash-active` | 742 / 746 | `.cs-frame` | 717 |
| `@keyframes popBounce` | 967 | `@keyframes shutterPulse` | 518 |
| `@media (prefers-reduced-motion)` | 1060 | `.band-anim` transition | 218 |
| `const REPERE` / `const CHAPTERS` | 1559 / 1636 | `BAND_SLOT` / `BAND_SAG` | 2072 / 2073 |
| `bandArcDeg` | 2118 | `renderBand` | 2135 |
| `renderCompassBand` | 2207 | `setWheelActiveIndex` | 2269 |
| `liveSelectNearestStop` | 2297 | `checkLandmarkProximity` | 2762 |
## 1. Gestalt & perception

### 1.1 The core claim, stated precisely

Gestalt is not "things look tidy". It is a family of **stimulus factors** that determine how
a visual field is organised. The canonical framing is Wertheimer's: *"All else being equal,
elements that are related by X tend to be grouped perceptively into higher-order units"*
(Palmer, quoted in Wagemans et al. 2012, <https://pmc.ncbi.nlm.nih.gov/articles/PMC3482144/>).

**The "all else being equal" clause is the whole game.** Each principle is a *ceteris paribus*
rule; when two principles conflict, you get a competition, not a law. This is exactly why
Gestalt is hard to apply to a live camera feed: the camera feed is a continuously changing
field of unpredictable content that will constantly out-compete your UI's grouping cues.

Sources: Wagemans, J., et al. (2012). *A century of Gestalt psychology in visual perception
I. Perceptual grouping and figure–ground organization.* Psychological Bulletin, 138(6),
792–817. <https://pmc.ncbi.nlm.nih.gov/articles/PMC3482144/> ·
Peterson, M. A. & Kimchi, R. (2013). *Perceptual Organization in Vision.* Oxford Handbook of
Perception. <https://newiipdm.haifa.ac.il/wp-content/uploads/2015/05/Peterson-Kimchi-_2013_Perceptual-Organization-in-Vision_Oxford-Handbook.pdf>

### 1.2 The grouping laws, and what each one means for a HUD over live video

| Law | Source | Mechanism | What it means in AradLens |
|---|---|---|---|
| **Proximity** | Wertheimer 1923 | elements that are closer are grouped; closeness is *relative distance*, not absolute | Two labels 8 px apart read as one unit; the same two labels 40 px apart read as two units. **Every panel needs an internal proximity zone tighter than the gap to the next panel.** |
| **Similarity** | Wertheimer 1923 | shared colour / size / shape / orientation | The app already exploits this: `--amber` = live direction, `--bone` = everything else, teal = completed. This is a *similarity-coded* system and it works because the mapping is 1:1 and never overlaps. |
| **Closure** | Wertheimer 1923 | closed forms are seen as complete units; **closure can dominate good continuation** | A rounded-rect panel that is *implied* by a 1 px hairline reads as a closed shape; a scrim gradient that fades to nothing does not. Use closure for the panel, not for the ground. |
| **Good continuation** | Wertheimer 1923 | intersecting lines are seen as two continuous lines, not two angles | The **compass band** is a literal instance: the tape arc continues past the frame edge, so a stop half-out-of-frame reads as "there is more tape", not "the tape is broken". |
| **Common fate** | Wertheimer 1923 | elements that move together are grouped; a special case of similarity (velocity) | Any animated HUD element that moves *with* another (e.g. a chevron + its distance label) is auto-grouped. Conversely, a pulsing element that moves independently of its label **un-groups** them. `shutterPulse` (`:193`) animates a ring's *box-shadow* while the label next to it (`:196` `#captureDistLabel`) stays still → they de-group at the moment the user most needs them joined. |
| **Common region** | Palmer 1992 | elements inside the same bounded region group; **can override proximity and similarity**; operates on a 3-D representation | The most under-used principle in this app. A panel with a visible closed boundary groups everything inside it, regardless of colour. Today the app's "panels" are scrims (transparent, unbounded) and hairlines at 22 % opacity — *weak* region cues. |
| **Element connectedness** | Palmer & Rock 1994 | elements sharing a common border group (head of a hammer + its handle) | The `.rail` rings at `:170` are separate; the ring *and* the label *inside* it are connected, so they group — but the four rings at `:166–169` are 52 px tall with 12 px gaps, i.e. **proximity-grouped into one vertical column**, which is why the right rail reads as "a strip" rather than "four actions". |
| **Uniform connectedness** | Wagemans et al. 2012 | elements connected *by a uniform visual property* (a line, a colour, a region) group | A shared bone stroke across four icons is a uniform connector. `.cb-halo`/`.cb-ring`/`.cb-tick` in the compass dial are uniform-connected and therefore read as one object — good. |
| **Synchrony** | Lee & Blake 1999; Palmer & Levitin 1998 | elements that change at the same time group; related to common fate but without motion | The cheap version of "common fate" and it's the one that actually works in a UI: **change several properties of a group simultaneously and it becomes one perceptual object.** |

Sources: Palmer (1992) *Common region: a new principle of perceptual grouping*,
Psychological Science 3(3), 189–195 —
<https://e-edu.nbu.bg/pluginfile.php/951829/mod_resource/content/1/Stephen-Palmer%20-%20Common%20region%20-%20A%20new%20principle%20of%20perceptual%20grouping%201992.pdf> ·
Palmer & Rock (1994), element connectedness, reviewed in Wagemans et al. 2012 ·
Brooks & Palmer (2010) synchrony, <https://palmerlab.berkeley.edu/pdf/PalmerBrooks&Nelson.pdf>

### 1.3 Edge and intersection — the two principles that decide *who owns the border*

This is the crux for a HUD. When an edge sits between two regions, the visual system must
decide whether the edge belongs to the foreground region or the background region, and that
assignment **determines which one is figure and which one is ground**.

- **Edge (border ownership).** Brooks (2010) *Grouping puts figure–ground assignment in
  context by …*, Attention, Perception, & Psychophysics 72(4), 1053 —
  <https://link.springer.com/content/pdf/10.3758/APP.72.4.1053.pdf>. An edge that is
  **convex** (bulges toward the region) tends to be owned by the other region; an edge that
  is **concave** (bulges into the region) is owned by the region itself. Net effect for
  design: **a panel whose border curves *into* the panel reads as a solid object sitting on
  top; a border that curves away reads as a hole cut in the ground.**
- **Intersection.** Two elements that intersect are perceived as belonging together
  (Peterson & Kimchi 2013). Directly relevant: the app's `#steerArrow` (`:151`) and the
  `#steerEdge` pill (`:157`) both occupy the centre of the screen and *replace* one another
  (`#steerEdge` is `display:none` until the target is behind you). Two mutually exclusive
  objects in the same place with no transition read as a **jump-cut**, breaking continuity.
  This is the single clearest place where the app violates good continuation.

### 1.4 Figure / ground in a camera-overlay HUD — and the inversion problem

Rubin's figure–ground is the classic: one region is *figure* (shape, in front, bounded), the
other is *ground* ( shapeless, behind, extending to the horizon). In this app the natural
reading is:

- **Figure = the live camera image.** It is high-contrast, textured, moving, infinite, and
  *predictable in nothing*. The user is looking at the street because the street is the task.
- **Ground = the UI.** But **this is the wrong way round for the parts of the UI that carry
  instructions.** The HUD text is not ground — it is a bounded, high-contrast, shape-like
  region that the eye must *parse as a figure*. Trying to force text into "ground" is why
  HUDs over video so often fail.

**The practical consequence: your panels need to be legible *figures* that are clearly
separated from the video *ground*, not "ground" that happens to be readable.** That means:

1. A **closed, convex-edged boundary** so the panel owns its border (edge ownership, §1.3).
2. **Uniform connectedness** for all the content inside it — same stroke family, same
   corner radius, same padding rhythm.
3. The camera image must be **suppressed, not merely covered**, wherever text sits — see §4.5.

A second, subtler inversion: **on a camera feed, the "figure" flips depending on what the
user is looking at.** A white wall in frame becomes the figure (it has the highest local
contrast) and your HUD becomes ground. This is why the current design's use of *scrims
rather than panels* is defensible (a scrim works over anything) but also why the app
already has to reach for drop-shadows on the chevron (`:153`) and on the stop name (`:710`).
The shadow is a **perceptual surface**: it creates a local edge that the visual system can
assign, restoring figure/ground even when the background is white.

### 1.5 Prägnanz, and why "good design = Prägnanz" is a category error

Koffka (1935): *"psychological organization will always be as 'good' as the prevailing
conditions allow"* (p. 110), where "good" is undefined but entails regularity, symmetry,
simplicity. **Van Geert (2023/2024)** — *Prägnanz in visual perception*, Psychonomic Bulletin
& Review — makes the modern, rigorous case and explicitly **debunks the common
misunderstanding**:
<https://pmc.ncbi.nlm.nih.gov/articles/PMC11061049> and
<https://link.springer.com/article/10.3758/s13423-023-02344-9>

Three findings that change how to use it:

- Prägnanz is **multifaceted**: "goodness" is not reducible to "simple". Both *removal of
  unnecessary detail* and *emphasis of characteristic features* produce a better Gestalt.
  → **Emphasis is not the enemy of Prägnanz.** The "One Beige Rule" (reserve beige for
  live direction) is a Prägnanz-consistent move, not a violation of it.
- **Simplicity of the Gestalt ≠ simplicity of its components** (Wertheimer 1923). Simple
  stimuli do not necessarily produce simple groupings. → A HUD with 12 identical 52 px
  rings is *element-simple* but perceptually *group-simple* (they all merge into one strip).
  The fix is not "fewer elements", it is "fewer *groups*".
- Koffka's "principle of minimum and maximum simplicity": at **low vigilance** the tendency
  is toward **uniformity (simplification)**; at **high vigilance** toward **good articulation
  (differentiation)**. → **A walking tourist is not at high vigilance.** Worn-down
  attention, sun, navigation stress, one hand on a phone: the HUD should collapse toward
  *fewer, larger, more uniform* elements, not more.

Also: **the law of Prägnanz and "good design" are different claims.** Prägnanz is a claim
about *perception* — what the visual system selects. Good design is a claim about *task
support* — whether the selected percept helps the user do the thing. They coincide most of
the time and diverge exactly where it matters: a perfectly grouped, beautifully balanced
HUD that shows the wrong number is a failure. **Prägnanz is a tiebreaker, not an objective.**

### 1.6 The "G1 / G2 / G3" ambiguity — both readings, resolved

The brief asked for *G1/G2/G3 in the 3D graphics pipeline* mapped onto z-depth of UI layers
over a camera feed, **and** for the "G2" reading as **Gestalt group 2 / second-level
grouping**. These are two unrelated things that share a token. Resolved explicitly:

#### Reading A — the OpenGL "three-stage model" (G1 / G2 / G3)

The classic SGI-era OpenGL conceptual split of the rendering pipeline into three stages:
**G1 = the geometry stage** (application, display lists, vertex transform, lighting,
primitive assembly), **G2 = the rasterization stage** (scan conversion, clipping, viewport
transform → fragments), **G3 = the texture-mapping / fragment stage** (texture sampling,
per-fragment shading, blending, depth/stencil test, framebuffer write). Sources:
SGI/OpenGL "Three-Stage Model of the Graphics Pipeline" —
<https://www.opengl.org/archives/resources/code/samples/advanced/advanced98/notes/node257.html>;
Khronos *Rendering Pipeline Overview* —
<https://wikis.khronos.org/opengl/Rendering_Pipeline_Overview>; OpenGL 1.3 spec ch. 2 —
<https://registry.khronos.org/OpenGL/specs/gl/glspec13.pdf>.

**Mapped onto AradLens's z-stack** (all of which the app already implements as flat CSS
`z-index`, which is the point — CSS z-order *is* a rasterization order):

| GL stage | What happens | AradLens layer | z-index | Current line |
|---|---|---|---|---|
| **G1 — geometry** | vertices are transformed and lit; *the shape of the world is decided* | **The camera feed + the sensor readouts that define "where I am"**: `#cam` (the projected scene), `#overlay` transform layer, `#diag`/`#coords` heading + bearing readout | 0–1 | `:106`, `:116` |
| **G2 — rasterization** | primitives are clipped and turned into **fragments**; *where they land on screen* | **The layout layer**: the HUD's geometry — top rail, right action rail, caption block, distance row, compass band, scrims. This is where the *z-order* and the *arc* live. | 1–2 | `:119`, `:166`, `:209`, `:283` |
| **G3 — fragment / texture** | each fragment is shaded, tested and blended; *what colour it finally is* | **The surface layer**: fills, strokes, scrims, shadows, text rendering. Where contrast is won or lost. | 2–25 | `:41–43`, `:116`, `:127`, `:441`, `:751` |

**Design rule from Reading A.** The three stages are *not* interchangeable: a problem
solved at the wrong stage is a hack.
- If the HUD is **illegible**, that is a **G3 problem** (blend/contrast), fix it with a
  scrim or a fill — *not* by moving the layer up.
- If the HUD is **in the wrong place**, that is a **G2 problem** (rasterization/clipping),
  fix it with layout, safe-area insets, z-index.
- If the HUD is **showing the wrong thing**, that is a **G1 problem** (the geometry — where
  am I, what is the bearing). Fix it in the sensor pipeline, not in CSS.
  → *The current app's `#diag` debug readout is G1; the `#coords` readout is G1; both are
  `z-index`-invisible behind a `.debug-only` class at `:328`, which is a G2 decision to
  hide a G1 surface.* That is correct, and the designer should know that "moving the compass
  warning badge closer to the camera" is meaningless.

#### Reading B — "Gestalt group 2" / second-level grouping

In Gestalt terms, "groups of groups": the output of one grouping operation becomes an input
to the next. Palmer (1992) showed common region is *"dominated by the smallest background
area"* and *"can follow a hierarchical embedding scheme"*; Brooks & Palmer (2010) show
grouping *puts figure–ground assignment in context*. So:

- **Level 1 grouping** = elements → objects. E.g. the four chevron ticks + ring + hub of a
  compass dial → *one dial*.
- **Level 2 grouping** = objects → regions. E.g. all five dials → *one compass band*.
- **Level 3 grouping** = regions → a *scene schema*. E.g. band + caption + distance row →
  *"the guidance layer"*, which the user then relates to the video below it.

**Design rule from Reading B.** Level-2 grouping is what makes a HUD feel like *an
instrument* rather than *a pile of stickers*. It requires that all members of a level-2
group share a **common region** (a bounded, closed container) — not merely that they are
near each other. Today, the app's compass band (`:209`) has `overflow: clip` and a
perspective `rotateX(13deg)` but **no visible container**; the five dials are grouped only
by proximity and similarity. The result is that the band does not read as one object — it
reads as five dials floating on a scrim. Adding a **closed region** (a defined, subtly
bounded arc-shaped plate behind the tape) would promote the band to a level-2 group and
would make the whole bottom third of the screen read as one "guidance instrument".

**The two readings together give the cleanest formulation:** treat the HUD as a
**G1 → G2 → G3 stack** (truth → geometry → surface), and *within the G2 layer* use
**Gestalt level-2 grouping** (common region) to make the HUD read as composed objects
rather than loose elements. The app's current failure is that G2 (layout) and G3 (surface)
are doing each other's jobs: a *layout* problem (the band isn't grouped) is being solved
with a *surface* trick (shadows, opacity fades), and a *surface* problem (the chevron on
white) is being solved with a *layout* trick (the drop-shadow at `:153`).

### 1.7 "Musical spacing" — proximity as rhythm, and why it beats a spacing scale

The "musical spacing" analogy is not decoration; it is the perceptual fact that
**relative** distance carries the grouping signal, and that a rhythm of space reads as a
rhythm of meaning. A "spacing scale" (4/8/12/16/24) is a *token* system; **musical
spacing** is a *ratio* system — the same principle as a modular type scale (§3.3) applied
to space.

In the app, the caption block (`:288`) has `padding: 10px 12px`, the distance row (`:317`)
has `padding-top: 10px`, and the rail gaps are `12px` (`:168`). The internal gaps
(10–12 px) and external gaps (the 68 px caption clearance) are in roughly a 1:5 relationship
— which is musically "close, but clearly separate". That is accidentally right. It will
break the moment a designer adds a 16 px or 20 px gap somewhere.

**Rule:** internal spacing should be a **consistent small value** (8/10/12); separation
between groups should be **at least 2× and ideally 3–4×** that; and the *rhythm* should
repeat. This is the "common region + proximity" pair doing the work together.

### 1.8 Rules for our app (Gestalt)

1. **Adopt the G1/G2/G3 stack as a triage tool.** Before changing a pixel, name the stage:
   wrong *data* → G1 (sensor/bearing pipeline); wrong *place* → G2 (layout, z-index, safe
   area); wrong *legibility* → G3 (fill, scrim, contrast). Never solve a G3 problem with a
   G2 move. This alone will kill several of the app's current hacks.
2. **Promote every HUD group to level-2 grouping with a closed common region.** The compass
   band needs a bounded arc plate behind it (currently `:209` has no visible container);
   the caption block needs a closed card (currently `:288` has `border: 1px solid
   transparent` that only becomes visible on arrival — give it a resting boundary too).
3. **Fix the centre-jump.** `#steerArrow` (`:151`) and `#steerEdge` (`:157`) must cross-fade
   and share a position, not swap. Good continuation beats a clean state change when the
   object is in the user's foveal line.
4. **Never animate one member of a group without the others.** `shutterPulse` (`:193`)
   must pulse the ring border, the `#captureDistLabel` (`:196`) and the chevron together —
   synchrony (Lee & Blake 1999) is a grouping force and it is free.
5. **Every text-bearing surface gets a closed, convex-edged boundary with uniform
   connectedness.** Convex edge → the panel owns its border (Brooks 2010). Use the same
   corner radius, same hairline weight, same padding inside all four HUD panels.
6. **Use opacity-fade as a "depth off-stage" signal, not as a grouping signal.** The band
   currently fades stops with `1 - (adx/fade)^1.6` (`:2148`) and additionally multiplies
   locked stops by 0.55 (`:2149`). Two different fade curves for two different meanings
   ("off-axis" vs "locked") is confusing. Use **position/rotation** for "off-axis" and
   **one dedicated, unmistakable visual state** (padlock + flat, not faded) for "locked".
7. **Make the accent a *rarity*, not a hue.** The "One Beige Rule" is correct and is
   Prägnanz-consistent (emphasis is compatible with Prägnanz, Van Geert 2023). Formalise
   it: beige appears in at most **one place per screen state**, plus its own echo inside
   the arrival flood. Everything else is bone/hairline/ground.
8. **Use a ratio for spacing, not a token list.** Fix one "close" value (10 px) and one
   "far" value (32–40 px) and derive everything between. The current 10/12/14/16/20/26
   mix is a ratio-free set.
9. **The video is the ground; your panels are figures.** When a white wall fills the frame,
   the HUD will lose figure/ground. Every text surface therefore needs a *guaranteed*
   local contrast mechanism — a fill, a shadow, or a scrim — never "it'll probably be dark
   enough".
10. **Design for low vigilance.** Koffka's vigilance clause (Van Geert 2023): a walking
    tourist gets *simplification*, not elaboration. Any new HUD element must be justified
    against "what does the user lose if I remove this?".

---

## 2. Cognitive & behavioural science

### 2.1 The laws, stated honestly (strength of evidence included)

| Law / effect | Claim | Evidence | Our use |
|---|---|---|---|
| **Hick's law** (Hick & Hyman 1952) | decision time grows with log₂ of the number of choices: T = a + b·log₂(n+1) | **[STRONG]** for simple reaction-time tasks; **[MODERATE]** for menus — it does *not* apply to searching a list of words (that's linear). <https://en.wikipedia.org/wiki/Hick's_law> | The 4-item right rail (`:166`) is at the sweet spot. The `CHAPTERS` list + free mode + album tabs is where it breaks. |
| **Fitts's law** (Fitts 1954) | MT = a + b·log₂(2D/W) — time to hit a target depends on **distance ÷ width** | **[STRONG]**, the most replicated law in HCI. <https://en.wikipedia.org/wiki/Fitts%27s_law> | Governs the compass band: the *effective* target width shrinks as the dial rotates and fades. See §6.4. |
| **Miller's law** (Miller 1956) | working memory holds ~7 (±2) chunks | **[WEAK / CONTESTED]** — modern estimates are 3–5 chunks for free recall, and the "7±2" figure does not survive replication; chunking is not a fixed-capacity property | Use it as a *minimum* ("don't show more than 5 peer items"), not a target. |
| **Jakob's law** (Nielsen 1994) | users spend most time on other sites; they expect your site to work like those | **[MODERATE]** — strong as a design heuristic, weak as a law. <https://lawsofux.com/jakobs-law> | Swipe-to-dismiss, tap-to-act, back-to-close. The app's custom bottom-sheet (`#card` `:454`) is a *sheet*, which is the expected pattern. |
| **Zeigarnik effect** | interrupted tasks stay in memory better than completed ones | **[WEAK]** — the original Zeigarnik (1927) results have not replicated robustly; the popular "open loops" version is largely a metaphor | *Use anyway, carefully*: the in-progress chapter is a genuine open loop. But don't manufacture fake open loops. |
| **Peak–end rule** (Kahneman et al. 1993; Coldpress et al. 2008) | remembered utility is dominated by the **peak** and the **end**, not the average or duration | **[STRONG]** for retrospective evaluations | **This is the single most actionable behavioural fact for a walking tour.** The tour has one peak (the arrival reveal at `:309`) and one end (the diploma, `:977`). Both must be excellent; everything between is "duration" and is largely not remembered. |
| **Processing fluency** (Reber, Schwarz & Winkielman 2004) | things that are easier to process feel truer, more familiar, more beautiful, more likable | **[STRONG]** for the fluency→feeling link; **[MODERATE]** for downstream behaviour | A HUD that is *hard* to read is not just annoying, it makes the content feel less credible. This is the strongest theoretical argument for typographic craft in this app. |
| **Mere exposure** (Zajonc 1968) | repeated exposure increases liking, with no reward needed | **[STRONG]** — the most robust finding in social psychology; also has an in-group/weather effect | The city is the repeated stimulus. A consistent, well-set visual identity across chapters compounds familiarity. |
| **Choice overload** (Iyengar & Lepper 2000) | more options → more deferral, less satisfaction | **[WEAK / CONTESTED]** — the *meta-analysis* (Scheibehenne, Greifeneder & Todd 2010, 63 conditions, N = 5 036) found a **mean effect size of virtually zero**, with large variance and no identifiable sufficient conditions. <https://scheibehenne.de/ScheibehenneGreifenederTodd2010.pdf> | **Do not cite choice overload as a reason to hide features.** Justification for reducing choice must come from Fitts/Hick or from SDT (autonomy), not from this. |
| **Cognitive load theory** (Sweller 1988; Sweller et al. 1998) | working memory is limited; load is **intrinsic** (inherent complexity) + **extraneous** (how it's presented) → **germane** (resources devoted to schema construction) | **[STRONG]** as a framework, though the additive three-way model is being reworked (Sweller 2010; Kalyuga 2011: germane may be "essentially indistinguishable from intrinsic"). <https://pmc.ncbi.nlm.nih.gov/articles/PMC6435105/> | See §2.2. |
| **Signal detection theory** (Green & Swets) | detection is a trade of hits vs false alarms, governed by the observer's criterion, not by the stimulus | **[STRONG]** | The proximity toast (`:559`) fires once per session per landmark (`notifiedLandmarksInSession`). If the criterion is too liberal, users learn the app nags; too conservative, they miss the cue. |
| **Salience / Itti & Koch** (2001) | attention is driven by bottom-up saliency + top-down task relevance | **[STRONG]** for the model; saliency maps are a standard tool | The beige chevron is a **bottom-up** salient item; the arrow's *rotation* is a **top-down** cue. Both matter, but they must not compete. |
| **Von Restorff / isolation effect** (von Restorff 1933) | the distinct item in a list is remembered better | **[STRONG]** for free recall; **[MODERATE]** for recognition — Kamp et al. (2026, *J. Exp. Psychol. LMC*) found the effect is largely absent in recognition unless recall precedes it. <https://psycnet.apa.org/doiLanding?doi=10.1037/xlm0001518> | The "beige = the one live thing" system is a Von Restorff implementation. It works. Don't dilute it with a second accent. |
| **Serial position effect** (Freyd 1893) | first and last items in a series are recalled best | **[STRONG]** | The 5-stop route is a serial list. **Stop #1 and stop #5 are the ones people will remember.** Don't waste the first or last slot on a weak item. |
| **Testing effect** (Roediger & Karpicke 2006) | retrieval practice beats re-reading for long-term retention | **[STRONG]** — the most robust finding in the (cognitive) psychology of learning | **The `CHAPTERS` structure is currently a re-reading design** (the user reads the lore). If the user had to *recall* the year/architect before being told, retention would roughly double. |
| **Habit loop / context cues** (Neal, Wood & Quinn 2006; Wood & Neal 2007) | habits are **response dispositions cued by context**, not goal pursuit; ~45 % of behaviour is habitual | **[STRONG]** — and the mechanism is *specific*: habits form in **stable contexts** with consistent cues | **This is the most under-used idea in the whole brief.** AradLens is a *walking* app: the context cue is literally "standing at a specific GPS coordinate". Make the arrival cue at each landmark **identical every time** — same sound, same haptic pattern, same visual flood, same wording. Then arriving at stop #3 triggers stop #1's behaviour. |
| **Self-determination theory** (Deci & Ryan 1985, 2000) | **autonomy, competence, relatedness** are innate needs; satisfying them yields intrinsic motivation | **[STRONG]** — the best-supported motivational theory in psychology. <https://psycnet.apa.org/doi/10.1037/0003-066X.55.1.68> | See §2.3. |
| **Effectance / flow** (Csikszentmihalyi) | engagement peaks when challenge ≈ skill | **[MODERATE]** | A walking tour has intrinsic flow potential: the street *is* the challenge. The app's job is not to add difficulty but to remove friction. |

### 2.2 Cognitive load applied to a walking AR HUD

CLT's three components map onto the app with uncomfortable precision:

- **Intrinsic load** = the task itself: find the Primăria, orient yourself, notice it, get
  close, photograph it, read the story. *You cannot reduce intrinsic load* — but you can
  reduce **element interactivity** (the number of things that must be processed
  simultaneously). The HUD currently forces simultaneous processing of: distance number +
  unit + step count + landmark name + "Mergi spre…" phrase + arrow + the *entire live video*.
  That is 7+ interacting elements, at a time when the user is also walking, reading street
  signs, and (in Arad) probably being spoken to.
- **Extraneous load** = everything the *design* adds. In the current app: a 5-item compass
  band with per-dial SVG dials, names, and distances (108 px × 5 = 540 px of simultaneously
  updating, rotating, fading content); a `hint` line that is always visible; `#routeStep` in
  *two* places simultaneously (`:2061` writes to both `#routeStep` and `#routeStepBottom`).
  Every one of these is **extraneous load** — the user did not ask for the distance of the
  *fourth* stop while walking toward the first.
- **Germane load** = resources devoted to actually learning the city. Currently near zero:
  the lore is read passively, and the year/architect are never asked for.

**The redesign's central bet should be: convert extraneous load into germane load.**
Same number of pixels, same information, radically different cognitive account:

- The compass band shows **5 stops with live distances and rotating dials**. That is
  ~25 data points updating at frame rate. Extraneous.
- If instead the band shows **the next 1 stop prominently (name, distance, bearing) and the
  remaining stops as inert dots**, and the *learning* content (year, architect, style) is
  surfaced as a **quizzable recall** ("Cum se numește clădirea construită în 1876?")
  before the reveal — then the same screen carries far more germane load and far less
  extraneous load.

### 2.3 Self-determination theory, applied to a gamified walking tour

SDT's three needs (Deci & Ryan 1985/2000):

| Need | In a walking tour | Current app | SDT-supporting design |
|---|---|---|---|
| **Autonomy** — "I chose this" | *free mode vs story mode*, which stop, when to start | **Present and good**: `selectGamemode` (`:1937`), free mode ignores order (`:2099`) | Keep both modes equally weighted. Never lock the user out of a stop for "sequence" reasons. The band currently renders future steps as `.locked` with a padlock (`:252`) — a locked step in a *tour* is autonomy-thwartening. Prefer **"available but not yet"** over **"forbidden"**. |
| **Competence** — "I can do this" | *I'm navigating well; I found it; I photographed it; I know the year* | **Weak**: the compass band gives constant distance, so there is never a moment of "I found it". The proximity toast (`:559`) fires at 50 m automatically — the app did the finding. | Make competence *legible*: show the arrow only when it helps, let the user *navigate* to within a tolerance, celebrate the accuracy ("ai ajuns la 8 m de Primăria"), give a per-chapter accuracy grade. Also: **the 50 m auto-trigger is too generous and too early** — see §6.4. |
| **Relatedness** — "I belong here" | *I'm part of a line of people who care about this city* | **Absent**: no diary entry, no shared record, no sense of a community or of a lineage. | The "Diplomă de Cronicar" (`:1652`) is exactly the right *shape* — a document that certifies you were here. Lean into it: a **chronicle** the user can show, a city-wide tally ("12 400 de cronicari în 2026"), a route name. |

**Tourism-specific evidence** that SDT is the right frame for gamified tourism:
Yeh, Chang & Li (2025), *The role of gamification in enhancing consumer engagement at
expositions through self-determination theory*, Journal of Service Management —
"intrinsic motivations of **competence, relatedness and autonomy** significantly enhance the
gamified experience" (N = tourism expo visitors, Taiwan) —
<https://www.sciencedirect.com/org/science/article/abs/pii/S0887604525000242>.
And the meta-analysis in education (Li, Hew & Du 2024, *Educational Technology Research and
Development* 72(2), 765–796) found gamification's effect on intrinsic motivation is
**small** (Hedges' g = 0.257) but its effect on **perceived autonomy (g = 0.638)** and
**relatedness (g = 1.776)** is large, with **minimal impact on competence (g = 0.277)** —
<https://eric.ed.gov/?id=EJ1424760>. **Design implication: in a gamified walking tour, the
leverage is in autonomy and relatedness, not in badge points.** The current app's
`#rewardModal` + diploma + badges is a **competence/points** design, which the meta-analysis
says is the weakest lever.

### 2.4 The peak–end rule applied to the walking tour's arc

Kahneman, Fredrickson, Schreiber & Redelmeier (1993) and Coldpress, Larrick & Yarkoni (2008)
on the peak–end rule. For AradLens:

- **Peak** = the moment of arrival. Currently `body.has-arrived` floods the caption beige
  (`:300–307`) — a genuine peak, and it is the *only* strong visual moment in the entire
  product. **Protect it. Do not spend the beige on anything else, or the peak flattens.**
- **End** = the diploma. Currently `#diploma-card` (`:977`) with a `4px double #7a6038`
  border and a serif name — a good shape. But it arrives in a **modal card on a 4.5:1
  `rgba(0,0,0,.7)` scrim** (`:749`), which is a generic pattern, not an Arad pattern.
- **Everything between** = duration. The 5-stop walk, the between-stop dead time, the
  "captează" modal (`:749`). The peak–end rule says this is where you can *save* effort.
  → **Do not spend design budget on the between-stops state.** Spend it on arrival and
  diploma.

Corollary: the "story" mode's real value is not the quizzes — it's that it produces
**one peak per chapter and one end per chapter**, giving the user 3 peaks + 1 end across
the tour instead of 1 + 1.

### 2.5 The testing effect applied to the lore

Roediger & Karpicke (2006), *Taking memory tests improves long-term retention*,
Psychological Science 17(3), 249–255 — <https://pubmed.ncbi.nlm.nih.gov/16507066/>.

Today, `openStoryLoreModal` presents the year, architect, style and a 2–3 sentence
narrative — a **pure re-reading** presentation. Re-reading is the *control condition* in
Roediger & Karpicke, and it loses to retrieval by a wide margin.

**Concrete redesign:** before opening the lore modal, ask **one** retrieval question about
the *next* landmark — "În ce an a fost construită clădirea?" with 4 multiple-choice
answers (1865 / 1876 / 1896 / 1913 — the four dates the user is trying to memorise).
Then reveal. Cost: one extra tap per stop. Benefit: the difference between "read" and
"remembered" for a walking tour whose entire point is that you'll remember the city.

### 2.6 Attention, salience, and the moment of arrival

Itti & Koch (2001) and Wolfe et al. (2016) model attention as the interaction of
**bottom-up saliency** (contrast, motion, onset) and **top-down relevance** (task, goals).
For a HUD:

- A **beige chevron that rotates** is bottom-up salient (motion + colour + the highest
  local contrast on screen) *and* top-down relevant (it's the answer to "where do I go?").
  Good.
- The **compass band** is bottom-up salient (5 glowing dials) but only *weakly* top-down
  relevant (the user wants the next stop, not stop #4). This is the definition of
  **extraneous load**: attention captured by low-relevance stimuli.
- The `shutterPulse` (`:193`, 1.6 s infinite) is bottom-up salient and only becomes
  top-down relevant within 50 m. For the entire rest of the tour it is a **perpetual
  attractor** — an infinite animation on the highest-salience channel. Also, an infinite
  1.6 s animation is a **power drain on a phone running a live camera + compass + GPS**,
  which on a mid-range Android is a real battery/thermal problem for a 40-minute tour.
  → **Make it finite**: pulse 3 times, then settle to a static beige border + a small
  filled dot. Same signal, no perpetual motion, no battery tax.

### 2.7 The scanning patterns, and what they mean on a phone

NN/g's eyetracking work identifies four scanning patterns (Pernice, *Text Scanning
Patterns: Eyetracking Evidence*, <https://www.nngroup.com/articles/text-scanning-patterns-eyetracking/>):

1. **F-pattern** — fixations on the first lines of the left column and down the left edge.
   It is what happens when *nothing signals* where to look. NN/g explicitly warn that the
   F-pattern is **not** a design goal and that *"in the absence of any signals to guide the
   eye, they will choose the path of minimum effort and will spend most of their fixations
   close to where they start reading"* —
   <https://www.nngroup.com/articles/f-shaped-pattern-reading-web-content>.
2. **Spotted pattern** — hunting for a specific distinctive item (a number, a link).
3. **Layer-cake pattern** — fixations on headings and subheadings, body text skipped
   (Pernice, <https://www.nngroup.com/articles/layer-cake-pattern-scanning/>). NN/g call it
   *"by far the most effective way in which users can scan pages"*, provided the headings
   are **descriptive and representative of the content underneath**.
4. **Commitment pattern** — after a heading grabs them, they read that section properly.

**On mobile specifically**, NN/g's follow-up confirms the F-pattern survives on phones and
adds the **"marking pattern"**: *"keeping the eyes focused in one place as the finger
swipes the page… Marking happens more on mobile than on desktop."*

**Applying this to a live camera HUD:**

- **The video destroys the F-pattern.** There is no stable "left column" — the camera moves.
  A HUD that relies on the F-pattern is a HUD that only works on a tripod.
- **Therefore the HUD must supply the layer-cake explicitly.** The layer-cake needs
  *signalled* headings that are *descriptive*. In the app's terms: the landmark name (26 px
  Fraunces, `:301`), the year, and the action — three visually distinct, semantically
  meaningful bands — with the camera deliberately *de-emphasised* between them.
- **Inverted-T** (used in journalism for page furniture: a heavy rule, a strong headline,
  a light two-column body) is the closest printed analogue for the HUD, and it maps
  directly to the current layout: strong top bar (brand + step), strong bottom caption
  (name + distance), weak centre (one chevron). The app already does this — **the
  problem is that the "T" is too weak**, not that the pattern is wrong.
- **Z-pattern** is a *landing-page* pattern (logo → nav → hero → CTA). It is essentially
  irrelevant to a camera HUD and should not be cited as if it applied. **The app already
  has a Z-shaped layout** (top-left brand → top-right step → centre arrow → bottom-left
  caption → bottom-right band) and that is a *misapplication* of Z-thinking: it puts the
  primary action at the *bottom-right*, which is the hardest reach on a phone held in the
  right hand.

### 2.8 Rules for our app (cognitive & behavioural)

1. **Prioritise the peak and the end.** Treat the arrival flood (`:309`) and the diploma
   (`:977`) as the two things the whole product exists to produce (peak–end rule). Budget
   design effort accordingly; let the between-stops state be cheap.
2. **Move leverage from points/badges to autonomy + relatedness** (Li/Hew/Du 2024:
   autonomy g = 0.638, relatedness g = 1.776, competence g = 0.277). Keep the badge, but
   add the thing that actually creates relatedness: a **chronicle** the user keeps.
3. **Add one retrieval question per landmark** (Roediger & Karpicke 2006). One tap per
   stop; it converts the entire lore from re-reading into testing.
4. **Do not cite choice overload** to justify hiding things — the meta-analytic effect is
   ~zero (Scheibehenne et al. 2010). Justify reductions with Fitts, Hick, SDT-autonomy or
   clutter, or not at all.
5. **Make the arrival cue identical every time.** Wood & Neal's context-cueing theory says
   habits form from stable contexts (same place, same cues). The *cue* is the landmark;
   the *response* is the photo + lore + diploma entry. Identical ritual every time.
6. **Kill the infinite pulse.** `shutterPulse` at `:193` is a 1.6 s infinite attractor and a
   battery tax. Make it a bounded 3-pulse then a static state.
7. **Reduce element interactivity in the band.** Show the next stop in full; reduce the
   others to inert dots. Five live dials is extraneous load; one live dial + four dots is
   the same information with a fraction of the interacting elements.
8. **Treat the first and last stop as the memorable ones** (serial position effect).
   Whatever you name first and last in the route order matters more than the middle.
9. **Plan the layer-cake explicitly.** Because the camera kills the F-pattern, every HUD
   surface must be a self-signalling "heading" band (name / year / action) with the video
   between them, not a continuous field of equal-weight text.
10. **Add the "commitment" affordance.** After the user selects a stop, give them a *real*
    commitment surface (the info sheet) rather than leaving them in the HUD.
11. **Do not let the progress/serial-position logic hide stop #5.** Ensure the last stop is
    the one the user has the strongest memory of.

---

## 3. Typography craft

### 3.1 Typeface classification, and the personality each class carries

The canonical scheme is Maximilien Vox's **Vox-ATypI** (1954), superseded in part by
DIN 16518 / BS 2961 and repeatedly criticised as unstable (Craig Eliason, *The history of
'humanist' type*, ATypI 2013, <https://atypi.org/presentation/the-history-of-humanist-type>;
TGDS, *Type Classification | Vox-ATypI, DIN 16518, BS 2961*). For our purposes:

| Class | Period / origin | Structural signature | Perceived personality (cultural convention, not measurement) | For AradLens |
|---|---|---|---|---|
| **Old style** (Garalde) | Renaissance, 15th–16th c. | low contrast, angled stress, bracketed serifs, calligraphic | humanist, scholarly, warm, authoritative-but-old | **Fraunces is a "display Old Style"** — explicitly modelled on early-20th-c. Windsor / Souvenir / Cooper. ✓ |
| **Transitional** | Baroque, 17th–18th c. | higher contrast, vertical stress, finer serifs | authoritative, editorial, "the newspaper" | Playfair Display (excessive), Libre Baskerville, Source Serif 4 |
| **Modern / Didone** | Enlightenment, 18th–19th c. | extreme thick–thin, hairline serifs | fashion, luxury, cold elegance | ✗ wrong register for Arad (too Parisian) |
| **Slab serif** | Egyptian, 19th c. | slab serifs, low contrast, even colour | industrial, sturdy, engineering, railway, institutional | Zilla Slab, Roboto Slab, Bitter — good for *the city as infrastructure* |
| **Humanist sans** | Renaissance-derived sans | modulated stroke, calligraphic skeleton, generous width | warm, readable, humane | Source Sans 3, **IBM Plex Sans**, Cabin, Mulish |
| **Neo-grotesque** | Helvetica/Univers, 1950s | uniform stroke, tight, neutral | neutral, corporate, *invisible* | Inter, Roboto, **Archivo** |
| **Geometric sans** | Futura, 1920s | perfect circles, monolinear | modern, optimistic, techy, Futura-adjacent to 1968 Olympics | Space Grotesk, Poppins — **too startup** for Arad |
| **Grotesque** | 19th c. | grotesque, tight, low contrast | raw, industrial, utilitarian | Space Mono family |
| **Decorative / display** | any era | expressive | heraldic, commemorative | **Fraunces at high wght + opsz** |
| **Humanist serif** | — | calligraphic serif, e.g. Optima's counterpart | warm serif | Lora, Source Serif |

**The honest caveat:** "typeface personality" is a **cultural-convention** claim, not an
empirical one. There is no controlled study showing that a neo-grotesque raises a
perceived trust rating by X%. What *is* well-supported is that **processing fluency
predicts liking and perceived truth** (Reber et al. 2004; Alter & Oppenheimer 2009), and
that **legibility** (large x-height, generous spacing) is a fluency proxy. So the defensible
version of "personality" is: *the convention is real and culturally learned (typographers
and brand teams have used these pairings for a century), but the mechanism is fluency +
familiarity + category recognition, not magic.*

Sources: Vox-ATypI classification — <https://en.wikipedia.org/wiki/Vox-ATypI_classification>;
sans-serif sub-classes — <https://en.wikipedia.org/wiki/Sans-serif>; type classification
critique — <https://www.thegraphicdesignschool.com/design-history/type-classification>.

### 3.2 What makes a display face read as "heritage / civic / institutional" vs "startup / techy"

This is the question that decides the redesign's personality. It is not one variable; it is
a **constellation**, and every lever points the same way:

**Toward heritage / civic / institutional:**
1. **Serif, and specifically an old-style/transitional serif** (or a slab). Serifs are the
   typographic citation of print; the letterform literally references the carved stone
   inscription. The "grotesque" was named because it looked like the grotesque carved
   ornament of Roman grottoes (Houghton Library, *Etruschi*,
   <https://sites.harvard.edu/houghton-library/2010/05/22/etruschi>).
2. **Moderate stroke contrast, visible serifs, generous counters.** The eye reads these as
   *drawn*, not *rendered*.
3. **High x-height relative to the em** → *no*, actually heritage faces are often *low*
   x-height (Fraunces: 0.482 em) because they were made for print at text sizes. What
   matters for heritage is that the *forms* are historical, not that they're efficient.
4. **Non-neutral numerals** — old-style (text) figures, or figures with a distinct,
   hand-cut quality. A tabular lining figure reads as data-software; an old-style figure
   reads as a printed year.
5. **Small caps, and letterspaced capitals for institutions.** The convention of
   `COMUNITATEA / PRIMĂRIA` style overlines is the visual grammar of government and
   learned institutions.
6. **Rules, seals, double borders, and other "document" furniture.** The app already has
   this at `:984–993` (the diploma with a `4px double #7a6038` border and a letterspaced
   seal line) — **this is the strongest heritage signal in the entire product and it should
   be the brand's visual anchor, not a reward modal.**
7. **Neutral, warm, desaturated colours** — bone, paper, ink, oxidized metal. Not blue.
8. **Asymmetry and editorial composition** — a caption on a plate, a marginal note.

**Toward startup / techy:**
1. **Geometric sans, or neo-grotesque with tight tracking.**
2. **Negative letter-spacing at large sizes** — the current app does this at
   `letter-spacing: -0.005em` on every display element (`:127`, `:134`, `:293`, `:301`,
   `:360`, `:472`, `:597`, `:642`, `:708`, `:823`, `:897`, `:923`, `:972`, `:1039`). At
   `-0.005em` this is negligible, but the *habit* of tracking display type tight is the
   startup reflex. The app's own `DESIGN.md:468` explicitly forbids it ("Don't reintroduce
   a condensed grotesque with negative tracking") — but the CSS still carries it on 14
   rules.
3. **Rounded corners everywhere + soft shadows + gradient fills** — the "app icon" look.
4. **Purple/blue gradients, glass, neon accents.**
5. **Big single-weight hero type at 700/800 with a product shot.**
6. **Emoji as iconography.** The app uses emoji extensively: `🏛️` `⚙️` and the reward
   icons `🥈`, `📷`, `🏆` (`:1170–1171`, `:1644`, `:1668`, `DESIGN.md:88–98`). **This is the
   single most "consumer-app" element in the product.** A civic heritage brand with a
   "Diplomă de Cronicar" does not hand out 🥈 medals.
7. **Inter/Geist/Space Grotesk** — literally the fonts of the current startup idiom.

**Arad specifically.** Arad is Transylvanian, multicultural (Romanian / Hungarian / German),
and its built heritage is **Austro-Hungarian Secession / Hungarian Art Nouveau** (Ödön
Lechner's Primăria, Lajos Szántay's Palatul Cultural, Miklós Ybl's Turnul de Apă — all
named in the app's own `REPERE` data at `:1567`, `:1580`, `:1593`). Secession typography
is *decorative, curvilinear, florinated*. Fraunces — a 2010s American revival of early-20th-c.
American/Windsor forms — is **not** Secession; it is more *Austro-Hungarian civic
administrative* (the engraved plates of city directories, the certificates of the
k.u.k. monarchy) than *Viennese florid*. **That is the correct register for a municipal
heritage tour**, and it is worth being explicit about it: if the redesign wants to claim
Lechner, it needs a different voice; if it wants to claim *the archive*, Fraunces is right.

### 3.3 Type scale ratios — and which suits a mobile HUD

Modular scales multiply a base size by a fixed ratio. Named ratios and their character:

| Ratio | Name | Steps from a 16 px base (down) | Character |
|---|---|---|---|
| 1.200 | minor third | 13.3 / 16 / 19.2 | tight, dense — product UI |
| **1.250** | **major third** | 12.8 / 16 / 20 / 25 / 31.25 | tight but with a step; **best for dense HUDs** |
| **1.333** | **perfect fourth** | 12 / 16 / 21.3 / 28.4 / 37.9 | balanced; the "modern site" default |
| 1.414 | augmented fourth | 11.3 / 16 / 22.6 / 32 | editorial; a touch dramatic |
| 1.500 | perfect fifth | 10.7 / 16 / 24 / 36 | dramatic; marketing |
| 1.618 | golden ratio | 9.9 / 16 / 25.9 / 41.8 | **collapses on small screens** |

Sources: the type-scale literature and design-system implementations — `display-dev/visualize`
typography reference (<https://github.com/display-dev/visualize/blob/main/visualize/reference/typography.md>);
European Commission Component Library v4 typography guidelines
(<https://ec.europa.eu/component-library/v4.10.0/eu/guidelines/typography/>), which uses
16 px / 1 rem base, 1.5 line-height for paragraphs, 1.2 for headings, and a **multiple-of-4
line-height rule**; Material 3 and Apple HIG type scales.

**Which for AradLens?**

- The HUD needs **dense, glanceable, small** sizes (12–28 px) and **big jumps** between
  "reading" and "glancing" registers.
- **1.25 (major third) from a 16 px base** is the right choice: it produces 12.8 / 16 / 20
  / 25 / 31.25 — i.e. usable rungs at **13 / 16 / 20 / 25 / 31**, which map cleanly onto
  "caption / body / subhead / title / display" with **no two rungs closer than 3 px**.
- **1.333 (perfect fourth)** gives 12 / 16 / 21.3 / 28.4 — also fine, slightly more dramatic.
- **1.414** and **1.618 must be avoided.** With a golden ratio the smallest useful step
  below 16 is 9.9 px, which is below the legibility floor (§3.6), so the scale *has* to be
  truncated at the bottom anyway — and then the truncation breaks the ratio and you get
  exactly the muddy 14-step scale the app has now.
- **The rule that matters:** a type system with **5–6 size steps**, not 14. The current
  `DESIGN.md` typography block defines 17 named roles (display/title/stat/headline/label/
  action/subhead/body/body-sm/caption/fine/tag/overline/icon-hero/icon-lg/icon-md/distance/
  start-headline) — most of which are within 2 px of each other.

**Line-height by size** (Apple HIG's table, adapted):
- Display / large title: 1.05–1.12
- Title: 1.15–1.2
- Body: 1.45–1.55 (Android/WCAG 1.4.12 wants ≥ 1.5)
- Caption / dense UI: 1.3–1.4
- **HUD numerals** (single-line, huge): 1.0–1.05 — the current `.dist .num` at `:322` is
  `font-size:26px; line-height:1` ✓.

**Line length:** 45–75 characters for prose. On a phone, 40–60. The app's `#card .card-desc`
at `:472` correctly caps at `max-width: 70ch` — but at 14 px on a 390 px screen, 70ch is
never reached, so the constraint is inert. Fine, but note the real constraint is the
viewport, not the `ch`.

### 3.4 Optical sizing — the app's biggest typographic asset, used at 40 % of its potential

**How it works.** `font-optical-sizing: auto` (the initial value) sets the `opsz` axis from
the used `font-size`, clamped to the font's range (CSS Fonts 4 §8.1,
<https://www.w3.org/TR/css-fonts-4/#font-optical-sizing-def>). Fraunces' `opsz` range is
**9 → 144**. Upstream: *"As opsz decreases, the x-height increases, spacing opens up, and
the characters expand in width"* — i.e. small optical sizes are optimised for *legibility*,
large optical sizes for *display impact* (<https://android.googlesource.com/platform/external/google-fonts/fraunces/>).
Fraunces additionally **disables the "wonk" axis at 18 px and below** in the upstream build
(the shipped 2-axis build has no wonk at all, but the principle matters when the 4-axis font
is adopted).

**Practical consequence for the app:** because `opsz` auto-tracks `font-size`, the app's
display face is *already* a different drawing at every size. At `font-size: 10px` (the
`.cb-name` overline, `:254`) Fraunces renders at opsz ≈ 7.5 → clamped to **9** → its most
legible, widest, lowest-contrast cut. At `font-size: 26px` (`.al-name`, `:301`) it renders
at opsz ≈ 19.5 → a much higher-contrast, more calligraphic cut.

**That means `.cb-name` at 10 px (`:254`) and `.al-name` at 26 px (`:301`) are the same
font at the same weight and they look like two different typefaces.** For the compass band
labels this is *good* (it makes tiny labels legible) but it also means the band labels and
the caption title have **no shared typographic identity**, which weakens the "one archival
voice" claim in `DESIGN.md`.

**Recommendations:**

1. **Adopt the full 4-axis variable font** (adds SOFT and WONK). This is the single
   highest-leverage typographic change available. SOFT at 0–100 controls inkiness; WONK
   0/1 swaps in the leaning and bulbous alternates. WONK **should be 1 above ~24 px**
   (the upstream font auto-disables it below 18 px anyway) and SOFT ≈ 50 for a
   *civic-archive* register — a perfectly sharp serif (SOFT 0) reads as a tech logo; a
   very wet one (SOFT 100) reads as a 1920s advert.
2. **Use `font-variation-settings` deliberately**, e.g.
   `font-variation-settings: "SOFT" 50, "WONK" 1;` on display sizes ≥ 24 px,
   and `"SOFT" 20, "WONK" 0;` below.
3. **Pin `opsz` explicitly where the auto-mapping hurts.** For the HUD numerals (`:322`,
   26 px) the auto-cut is a display cut — high contrast, which is *bad* for a number that
   must be read at a glance while walking. Set
   `font-variation-settings: "opsz" 14;` on the distance numeral so it uses the
   sturdier text cut at a large size. **This is a genuinely expert move and it is exactly
   the kind of thing `opsz` exists for.**
4. **Do not use Fraunces for small running text.** Its x-height is 0.482 em and it has
   old-style proportions; at 11–13 px over a moving video it will be a smudge. Keep the
   body on the system stack, or on a purpose-built text face.

### 3.5 Variable fonts, weights, and a no-build static page

**How to use variable fonts with zero build tooling:**

```css
@font-face {
  font-family: "AradLens Display";
  src: url("fonts/fraunces-latin.woff2") format("woff2-variations");
  font-weight: 100 900;      /* declares the variable wght range */
  font-style: normal;
  font-display: swap;        /* swap, not block: the HUD must never be blank */
}
```
The current `@font-face` at `:14–25` already does this correctly, plus `unicode-range`
splitting latin / latin-ext so the browser only downloads what it needs. Two improvements:

- **`format("woff2")` is correct and modern** — `woff2-variations` is the legacy token.
  Keep `format("woff2")`.
- **`font-display: swap` is right for this app.** The HUD is useless if the display face
  blocks; swap with a metric-compatible fallback is right. But `swap` means a **visible
  reflow** when the font arrives. For the *display* elements (`.al-name`, `.brand`) use
  `size-adjust`/`ascent-override`/`descent-override`/`line-gap-override` on a fallback
  `@font-face` (CSS Fonts 4 §4.10) to eliminate the jump. **This is the professional move
  and it is cheap.**
- **`font-display: swap` also means the first paint of a walking tour may use Georgia.**
  Georgia has a very different width from Fraunces → the caption reflows → the distance
  number moves → the user looks at the wrong place for 200 ms while walking. Metric
  overrides fix this.

**Weights actually available:** `wght` 100–900 continuous. The app uses 600 (display),
700/800 (body/action), 400 (fine). At 26 px a 600-weight Fraunces reads quite light; at
9 pt optical size it reads *heavier*. Note the CSS declares `font-weight: 100 900` so any
weight in the range interpolates — **there is no "missing weight" problem here** (unlike a
static family). Good.

**System-font / variable-font strategy for a no-build static page:**
- **Self-host everything you brand with.** The app already does this for Fraunces. Keep it
  that way: no Google Fonts CDN (GDPR + latency + the deploy is a flat nginx root).
- **Do NOT self-host the body font.** Use the platform stack. Cost: 0 KB. Benefit: native
  rendering, native Dynamic Type, native accessibility, no FOUT.
- **The correct body stack for this app** (fixing `:84`):
  ```css
  --body: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
          "Helvetica Neue", Arial, "Noto Sans", sans-serif;
  ```
  Note the order: **`-apple-system` and `BlinkMacSystemFont` must come before `Segoe UI`**,
  otherwise Windows desktop gets Segoe UI while iOS gets SF Pro — inconsistent identity.
  Current code has `'Segoe UI', system-ui, sans-serif` which is the reverse of what you
  want for a cross-platform product.
- **Consider `ui-serif` / `ui-sans-serif` generics** (CSS Fonts 4 §2.1.5) for the
  *fallback* of the display face: `font-family: "AradLens Display", ui-serif, Georgia,
  "Times New Roman", serif;` — `ui-serif` maps to New York on macOS/iOS, giving a
  native-feeling fallback that is far closer to Fraunces than Georgia.
- **Add `font-synthesis-weight: none`** if you ever want to prevent synthetic bolding of a
  fallback (CSS Fonts 4 §2.8.1).

### 3.6 Small-size legibility on mobile — the hard floors

- **16 px is the consensus floor for body text** on mobile. Reasons: (a) iOS Safari
  auto-zooms any input with a computed font-size < 16 px; (b) 16 px CSS ≈ 12 pt ≈ the
  minimum x-height of 1.2 mm at 40 cm viewing distance recommended for people with
  moderate vision impairment (<https://www.cedc.tools/size.html>); (c) the W3C Mobile
  Accessibility Task Force converged on it
  (<https://www.w3.org/2014/07/25-mobile-a11y-minutes.html>); (d) a SIGACCESS review of text
  accessibility standards reports practitioners "unanimously agreed that 16px (pixels) or
  1rem is the ideal minimum"
  (<https://dl.acm.org/doi/10.1145/3663547.3759692>).
- **Apple HIG**: iOS/iPadOS default 17 pt, **minimum 11 pt**; and explicitly *"avoid light
  font weights… prefer Regular, Medium, Semibold, or Bold and avoid Ultralight, Thin, and
  Light"* (<https://developer.apple.com/design/human-interface-guidelines/foundations/typography>).
- **Legibility boosters**, in order of effect: **larger x-height**, then **wider letter
  spacing at small sizes**, then **larger line-height**, then **higher contrast**.
  The SIGACCESS review states: *"larger x-heights, width, and letter spacing improve
  legibility, especially at smaller font sizes."*
- **The app's floors are wrong in two places:**
  - `.cb-name` at **10 px** (`:254`) and `.cb-dist` at **10 px** (`:260`) — the compass band
    labels. At 10 px over a live camera, with the label at `opacity: .82` (`:257`) and the
    *distance* at `opacity: .55` (`:260`), the effective contrast of the distance is
    roughly **bone at 45 %** — around 4:1 at best on a dark scrim and **~1.5:1 over a bright
    street**. These are unreadable. Apple allows 11 pt as an absolute floor; the app goes
    below it.
  - `.lore-ribbon` / `.mode-badge-pill` / `.reward-ribbon` / `.schematic-badge` /
    `.chapter-period-badge` / `.cl-item` at **11 px** with `letter-spacing: 1px–2px` and
    `text-transform: uppercase` (`:845`, `:919`, `:958`, `:615`, `:885`, `:902`, `:983`).
    Uppercase + letterspacing + 11 px is the classic legibility killer (no ascender/descender
    cues, x-height confusion). **These are the app's worst typographic offenders.**

### 3.7 Tracking, kerning, and the "letterspace the caps" reflex

- **Negative tracking belongs to large display type only, and only when the face has
  generous sidebearings.** The app applies `letter-spacing: -0.005em` to 14 display rules —
  which is *so small it is invisible* (−0.13 px at 26 px). It is neither helping nor
  hurting. If the redesign wants a real display cut, use **−0.015em to −0.02em at 28 px+
  only**, and 0 or +0.005em below 20 px.
- **Positive tracking belongs to small caps/uppercase labels** — the app does this
  correctly at `:845` (1 px), `:919` (1 px), `:958` (2 px), `:983` (2 px). At 11 px, 1 px
  = 0.09 em, which is on the weak side; **0.12–0.16 em** is the right range for tracked
  uppercase micro-labels.
- **Kerning** is handled by the font's `kern`/`GPOS` table. Fraunces ships `liga` and
  `rvrn` in GSUB (measured) plus the standard GPOS kerning; **do not add manual kerning
  pairs** — modern browsers apply GPOS kerning automatically and `font-kerning: auto` is
  the default. Explicitly *do not* set `font-kerning: none` (the app doesn't).
- **Optical margin alignment** for the flush-left caption block: a serif's "A" and "T"
  overhang their sidebearings, so a flush-left column of Fraunces looks slightly
  indented at the top-left. The `.caption` block (`:288`) is flush-left — a
  `text-indent: -0.02em` on the first line, or a 1–2 px negative left padding, fixes it.

### 3.8 Tabular numerals, ligatures, and ALL-CAPS

- **Tabular numerals.** A "meter readout that shifts width while walking is a defect" is
  correct design reasoning (the app says so at `DESIGN.md:337–341`). But:
  - The system stack (SF Pro / Segoe UI / Roboto) **does** have real tabular figures and
    `font-variant-numeric: tabular-nums` works there. ✓
  - **Fraunces has no `tnum` feature** (measured). `tabular-nums` on Fraunces is a no-op
    and the digits are **proportional** (1024–1461 units). → **Never put a live-changing
    number in Fraunces.** The app is mostly correct here (`.dist .num` at `:322` inherits
    the body font; `.cb-dist` at `:260` inherits the body font) — but `.lore-year-stamp`
    (`:931`) *is* Fraunces and *does* carry `tabular-nums` that does nothing. And
    `.reward-ribbon`/`.diploma-meta` are body-font, ✓.
  - **Recommendation:** introduce a *tabular mono* for the live meters. `ui-monospace` /
    `SF Mono` / `Roboto Mono` / `JetBrains Mono` — but a monospace meter changes the
    register. Better: keep the system sans and add
    `font-variant-numeric: tabular-nums slashed-zero;` — the **slashed zero** is a
    genuinely useful addition for a navigational readout (distinguishes `0` from `O`).
  - Even with real tabular figures, the *unit* and the *number* must be on the same
    baseline grid, and the number must not change width when the value goes from 3 to 4
    digits. **The current `.dist .num` at `:322` is `font-size: 26px` with tabular-nums —
    ✓ — but the unit `.dist .unit` at `:323` is only 15 px and is *not* tabular, so the
    unit can shift.** Fix: give `.dist .unit` and `.dist .sep` the same `tabular-nums` and
    a fixed inline-block width, or set the whole `.dist` to `font-variant-numeric:
    tabular-nums` and `white-space: nowrap` (it already is, `:320`).
- **Ligatures.** `liga` is present in Fraunces (measured). The app should **not**
  force `font-variant-ligatures: none` — but it also shouldn't lean on them; a civic
  heritage voice wants the `fi`/`fl` ligatures intact at display sizes and the `liga`
  behaviour is fine either way.
- **ALL-CAPS misuse.** The three classic failures, all present in the app:
  1. **Caps for long phrases** — `.lore-ribbon` (`:943`) sets the ribbon label in uppercase;
     if that's a phrase, it's unreadable at 11 px. `.reward-ribbon` (`:958`) sets
     `"OMOLOGAT 1876 · ARADLENS ARCHIVE"` at 11 px / 2 px tracking — that one is
     *acceptable* because it's 3 words and the tracking is generous.
  2. **Caps + tight tracking** — the app tracks caps *wide*, which is correct. ✓
  3. **Caps + low contrast + small size** — `.mode-badge-pill` (`:845`) is 11 px / 800 /
     amber-on-amber-ink (8.69:1 ✓) but in uppercase. The contrast is fine; the size is not.
  - **Rule:** ALL-CAPS is for **≤ 3 words**, **≥ 11 px**, **≥ 0.12em tracking**, and never
    for a sentence. The app's `.schematic-badge` ("Hartă schematică temporară (Demo)",
    `:615`) is **6 words, uppercase, 12 px, 1px tracking** — a clear violation of the
    rule as well as being the app's most legally/medically risky string (it's the
    disclaimer that the map is not GPS-projected).

### 3.9 What makes a display face feel "heritage / civic" — operational checklist

Consolidated into a testable checklist (each item is a lever, not a law):

| Lever | Heritage / civic | Startup / techy |
|---|---|---|
| Classification | old-style / transitional serif, or slab | geometric sans |
| Stroke contrast | moderate | monolinear |
| Numerals | old-style or distinctly-cut; lining-tabular in the data layer | default lining |
| Labels | letterspaced small caps | sentence case, tracked |
| Rules & borders | 1 px hairline + occasional double rule | 1 px, uniform, no ornaments |
| Colour | bone / paper / ink / oxidised metal | saturated, gradient, neon |
| Composition | editorial, asymmetric, marginal | centred hero, symmetric grid |
| Furniture | seals, plates, document edges | cards, chips, pills, shadows |
| Iconography | line-drawn, consistent stroke | filled emoji |
| Motion | short, mechanical, physical (a stamp, a card sliding) | springy, playful, bouncy |

The app currently scores **8/10 on heritage** in structure (hairlines, bone, sealed
diploma, no gradients) and **2/10** on the two items that most cheaply read as "startup":
**emoji iconography** (`:1163`, `:1644`, `:1650`, `DESIGN.md:88`) and **rounded pill
buttons with soft shadows** (`:139`, `:383–388`, `:687`).

### 3.10 Font pairing — the rules

**Rule 1 — contrast or harmony, not both.** Either two faces of clearly different
categories (serif display + sans body) or one family. Never two similar-but-not-identical
families: they create tension without hierarchy.
(`display-dev/visualize` typography reference, linked above; `impeccable` typography
reference, <https://github.com/pbakaus/impeccable/blob/main/skill/reference/typography.md>.)

**Rule 2 — the body font is the more important choice.** A great display with an
unreadable body is a failure. Test the body in real Romanian content first.

**Rule 3 — match x-height when both are sans.** Inter and Roboto Flex pair badly because
Inter's x-height is much taller. (Same sources.)

**Rule 4 — one variable family per role.** A display face with a `wght` axis + a body
face with a `wght` axis = two font files, not twelve.

**Rule 5 — for this app, the pairing is already decided by the brand:** *display serif +
system sans*. Do not add a third face. Do not add a "techy" mono for the meters if the
system sans has real tabular figures; if you do add one, it must be the *only* mono.

### 3.11 Ten recommended pairings for AradLens (real OFL families, real fallbacks)

Romanian diacritics required: **ă â î ș ț** (U+0218–U+021B, U+0102–U+0103, U+00C2–U+00C3).
Every family below ships Latin-Ext coverage on Google Fonts; the two `Fraunces` subsets
already in `fonts/` cover exactly this (`fraunces-latin-ext.woff2` declares
`U+0100-02BA … U+1E00-1E9F … U+1EF2-1EFF, U+2020-20AB, U+2026, U+20A0-20AB, U+20AC-20C0,
U+2113, U+2C60-2C7F, U+A720-A7FF`). **Every candidate below must be checked for
U+0218/0219/021A/021B before shipping** — Google Fonts' "Romanian" language tag is the
quick check (<https://fonts.google.com/specimen/Playwrite+RO> lists Romanian-supporting
families).

| # | Display | Body | Why it fits the personality | Fallback stack |
|---|---|---|---|---|
| 1 | **Fraunces** (already shipped; upgrade to 4-axis) | system sans | *The incumbent.* Old-style soft-serif modelled on Windsor/Souvenir/Cooper = "archival city plate", exactly the `primaria-1901.jpg` register. The `opsz` axis lets one family do display **and** the 12–14 px band labels. | `"AradLens Display", ui-serif, Georgia, "Times New Roman", serif` / `-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif` |
| 2 | **Source Serif 4** | system sans | Transitional-ish, *designed for screen reading* (Adobe's own brief). More institutional/archival than expressive; less "boutique coffee shop" than Fraunces. Variable `wght` + `opsz`. | `ui-serif, Georgia, serif` / system sans |
| 3 | **Zilla Slab** | system sans | Slab = engineering + civic + railway. Reads as *the city as infrastructure* (water tower, tram lines, the Mureș). Pairs perfectly with a manuscript/archival tone. | `ui-serif, Georgia, serif` / system sans |
| 4 | **Playfair Display** | system sans | High-contrast Didone — **the "official city hall invitation"** voice. Maximum institutional. *Risk:* over-used and fashion-coded; use only at 30 px+ for one word. | `ui-serif, Georgia, serif` / system sans |
| 5 | **Bitter** | system sans | Contemporary slab with an editorial spine. Warmer and more literary than Zilla; good for lore body copy if Fraunces is too decorative for paragraphs. | `ui-serif, Georgia, serif` / system sans |
| 6 | **IBM Plex Sans** | IBM Plex Sans | Plex is *engineered-institution* by name and design (IBM = civic/enterprise documentation). Plex Sans is a humanist sans, high x-height, excellent at 12–14 px, **with real tabular figures**. Use as the *whole* system — display + body — for a "municipal archive terminal" concept. | `ui-sans-serif, system-ui, sans-serif` |
| 7 | **Libre Caslon Text / Libre Baskerville** | system sans | Old-style/transitional text faces (SIL, from the Libre ecosystem). Libre Caslon Text is *explicitly designed for long-form reading* — the right choice if the lore becomes a scrolling "chapter" document. | `ui-serif, Georgia, serif` / system sans |
| 8 | **Fraunces** (4-axis, WONK+SOFT) | **Source Sans 3** | The only pairing on this list where both faces are designed by people who think about *ink and paper*: Fraunces for the plate, Source Sans 3 for the archival caption. Source Sans 3 is a humanist sans (Adobe) with a strong institutional voice and true tabular figures. | `ui-serif, Georgia, serif` / `system-ui, -apple-system, "Segoe UI", sans-serif` |
| 9 | **Cormorant Garamond** | system sans | A very high-contrast, small-x-height Garamond revival — the *brochure / opera programme* register. Use only for the chapter title and the diploma. Beautiful, unforgiving, needs ≥ 28 px. | `ui-serif, Georgia, serif` / system sans |
| 10 | **Newsreader** | system sans | Designed for *news* — a typeface whose stated job is to be read on a screen in a column, fast. The right "heritage that people actually read" option for the lore body, if you want a serif reading face without Fraunces' display quirks. | `ui-serif, Georgia, serif` / system sans |

**Not recommended** (and why, so the next agent doesn't drift): *Space Grotesk, Poppins,
DM Sans, Outfit, Sora* (geometric/startup); *Inter, Geist* (neutral tech; Inter is the
default UI face of the entire 2015–2025 startup world and will make Arad read as a
fintech pitch deck); *Libre Baskerville at 11 px* (too small for that contrast).

**Three best, for Arad specifically:**
1. **#1 Fraunces (4-axis) + system sans** — lowest risk, highest authenticity, zero new
   files beyond one woff2 swap.
2. **#8 Fraunces + Source Sans 3** — best *designed* pairing; two files, both OFL, both with
   `opsz`/`wght`.
3. **#6 IBM Plex Sans + IBM Plex Sans** — the radical option: abandon the serif entirely
   and build the whole "municipal archive terminal" identity on a humanist sans with real
   tabular figures. If the brief wants a genuinely different direction from the current
   one, this is the cleanest way to get it.

### 3.12 Rules for our app (typography)

1. **Ship a 5-step modular scale, ratio 1.25, base 16 px:** 13 / 16 / 20 / 25 / 31 px
   (rounded), with line-heights 1.4 / 1.5 / 1.35 / 1.2 / 1.1. Kill the 14-step scale.
2. **Body text ≥ 16 px.** Everything at 12–14 px must be a *label*, not prose, and must be
   uppercase-with-tracking ≤ 3 words or a single short phrase.
3. **Absolute floor 11 px, and only for letterspaced uppercase micro-labels.** The current
   10 px band labels (`:254`, `:260`) must go up to 12–13 px or become icons.
4. **Never put a live-changing number in Fraunces.** Fraunces has no `tnum` and its
   digits are proportional (measured). Use the body sans with
   `font-variant-numeric: tabular-nums slashed-zero;` for every meter, including the
   unit and separator.
5. **Upgrade the display font to the full 4-axis variable build**
   (`Fraunces[SOFT,WONK,opsz,wght]`). Set `SOFT` ≈ 40–60 and `WONK` = 1 for ≥ 24 px,
   `WONK` = 0 and `SOFT` ≈ 20 below. This is the highest-leverage single change.
6. **Pin `opsz` on the live distance numeral** (`font-variation-settings: "opsz" 14;`)
   so a 26 px number uses the sturdy text cut, not the high-contrast display cut.
7. **Fix the body stack order:** `-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
   "Helvetica Neue", Arial, sans-serif`. `system-ui` first for a consistent native feel;
   `Segoe UI` first only on Windows.
8. **Use `ui-serif` as the display fallback**, before Georgia — on iOS/macOS this is New
   York, which is much closer to Fraunces than Georgia and avoids a jarring reflow.
9. **Add metric-compatible fallbacks** (`size-adjust`, `ascent-override`, `descent-override`,
   `line-gap-override`) so `font-display: swap` does not reflow the caption on first paint.
10. **Zero ALL-CAPS sentences.** Specifically fix `.schematic-badge` (`:615`, 6 words,
    uppercase, 12 px) — rewrite it as a sentence: *"Hartă demonstrativă — pozițiile nu
    sunt GPS"*.
11. **Replace all emoji with drawn line icons** (`:1170–1171`, `:1644`, `:1650`, `:963`).
    This is the single biggest "civic vs startup" lever and it is cheap.
12. **Tracking:** 0 for body; −0.015em only at ≥ 28 px display; +0.12–0.16em on uppercase
    micro-labels; remove the meaningless −0.005em from all 14 display rules (or make it
    real at large sizes).
13. **Line length 40–60 ch on mobile** for the lore; keep `max-width: 70ch` for desktop.
    Line-height 1.5 for body (WCAG 1.4.12 floor), 1.2 for headings.
14. **Never disable kerning.** Do not add manual kerning pairs.

---

## 4. Colour & contrast

### 4.1 Colour psychology — what the evidence actually supports

**The strong version (weakly supported):** Elliot & Maier's *colour-in-context theory*
(2014, *Annual Review of Psychology* 65:95–120) proposes that colour responses are
*learned* through repeated pairing of colour with concepts, messages and experiences, and
that context determines which connotation is selected: *"blue on a ribbon is positive
(indicating first place), but blue on a piece of meat is negative (indicating rotten)"*
(<https://www.annualreviews.org/content/journals/10.1146/annurev-psych-010213-115035>).
Their own conclusion: *"The literature remains at a nascent stage of development, however,
and we note that considerable work on boundary conditions, moderators, and real-world
generalizability is needed before strong conceptual statements and recommendations for
application are warranted."*

**The best large-scale evidence:** Jonauskaite, Abu-Akel et al. (2025), *Do we feel
colours? A systematic review of 128 years of psychological research linking colours and
emotions*, Psychonomic Bulletin & Review — 132 peer-reviewed articles, 1895–2022,
**42 266 participants across 64 countries**. Findings: all basic colour categories show
systematic correspondences with valence, arousal and power; the effects are **many-to-many**
and are driven by **lightness, saturation and hue** ("colour temperature"), with light
colours → positive, dark → negative, warm → more arousing/powerful, cool → calmer.
**Critical caveat in their own words:** *"most colour–emotion correspondences were tested on
an abstract level (i.e., associations), it remains to be seen whether such correspondences
translate to the impact of colour on experienced emotions and specific contexts."*
(<https://link.springer.com/article/10.3758/s13423-024-02615-z>)

**The critique (essential to read):** Jonauskaite & Mohr (2026), *Beware! Colour and
emotion correspondences are rarely about feelings*, Psychonomic Bulletin & Review —
reviewed 31 studies that measured **felt** affect rather than associations; only 8 immersed
participants in coloured environments and controlled lightness/chroma; **those 8 were
inconsistent**; there are *"tendencies hinting at higher physiological arousal in warm and
more chromatic environments"* but *"We need more systematic studies before we can conclude
that colour impacts felt affective states"* —
<https://benjamins.com/catalog/z.244.03jon>.

**And the strongest debunk:** Jonauskaite, Gayle Thalmayer, Müller & Mohr (2021),
*What Does Your Favourite Colour Say About Your Personality? Not Much*, PSPR — tested 11
colour-personality predictions from popular websites against Big Six/HEXACO traits in 323
participants; **failed to confirm any of the 11**; Bayes factors gave substantial-to-strong
support for the null — <https://journals.sagepub.com/doi/full/10.5964/ps.6297>.

**Practical rules for us:**

- **Never argue "blue = trust".** Argue "blue-teal = the Mureș river = the map = the
  water-feature layer". A *referential* justification (this colour means *this thing in
  this app*) is both defensible and much more useful to a designer than a
  universal-meaning claim.
- **Do use lightness/saturation/hue systematically**, because that axis *is* well
  supported: light = positive, warm = arousing, dark = serious. The app's bone-on-near-black
  is literally "light-on-dark = positive, serious".
- **Do use colour to encode *state within one system*** (teal = completed). That is
  *referential* colour, which is the reliable kind.

### 4.2 Colour harmony in practice: OKLCH and HCT

**OKLCH** (Björn Ottosson, *A perceptual color space for image processing*, 2020,
<https://bottosson.github.io/posts/oklab/>; CSS Color 4, <https://www.w3.org/TR/css-color-4/>)
gives three axes: **L** (perceived lightness 0–1), **C** (chroma), **H** (hue angle).
Why it matters here:
- Equal `L` steps look equally spaced to the eye → a tonal ramp built on one hue+chroma
  is perceptually even.
- Hue stays steady as you lighten/darken (unlike CIELAB, where blues drift purple).
- `color-mix(in oklch, ...)` produces clean midpoints without the muddy HSL arc.
- **Critical limit:** OKLCH is a *colour space*, not an *appearance model*. It has no inputs
  for surround, adaptation or viewing conditions, so it **cannot predict simultaneous
  contrast** — i.e. exactly the effect that matters when bone text sits on a *changing
  camera feed*. And it assumes SDR, D65, a normally-lit room. Ottosson himself notes the
  fit used CAM16-generated data, not new human experiments
  (<https://colortable.org/methods/oklab/>). **Use OKLCH to *choose* colours; use WCAG
  ratios to *verify* them.** Never use OKLCH L as a proxy for contrast.

**HCT / Material You** (Material color utilities, <https://github.com/material-foundation/material-color-utilities>)
adds a **tone** scale (T0–T100) mapped onto the Material 3 tonal-palette algorithm, and
supports **dynamic colour** from a wallpaper/source colour. Relevant to AradLens because
the app already has two themes (`body.light-theme`, `:65`) — HCT could generate the two
themes from one brand hue with guaranteed tonal relationships. But HCT's tone→contrast
mapping is not WCAG-aligned; still verify with the ratio.

**Measured OKLCH for the current palette** (see §0.1) shows the app is already
*almost* well-formed in OKLCH: `--ground` is `oklch(0.162 0.010 255.7)` — a near-neutral
with a whisper of blue; `--bone` is `oklch(0.962 0.013 86.8)` — a warm off-white with a
tiny warm chroma; `--amber` is `oklch(0.768 0.061 80.3)` — a low-chroma warm beige at
L 0.77. **The hues are right. The *chroma* of the beige is low (0.061)**, which is exactly
the "archive paper, not gold" intent in the CSS comment at `:30–35`, and it is *also* why
the beige fails contrast over bright footage (1.88:1 on mid-grey).

### 4.3 Contrast ratios — the actual WCAG 2.2 rules

From WCAG 2.2 (W3C Recommendation, 12 Dec 2024) — <https://www.w3.org/TR/WCAG22/>:

| SC | Level | Requirement |
|---|---|---|
| **1.4.3 Contrast (Minimum)** | AA | text ≥ **4.5:1**; large-scale text (≥ 18.66px bold or ≥ 24px) ≥ **3:1**; inactive components, decoration, and logotypes exempt |
| **1.4.6 Contrast (Enhanced)** | AAA | text ≥ **7:1**; large text ≥ **4.5:1** |
| **1.4.11 Non-text Contrast** | AA | **UI component states and graphical objects** ≥ **3:1** against adjacent colour |
| **1.4.12 Text Spacing** | AA | no loss of content/functionality at line-height 1.5, paragraph-spacing 2em, letter-spacing 0.12em, word-spacing 0.16em |
| **2.4.11 / 2.4.12 Focus Not Obscured** | AA | focus target not entirely / not partially hidden |
| **2.4.13 Focus Appearance** | AAA | focus indicator ≥ the area of a 2 px perimeter **and** ≥ **3:1 change of contrast** between focused and unfocused states |

Understanding docs: <https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast>,
<https://www.w3.org/WAI/WCAG22/Understanding/focus-appearance.html>.

**The app's focus ring** (`index.html:88`) is `outline: 2px solid var(--accent-green);
outline-offset: 3px;` → **2 px thick ✓**, but:
- In dark theme `--accent-green` = `#c8b088` on the camera ground `#0b0e12` → 9.23:1 ✓.
- In light theme `--accent-green` = `#7a6038` on bone → 5.28:1 ✓.
- But the **2.4.13 change-of-contrast** requirement measures focused-vs-unfocused. If the
  unfocused state already has a visible border, the *change* may be small. The app's ring
  is the only focus indicator and it appears from nothing → change is large ✓.
- **Gap:** `outline-offset: 3px` on a control over a *moving camera feed* means the ring
  floats 3 px above a background that changes every frame — the ring must be visible
  against *any* background, i.e. it needs its own guaranteed contrast, not just "the
  outline colour has good contrast with the surface".

**APCA / WCAG 3.0.** WCAG 3.0 is a **Working Draft** (latest 10 Sept 2026,
<https://www.w3.org/TR/wcag-3.0>) and *does not replace WCAG 2*; the AGWG states
*"Meeting WCAG 2 at AA level means you will be close to meeting WCAG 3, but there may be
differences."* APCA's status inside WCAG 3 has been unstable (it was marked for removal in
early 2023 and the contrast algorithm is still not settled —
<http://adrianroselli.com/2026/04/wcag3-contrast-as-of-april-2026.html>).
**Design against WCAG 2.2 AA. Use APCA only as a secondary tiebreaker, and never as the
justification for a failure.**

### 4.4 Dark-mode elevation, and the "one accent" discipline

**Elevation.** Material 3 uses *tonal* elevation: surfaces get lighter as they rise
(`surface-container-low → … → -high`), not shadows. Apple uses translucent materials +
shadows. In a camera HUD, **tonal elevation is strictly better than shadow elevation**,
because a shadow over arbitrary footage is unpredictable and the shadow *is* what creates
the figure/ground edge (§1.4) — so you want that edge to be *designed*, not incidental.

**One accent.** The app's "One Beige Rule" (`DESIGN.md:252–256`) is a strong, correct
instinct, and it is a **Von Restorff** implementation (§2.1) *and* a Prägnanz
"emphasis" implementation (§1.5). The problem is that the app already has **three**
accents: beige (`--amber`), teal (`--deep-teal`) and green (`.completed #2f9e8c`), plus
the emoji medals. Three accents = no accent.

**Proposed consolidation:** beige = *live direction and arrival* (the one accent);
teal = *a second, non-competing hue used only for "done/verified"*, at most one element
per screen; everything else bone/hairline. The green `.completed` ring (`:288`) should be
**the same teal as `--deep-teal`** — not a third hue — and it should be light enough to
read (see §4.5).

### 4.5 Why glassmorphism fails over a camera feed — and what to do instead

**The mechanics of failure.** NN/g, *Glassmorphism: Definition and Best Practices* (2024),
<https://www.nngroup.com/articles/glassmorphism/>:
- *"The most significant issues with glassmorphism stems from text readability problems,
  with text either being too light or too dark or backgrounds being too busy."*
- *"Since glassmorphic components are translucent, textual elements can fall over multiple
  colors, which can affect readability."*
- *"The more background blur applied to a glassmorphic component, the harder it is to
  distinguish the elements behind it."*
- Recommended mitigations: **meet contrast requirements**, **use strokes and gradients for
  depth instead of relying on blur**, and **offer the user a reduced-transparency /
  increase-contrast option** (Apple's `Increase Contrast` / `Reduce Transparency`
  accessibility settings).

**The WCAG problem.** A translucent panel over a *live, changing* background has **no
stable adjacent colour**, so 1.4.3 and 1.4.11 cannot be satisfied *by construction* — you
cannot compute a ratio against a background that changes 30 times a second. A translucent
panel over a *static* background (a marketing hero image) is one thing; over a camera
feed it is un-auditable.

**The performance problem.** `backdrop-filter: blur()` is GPU-accelerated and must be
recomputed whenever the content behind changes — which for a live camera is *every frame*.
The app already uses `backdrop-filter: blur(4px)` (`:751`) and `blur(5px)` (`:808`) on two
modals; the `captureModal` sits over the *live camera* (`:749` `rgba(0,0,0,.7)` +
`blur(4px)`). On a mid-range Android at 1080p this is a measurable frame-rate hit on a
battery-powered tour. Apple's "liquid glass" (2025) drew the same criticism for
contrast, motion sensitivity, and energy consumption
(<https://uxdesign.cc/apples-liquid-glass-isn-t-just-an-accessibility-blunder-it-s-an-environmental-one-too-08c593a87963>).

**Better alternatives for this app — in order of preference:**

1. **Opaque "world surface" panels.** The app already has this concept: `--bg-surface`
   `#141a21` with a 1 px hairline (`DESIGN.md:258–274`). Make it the *default* for all
   text-bearing surfaces over the camera. Solid = auditable = fast = accessible.
2. **Tonal scrims with a guaranteed floor.** The current top/bottom scrims
   (`--hud-scrim-top` / `--hud-scrim-bottom`, `:41–42`) are the right idea and already
   achieve 6.58:1 and 13.77:1 over a white frame. **Extend this idea**: every text element
   gets either a scrim of its own or a guaranteed-contrast fill behind it.
3. **A "shadow instead of blur" material.** The app's "Offset-Blur Rule" (`DESIGN.md:379–381`)
   — `2px 6–14px` black at .5–.7 — is a *good* material system for a camera HUD: it is
   cheap (no blur, no extra compositing pass), it creates the perceptual edge that restores
   figure/ground, and it is contrast-stable because the shadow is a fixed dark region
   regardless of what is behind it. **This is the app's existing strength and it should be
   pushed further, not replaced by glass.**
4. **If you must have translucency:** use a *fixed* low-alpha tint (e.g. `oklch(0.16 0.01
   250 / 0.82)`) that is **opaque enough to guarantee ≥ 4.5:1 against the worst-case
   background**, plus a 1 px high-contrast stroke. In practice that means you are no longer
   doing glassmorphism — you are doing a tinted panel. **Be honest about that in the
   design rationale.**

### 4.6 The 60/30/10 rule — what it is and what it is not

The 60/30/10 rule (60 % dominant, 30 % secondary, 10 % accent) originates in **interior
design** and has been carried into UI as a heuristic. Its proponents state it as a
guideline, not a law ("*This rule is a guideline, not a strict rule*",
<https://uxplanet.org/the-60-30-10-rule-a-foolproof-way-to-choose-colors-for-your-ui-design-d15625e56d25>).
**There is no empirical validation of the specific proportions.** Treat it as a *check*:
if your accent colour occupies 10 % of the screen and everything else is one neutral plus
one secondary, your hierarchy is probably right. Do not cite it as research.

**Applied to AradLens:** the camera feed is ~90 % of the screen, so the HUD chrome (bone +
hairlines + scrims) is the "60", the beige is the "10" and the teal is the "2". That is
already approximately correct. **The real problem is not the ratio — it's that the beige
and the teal are used at *the same visual weight in the same view* in the story mode**
(`.completed` rings at `:269–270` next to the active beige ring at `:262`).

### 4.7 A proposed OKLCH palette (computed and contrast-verified)

**[OUR OWN MEASUREMENT]** — OKLCH → sRGB hex (CSS Color 4 matrices), with WCAG 2.x ratios:

| Token | OKLCH | sRGB fallback | Verified contrast |
|---|---|---|---|
| `--ground` | `oklch(0.160 0.012 250)` | `#090e12` | — |
| `--surface` | `oklch(0.225 0.014 250)` | `#171c22` | — |
| `--surface-hi` | `oklch(0.275 0.016 250)` | `#22282f` | — |
| `--bone` | `oklch(0.960 0.012 85)` | `#f5f1e9` | on ground **17.21:1** |
| `--bone-dim` (replaces `rgba(246,242,233,.72)`) | `oklch(0.820 0.014 85)` | `#c8c4ba` | on ground **11.13:1**, on surface **9.84:1** |
| `--beige` | `oklch(0.800 0.085 78)` | `#dcb77f` | on ground **10.27:1**, on surface **9.08:1** |
| `--beige-ink` | `oklch(0.190 0.030 70)` | `#1c1105` | on beige **9.83:1** |
| `--teal` | `oklch(0.520 0.095 180)` | `#007a6b` | on ground **3.69:1** (non-text ✓), bone on teal **4.66:1** (text ✓) |
| `--teal-bright` | `oklch(0.720 0.105 178)` | `#4dbaa5` | on ground **8.20:1** — *this* is the "completed" colour, not a third hue |
| `--hairline` | `oklch(0.420 0.018 250)` | `#464e57` | on ground 2.30:1 — decorative only ✓ |
| light `--bg-main` | `oklch(0.970 0.010 85)` | `#f8f5ee` | — |
| light `--surface` | `oklch(0.995 0.004 85)` | `#fffdfa` | — |
| light `--ink` | `oklch(0.180 0.025 80)` | `#171005` | on light-main **17.33:1** |
| light `--ink-dim` | `oklch(0.400 0.025 80)` | `#4f4639` | on light-main **8.51:1** |
| light `--beige-deep` | `oklch(0.520 0.075 75)` | `#826235` | on light-main **5.15:1** |

**Deltas from the current palette, and why each is needed:**

1. `--beige` chroma 0.061 → **0.085** and L 0.768 → **0.800**. The current beige is
   *deliberately* low-chroma ("bej de hârtie de arhivă, nu galben", `:30`). That intent is
   good, but the chroma was pushed too far: at L 0.768/C 0.061 the beige reads as *grey-beige*
   rather than *archive paper*. Raising chroma to 0.085 at the same L keeps the paper
   feeling but makes it legible as a colour.
2. `--teal` L 0.458 → **0.520**. The current `#14655a` at **2.53:1** on `--bg-surface`
   **fails WCAG 1.4.11** for the `.schematic-badge` chip, `.lore-badge` chip, and
   `.chapter-card.completed-chapter` border. New value: **3.69:1** ✓.
3. `.completed` green `#2f9e8c` → **`--teal-bright` `#4dbaa5`** (8.20:1 on ground). The
   current value is **2.94:1 on bone** — fails. And it removes the third hue.
4. `--text-muted` becomes an **opaque** `oklch(0.820 0.014 85)` instead of
   `rgba(246,242,233,.72)`. Opaque is auditable; the alpha version is only correct over
   exactly one background.
5. `--btn-border` `rgba(246,242,233,.35)` (2.97:1 — a fail) → an **opaque** hairline at
   ≥ 3:1 for any control whose border is its only affordance.

### 4.8 Rules for our app (colour & contrast)

1. **Contrast against the camera, not against the design mock.** Every text element over
   live video needs a *guaranteed* local backdrop (scrim or opaque fill). Current
   failures: `.hint` (`:437`, bone @ .75 over bare video → invisible on white pavement);
   `--amber` chevron on mid-grey (1.88:1); `.cb-dist` at 10 px / .55 opacity.
2. **Adopt the verified OKLCH palette in §4.7** and drop `--deep-teal`'s 2.53:1.
3. **Merge the third hue.** Replace `.completed #2f9e8c` (`:288`) with the light teal.
   Two hues + bone + ground, maximum.
4. **One accent, one place.** Beige appears in at most one element per screen state.
   Enforce with a CSS comment convention (the current `DESIGN.md` "One Beige Rule" is
   right — make it enforceable, e.g. a single `.is-signal` class that owns the beige).
5. **Opaque, not alpha, for anything audited.** `--text-muted` and `--btn-border` become
   solid tokens. Alpha is fine for *scrims* (whose job is to darken an unknown background
   by a known amount) and wrong for *text*.
6. **Use tonal elevation, not shadow elevation,** for surfaces; keep the offset shadow for
   glyphs over footage (it is doing real perceptual work).
7. **No glassmorphism over the camera.** No `backdrop-filter` on anything above `#cam`.
   Replace `:751` and `:808` with an opaque surface + a `rgba(0,0,0,.72)` scrim.
8. **Respect the user's OS accessibility settings** — `prefers-reduced-transparency`,
   `prefers-contrast: more`, and `forced-colors`. At minimum, drop the scrims' alpha and
   go opaque when `prefers-contrast: more` is set.
9. **Keep the 60/30/10 heuristic as a sanity check only**, and use the *referential* colour
   argument (this beige = live direction, this teal = verified), never the universal-
   meaning argument.
10. **Focus ring:** 2 px, 3 px offset ✓ — but give it a **guaranteed contrast against the
    live feed** (e.g. a 1 px dark outer ring) so it survives on white pavement.
11. **Do not use OKLCH `L` as a contrast proxy.** Verify every pair with the WCAG ratio.

---

## 5. Motion & AR-specific

### 5.1 Motion as feedback, not decoration

Material 3's motion philosophy: motion should **explain a spatial or contextual change**,
and durations should scale with the size of the area traversed. The M3 spec's own
"Applying easing and duration" guidance (<https://m3.material.io/styles/motion/easing-and-duration/applying-easing-and-duration>)
says: *"Transitions that cover small areas of the screen have short durations. Those that
traverse large areas have long durations."* And: *"Exit transitions are faster because they
require less attention than the user's next task. Transitions that enter or remain
persistent on the screen use longer durations."*

**Test:** for every animation in the app, ask *"what does this motion tell the user that
the state change alone did not?"* If the answer is "nothing", delete it.

**The app's audit:**

| Animation | Duration | Verdict |
|---|---|---|
| `#steerArrow` rotation `.12s linear` (`:154`) | 120 ms, linear | **Good.** Continuous motion, so `linear` is correct (an eased curve on a continuously-updated value creates lag/jitter). But 120 ms on a value updated per frame is effectively "no transition" — see §5.4. |
| `#steerArrow` **jump** between chevron and `#steerEdge` (`:151`/`:157`) | 0 | **Bad** — a discontinuity in the user's foveal line. |
| ring press `scale(.92)` `.15s ease` (`:146`, `:178`) | 150 ms | **Good.** Small, fast, tactile. |
| `shutterPulse` 1.6 s **infinite** (`:193`) | ∞ | **Bad** — perpetual attractor + battery tax (§2.6). |
| band snap `.34s cubic-bezier(.22,.61,.36,1)` (`:218`) | 340 ms | **Good** — a decelerating curve (Material "standard decelerate" is `cubic-bezier(0,0,0,1)`; the app's is a smooth-out approximation). |
| `toastIn` `.25s ease-out` translateY(-10px) (`:568`) | 250 ms | **Good**, though it should also respect `prefers-reduced-motion` (it does, via the global override at `:1060`). |
| `#captureFlash` `.15s ease-out` to opacity .9 (`:742`) | 150 ms | **Good** — this is motion-as-feedback (the shutter). But 0.9 white flash is a **photosensitivity** concern; it should be ≤ 0.35 and never a full-screen strobe. |
| `popBounce` `.6s cubic-bezier(.34,1.56,.64,1)` (`:972`) | 600 ms, overshooting | **Bad register.** A springy overshoot on a *diploma* is a "delight" animation — the exact mismatch with a civic archive. A diploma should *stamp*: fast in, tiny overshoot, settle — 240 ms with a very small overshoot, or a 2-frame scale-down like a rubber stamp. |
| `#status` / theme transition `.3s ease` (`:84`) | 300 ms | Fine but should use `prefers-reduced-motion` (the global override handles it). |
| `.compass-stop` hover `brightness(1.18)` (`:1059`) | — | Fine. |

### 5.2 Durations and easing tokens (Material 3)

M3 tokens (<https://m3.material.io/styles/motion/easing-and-duration/tokens-specs>, and the
`material-web` token source
<https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-sys-motion.scss>):

**Durations**
| Token | ms | Use |
|---|---|---|
| short1 | 50 | micro feedback (checkbox tick) |
| short2 | 100 | small state change |
| short3 | 150 | button press, small fade |
| short4 | 200 | selection controls, small utility |
| medium1 | 250 | toast in, small sheet |
| medium2 | 300 | standard in/out, theme change |
| medium3 | 350 | — |
| medium4 | 400 | FAB → sheet, medium travel |
| long1 | 450 | — |
| long2 | 500 | card → full screen |
| long3 | 550 | — |
| long4 | 600 | — |
| extra-long1–4 | 700–1000 | ambient, auto-advance carousel |

**Easing**
| Token | cubic-bezier |
|---|---|
| standard | `cubic-bezier(0.2, 0, 0, 1.0)` |
| standard decelerate (enter) | `cubic-bezier(0, 0, 0, 1.0)` |
| standard accelerate (exit) | `cubic-bezier(0.3, 0, 1, 1)` |
| **emphasized** | `cubic-bezier(0.05, 0.7, 0.1, 1.0)` |
| emphasized decelerate | `cubic-bezier(0.05, 0.7, 0.1, 1.0)` |
| emphasized accelerate | `cubic-bezier(0.3, 0, 0.8, 0.15)` |
| linear | `cubic-bezier(0, 0, 1, 1)` |

M3's suggested pairs: *begin and end on screen* → emphasized @ 500 ms; *enter the screen* →
emphasized decelerate @ 400 ms; *exit permanently* → emphasized accelerate @ 200 ms;
standard @ 300 ms for utility transitions.

**Note the "emphasized" curve is `cubic-bezier(0.05, 0.7, 0.1, 1.0)`** — a strong
decelerate. The app's band snap uses `cubic-bezier(.22,.61,.36,1)` — similar spirit,
slightly softer. **Both are fine.** What matters is that the app stops using
`ease` (the CSS keyword, ≈ `cubic-bezier(.25,.1,.25,1)`) for anything larger than a
button press, and stops using a *bouncy* curve (`.34,1.56,.64,1`) for anything civic.

**Recommended AradLens motion tokens** (a deliberately small set):

```css
--dur-press: 120ms;   --dur-state: 200ms;   --dur-enter: 250ms;
--dur-sheet: 320ms;   --dur-scene: 450ms;   --dur-ambient: 1200ms;
--ease-standard: cubic-bezier(0.2, 0, 0, 1);
--ease-out:      cubic-bezier(0.05, 0.7, 0.1, 1);
--ease-in:       cubic-bezier(0.3, 0, 0.8, 0.15);
--ease-linear:   cubic-bezier(0, 0, 1, 1);   /* for continuously-updated values */
```

And a **registry of which property animates what** — the app currently mixes
`transform`, `opacity`, `box-shadow`, `background` and `filter` freely. Animate
`transform` and `opacity` only (compositor-friendly, no layout, no repaint); the current
`shutterPulse` animates `box-shadow` (`:509–512`) which **repaints** — replace it with a
`transform: scale()` or `opacity` change on a pseudo-element.

### 5.3 Vestibular risk, and the "magic window" problem

**The core AR comfort fact.** In a handheld AR/VR context, sickness arises from a
**mismatch between vestibular and visual signals** (sensory conflict). The dominant
contributors:

- **Motion-to-photon latency.** Google VR's guidance: *"the motion-to-photon latency needs
  to be under 300ms"* for comfort and immersion, and *"If the latency is too high, users
  will perceive lag, or in the worst case get motion sickness"*
  (<https://developers.google.com/vr/discover/fundamentals>). The systematic review
  (Caserman et al. 2024, *ACM Computing Surveys*, "Are you feeling sick?" —
  <https://dl.acm.org/doi/full/10.1145/3670008>) confirms latency as an identified cause
  of cybersickness, and notes that a 2020 study found CS **increased with angular
  velocity**, more so around the X and Y axes than Z.
- **Discrepancy between virtual and physical head pose.** Kim et al. (2019/2020) showed
  cybersickness severity scales with the **amplitude and variability** of the difference
  between the virtual and physical head pose (DVP) —
  <https://pmc.ncbi.nlm.nih.gov/articles/PMC9761034/>.
- **Head-locked content** is the classic offender. The AHFE *Human Interface Guidelines for
  Interaction Zones in AR* (2022) is explicit:
  *"Do not rigidly head-lock content — translations and rotations should not be 1:1 with
  the user's head movements as this may cause discomfort. We recommend the content to
  translate with (i.e. follow) the user as they move, and only loosely rotate with the
  user's head movements"* —
  <https://openaccess-api.cms-conferences.org/articles/download/978-1-958651-44-5_36>.
  It also says: *"If content is large, do not head-lock, as this will obstruct the user's
  view of the environment."*
- **Rotation causes more sickness than translation**, and a restricted field of view with a
  **stable, high-contrast background** is the standard mitigation (Google's *Tunneling*
  technique: *"Motion should occur in a restricted field of vision… There should be a fixed
  background to anchor the player's motion… Motion should avoid acceleration and
  deceleration… Rotation causes more motion sickness than translation"* —
  <https://developers.google.com/vr/elements/tunneling>).
- **Meta's comfort guidance** for immersive: *"Avoid anchoring content statically in front
  of the user's camera, especially if it obscures a large part of passthrough, as it
  decreases the user's awareness of their surroundings… Avoid displaying too many objects
  at once… try to keep the main controls in a single UI panel, as opposed to having
  multiple windows floating around"* —
  <https://developers.meta.com/horizon/design/comfort>.

**The "magic window" and re-anchoring.** The "magic window" is Google's term for the
video-see-through *handheld* form factor: instead of moving a heavy camera with your head
(which produces huge DVP and therefore sickness), you move a *light phone* and rely on
**the scene itself as the stable world anchor**, with the phone acting as a window into it.
For AradLens this is the good news: **the app's camera is already a magic window.** The
camera feed is world-locked by physics — it moves exactly with the world. **The danger is
anything the app draws that does *not* move exactly with the world.**

**Where AradLens breaks the magic window today:**

1. **The compass band's 3D rotation.** `#snapRail` has
   `transform: perspective(760px) rotateX(13deg)` (`:215`) and each stop is individually
   rotated by `bandArcDeg(dx)` (`:2118`) — up to ±(atan(180/320)) ≈ ±29° at the edges.
   Because the band is a *screen-space* transform, it is **head-locked** (it moves with the
   phone, which moves with the head). **But it does not rotate with the head** — it only
   rotates with the *scroll offset*. So as the user turns their head, the band slides
   across the world while the world slides behind it. The mismatch is subtle but real,
   and it's *exactly* the "tag-along" problem Microsoft describes:
   *"Just like truly head-locked content, tag-along objects can prove overwhelming or
   nauseating if they move wildly or spring too much in the user's view… if tag-along
   keeps on moving when the user has stopped, it may confuse their senses"* —
   <https://learn.microsoft.com/en-us/windows/mixed-reality/design/billboarding-and-tag-along>.
   → **Fix: keep the band's rotation *static* (a fixed arc shape) and animate only the
   *translation* of the tape within it.** A static arc = a stable visual reference; a
   sliding tape = the only motion, and it's user-initiated.
2. **The chevron's `rotate()` transition** (`:154`, `.12s linear`). This is small, but a
   rotating element in the user's foveal centre while their head is turning is the
   highest-risk motion in the app. → **Make the chevron translate and scale rather than
   rotate**, or reduce rotation to a 3-state snap (ahead / ahead-left / ahead-right) instead
   of continuous rotation.
3. **The 3D `perspective` on the band** is a *depth* cue that does not correspond to any
   real depth in the world. → **Consider removing the `perspective(760px)` entirely** and
   using a 2D arc drawn with a clip-path or an SVG path. The arc shape can be preserved
   without the perspective illusion.

**Re-anchoring.** Re-anchoring is the technique of re-establishing the mapping between the
virtual overlay and the physical world when the user loses track of it (typically after
looking away or after a tracking jump). In a **2D handheld camera app** the mapping is
trivial (the overlay is a flat layer over a flat video), so AradLens's re-anchoring problem
is not spatial — it is **semantic**: *"which stop am I heading to?"* The app's answer is the
amber reticle on the band + the amber chevron + the caption name + the distance. **These
four signals are the re-anchoring mechanism.** They must always agree, and there must
always be *one* unambiguous "you are here / go here" pair. Today there are **four
competing "current stop" indicators**: the band's amber reticle (`:211–215`), the amber
`aria-current` ring (`:262`), the `#routeStep` counter (`:134`) and the caption name
(`:301`). → Consolidate to **one** primary indicator + one counter.

### 5.4 Parallax, depth cues, and the "G2/G3" z-stack in a 2D HUD

- **Parallax** is a depth cue: objects at different apparent depths move at different
  rates relative to the head. In a camera HUD, the camera feed *is* the parallax. Any UI
  layer that is drawn at a "different depth" from the video must therefore move at a
  different rate as the head moves — which in a flat 2D web app it **cannot**, because the
  browser composites the DOM over a `<video>` element with no head-tracking transform.
  → **Therefore: do not fake parallax in this app.** Any parallax-ish effect (the band's
  `rotateX(13deg)` + per-stop rotation) creates a depth *expectation* with no depth
  *reality*, which is the recipe for the mismatch described above.
- **Depth cues that DO work in 2D:** blur (expensive, and glassmorphism's problem),
  **opacity/contrast attenuation** (cheap, and what the band already does at `:2148`),
  **scale** (the band already scales stops by up to 1.08 at `:2144`), and **shadow**.
- **The correct z-depth model for this app** is therefore: *the camera feed is the world
  (G1); the HUD is a single, flat, world-locked sheet floating a few centimetres in front
  of the phone screen; within that sheet, depth is communicated only by tonal
  contrast and scale.* — which is exactly what the "Offset-Blur Rule" (`DESIGN.md:379–381`)
  already implements, and why the current design is more correct than a glassmorphism
  redesign would be.

### 5.5 Billboarding, head-locked vs world-locked, and "keep the camera still"

- **Billboarding** = an object that always rotates to face the user. Microsoft's MR
  guidance: *"Objects with billboarding always orient themselves to face the user. Text
  and menu systems are common use cases, where static objects placed in the user's
  environment (world-locked) would be otherwise obscured or unreadable when users move
  around"* — <https://learn.microsoft.com/en-us/windows/mixed-reality/design/billboarding-and-tag-along>.
  In a handheld phone AR app, **billboarding is what the camera already does** — the phone
  screen always faces the user. So: **all AradLens HUD text is already billboarded by
  construction.** Good — and it means "billboarding" is not a design lever here, it is a
  given. (The AR-HUD literature's specific guidance — e.g. *ICDEL 2021*'s Guideline #8
  recommending a **sans-serif** with a height/outline-thickness ratio of ~0.08 for legibility
  on a projected AR HUD, <http://www.icicel.org/ell/contents/2021/12/el-15-12-09.pdf> —
  is directly relevant to the decision about the display face.)
- **Head-locked vs world-locked.** In this app:
  - The **camera feed** = world-locked (physically).
  - The **HUD chrome** = head-locked (it moves with the phone which moves with the head),
    but *not* fully — because the browser does not apply a head-transform to the DOM layer.
    → This is a **half-locked** state, and it is the uncomfortable one: the video slides
    behind a HUD that slides with it. In practice it works because the HUD is small and
    mostly at the edges.
  - The **recommended model** (AHFE HIG + Microsoft): keep the HUD *loosely* following the
    head, anchored to the **screen** (not the world), and keep the *world* (the video) as
    the stable reference. That is what the app does. **The band is the exception and
    should be brought back into line** (§5.3).
- **"Magic window" re-anchoring for a handheld camera.** The user never loses spatial
  anchoring (the phone is the window). What they lose is **semantic** anchoring. The
  app's `#compassWarning` (`:525`) already handles the sensor-failure case with a clear
  checklist — good UX. Extend the same treatment to a **"where am I?" re-anchor**: if the
  user has been walking for > 40 s with no distance change, or the bearing has been
  ambiguous, show a compact re-anchor strip: *"Următorul obiectiv: Primăria · 340 m ·
  la dreapta"* — the three facts, in the order that resolves ambiguity.

### 5.6 Rules for our app (motion & AR)

1. **Every animation must answer "what did the state change not tell me?"** Delete the
   rest. The `popBounce` diploma animation (`:972`) currently answers nothing and is in
   the wrong register — replace it with a 240 ms "stamp".
2. **Adopt 6 duration tokens and 4 easing tokens** (§5.2) and stop using the `ease`
   keyword and bouncy curves for anything civic.
3. **Animate only `transform` and `opacity`.** Replace the `box-shadow` pulse
   (`:509–512`) with a transform/opacity animation — the current one repaints every
   1.6 s for the whole tour.
4. **Make `shutterPulse` finite** (3 pulses, then a static state) — attention economy
   *and* battery.
5. **Remove the `perspective(760px) rotateX(13deg)`** from `#snapRail` (`:215`) or at
   minimum keep the arc's rotation **static** and animate only the tape's translation.
   A shape that pretends to be 3D but is screen-locked is a sensory-conflict generator.
6. **Never rotate the foveal-centre chevron continuously.** Replace continuous rotation
   with 3–5 discrete bearing states + translation. This is the single biggest comfort
   win available.
7. **Keep the HUD "loosely following", never rigidly 1:1 head-locked**, and keep the
   video as the only stable world anchor (AHFE HIG 2022; Microsoft MR guidance).
8. **Consolidate the four "current stop" indicators into one.** Reticle + ring + step
   counter + caption name → one reticle + one counter + one caption.
9. **Design the re-anchor explicitly.** A compact 3-fact strip (which stop / how far /
   which way) that can be summoned and that resolves ambiguity. This is the handheld
   equivalent of "re-anchoring".
10. **Cap the flash at ~0.35 opacity** and never strobe it — photosensitivity.
11. **Use `prefers-reduced-motion` as a first-class case**, not just a global override.
    The current override (`:1067–1076`) kills *all* motion including the state-change
    fades that carry meaning; a better implementation keeps the *functional* transitions
    (sheet in/out) at near-zero duration and removes only the decorative ones.
12. **No parallax in a 2D phone HUD.** It cannot be done correctly without head tracking.

---

## 6. Mobile HUD / glass UI craft

### 6.1 Safe areas

Apple: *"A safe area defines the area within a window that isn't covered on the edge by a
hardware feature or another view… Respecting the safe area is essential to make sure
system UI and hardware features like the Dynamic Island don't obstruct content and
controls"* — <https://developer.apple.com/design/human-interface-guidelines/layout>.
WebKit's guidance on the web (<https://webkit.org/blog/7929/designing-websites-for-iphone-x/>)
is the operative one for this app:

> *"Safe area insets are not a replacement for margins."*
> Use `max(12px, env(safe-area-inset-left))` etc.

Observed inset values: **44–48 px** top on notch devices, **59–62 px** on Dynamic Island,
**34 px** bottom home-indicator, and **non-zero left/right in landscape**
(<https://1440px.com/safe-area>).

**The app's audit:**

| Where | Line | Issue |
|---|---|---|
| `.top` | `:120` | `padding: calc(16px + env(safe-area-inset-top)) 20px 26px 20px` — **adds** to the inset, but does not use `max()`. If a browser reports 0 for the inset (older WebView / desktop), 16 px remains ✓. Acceptable, but `max(16px, env(...))` is the correct form per WebKit. **The 20 px horizontal padding ignores `env(safe-area-inset-left/right)`** → in landscape on a notch phone the brand and the step counter sit under the sensor housing. |
| `.bottom` | `:283` | `padding: 14px 16px calc(20px + env(safe-area-inset-bottom)) 16px` — same: **no left/right inset handling in landscape.** |
| `#card` (info sheet) | `:458` | same pattern, same landscape gap. |
| `#albumModal` | `:587` | same. |
| `#start` | `:350` | `padding: calc(16px + env(safe-area-inset-top)) 20px calc(16px + env(safe-area-inset-bottom))` — same. |
| `#photoCmp` | `:502`, `:506`, `:510` | `bottom: calc(64px + env(safe-area-inset-bottom))` ✓ — correct additive use. |
| `#status` | `:432` | `top: env(safe-area-inset-top)` ✓. |
| `#snapRail` | `:209`–`:217` | **No safe-area handling at all**, and it is `width: 100%; max-width: 560px` — in landscape it spans nearly the full width under the housing. |
| `#rail` | `:167` | `right: 14px` — **no landscape inset handling**; the 52 px action rings can sit under the housing in landscape. |

**This is a concrete, fixable, shippable defect class: six elements ignore
`env(safe-area-inset-left/right)`, and three ignore the bottom inset in landscape.**

### 6.2 Thumb zones and one-handed reach

- **Touch target sizes.** Apple HIG: **44 × 44 pt** minimum on iOS
  (<https://developer.apple.com/design/tips/>). Android/Material: **48 × 48 dp**, *"which
  results in a physical size of about 9 mm, regardless of screen size"*, with ≥ 8 dp
  separation between targets (<https://support.google.com/accessibility/android/answer/7101858>).
  Parhi, Karlson & Bederson (2006), *Target size study for one-handed thumb use on small
  touchscreen devices*, MobileHCI '06 — the landmark one-handed study — recommends
  **9.2 mm for discrete tasks and 9.6 mm for serial tasks**; thumb length varied
  **99–125 mm (μ 115 mm)** and hand width **75–97 mm** —
  <https://www.microsoft.com/en-us/research/wp-content/uploads/2006/01/parhi-mobileHCI06.pdf>.
- **Thumb reach.** Kim & Ji (2019), *Natural Thumb Zone on Smartphone with One-Handed
  Interaction*, IEA 2018: for **small- and medium-thumb users the natural thumb zone
  covers only ~30 % of the screen**, and *"the lowermost region and the upper-left region
  of the smartphone touchscreen are not commonly included in the natural thumb zone,
  regardless of the thumb-length groups"* —
  <https://link.springer.com/chapter/10.1007/978-3-319-96071-5_50>. Otten, Karn & Parsons
  (2013), *Defining thumb reach envelopes for handheld devices*, Human Factors —
  <https://pubmed.ncbi.nlm.nih.gov/23516793>.

**The app's audit:**
- `#rail .ring` = **52 px** ✓ (above both floors).
- `.btn` = `min-height: 44px` ✓ (Apple floor, 4 px under Android's 48 dp).
- `.card-x`, `.album-close-btn`, `.modal-close-btn` — `.modal-close-btn` (`:835–841`) is
  **36 × 36 px** ✗ — below the 44 px floor.
- `.cw-close` (`:539`) = `min-width: 44px; min-height: 44px` ✓ but the visible glyph is
  20 px — fine, the hit area is what matters.
- `.pt-close` (`:576`) = 44 × 44 ✓.
- `.compass-stop` = `width: 104px` but the **hit target is the SVG dial (40 × 40 px) plus
  text**; the button is `position: absolute; width: 104px` (`:231`) with the dial centred —
  so the *tappable* region is the whole 104 px box, but the *visible* affordance is 40 px.
  From a Fitts's-law standpoint the effective target width `W` is closer to 40 px than
  104 px, because users aim at the visible ring. **40 px < 44 px.** ⚠️
- `.theme-toggle-btn` = **34 × 34 px** ✗ (`:139`).
- `#compassWarningBadge` = **34 × 34 px** ✗ (`:539`).
- `.mode-badge` = `min-height: 34px` ✗ (`:845`).
- `.chapter-period-badge`, `.cl-item`, `.mode-badge-pill`, `.reward-ribbon` — all
  **non-interactive badges**, so no target requirement, but they are 11 px text.
- **The `#rail` is on the RIGHT edge at `top: 22%`** (`:167`). Per the thumb-zone
  literature, the **right edge is the hardest reach for a right-thumb user** and the
  **left edge is hardest for a left-thumb user**; the bottom is easiest. The app puts its
  four primary actions (details, capture, album, game mode, theme) in the **hardest-to-reach
  zone**, and puts the compass band (the *selector*) at the bottom. **This is inverted.**
- **The camera shutter is at the bottom-centre** (`:725`, `.cs-shutter` 72 px) ✓ —
  correct.

### 6.3 Sheet vs full-screen vs bottom-rail

Material 3's bottom-sheet anatomy: **container + optional drag handle + scrim (modal
only)**; **modal bottom sheets' initial vertical position is capped at 50 % of screen
height**; they can be pulled to full screen and scrolled internally; dismissal via *menu
item / action*, *tapping the scrim*, *swiping the sheet down*, or *a close affordance in
the app bar*; the drag handle can be dragged **or selected** to change height, and
*"Sheets should be able to cycle through preset heights and close completely without
dragging. Selecting the drag handle should toggle through preset heights or close the
sheet, while selecting the scrim should always close the bottom sheet."* Geometry: drag
handle **32 × 4 dp**, centred, **22 dp** padding top/bottom; sheet spans full width up to
**640 dp**, then 56 dp margins; 28 dp top corner radius; **48 dp accessible hit target**
for the handle; *"The top 48dp portion of the bottom sheet is interactive when
user-initiated resizing is available and the drag handle is present"* —
<https://m3.material.io/components/bottom-sheets/guidelines> and
<https://m3.material.io/components/bottom-sheets/specs>.

**The app's audit:**
- `#card` (`:445–452`) is a **modal bottom sheet** with `border-radius: 12px 12px 0 0`,
  `max-height: 72vh`, `overscroll-behavior: contain`, a close button, and no scrim and no
  drag handle. **72vh exceeds M3's 50 % initial cap.** And it has **no scrim** — so the
  live camera stays fully visible and interactive behind it, which under M3 is a
  **standard** sheet, not a modal one. But it *behaves* modally (it covers content). Pick
  one: either add a scrim and treat it as modal (and drop to ≤ 50 % initial height), or
  add a drag handle and treat it as a resizable standard sheet.
- `#card` has **no drag handle** and **no swipe-to-dismiss** — so on a phone, dismissing
  requires finding the "Închide" text button. That's a **Fitts's law and Jakob's law**
  failure: the expected gesture is swipe-down.
- `#captureModal` (`:749`) is a **centered modal card** with a scrim + `blur(4px)`. This
  is the right pattern for a *confirmation*, but it is used for a *success message*
  ("Fotografie realizată!"), which is a toast/inline moment, not a modal. **A modal that
  interrupts with good news is a peak-end violation** (§2.4) — the peak is being spent
  on a dialog instead of on the arrival.
- `#albumModal` (`:584`) is a **full-screen modal** ✓ correct for a map + album.
- `#gamemodeModal` / `#storyLoreModal` / `#rewardModal` — `.full-modal` (`:806`) is a
  centered card with `backdrop-filter: blur(5px)` over the live camera. Replace the blur
  with an opaque scrim (§4.5).

### 6.4 The compass band — a critique

**What it is.** A horizontally scrolling tape of 5 stops, rendered on a sagging arc
(`BAND_SAG` 26 px, `BAND_SLOT` 108 px, `perspective(760px) rotateX(13deg)`), with an amber
reticle at the centre marking the selected stop (`:211–215`), per-stop dials showing a
compass needle (`:2178–2203`), names, and distances. Interaction: pointer drag, mouse
wheel, arrow keys, rubber-band at the ends, snap on release (`:2133–2151`, `:2295–2303`).

**What is good.**
- It is a **direct-manipulation** selector, not a menu — good for Fitts.
- The reticle + tap = a well-understood "scrubber" metaphor.
- The `aria-current` pattern (`:2283`) is correct ARIA.
- The arc shape carries the **compass metaphor** semantically.
- Keyboard support (arrow keys) exists.

**What is wrong — five concrete problems:**

1. **The effective target width shrinks with distance.** Fitts's law: `MT = a + b·log₂(2D/W)`.
   Stops are 108 px apart and the dial is 40 px wide, but the scale falloff
   `Math.max(0.74, 1 - adx/1100)` (`:2144`) shrinks distant stops to 74 % of their size
   (≈ 30 px visual) *and* the opacity falloff
   `1 - (adx/fade)^1.6` (`:2148`) dims them further. **The stops at the edges of the arc
   are simultaneously smaller, dimmer and further away** — a triple penalty on exactly
   the stops the user is most likely to want to reach. → **Do not shrink with distance.
   Keep all stops at full size; use opacity alone (or nothing) for the off-axis cue.**
2. **The "locked" state is communicated by *dimming* (`:2149`, ×0.55) plus a padlock
   (`:252`).** Dimming a thing and a lock icon are two different signals, and the padlock
   is 1.1 px stroke at 62 % opacity on a 44 × 44 SVG — **invisible on a phone at arm's
   length over a moving video.** → **Make locked steps visually *flat* (fully opaque,
   outline-only, no needle) with a high-contrast lock glyph at ≥ 2 px stroke, and make
   them *non-interactive but reachable*, not faint.** Autonomy (§2.3) says "available but
   not yet", not "forbidden and invisible".
3. **The 50 m proximity auto-trigger fires too early and too often.** `checkLandmarkProximity`
   fires the toast at 50 m. In the historic centre of Arad, the landmarks are ~300–800 m
   apart (from `REPERE` lat/lon, the Primăria ↔ Palatul Cultural distance is ~85 m; the
   Cathedral ↔ Primăria ~570 m). At 50 m, the toast can fire while the user is still
   walking toward a *different* landmark and hasn't even identified the target visually.
   → **Reduce to 25–30 m, and gate it on the bearing being within ±20°** so the toast
   means "the building you are looking at".
4. **The band shows 5 live dials at once.** Five needles each rotating, plus five
   distances, plus five names — ~25 continuously-updating items in a 108 px-tall strip at
   the bottom of the screen. This is the extraneous load of §2.2. → **One live dial
   (the next stop), four inert dots.** The distance of stop #4 is not information the user
   can act on.
5. **The `wheel` handler on a phone.** `:2473` and around handle mouse wheel; on a phone
   this is a two-finger scroll on a `touch-action: none` element, which will *fight* the
   page scroll. `#snapRail` has `touch-action: none` (`:213`) — correct for the drag, but it
   means any attempt to scroll the page over the band is dead. Since the app has no page
   scroll in the HUD state, this is fine. ✓

**Precedents.** The nearest relatives are **radial / pie menus** (Callahan, Hopkins, Weiser
& Greenberg, CHI '86 "An Empirical Comparison of Radial and Linear Menus"; Kurtenbach,
2009 *The HCI Handbook*) — which are fast for ≤ 8 items once learned, and
**carousels** (NN/g, *Carousel Usability*, <https://www.nngroup.com/articles/designing-effective-carousels>)
— which NN/g warn *"people frequently overlook them, together with all or some of the
content within them."* The band is essentially a **horizontally-scrolling carousel with a
compass metaphor**, and it inherits the carousel's discoverability problem: a user who
does not read the `.hint` line at `:1487` ("Glisează busola pentru a alege oprirea") will
not know the band is interactive.

**The hint is a **band-aid**: it is a permanent line of text explaining a gesture, which
is a direct admission that the affordance is weak. → **Design the affordance into the
control** (a visible, obvious "current stop" card with ‹ › affordances next to it, plus
the drag), and keep the hint as a **first-run coach mark only**.

### 6.5 Sheet drag physics

M3's bottom-sheet behaviour states: `STATE_EXPANDED`, `STATE_HALF_EXPANDED`,
`STATE_HIDDEN`, `STATE_DRAGGING`, `STATE_SETTLING`; the sheet is dragged vertically and
dismissed by completely sliding down; **tapping the scrim dismisses**; and **a visible
scrim is required** so users know the rest of the screen is inert
(<https://material.io/components/sheets-bottom>). The 2025 AHFE *HIG for Interaction Zones
in AR* also requires a **single-pointer alternative** for any drag-only action.

**The app's `#card` has no drag physics at all.** A redesign should add:
- a **32 × 4 dp drag handle** at the top of the sheet, with a 48 dp hit area;
- **preset heights** (peek 25 %, half 50 %, full 92 %) cycled by *tapping* the handle;
- **swipe-down to dismiss** with a velocity threshold;
- a **visible scrim** at `rgba(0,0,0,.55)` that dismisses on tap;
- a **single-pointer alternative** (the existing "Închide" button stays).

### 6.6 Rules for our app (mobile HUD craft)

1. **Handle all four safe-area insets everywhere.** Replace the six `calc(Npx +
   env(safe-area-inset-top))` patterns with `max(Npx, env(safe-area-inset-*) + Mpx)` and
   add `env(safe-area-inset-left/right)` to `.top`, `.bottom`, `#rail`, `#card`,
   `#albumModal`, `#start`, `#snapRail`. **This is the single highest-value, lowest-risk
   fix in the whole redesign.**
2. **Move the primary actions into the thumb zone.** The four 52 px rings on the right edge
   at 22 % height are in the hardest-reach zone for both hands (right edge for a right
   thumb, and 22 % height is near the top). → Either move the rail to the **right edge but
   low** (below 60 % height) or convert it to a **bottom bar** within reach.
3. **Raise every interactive target to ≥ 48 × 48 px.** Fix `.theme-toggle-btn` (34),
   `#compassWarningBadge` (34), `.modal-close-btn` (36), `.mode-badge` (34).
4. **Keep the visible affordance ≥ 44 px, not just the hit box.** The compass dial is
   40 px; make it 44–48 px.
5. **Do not shrink stops by distance.** Remove the `1 - adx/1100` scale falloff (`:2144`).
6. **Make the band a scrubber with an obvious current-stop card.** One live dial +
   inert dots + a ‹ › pair + drag. Remove the permanent hint line (`:1487`) in favour of
   a first-run coach mark.
7. **Give `#card` a proper bottom-sheet treatment:** drag handle, 3 preset heights,
   swipe-to-dismiss, visible scrim, ≤ 50 % initial height, and keep the close button as
   the single-pointer alternative.
8. **Turn the capture-success dialog into an inline/toast moment** — do not spend a
   modal peak on good news. Put the peak on the *arrival*.
9. **Remove `backdrop-filter` from `#captureModal` and `.full-modal`**; use opaque
   surfaces over the camera.
10. **Reduce the proximity trigger to 25–30 m AND gate on bearing ±20°.**
11. **Provide a "reduced transparency" and "increased contrast" path** (respect
    `prefers-contrast: more`, `prefers-reduced-transparency`).

---

## 7. Humour, copy & voice

### 7.1 Plain language

**Definition (NZ Digital Government, mandatory for NZ public services, and the best
plain-language statement available):** plain language is *"clear — the meaning is easy to
understand and is without jargon or long sentences; concise — it only includes the words
and information people need; well organised — ideas are presented in a logical order;
audience-focused — it's written for real people, not institutions."* It notes **26 % of New
Zealand adults have low literacy skills** and only 13 % high, and that plain language
*"builds confidence in public institutions because it does not hide information behind
jargon"* — <https://www.digital.govt.nz/standards-and-guidance/design-and-ux/content-design-guidance/writing-style/plain-language>.

NN/g's UX-writing guidance: *"Plain language can be understood the first time your audience
reads or hears it… Just because you and your internal team understand something, doesn't
mean your users do!"* — <https://www.nngroup.com/articles/ux-writing-study-guide>.
Stanford's UX-writing lecture (CS 194H) gives the four building blocks: **concise, clear,
useful, consistent** — <https://hci.stanford.edu/courses/cs194h/2023/wi/lectures/UX_Writing.pdf>.

**Apply to the app's existing copy.** The current UI copy is *already unusually good* —
"Pornește traseul", "Fără cont, fără server: fotografiile rămân pe telefonul tău",
"Fiecare obiectiv are fișă și poveste". That last one is exactly plain-language: it names
the thing, it doesn't say "features". **The redesign's copy risk is therefore regression,
not improvement.** Preserve the register.

**Where the copy fails:**
- `"Obiectiv în apropiere!"` (`:1099`) — "Obiectiv" is a *military/optics* term
  ("objective/target"), and the app calls landmarks "reper" (French for landmark) in the
  UI but "obiectiv" in the data (`:1569` "reper" vs. the toast text). **Inconsistent
  terminology is the #1 content-heuristic failure.** Pick one word and use it everywhere:
  **"reper"** (already used in the button "Vezi fișa", the capture screen title "Reper
  Arad", and the album tab "Repere & Hartă").
- `"Te invităm să fotografiezi obiectivul."` (`:1100`) — passive + formal + "vă" form.
  The rest of the app uses the informal singular ("telefonul tău", "apasă declanșatorul",
  "Poți doar previzualiza"). → **"Fotografiază reperul."**
- `"Fotografie realizată!"` (`:1135`) — exclamation marks are a tone choice, not a
  correctness one. It also **wastes the peak** (§2.4) on a modal.
- `"Continuă în mod previzualizare (Desktop)"` (`:1078`) — parenthetical device name in a
  button. → *"Continuă în previzualizare"*, with the device note below in 12 px.
- `"Verifică: pagina se deschide pe HTTPS, ai acordat permisiunea de mișcare/orientare și
  cea de locație, apoi reîncarcă."` (`:1091`) — this is **good** (actionable, specific,
  ordered), but it's a *wall*. Make it a 3-item checklist.

### 7.2 Voice & tone

NN/g's definitions are the working standard:
> *"**Voice** is your organization's personality; it should stay consistent. **Tone** is how
> that voice adapts to a specific situation and the emotion it evokes in the reader."*
> And tone is analysed on **four dimensions: humour, formality, respectfulness, and
> enthusiasm** — <https://www.nngroup.com/articles/ux-writing-faqs/> and
> <https://www.nngroup.com/articles/tone-voice>.

The app's current voice, read from the copy: **calm, specific, second-person, Romanian
informal singular, occasionally archival in register** ("Cronicar", "Diplomă", "capitol",
"Zorii Renașterii Civice", "Epoca Inovației și Artelor"). That is a *distinctive* voice and
it should be protected.

**The one register violation:** the emoji and the `popBounce` spring animation (`:972`)
belong to a *different* voice (consumer gamification) from the copy. **Fix the visuals and
the voice will cohere.**

### 7.3 The "AI-ish delightful" problem — and how to avoid it

The failure mode: adding exclamation marks, emoji, "Yay!", "Awesome!", "🎉 Let's go!",
and a springy pop to a product that is otherwise calm and serious. It reads as a *demo*,
it is culturally narrow, and it directly violates the plain-language and tone guidance
above (the NN/g tone dimensions: **humour** and **enthusiasm** are two of the four — they
are *dimensions to set deliberately*, not defaults to max).

**Specific anti-patterns to avoid in this app:**
1. ❌ "Obiectiv în apropiere!" → ✅ "Reperul e la 28 m."
2. ❌ "Fotografie realizată!" → ✅ (no dialog — inline) "Salvată în album."
3. ❌ "🎉 Ai ajuns la destinație!" → ✅ (the beige flood already says it) — keep the
   *existing* "Ai ajuns la destinație!" (`:1480`), which is correct and unfussy.
4. ❌ Emoji as icons → ✅ drawn line icons.
5. ❌ "Pionier al Aradului Modern" as a badge title (`:1658`) — this is a bit *infomercial*.
   A civic register would say **"Constructor al Aradului Modern"** (a role, not a
   self-congratulation) or, better, a **chapter title** rather than a badge title.
6. ❌ `"OMOLOGAT 1876 · ARADLENS ARCHIVE"` (`:1652`) — "OMOLOGAT" (certified/approved) is
   the right bureaucratic word; "ARADLENS ARCHIVE" is the wrong one (English, and
   "archive" as a product name is a startup tell). → **"OMOLOGAT · PRIMĂRIA ARAD · 1876"** or
   **"CERTIFICAT DE CRONICAR · ARAD"**.

**Humor.** The tone dimensions include humour, and humour is *not* forbidden. But for a
heritage-civic product aimed at tourists and families in a Romanian city with a
Romanian/Hungarian/German heritage, **humour must be dry, local and sparing** — a
half-joke in the chapter *sinopsis*, never in a system message, never in a button. The
current chapter synopses (`:1645`) are already good at this: *"trecând prin sanctuarul
dramaturgiei"* is a lovely, dry phrase. **That is the register to scale.** And the
content-heuristics checklist's "Global-friendly" row explicitly asks whether *"humor or
whimsy [is] culturally appropriate"* — with Arad's Hungarian and German heritage, a
Romanian-language pun can land badly on a Hungarian-speaking visitor. **Keep the humour in
the historical narrative, not in the interface chrome.**

### 7.4 Rules for our app (copy & voice)

1. **Write in Romanian informal singular ("tu") everywhere.** The app already does this;
   the toast at `:1100` is the one violation. Fix it.
2. **Use ONE word for a landmark: "reper".** Not "obiectiv", not "punct", not "țintă".
3. **Lead with the fact, not the announcement.** "Reperul e la 28 m." not "Obiectiv în
   apropiere!".
4. **No exclamation marks in system messages.** Reserve them for the arrival moment.
5. **No emoji anywhere in the product chrome.** Drawn line icons, 1.5–2 px stroke, 24 px,
   one consistent grid.
6. **Keep the dry archival humour in the narrative layer** (chapter synopses, lore text)
   and keep the *interface layer* completely straight.
7. **Make the button labels verbs that predict the outcome**: "Pornește traseul" ✓,
   "Fotografiază" ✓, "Vezi fișa" → **"Deschide fișa"**, "Mai târziu" ✓, "Închide" ✓.
8. **Rewrite the compass warning as a 3-item checklist** (HTTPS / motion permission /
   location permission) with the fix order.
9. **Romanise the badge and seal language** — no "ARCHIVE", no "Cronicar" as a product
   name.
10. **Use the Romanian Academy's comma-below characters** (`ș` U+0219, `ț` U+021B) — the
    app already does (`:1099` "apropiere" etc.), and the fonts' Latin-Ext subsets cover
    them. **Never let a tool rewrite them to cedilla forms** (see `AGENTS.md` and
    `docs/codebase.md` §5).

---

## 8. Where the current app violates the principles above (audit)

**[OUR OWN MEASUREMENT + DESIGN JUDGEMENT]** — every row cites a line in `index.html`.
Line numbers were re-verified against the **3 722-line working tree** on 2026-10-22 (see the
drift note in §0.4). Where the file changed during this research, the row names the CSS
selector or element id as well — **the selector is the durable anchor.**

| # | Violation | Lines (current tree) | Principle | Severity |
|---|---|---|---|---|
| 1 | `backdrop-filter: blur()` over the **live camera** in two modals | 751, 808 | §4.5 glassmorphism + battery | High |
| 2 | `--deep-teal #14655a` = **2.53:1** on `--bg-surface` — fails WCAG 1.4.11 | 39 (token), 617 (`.schematic-badge`), 876 (`.chapter-card.completed-chapter`), 903 (`.cl-item.done`), 921 (`.lore-badge`) | §4.3, §4.7 | High |
| 3 | `.completed` green `#2f9e8c` = **2.94:1** on bone — fails 3:1; also a **third hue** | 278–279 (`.compass-stop.completed .cb-ring` / `.cb-hub`) | §4.4, §4.7 | High |
| 4 | `.hint` at bone/.75 over bare video → **~1.06:1 on white pavement** | 437 (`.hint`) | §4.8 rule 1 | High |
| 5 | `--amber` chevron = **1.88:1** on mid-grey pavement | 151 (`#steerArrow`), 156 (`.chev-mark`) | §4.8 rule 1 | High |
| 6 | Compass band labels at **10 px**, distance at **opacity .55** | 255 (`.cb-name`), 260 (`.cb-dist`) | §3.6 | High |
| 7 | 8 uppercase micro-labels at **11 px** (and one 6-word one at 12 px) | 615 (`.schematic-badge`), 845 (`.mode-badge-pill`), 885 (`.chapter-period-badge`), 897 (`.cl-item`), 919 (`.lore-badge`), 936 (`.lore-ribbon`), 958 (`.reward-ribbon`), 983 (`.diploma-seal`) | §3.8 | High |
| 8 | Emoji as product iconography | 963 (`.reward-icon-huge`), 1163–1164 (album tabs), 1281 & 1298 (`.mode-icon`), 1644 / 1650 / 1668 / 1680 / 1686 (chapter + reward `icon:`), 3251, 3356, 3369 | §3.9 | High |
| 9 | **Seven elements ignore `env(safe-area-inset-left/right)`**; `#rail` and `#snapRail` ignore the bottom inset in landscape | 120 (`.top`), 167 (`#rail`), 209 (`#snapRail`), 284 (`.bottom`), 350 (`.start-inner`), 458 (`#card`), 587 (`#albumModal`) | §6.1 | High |
| 10 | Interactive targets at **34–36 px** | 139 (`.theme-toggle-btn`), 547 (`#compassWarningBadge`), 828 (`.modal-close-btn`) | §6.2 | High |
| 11 | Primary actions on the **right edge at 22 % height** — hardest reach | 167 (`#rail`) | §6.2 | High |
| 12 | `shutterPulse` — **1.6 s infinite** attractor + `box-shadow` repaint | 193 (`.ring.capture-ready`), 518–521 (`@keyframes shutterPulse`) | §2.6, §5.2 | Medium |
| 13 | `popBounce` springy overshoot on a **diploma** — wrong register | 963 (`.reward-icon-huge`), 965–970 (`@keyframes popBounce`) | §5.1 | Medium |
| 14 | `#steerArrow` ⇄ `#steerEdge` **hard swap** in the foveal centre | 151, 157 | §1.3, §5.3 | Medium |
| 15 | `perspective(760px) rotateX(13deg)` on a screen-locked band — fake depth | 215 (`#snapRail`) | §5.3, §5.4 | Medium |
| 16 | Four competing "current stop" indicators | 134 (`.route-step`), 220 (`.cb-reticle`), 262 (`[aria-current="true"] .cb-ring`), 301 (`.al-name`) | §5.3 rule 8 | Medium |
| 17 | `#card` = modal sheet at **72vh** with **no scrim**, **no drag handle**, **no swipe-dismiss** | 454–461 | §6.3 | Medium |
| 18 | 50 m proximity trigger with **no bearing gate** | JS 2762 (`checkLandmarkProximity`), 2985 | §6.4 | Medium |
| 19 | 5 live dials × (needle + name + distance) — ~25 updating items | JS 2135–2153 (`renderBand`), 2207–2260 (`renderCompassBand`) | §2.2 | Medium |
| 20 | `font-variant-numeric: tabular-nums` on Fraunces — **no-op** (no `tnum` feature) | 923 (`.lore-year-stamp`) + `DESIGN.md` typography block | §3.8 | Medium |
| 21 | 14-step type scale; 17 named type roles | `DESIGN.md` typography block | §3.3 | Medium |
| 22 | Negative tracking `-0.005em` on **14** display rules — invisible, but the wrong habit | 295, 303, 362, 465, 595, 644, 710, 778, 825, 853, 891, 929, 974, 1032 | §3.7 | Low |
| 23 | Body stack has `'Segoe UI'` before `system-ui` — inconsistent cross-platform identity | 84 | §3.5 | Low |
| 24 | `perspective` + per-stop rotation create head-locked motion | 215 (CSS), 2118 (JS `bandArcDeg`) | §5.3 | Medium |
| 25 | Terminology drift: "reper" vs "obiectiv" | 1099–1100 (toast) vs 1115 (`csTitle`), 1163 (album tab) | §7.1 | Low |
| 26 | `#status` bar at `env(safe-area-inset-top)` but the `.top` rail **also** pads by it → double top spacing | 432 vs 120 | §6.1 | Low |
| 27 | `captureFlash` at opacity **0.9** full-screen white | 746 (`.flash-active`) | §5.6 rule 10 | Medium |
| 28 | `--btn-border rgba(246,242,233,.35)` = **2.97:1** — fails 1.4.11 for bordered buttons | 56 (token), 78 (light theme), 441 (`.btn`), 473 (`.card-actions .btn`), 687 (`.album-action-btn.primary`), 828 (`.modal-close-btn`) | §4.7 | Medium |
| 29 | `white-space: nowrap` on `.cb-name` in a 104 px slot → **names truncate** ("Teatrul I. Slavici" → "Teatrul I. S…") | 258 (`.cb-name`), 231 (`width: 104px`), 2246 (JS `textContent`) | §1.7 | Medium |
| 30 | `text-wrap: balance` on HUD headings — expensive on a low-end device running a live camera + compass + GPS | 363, 595, 644, 710, 764, 778, 1038 | §5.2 (perf) | Low |
| 31 | **The story-mode badge and the "Pasul X / Y" counter have been removed** from the top rail during this session (`.mode-badge` and `#gameModeBadge` no longer exist). The route now has **no persistent progress readout** — the user cannot see "step 2 of 3" without opening a sheet. | removed (was `.mode-badge` ~789, `#gameModeBadge`) | §2.3 (competence), §2.7 | **High** |
| 32 | **The `.cs-frame` viewfinder is a 240 × 240 dashed square** in a portrait phone screen — a square viewfinder on a 9:19.5 display wastes the frame and contradicts "the phone is the window" | 717 (`.cs-frame`) | §5.5 (magic window), §1.4 | Medium |

**Note on rows 31–32:** `index.html` was edited by a concurrent session *during* this
research (3 634 → 3 722 lines). Rows 31–32 are the deltas that edit introduced; they are
flagged because they change what a redesign must preserve. **Re-verify the whole table
against the tree before implementing.**

---
## 9. Sources

Full bibliographic detail is in the inline citations above; this is the index. Every entry was
fetched and read.

**Gestalt & perception** — Wagemans et al. (2012) *Psychological Bulletin* 138(6),
<https://pmc.ncbi.nlm.nih.gov/articles/PMC3482144/> · Palmer (1992) *Psychological Science*
3(3), <https://e-edu.nbu.bg/pluginfile.php/951829/mod_resource/content/1/Stephen-Palmer%20-%20Common%20region%20-%20A%20new%20principle%20of%20perceptual%20grouping%201992.pdf> ·
Peterson & Kimchi (2013) *Oxford Handbook of Perception*,
<https://newiipdm.haifa.ac.il/wp-content/uploads/2015/05/Peterson-Kimchi-_2013_Perceptual-Organization-in-Vision_Oxford-Handbook.pdf> ·
Brooks & Palmer (2010) *Atten Percept Psychophys* 72(4),
<https://link.springer.com/content/pdf/10.3758/APP.72.4.1053.pdf> · Brooks & Palmer (n.d.)
<https://palmerlab.berkeley.edu/pdf/PalmerBrooks&Nelson.pdf> · Van Geert (2023/24)
*Psychon Bull Rev*, <https://pmc.ncbi.nlm.nih.gov/articles/PMC11061049>,
<https://link.springer.com/article/10.3758/s13423-023-02344-9> · SGI *Three-Stage Model*,
<https://www.opengl.org/archives/resources/code/samples/advanced/advanced98/notes/node257.html> ·
OpenGL 1.3 spec §2, <https://registry.khronos.org/OpenGL/specs/gl/glspec13.pdf> · Khronos
*Rendering Pipeline Overview*, <https://wikis.khronos.org/opengl/Rendering_Pipeline_Overview> ·
Ahmed et al. (2020) EGVE, <https://doi.org/10.2312/egve.20201256> · *Perceptual Science of
AR* (2023), <https://doi.org/10.1146/annurev-vision-111022-123758> · AR-HUD HMI guidelines
(2024), <https://doi.org/10.1016/j.trf.2024.06.001> · ICICEL (2021),
<http://www.icicel.org/ell/contents/2021/12/el-15-12-09.pdf>

**Cognitive & behavioural science** — Hick & Hyman (1952) <https://en.wikipedia.org/wiki/Hick's_law> ·
Fitts (1954) <https://en.wikipedia.org/wiki/Fitts%27s_law> · Jakob, *Jakob's Law*
<https://lawsofux.com/jakobs-law> · Kahneman et al. (1993) & Coldpress et al. (2008) on the
peak–end rule · Reber, Schwarz & Winkielman (2004) on processing fluency · Zajonc (1968)
*mere exposure* · Scheibehenne, Greifeneder & Todd (2010) *JCR* 37(3),
<https://scheibehenne.de/ScheibehenneGreifenederTodd2010.pdf> · Sweller et al. (1998) &
Sweller (2010) on CLT, <https://pmc.ncbi.nlm.nih.gov/articles/PMC6435105/> · Green & Swets
(1966) on signal detection · Itti & Koch (2001) on saliency · von Restorff (1933), Hunt (1995),
Kamp et al. (2026) *JEP:LMC* 52(6),
<https://psycnet.apa.org/doiLanding?doi=10.1037/xlm0001518> · Roediger & Karpicke (2006)
*Psych Sci* 17(3), <https://pubmed.ncbi.nlm.nih.gov/16507066/> · Deci & Ryan (2000)
*American Psychologist* 55(1), <https://psycnet.apa.org/doi/10.1037/0003-066X.55.1.68> ·
Neal, Wood & Quinn (2006) & Wood & Neal (2007) *Psych Review* 114(4),
<https://dornsife.usc.edu/wendy-wood/wp-content/uploads/sites/183/2023/10/wood.neal_.2007psychrev_a_new_look_at_habits_and_the_interface_between_habits_and_goals.pdf> ·
Yeh, Chang & Li (2025) *J Service Management*,
<https://www.sciencedirect.com/org/science/article/abs/pii/S0887604525000242> · Li, Hew & Du
(2024) *ETR&D* 72(2), <https://eric.ed.gov/?id=EJ1424760>

**Typography** — Google Fonts *Fraunces*, <https://fonts.google.com/specimen/Fraunces> ·
Undercase Type / Google Fonts *Fraunces Font Project* README (axes, opsz behaviour, WONK
auto-disable ≤18 px),
<https://android.googlesource.com/platform/external/google-fonts/fraunces/+/refs/heads/main/README.md> ·
W3C *CSS Fonts 4* §4.10 / §6.7 / §8.1 / §8.2, <https://www.w3.org/TR/css-fonts-4/> · Apple HIG
*Typography*, <https://developer.apple.com/design/human-interface-guidelines/foundations/typography> ·
Apple *UI Design Do's and Don'ts*, <https://developer.apple.com/design/tips/> · SIGACCESS (2025)
text-accessibility review, <https://dl.acm.org/doi/10.1145/3663547.3759692> · Microsoft
Inclusive Design, *Text size and impairment categories*, <https://www.cedc.tools/size.html> ·
W3C Mobile A11y TF minutes, <https://www.w3.org/2014/07/25-mobile-a11y-minutes.html> ·
European Commission Component Library v4 *Typography*,
<https://ec.europa.eu/component-library/v4.10.0/eu/guidelines/typography/> · *Vox-ATypI*,
<https://en.wikipedia.org/wiki/Vox-ATypI_classification> · *Sans-serif* sub-classes,
<https://en.wikipedia.org/wiki/Sans-serif> · Eliason (2013) *The history of 'humanist' type*,
<https://atypi.org/presentation/the-history-of-humanist-type> · Harvard Houghton Library
*Etruschi* (the "grotesque" etymology), <https://sites.harvard.edu/houghton-library/2010/05/22/etruschi> ·
type-scale tables, <https://github.com/display-dev/visualize/blob/main/visualize/reference/typography.md>,
<https://github.com/pbakaus/impeccable/blob/main/skill/reference/typography.md> · Romanian
orthography, <https://en.wikipedia.org/wiki/Romanian_alphabet>, Fedora *Ro fonts*
<https://fedoraproject.org/wiki/L10N/Tasks/Ro_fonts>

**Colour & contrast** — W3C *WCAG 2.2* (1.4.3, 1.4.6, 1.4.11, 1.4.12, 2.4.11–2.4.13),
<https://www.w3.org/TR/WCAG22/> · Understanding: non-text contrast
<https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast>, focus appearance
<https://www.w3.org/WAI/WCAG22/Understanding/focus-appearance.html> · W3C *WCAG 3.0* Working
Draft (10 Sept 2026; does not replace WCAG 2), <https://www.w3.org/TR/wcag-3.0> · Ottosson
(2020) Oklab/OKLCH, <https://bottosson.github.io/posts/oklab/> · W3C *CSS Color 4*,
<https://www.w3.org/TR/css-color-4/> · Elliot & Maier (2014) *Annual Review of Psychology* 65,
<https://www.annualreviews.org/content/journals/10.1146/annurev-psych-010213-115035> ·
Jonauskaite et al. (2025) *Psychon Bull Rev*,
<https://link.springer.com/article/10.3758/s13423-024-02615-z> · Jonauskaite & Mohr (2026),
<https://benjamins.com/catalog/z.244.03jon> · Jonauskaite et al. (2021) *PSPR*,
<https://journals.sagepub.com/doi/full/10.5964/ps.6297> · NN/g *Glassmorphism* (2024),
<https://www.nngroup.com/articles/glassmorphism/> · *Apple "liquid glass" is not just an
accessibility blunder* (2025),
<https://uxdesign.cc/apples-liquid-glass-isn-t-just-an-accessibility-blunder-it-s-an-environmental-one-too-08c593a87963> ·
Material color utilities (HCT), <https://github.com/material-foundation/material-color-utilities>

**Motion & AR** — Material 3 *Easing and duration*,
<https://m3.material.io/styles/motion/easing-and-duration/tokens-specs>,
<https://m3.material.io/styles/motion/easing-and-duration/applying-easing-and-duration>,
token source <https://raw.githubusercontent.com/material-components/material-web/main/tokens/versions/v0_192/_md-sys-motion.scss> ·
Caserman et al. (2024) *ACM Computing Surveys*, <https://dl.acm.org/doi/full/10.1145/3670008> ·
Kim et al. (2019/20) on virtual-vs-physical head pose,
<https://pmc.ncbi.nlm.nih.gov/articles/PMC9761034/> · Allsop et al. (2021) NATO STO
TR-HFM-MSG-323 · Google VR *Fundamental Concepts* (motion-to-photon < 300 ms),
<https://developers.google.com/vr/discover/fundamentals> · Google VR *Tunneling*,
<https://developers.google.com/vr/elements/tunneling> · Meta *Comfort*,
<https://developers.meta.com/horizon/design/comfort> · Microsoft MR *Billboarding and tag-along*,
<https://learn.microsoft.com/en-us/windows/mixed-reality/design/billboarding-and-tag-along> ·
AHFE (2022) *HIG for Interaction Zones in AR*,
<https://openaccess-api.cms-conferences.org/articles/download/978-1-958651-44-5_36> · Adobe XD
*UX Design Principles for AR*,
<https://xd.adobe.com/ideas/principles/emerging-technology/ux-design-principles-for-augmented-reality> ·
*UI Placement as a Critical Design Factor for AR During Locomotion* (2026),
<https://arxiv.org/pdf/2604.06102>

**Mobile HUD craft** — Apple HIG *Layout* (safe areas),
<https://developer.apple.com/design/human-interface-guidelines/layout> · WebKit (2017)
*Designing Websites for iPhone X*, <https://webkit.org/blog/7929/designing-websites-for-iphone-x/> ·
1440px *Safe Area Insets*, <https://1440px.com/safe-area> · Android A11y Help *Touch target size*
(48 dp, 8 dp separation), <https://support.google.com/accessibility/android/answer/7101858> ·
Parhi, Karlson & Bederson (2006) *MobileHCI '06*,
<https://www.microsoft.com/en-us/research/wp-content/uploads/2006/01/parhi-mobileHCI06.pdf> ·
Kim & Ji (2019) *IEA 2018*, <https://link.springer.com/chapter/10.1007/978-3-319-96071-5_50> ·
Otten, Karn & Parsons (2013) *Human Factors*, <https://pubmed.ncbi.nlm.nih.gov/23516793> ·
Material 3 *Bottom sheets*, <https://m3.material.io/components/bottom-sheets/guidelines>,
<https://m3.material.io/components/bottom-sheets/specs>, M2 *Sheets: bottom*,
<https://material.io/components/sheets-bottom> · NN/g *Carousel Usability*,
<https://www.nngroup.com/articles/designing-effective-carousels> · Callahan, Hopkins, Weiser &
Greenberg (1986) *CHI '86* radial vs linear menus.

**Copy & voice** — NN/g *UX Writing: FAQs*, <https://www.nngroup.com/articles/ux-writing-faqs/> ·
NN/g *UX Writing: Study Guide*, <https://www.nngroup.com/articles/ux-writing-study-guide> ·
NN/g *tone of voice*, <https://www.nngroup.com/articles/tone-voice> · NZ Digital Government
*Plain language* (mandatory for NZ public services; literacy statistics),
<https://www.digital.govt.nz/standards-and-guidance/design-and-ux/content-design-guidance/writing-style/plain-language> ·
Stanford HCI *UX Writing* (CS 194H),
<https://hci.stanford.edu/courses/cs194h/2023/wi/lectures/UX_Writing.pdf> · Bobbie Wood
*UX Writing Best Practices Checklist*,
<https://uxcontent.com/wp-content/uploads/2022/01/UX-Writing-Best-Practices-Checklist-Content-Heuristics-for-Designers.pdf> ·
NN/g *Text Scanning Patterns*, <https://www.nngroup.com/articles/text-scanning-patterns-eyetracking/>,
*Layer-Cake Pattern*, <https://www.nngroup.com/articles/layer-cake-pattern-scanning/>,
*F-Shaped Pattern (Misunderstood, But Still Relevant — Even on Mobile)*,
<https://www.nngroup.com/articles/f-shaped-pattern-reading-web-content>

**Local (repo)** — `index.html` (CSS 9–1077, body 1079–1557, script 1559+) · `docs/codebase.md` ·
`DESIGN.md` · `fonts/` + `fonts/OFL.txt` (Fraunces, SIL OFL 1.1) · `AGENTS.md`.