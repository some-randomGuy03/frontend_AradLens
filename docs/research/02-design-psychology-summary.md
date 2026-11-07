# 02 — Design psychology & craft: compact digest for the designer agent

Full report with citations: `docs/research/02-design-psychology.md` (read it for sources).
Operational sheet only. **Do not modify `index.html` from this sheet.** Line numbers are a
snapshot of the 3 722-line working tree (2026-10-22); **selectors are the durable anchor.**

## Ground truth

- Display font = **`Fraunces`** (Undercase Type), CSS-aliased `"AradLens Display"`, self-hosted
  `fonts/fraunces-latin{,-ext}.woff2` (SIL OFL 1.1). An **Old Style soft-serif** modelled on
  early-20th-c. Windsor/Souvenir/Cooper — the "1901 city plate" register.
- **Only 2 of Fraunces' 4 axes ship: `opsz` (9–144) and `wght` (100–900).** `SOFT` and `WONK` are
  **absent** → re-downloading the 4-axis variable font is the cheapest high-leverage upgrade.
- **Fraunces has NO `tnum` and proportional digits** → `tabular-nums` on it **does nothing**; never
  put a live number in Fraunces. `font-optical-sizing:auto` is the CSS default, so `opsz` tracks
  size (10 px and 26 px are two different drawings) — pin `opsz` where it matters.
- Palette now: ground `#0b0e12` = `oklch(.162 .010 255.7)`; bone `#f6f2e9` = `oklch(.962 .013 86.8)`;
  amber `#c8b088` = `oklch(.768 .061 80.3)`; teal `#14655a` = `oklch(.458 .076 181.4)`; surface
  `#141a21` = `oklch(.215 .017 252.5)`. Type scale = **14 steps / 17 roles** (10–26 px) — the
  biggest typographic defect. Body stack (`:84`) puts `'Segoe UI'` before `system-ui` (wrong).
  Emoji are used as product iconography (1163–1164, 1281/1298, 1644–1686).

## The 20 rules (highest value first)

1. **G1→G2→G3 triage.** G1 = data (bearing/distance); G2 = layout (position, z-order, clipping);
   G3 = surface (fill, scrim, contrast). Never fix a G3 problem with a G2 move.
2. **Handle all 4 safe-area insets.** Seven elements ignore `env(safe-area-inset-left/right)` (120,
   167, 209, 284, 350, 458, 587); `#rail`/`#snapRail` ignore bottom-inset in landscape. Use
   `max(Npx, env(safe-area-inset-*) + Mpx)`. Highest value / lowest risk fix.
3. **Every text surface over video needs a guaranteed local backdrop.** Failures now: `.hint`
   (437) ≈1.06:1 on white pavement; `--amber` chevron 1.88:1 on mid-grey; `--btn-border` 2.97:1;
   `--deep-teal` 2.53:1; `.completed` green 2.94:1. **Opaque > alpha for anything audited.**
4. **No glassmorphism over the camera.** Drop `backdrop-filter` at 751 and 808 → opaque `--surface`
   + `rgba(0,0,0,.72)` scrim. Glass = uncomputable contrast + per-frame GPU cost.
5. **One accent, one place.** Beige = live direction + arrival only. Merge the third hue:
   `.completed #2f9e8c` → the light teal. Two hues + bone + ground, max.
6. **Ship a 5-step scale, ratio 1.25, base 16 px: 13 / 16 / 20 / 25 / 31 px**; line-heights
   1.4 / 1.5 / 1.35 / 1.2 / 1.1. Body ≥ 16 px; floor 11 px for tracked uppercase only; delete the
   10 px band labels (255, 260). **5–6 steps, not 14** — two sizes within 3 px = muddy hierarchy.
7. **Never a live number in Fraunces.** Body sans with `font-variant-numeric: tabular-nums
   slashed-zero;`, including unit and separator (323).
8. **Upgrade to 4-axis Fraunces.** `SOFT` 40–60, `WONK` 1 at ≥24 px (0 below). Pin
   `font-variation-settings:"opsz" 14;` on the 26 px distance numeral (sturdy text cut).
9. **Drop every emoji** → 1.5–2 px stroke line icons on one 24 px grid. Biggest "civic vs startup" lever.
10. **Never rotate the foveal-centre chevron continuously.** 3–5 discrete bearing states + translation.
    Biggest vestibular comfort win.
11. **Remove the fake depth on the band.** `perspective(760px) rotateX(13deg)` (215) + per-stop
    `rotate()` (2118) pretend to be 3D but are screen-locked → sensory conflict. Static arc; animate
    only the tape's translation.
12. **One live dial + four inert dots**, not five live dials (~25 updating items = extraneous load).
    Remove the `1 - adx/1100` scale falloff (2144).
