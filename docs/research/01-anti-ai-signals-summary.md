# 01 — Anti-AI Signals: compact summary (AradLens)

Full report + source list: `docs/research/01-anti-ai-signals.md` · S# = sources there · [TOOL] = Impeccable CLI run against this repo · line numbers = **working tree** of `index.html` (3722 lines, uncommitted changes present) — re-verify with `Get-Content index.html -Encoding UTF8` before editing.

**Version.** AradLens is *not* purple-gradient slop; it already had one anti-AI pass (Oswald+amber → Fraunces+sand, uncommitted). That pass landed in the **third wave** of AI tells — "warm it up and make it editorial" — which is now itself the most recognisable generated look [S5]. The next pass must not repeat the move: derive the palette and type from **Arad's own materials** (Lechner's Magyar Szecesszió, Zsolnay tile, the 1901 Fortepan city plate), not from the fashion cycle.

## Top 25 tells, in priority order (P0 = do first)

1. **Display face is Fraunces** — on Impeccable's `overused-font` list ("Inter, Roboto, **Fraunces**, Geist, Plus Jakarta Sans, Space Grotesk… no longer feel distinctive"). `:14-25`
2. **Body face is not a face** — `'Segoe UI', system-ui, sans-serif` (`:84`) = Roboto on Android. [TOOL] `overused-font: Primary font: arial (47% of text)`. Self-host one body face.
3. **Light theme is the "safe warm off-white" reflex** — `#f6f2e9`/`#fffdf7`/`#ffffff` + beige accent (`:66-68`, `:36`, `:76`). Rule `cream-palette`; wave-3 ban "cream + terracotta".
4. **11-rung type ramp, no real steps** (26/22/20/19/18/17/16/15/14/13/12/11/10). Rule `flat-type-hierarchy`. Studied headline-to-body median **4.3**; the app is **1.73**.
5. **10px functional text** — landmark name + distance on the band (`:254`, `:260`). [TOOL] `undersized-ui-text` ×2. Names truncate to an ellipsis in a 104px slot.
6. **12px radius on nearly everything** (9 values in the ladder, one dominant). "The 9-16px soft radius is the weak-site default" (52% of top sites square, 23% pill).
7. **Card-in-card-in-card** — `.schematic-box`→`.schematic-svg-wrap` (`:606`, `:623`); `.album-detail`→`.cmp-card`→`.cmp-card-content` (`:637`, `:654`, `:665`); every modal wraps cards in `.modal-card` (`:811`). "Nested cards are always wrong."
8. **Gamemode modal = the literal AI feature-card template** — pill badge → 32px emoji tile → title → subtitle → paragraph → ✓ tricolons → button (`:1279-1293`, `:1296-1310`). Icon cards: 1% of top sites vs 28% of weak ones.
9. **Emoji *is* the design system's icon system** — `DESIGN.md:87-98` declares `icon-hero: "Apple Color Emoji"`. DOM: `:1163-1164, 1281, 1298, 1351, 1370, 1411, 1644, 1662, 1680, 1650, 1668, 1686, 2010-2017, 3356, 3369`. Banned outright.
10. **Every card wears hairline border + wide diffuse shadow** — `.schematic-box` (`:609`) and `.album-detail` (`:640`) carry the *identical* `2px 8px 22px rgba(0,0,0,.5)`.
11. **Bounce easing on the reward icon** — `popBounce`, `cubic-bezier(.34,1.56,.64,1)` (`:965-970`). [TOOL] `bounce-easing` ×2.
12. **Em-dash as the universal empty placeholder** — 13 body-HTML hits (`:1225, 1226, 1352, 1357, 1378, 1379, 1466, 1470, 1472, 1483, 1494, 2247, 1802`). [TOOL] `em-dash-overuse: 16`.
13. **Gamemode copy is marketing voice** — "Pășește într-o veritabilă călătorie în timp!" (`:1285`), "deblochezi file de istorie", "recompense de cronicar" — absent from the app's real voice.
14. **Bilingual SaaS parentheticals** — "(Story & Lore)" `:1282`, "(Explorer)" `:1299`, "(Demo)" `:1172`, "(Istoric)" `:1231`, "(Album personal)" `:1239`. Reads machine-translated.
15. **"Lore" / "File Deblocate" as product nouns** (`:1289`, `:1351`, `:3369`) — collides with "fișă" (the landmark record).
16. **Reward/diploma is the stock AI certificate** — `4px double #7a6038`, 10px tracked "OMOLOGAT ARADLENS ARCHIVE" seal, centred everything (`:958-1008`).
17. **Reward titles are LinkedIn compliments** — "Maestru al Inovației Arădene", "MARELE SIGILIU DE AUR" (`:1667`, `:1687`). "Cronicar" is good; the adjectives are not.
18. **Pills floating over the lens** — `.story-objective-banner` `:792-799`, `.mode-badge-pill` `:845`, `.cs-badge` `:702`. Beige *border* is decoration; the HUD rule says beige = live only.
19. **Two chromatic glows on a dark ground** — `drop-shadow(0 0 6px rgba(200,176,136,.4))` `:268`, `box-shadow: 0 0 0 3px rgba(200,176,136,.35)` `:1048`. Rule `dark-glow`.
20. **Everything centred in the modals** — `.cs-top` `:701`, `.cs-bottom` `:722`, `.cm-card` `:753`, `.celebratory` `:957`, `#captureModal` `:749`, `#desktopPlaceholder` `:770-774`.
21. **Monotonous spacing** — one gap band (12/14/16px); no item-gap vs section-gap distinction (`:821, 649, 837, 867, 1020`).
22. **Album Then/Now is a 2-col card grid** (`:648-652`) though the app owns a compare wipe in `#photoCmp` (`:479-514`).
23. **Undocumented colour** — `rgba(47,158,140,.8)` `:278`. [TOOL] `design-system-color`.
24. **`<img id="cmpOld">` has no `src`** `:1508`. [TOOL] `broken-image` — the only **error** hit.
25. **DESIGN.md describes the generated output instead of constraining it** — it ratifies the emoji system, the flat ramp and nine radius values. The previous pass wrote the system to fit the artefact.