13. **Make "locked" flat + a 2 px high-contrast padlock**, not dimmed (2149, 273). SDT: offer
    "available but not yet", never "forbidden and invisible".
14. **Proximity trigger → 25–30 m AND gate on bearing ±20°.** 50 m ungated fires while the user is
    still walking to a different landmark.
15. **Motion:** 120/200/250/320/450/1200 ms × `standard cubic-bezier(.2,0,0,1)` /
    `out cubic-bezier(.05,.7,.1,1)` / `in cubic-bezier(.3,0,.8,.15)` / linear. Animate only
    `transform` + `opacity`. Make `shutterPulse` finite (3 pulses → static): today it is a 1.6 s
    infinite attractor repainting `box-shadow` for the whole tour.
16. **The peak is the arrival, the end is the diploma.** Spend budget there; the between-stops state
    stays cheap. Move the capture-success *modal* to an inline moment.
17. **Bottom sheet done right:** drag handle (32×4 dp, 48 dp hit), 3 preset heights,
    swipe-down-dismiss, visible scrim, ≤50 % initial height (now: 72vh, no scrim, no handle, no
    swipe — line 454).
18. **Move primary actions out of the worst reach zone.** The 4× 52 px rings sit on the right edge
    at 22 % height (167). Also fix 34–36 px targets: 139, 547, 828.
19. **Copy:** Romanian informal singular ("tu"); one word for a landmark (**"reper"**, not
    "obiectiv"); no exclamation marks in system messages; dry humour only in the narrative layer;
    buttons = outcome verbs ("Pornește traseul" ✓, "Fotografiază" ✓).
20. **Restore a persistent progress readout.** The story badge and "Pasul X / Y" counter were removed
    from the top rail during this session; the route now shows no step progress at all.

## 10 font pairings (all OFL; **verify ș/ț/ă/â/î per family before shipping**)

| # | Display / Body | Why it fits | Fallback stack |
|---|---|---|---|
| 1 | **Fraunces** (4-axis) / system sans | incumbent; "1901 city plate" register | `ui-serif, Georgia, serif` / `-apple-system, "Segoe UI", Roboto, sans-serif` |
| 2 | Source Serif 4 / system sans | screen-first transitional; institutional | `ui-serif, Georgia, serif` |
| 3 | Zilla Slab / system sans | engineering + civic; "city as infrastructure" | `ui-serif, Georgia, serif` |
| 4 | Playfair Display / system sans | city-hall invitation; ≥30 px, one word | `ui-serif, Georgia, serif` |
| 5 | Bitter / system sans | warm editorial slab; long-form lore face | `ui-serif, Georgia, serif` |
| 6 | IBM Plex Sans / IBM Plex Sans | "municipal archive terminal"; humanist, real tabular figures | `ui-sans-serif, system-ui, sans-serif` |
| 7 | Libre Caslon Text / system sans | Old Style made for reading; the lore document | `ui-serif, Georgia, serif` |
| 8 | **Fraunces / Source Sans 3** | best crafted pair — ink & paper, both with opsz/wght | `ui-serif, Georgia, serif` / `system-ui, "Segoe UI", sans-serif` |
| 9 | Cormorant Garamond / system sans | brochure/opera-programme; ≥28 px | `ui-serif, Georgia, serif` |
| 10 | Newsreader / system sans | designed for news: heritage you can read fast | `ui-serif, Georgia, serif` |

**Best 3:** #1 (lowest risk, highest authenticity) · #8 (best crafted pair) · #6 (radical "no serif"
direction). **Never:** Space Grotesk / Poppins / DM Sans / Outfit / Sora (startup); Inter / Geist
(the default face of the 2015–25 startup world — makes Arad read as a pitch deck).
**Heritage levers:** old-style/slab serif · moderate contrast · old-style or cut numerals ·
letterspaced small caps over lines · hairlines + double rules · bone/paper/ink/oxidised metal ·
editorial asymmetry · seals & document edges · line icons · short mechanical motion.
**Startup levers (all present today):** geometric sans · negative tracking on display · rounded pills
+ soft shadows · gradient/neon · Inter/Geist · emoji icons.

## Recommended type scale (base 16 px, ratio 1.25)

| Role | Size | LH | Weight | Face |
|---|---|---|---|---|
| Display / landmark name | 31 px | 1.10 | 600 | Fraunces (WONK 1) |
| Title / chapter | 25 px | 1.20 | 600 | Fraunces |
| Subhead / landmark meta | 20 px | 1.35 | 600 | Fraunces or body 600 |
| Body | 16 px | 1.50 | 400–500 | body sans |
| Caption / label | 13 px | 1.40 | 600 | body sans, `tabular-nums` |
| Micro-label | 11 px | 1.30 | 700 | body sans, ALL-CAPS, `.12em` |

Never two sizes within 3 px. Line length 40–60 ch on mobile. WCAG 1.4.12 Text Spacing must survive
(`line-height:1.5`, `letter-spacing:.12em`, `word-spacing:.16em`, paragraph 2em).

## Recommended palette (OKLCH → verified hex; WCAG 2.2 AA)

| Token | OKLCH | Hex | Verified contrast |
|---|---|---|---|
| `--ground` / `--surface` / `--surface-hi` | `oklch(.160 .012 250)` / `oklch(.225 .014 250)` / `oklch(.275 .016 250)` | `#090e12` / `#171c22` / `#22282f` | — |
| `--bone` / `--bone-dim` | `oklch(.960 .012 85)` / `oklch(.820 .014 85)` | `#f5f1e9` / `#c8c4ba` | 17.21:1 / 11.13:1 on ground |
| `--beige` / `--beige-ink` | `oklch(.800 .085 78)` / `oklch(.190 .030 70)` | `#dcb77f` / `#1c1105` | 10.27:1 / on-beige 9.83:1 |
| `--teal` | `oklch(.520 .095 180)` | `#007a6b` | ground 3.69:1 ✓ (was 2.53:1 ✗) |
| `--teal-bright` | `oklch(.720 .105 178)` | `#4dbaa5` | ground 8.20:1 — the "completed" colour |
| `--hairline` | `oklch(.420 .018 250)` | `#464e57` | decorative only |
| light `--bg-main` / `--surface` | `oklch(.970 .010 85)` / `oklch(.995 .004 85)` | `#f8f5ee` / `#fffdfa` | — |
| light `--ink` / `--ink-dim` | `oklch(.180 .025 80)` / `oklch(.400 .025 80)` | `#171005` / `#4f4639` | 17.33:1 / 8.51:1 |
| light `--beige-deep` | `oklch(.520 .075 75)` | `#826235` | 5.15:1 |

Deltas: beige chroma .061→**.085** (keeps "archive paper", stops reading grey); teal L .458→**.520**
(fixes the 1.4.11 failure); `.completed` green → `--teal-bright` (fixes 2.94:1, kills the third hue);
`--text-muted` / `--btn-border` become **opaque**. Verify every pair with the WCAG ratio — OKLCH `L`
is **not** a contrast proxy.

## Motion tokens

`--dur-press:120ms · state:200ms · enter:250ms · sheet:320ms · scene:450ms · ambient:1200ms`
`--ease-standard:cubic-bezier(.2,0,0,1) · out:cubic-bezier(.05,.7,.1,1) · in:cubic-bezier(.3,0,.8,.15) · linear:cubic-bezier(0,0,1,1)`
Animate `transform`/`opacity` only; `linear` for continuously-updated values (chevron). No bouncy
curves on civic artefacts (replace `popBounce` 965 with a 240 ms "stamp"). Cap the shutter flash at
~0.35 opacity.

## AR / glass cautions

- The phone camera **is** the "magic window": the feed is world-locked by physics, so it must stay the
  *only* stable world anchor. Anything the HUD adds that doesn't move with the world = conflict.
- **No parallax** in a 2D phone HUD (no head tracking): a parallax *expectation* with no depth
  *reality* is the nausea recipe. Use tonal contrast + scale for depth.
- **Head-locked ≠ 1:1** (AHFE HIG 2022): content should *loosely* follow; large content must not be
  head-locked. Motion-to-photon < 300 ms; sickness scales with angular velocity.
- Re-anchoring here is **semantic**, not spatial: "which stop / how far / which way" answerable in one
  glance, every indicator agreeing. Respect `prefers-reduced-motion`, `prefers-contrast: more`,
  `prefers-reduced-transparency`. **Never `backdrop-filter` over `#cam`** — no contrast ratio can be
  computed against a background that changes 30×/second.

## Highest risks of the redesign

1. **Contrast over arbitrary video** — beautiful on a dark mock, unreadable on white pavement at noon.
   Test every scheme against worst-case frames (white sky, white wall, sunlit asphalt).
2. **The compass band** — 108 px slots, ≤74 % scale falloff, opacity falloff, a 40 px dial, a 1.1 px
   padlock, plus a fake-3D perspective. It is the *only* route selector: change one variable at a
   time and keep the drag gesture.
3. **Losing the archival voice** — Fraunces + bone + beige + seal is genuinely good and rare. Adding
   glass, gradients, emoji, pills or a geometric sans moves AradLens from "civic archive" to "2024
   app" in one step.