## Top 10 anti-patterns to avoid (and the replacement)

| Avoid | Because | Do instead |
|---|---|---|
| Purple/indigo/aurora gradient, gradient text | wave-1 tell | Flat colour; a real photograph |
| Cream/beige ground + terracotta accent | wave-3 tell = the current failure | A ground from the subject: cool plate white, or a Szecesszió field (turquoise `#1F6F65`, oxblood, ochre) |
| Fraunces / Inter / Roboto / Geist / Plus Jakarta Sans / Space Grotesk | the 2026 convergence list | Spectral, EB Garamond, Cormorant, Alegreya, Source Serif 4, Literata, Besley (OFL, all with ș/ț) |
| Icon-in-rounded-square above a heading | "every generator outputs this exact shape" | One drawn 24-grid stroke set; no tile |
| Nested cards | "always wrong" | Space, typography, one hairline rule |
| Hairline border + wide diffuse shadow on every card | `gpt-thin-border-wide-shadow` | Commit to the hairline; shadow only on things that float |
| Emoji as icons | banned outright | Authored SVG, one stroke weight |
| Kicker / eyebrow / pill above a heading | banned outright, "no brief earns it back" | Fold into the sentence, or delete |
| Tiny uppercase tracked labels | 16% of top sites vs 57% of weak ones | Sentence case at a readable size; tracked caps only when they are *content* (architect, year, style) |
| Bounce easing, hover-lift on everything, identical fade-ups | motion tells | One authored moment (the band; the diploma arriving) on exponential ease-out |

Also banned: index numbering (01/02/03) · em-dash saturation · "theatre" framing copy · glassmorphism · fake dashboard UI · decorative status dots · marquee · monospace as costume · one 12-16px radius everywhere · nine near-equal font sizes · full-sentence headline at display size · "soft grey drop shadow under every card" · "the same typeface on every page".

## Voice — a hand-designed, historically-grounded AradLens

**The idea.** *The 1865→1913 construction chronology of Arad becomes the stop selector.* The live thing is the band: a curved dial of plate-dials you drag through your own street, and the city answers with its own dates. The reference object is **the 1901 Fortepan city plate** — a survey document, not a photo: a ruled frame, plate lettering, a date, a scale, a credit.

**Typography.** A 19th-c. Central-European **transitional/old-style serif** for the archive and the lore prose (Spectral, EB Garamond, Cormorant, Alegreya, Source Serif 4, Literata, Besley) — a book face, *not* a "wonky" editorial serif. Plus a **condensed / wide-tracked civic grotesque or small-caps cut** for wordmarks, labels and the diploma seal (the register of engraved shopfront and official-notice lettering: Archivo Narrow, Antonio, Oswald, Big Shoulders, or a small-caps cut of the serif). One self-hosted humanist **sans** for the interface (Archivo, Public Sans, Source Sans 3, IBM Plex Sans) — a museum caption, not a product sans. 5-6 size steps with real gaps; body ≥15px, meta ≥12px, nothing functional <11px; tabular figures on every meter.

**Texture.** Paper with a *cooler* cast (not cream) plus a faint, visible plate grain. The 1901 photograph shown with its **original plate border and paper tone**, not bled to the edge (the app does the opposite at `:342-343`). Real open-archive Arad material (Fortepan, Photoplan, Baumann, Europeana, Wikimedia) rather than generated imagery. Ink, not glow: neutral elevation only, 0.5-0.75px ink rules, no glass, no gradients, no blobs.

**Restraint.** One signal colour (live direction + arrival) + one accent (the action) + one ink. **The signal could be the turquoise already in the file** (`#14655a`) — the actual colour of Secession ceramic roofs. No badge layer: every label is part of a sentence, a rule, or a table cell. No cards where a rule will do. One authored motion, total.

**Asymmetry / editorial layout.** Left-anchored, ragged right; one centred moment (the diploma). The band is already asymmetric — do not symmetrise it. The HUD is a **plate caption**: a ruled left block, the landmark name large, the distance in tabular figures at the right. The album is a **bound plate book**: ruled index, plate, caption, colophon — not a grid of surfaces. The mode chooser is a **table of contents**; the chapter list is a **chronological index** with right-aligned years, so the 1865→1874→1876→1896→1913 line is *visible*.

**Bilingual accents.** Romanian is the product language; Latin/German/Hungarian are the *historical* voices. Use the original names with their real orthography and a Romanian gloss ("Ödön Lechner", "Anton Czigler", "Miklós Ybl"). **One** foreign word only — "Cronica" (and "Cronicar"). Remove "Lore"; remove the SaaS English parentheticals. The years are the typography. **Not this:** no startup purple, no aurora, no glass, no cream+terracotta, no dark-mode-neon, no "monochrome sans + rounded cards", no game UI (trophy, "★ CAPITOL FINALIZAT", confetti), no US travel-app voice ("Explore", "Uncover", "Trusted by 10,000+").

## Skills — the ranked eight

1. **`impeccable`** — installed; `impeccable detect --json index.html` plus the browser variant (`--viewport 390x844`) are the checker's ground truth. Read `reference/craft-floor.md` before editing.
2. **`design-taste-frontend`** (tasteskill v2) — anti-slop house rules + the 247-site study. **Not installed**: fetch `SKILL.md` + `references/tells.md` from `https://raw.githubusercontent.com/Leonxlnx/taste-skill/HEAD/skills/taste-skill/`.
3. **`redesign-existing-projects`** — audit-first protocol (before → type → colour → frame → states → stock components). **Not installed**; same upstream repo.
4. **`web-design-guidelines`** — installed; the a11y half of the checker.
5. **`research`** — already applied; next use = sourcing open-archive Arad images.
6. **`imagegen-frontend-mobile` / `-web`** — reference boards for the 10 concepts.
7. **`full-output-enforcement`** — bans placeholder content in the concept page and the redesign.
8. **`prototype`** — the concept page's contract: one throwaway artefact, one question.

**Operational trap:** `.opencode/commands/` holds 54 stubs, but `.agents/skills/` is gitignored and absent. **51 of 54 will fail to load.** Only `impeccable`, `web-design-guidelines` and `grill-me` resolve. Do not load `design-taste-frontend-v1` / `-v2-experimental` (archived predecessors). Redundant: `grill-me`≈`grilling`≈`grill-with-docs`≈`loop-me`; `to-spec`→`to-tickets`→`implement`→`implement-spec` (unusable: no issue tracker); `claude-handoff`≈`handoff`; `high-end-visual-design`≈`minimalist-ui`≈`industrial-brutalist-ui` (pick one; prefer print).

## Keep (do not lose)

The **compass band** (real arc maths — an instrument, not a container) · full-bleed unfiltered camera + two scrims · the "one signal colour" *rule* · tabular meters · the offset-blur rule · the start gate's no-scroll contract + landscape two-column mode · the Fortepan credit and public-domain provenance · the schematic-map disclaimer · the start gate's Romanian voice ("O plimbă prin istoria Aradului.", "Fără cont, fără server…") · the real content (5 landmarks, 3 chapters, lore prose) · the hand-drawn 24-grid SVG icon language · `prefers-reduced-motion` · the 44px / aria / focus accessibility floor · the idea of a chronological "cronica".

## Biggest risk

The last pass went **Oswald + saturated `#e8a33d`** → **Fraunces + muted `#c8b088`**: wave 2 → wave 3. Repeating it (any "warm editorial" move) reproduces the same generic look with new tokens. **Derive from the subject.**
