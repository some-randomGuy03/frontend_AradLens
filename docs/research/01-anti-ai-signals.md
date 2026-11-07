# 01 — Anti-AI Signals: what makes an app look machine-made, and how to undo it in AradLens

**Research report · Agent #1 · AradLens UI redesign**

Status: research only. No source file was modified. Every `index.html` line citation below was
verified against the working tree with `Get-Content index.html -Encoding UTF8` (file is **3722
lines**; `docs/codebase.md` still says 3634 — it is stale). Read this file plus
`docs/research/01-anti-ai-signals-summary.md` before designing.

Legend used throughout:
- **[S#]** = a cited external source (full list in §2).
- **[TOOL]** = output of a deterministic detector actually run against this repo (see §5).
- **[SYNTH]** = my own synthesis / judgement, not a sourced fact.
- **[CONFLICT]** = sources disagree; the resolution is stated.

---

## 1. The problem, stated precisely

There are two distinct things people mean by "AI slop", and they need different fixes.

**(a) The statistical-average look.** A model trained on the web reproduces the *median* of what
it has seen. NewWebsite.ai puts it bluntly: "it compresses design into statistical averages. When
millions of designs get distilled into 'what a good landing page looks like,' you don't get good
design. You get the median of every design that came before it." [S8] Lunis Design adds the
diagnostic: "Every section feels equally weighted, equally spaced. No visual personality.
Everything is calibrated to the middle." [S9] Paul Bakaus (Impeccable) puts the commercial version
of it: users get "the same UI when they're coding with the general models." [S11]

**(b) The unconsidered artifact.** Maya Brennan (UX Collective) is the most useful frame because
she separates the two halves: "Slop is what happens when AI artifacts are generated without thought,
effort or quality — often in high quantities. Slop strips out considered decisions, adds unnecessary
fluff and ends up telling every story the exact same way." [S7] Oliver Jahn (Pimp my Type) makes the
same point about typography: "AI models were trained on the average of the web." [S13]

**The consequence that matters for this redesign.** NN/G named the failure mode in August 2026:
"production has become cheaper than UX evaluation… teams accumulate **UX debt**… the resulting
experience may work well enough to demo or ship, but user confusion and degraded trust surface
later." [S14] And on copy specifically: "Copy, graphics, and audio that are so obviously AI-generated
that they become awkward distractions (and reputation killers)." [S14]

**The single most important finding for AradLens** [SYNTH, but mechanically verified in §5]:
AradLens does **not** look like the purple-gradient AI mush that the public discourse talks about.
It has already been through at least one anti-slop pass — it has a bespoke serif, a restrained
palette, a real signature component (the compass band), a proper offline type system, and a
thoughtful "bone + one beige" rule. What it *does* still look like is **the third-wave AI
aesthetic**: the 2025–2026 "editorial, warm, archival" look that models produce when asked for a
"premium, non-generic" design. That look is now itself a tell — it is what Taste Skill calls the
"fix that became the look" [S5 §3] and what Bakaus calls "beige or tinted backgrounds and sans-serif
fonts… an *algorithmic Uniqlo or Ikea*" [S11].

So the redesign brief is not "make it less AI." It is: **stop being the algorithmic Uniqlo.**

---

## 2. Source index

| # | Source | Link | What it gives |
|---|---|---|---|
| S1 | Impeccable antipattern registry (61 deterministic rules, Rust port of the JS registry) | https://github.com/pbakaus/impeccable/blob/main/crates/foundation/src/registry.rs | The citable rule list. Categories `slop` / `quality`, severities, and the exact wording of each rule. |
| S2 | Impeccable README | https://github.com/pbakaus/impeccable | "Inter for everything, purple-to-blue gradients, cards nested in cards, gray text on colored backgrounds, the rounded-square icon tile above every heading." |
| S3 | Impeccable `reference/craft-floor.md` (installed locally at `C:\Users\Norbert\.config\opencode\skills\impeccable\reference\craft-floor.md`) | upstream: https://github.com/pbakaus/impeccable | The "absolute bans" and "refuse" lists — the strongest single statement of what must not exist. |
| S4 | Taste Skill v2 `SKILL.md` (Leonxlnx/taste-skill) | https://raw.githubusercontent.com/Leonxlnx/taste-skill/HEAD/skills/taste-skill/SKILL.md | The house rules, the **measured** study of 247 curated gallery sites, the redesign protocol, the idea-inventory method. |
| S5 | Taste Skill `references/tells.md` | https://raw.githubusercontent.com/Leonxlnx/taste-skill/HEAD/skills/taste-skill/references/tells.md | The dated registry of generated-page tells, in four waves. The single most useful document for this task. |
| S6 | Taste Skill changelog | https://www.tasteskill.dev/changelog | Section 9 ban list (em-dash, section numbering, pills, photo-credit captions, decorative status dots…). |
| S7 | Maya Brennan, "How to de-slopify your designs", UX Collective, 29 Sep 2026 | https://uxdesign.cc/how-to-de-slopify-your-designs-4c40c57c1dc9 | The four de-slop levels (0→3); "Level 3: design it for real." |
| S8 | NewWebsite.ai, "10 Signs a Website Was Designed by AI", 11 May 2026 | https://newwebsite.ai/blog/10-signs-a-website-was-designed-by-ai | The public-facing ten tells. |
| S9 | Lunis Design, "AI-generated websites vs. human-designed" | https://lunisdesign.com/blogs/ai-generated-websites-vs.-human-designed | Gradient hero, 2–3 column uniformity, rounded buttons, "calibrated to the middle". |
| S10 | Paul Bakaus on X — "AI slop design tells" (11 Jan 2026) and the long thread on bad AI patterns (6 Apr 2026) | https://x.com/pbakaus/status/2010480866276114616 · https://x.com/pbakaus/status/2041369057300218213 | "The not-so-obvious ones: japanese-style UX writing (extreme redundancy) · cardocalypse (everything is a card, nested cards in cards) · massive rounded [corners]". |
| S11 | Business Insider via Yahoo, "Base44's CEO says the company built its own model to stop churning out AI-slop designs", 2 Jul 2026 | https://malaysia.news.yahoo.com/base44s-ceo-says-company-built-044844562.html | Bakaus: AI tells include "beige or tinted backgrounds and sans-serif fonts… an algorithmic Uniqlo or Ikea". |
| S12 | SmoothUI, "AI Design Slop: Why AI-Generated UI Looks Generic", 24 Jun 2026 | https://smoothui.dev/blog/ai-design-slop | "The purple-to-cyan gradient. Glassmorphism with a neon glow. Six identical cards in a row, each with an icon, a heading, and two lines of text." |
| S13 | Oliver Jahn, Pimp my Type, "AI design has no soul, but Typography makes it whole", 6 May 2026 | https://pimpmytype.com/ai-design-has-no-soul-but-typography-makes-it-whole | Typography as the sharpest anti-slop tool; "AI models were trained on the average of the web." |
| S14 | NN/G, "The Custodial Era of UX: Cleaning Up After AI", 28 Aug 2026 | https://www.nngroup.com/articles/ai-ux-debt/ | UX debt; AI-obvious copy as reputation killer. |
| S15 | NN/G topic hub: trust & credibility (incl. "Why AI-Generated Holiday Ads Fail", 19 Dec 2025) | https://www.nngroup.com/topic/trust-and-credibility | Authenticity deficit in AI-made creative. |
| S16 | Wikipedia, Ödön Lechner | https://en.wikipedia.org/wiki/Ödön_Lechner | Lechner designed the Arad City Hall (1872–76). Hungarian Szecesszió. |
| S17 | Cultural Heritage Online, "Budapest — Ödön Lechner and the Hungarian Szecesszió" | https://culturalheritageonline.com/places/budapest-hungarian-art-nouveau-szecesszio/ | Lechner studied "Transylvanian wooden churches" and Magyar folk ornament; Zsolnay polychrome ceramic. |
| S18 | The Decorative Arts Trust Bulletin, "Hungary's Magyar Szecesszió Art Nouveau Movement", 16 Feb 2024 | https://decorativeartstrust.org/hungary-post | Sources of the Magyar ornamental vocabulary (Huszka's *Magyarische Ornamentik*, 1898). |
| S19 | Production Type, "Spectral: A New Screen-First Typeface", 10 Apr 2025 | https://productiontype.com/article/spectral-a-new-screen-first-typeface | Spectral's screen-first serif rationale, 7 weights + small caps. |
| S20 | Wikipedia, EB Garamond | https://en.wikipedia.org/wiki/EB_Garamond | OFL Garamond revival; Erik Spiekermann: "one of the best open source fonts". |
| S21 | Smashing Magazine, "The AI Dilemma In Graphic Design: Steering Towards Excellence In Typography And Beyond", 23 Jan 2024 | https://www.smashingmagazine.com/2024/01/ai-dilemma-graphic-design-typography | Typography as the last domain where craft is legible. |
| S22 | Local repo artefacts | `DESIGN.md`, `PRODUCT.md`, `docs/codebase.md`, `fonts/OFL.txt` | The incumbent committed visual world and product truth. |
| S23 | Community lists (corroborating, weaker) | https://yomotherboard.com/question/how-can-you-spot-a-website-made-by-ai · https://growthguys.tech/blog/genuine-website-vs-ai-slop.html | Over-used gradients, stock images, generic copy, mobile breakdown. |

---

## 3. The three registers of "AI tells", and how they differ

Three independent teams converged on overlapping sets. Their *union* is the safest rulebook; their
*differences* tell you which tells are dated.

### 3.1 Impeccable's 61 rules [S1] — mechanical, file-scannable, severity-ranked

The registry is the most rigorous artifact available because it is **deterministic and testable**:
each rule has an id, a detector, and fixtures under `tests/fixtures/antipatterns/`. A test asserts
`ANTIPATTERNS.len() == 61` and `ANTIPATTERNS[0].id == "side-tab"`. Rules are `category: "slop"` (things
that make it look generated) or `category: "quality"` (things that are simply wrong).

The `slop` rules, verbatim in the parts that matter here:

| id | Name | Verbatim description (abridged) |
|---|---|---|
| `side-tab` | Side-tab accent border | "the most recognizable tell of AI-generated UIs" |
| `border-accent-on-rounded` | Border accent on rounded element | "the border clashes with the rounded corners" |
| `overused-font` | Overused font | "**Inter, Roboto, Fraunces, Geist, Plus Jakarta Sans, and Space Grotesk** are used on so many sites they no longer feel distinctive." |
| `flat-type-hierarchy` | Flat type hierarchy | "Dominant heading and body roles are separated by less than 1.25× at every step" |
| `gradient-text` | Gradient text | "decorative rather than meaningful — a common AI tell" |
| `ai-color-palette` | AI color palette | "Purple/violet gradients and cyan-on-dark are the most recognizable tells" |
| `cream-palette` | Cream / beige palette | "A warm cream or beige page background has become the default 'tasteful' AI surface, reached for by reflex." |
| `nested-cards` | Nested cards | "Cards inside cards create visual noise and excessive depth." |
| `monotonous-spacing` | Monotonous spacing | "The same spacing value used everywhere — no rhythm, no variation." |
| `bounce-easing` | Bounce or elastic easing | "feel dated and tacky… use exponential easing" |
| `pulsing-dot` | Pulsing status dot | "simulate liveness decoratively" |
| `icon-tile-stack` | Icon tile stacked above heading | "the universal AI feature-card template — every generator outputs this exact shape" |
| `italic-serif-display` | Italic serif display headline | names **Fraunces** explicitly; "judge by context" |
| `hero-eyebrow-chip` | Hero eyebrow / pill chip | "the default AI SaaS hero" |
| `kicker-above-heading` | Kicker / eyebrow label above heading | "**banned outright**, repeated or not" |
| `numbered-section-labels` | Tiny numbered section labels | "AI editorial scaffolding — a page numbering its own chapters" |
| `em-dash-overuse` | Em-dash overuse | "Em-dash saturation in body copy is an AI cadence tell." |
| `marketing-buzzword` | Marketing buzzword | "Generic SaaS phrases… are instant AI tells." |
| `aphoristic-cadence` | Aphoristic-cadence copy | "'Not a feature. A platform.' reads as AI cadence, not voice." |
| `oversized-h1` | Oversized hero headline | "A full-sentence headline set at display size ends up dominating the viewport" |
| `dark-glow` | Glowing shadow accents | "Colored glow shadows… are the default 'cool' look of AI-generated UIs." |
| `radial-halo` / `radial-spotlight-glow` | Radial gradient halos | "Same tell as glowing shadows, drawn with a gradient instead of a shadow." |
| `shape-assembled-illustration` | Shape-assembled illustration | "a pile of primitive shapes reads as placeholder clip art, not illustration" |
| `gpt-thin-border-wide-shadow` | Hairline border with wide shadow | "a recurring generated-UI signature. One floating panel earns both; a whole row wearing them reads as a default nobody chose." |
| `repeating-stripes-gradient` | Repeating-gradient stripes | "a recurring generated-UI signature" |
| `codex-grid-background` | Decorative grid-line background | "a recurring generated-UI signature. Reserve grid overlays for actual canvas, map, blueprint, or measurement surfaces" |
| `marquee` | Auto-scrolling marquee | "demands attention it has not earned" |
| `blinking-cursor` | Decorative blinking cursor | "simulates typing where no input exists" |
| `theater-slop-phrase` | Theater framing copy | "Dismissing something as 'theater' is a recurring generated-copy tic." |

And the `quality` rules that are *also* AI tells in practice: `undersized-ui-text` ("below 11px is a
legibility failure, not a style choice… Being ON the DESIGN.md size ramp does not exempt a value
here: adding 8px to the ramp launders the token but not the legibility problem"), `tight-leading`,
`flat-type-hierarchy`, `line-length`, `cramped-padding`, `gray-on-color`, `design-system-color`.

### 3.2 Taste Skill's house rules + tells registry [S4][S5][S6] — opinionated, measured, dated

This is the most valuable document for AradLens because it is (a) grounded in a **measured study of
247 curated gallery sites** (One Page Love + Awwwards Sites of the Day) and (b) explicit about
*tells* — devices that were once good ideas and became tells "because they were produced by default,
everywhere, without a reason."

Its four waves:

1. **First wave (2023–2024):** violet/indigo gradients, gradient-filled headlines, glass panels,
   glowing buttons, soft grey shadow under every card, three identical feature cards each with an
   icon in a rounded square, **emoji as icons or bullets**, the same typeface on every page.
2. **Second wave (2025):** eyebrow/kicker above every heading, pill badge above the hero headline,
   one headline word in italic serif, bento tile grids, near-black ground + one neon accent + glow,
   floating pill nav with blur, fake dashboard heroes, decorative status dots, fade-and-rise on
   every section.
3. **Third wave (2025–2026) — "the fix that became the look":** ← **AradLens lives here.**
   "Yellow-cream ground + terracotta / rust / clay accent" (banned together); "High-contrast or soft
   serif display as the shortcut to 'premium'"; "Oversized italic serif headline"; "Broadsheet
   cosplay: hairline rules everywhere, zero radius, dense columns"; "performative labels" (*Field
   notes*, *Quietly trusted by*, *On our desks*).
4. **Gallery fashion banned as house style** (i.e. banned even though award sites do it — precisely
   because generators imitate it): monospace micro-labels, index numbering (`01 / 02 / 03`,
   `Step 02`), thin rules / hairline dividers / 1px outlined boxes, design-tool chrome as ornament,
   agency micro-meta (local time, coordinates, version stamps, middle-dot strings), tiny uppercase
   letter-spaced captions.

Its structural tells (§5 of tells.md): "Headline as a full sentence at display size, three or four
lines"; "Everything centred (warned over 72%)"; "**One medium border radius (12–16px) on
everything**"; "Nine nearly equal font sizes (warned over 9)"; "Invented social proof".

Its copy tells (§6): genre verbs and adjectives (*unlock, supercharge, seamless, elevate,
effortless, cutting-edge, all-in-one*); the correction ("not just X, it's Y"); tricolon headlines;
"Get started" / "Learn more" as labels; more than a handful of em dashes; lorem ipsum.

Its motion tells (§7): identical fade-up on every block; a dozen staggered hero entrances; hover
lift on every card; bounce easing; infinite loops that mean nothing.

### 3.3 The public discourse [S8][S9][S10][S12][S23]

NewWebsite.ai's ten: floating pills/badges in the hero; the scroll indicator icon; Instrument Sans
everywhere; multi-colour gradient headlines; stats bars in the hero; aurora gradient backgrounds;
glassmorphism everywhere; fake dashboard UI mockups; over-animated interfaces; perfectly generic copy.

Lunis adds: "2 or 3-column layout throughout the site"; "rounded buttons with generic style";
"uniform spacing and proportion".

Mageswari (Medium, Feb 2026) adds a useful one for us: "**Generous White Space** — which is great,
except when it's hiding a lack of actual content strategy."

Bakaus's "not-so-obvious ones" [S10] are the most valuable because they are *structural*:
"japanese-style UX writing (extreme redundancy)" and "cardocalypse (everything is a card, nested
cards in cards)".

Two supporting pieces. NN/G's field work on AI-made creative supplies the *consequence* rather
than the symptom: AI-generated ads "lack authenticity and emotional resonance" [S15], and the
broader organisational version is that "production has become cheaper than UX evaluation" [S14].
Smashing Magazine's 2024 typography piece supplies the counterweight [S21]: the last domain where
craft stays legible is the shape of the letters, so typography is where a hand-made voice is
either won or lost. Jahn makes the same argument for 2026 [S13].

### 3.4 Where the registers conflict — and the resolution

| Conflict | Impeccable says | Taste Skill says | Resolution for AradLens |
|---|---|---|---|
| **Hairline rules** | Not a rule; `gpt-thin-border-wide-shadow` only penalises border+shadow *together* | **Banned** ("hairline dividers, ruled grids, 1px outlined boxes") | **Keep the hairlines, kill the hairline+shadow pairing.** AradLens's entire world ("rigle de păr" / hairline rules) is the *archival plate* device and is hand-designed, not default. Taste Skill bans hairlines because generators imitate gallery fashion; here the hairline is the content. Override with a stated reason [S3: "A pinned brief or the committed visual world overrides anything here"]. |
| **Cream/beige** | `cream-palette` is a **slop** rule | "Yellow-cream ground + terracotta" is banned in wave 3 | **Change the ground.** The current `#f6f2e9` bone ground is precisely the reflex. See §6.B. |
| **Serif display** | `overused-font` names Fraunces; `italic-serif-display` names Fraunces | "High-contrast or soft serif display as the shortcut to 'premium'" is a third-wave tell | **Keep a serif, change the face.** The *serif* is right for an archival plate; *Fraunces* is the AI default serif. |
| **Borders/shadows** | Allowed singly | "No thin rules"; "No shadows on things at rest" | Keep the offset-blur lift (it is a *field* device — legibility over sunlit footage, [S22 DESIGN.md "Elevation & Depth"]). Kill the resting shadow on cards. |
| **Radius** | Not a rule | "One medium border radius (12–16px) on everything" is a structural tell; "the 9–16px 'soft' radius is the weak-site default" (52% of top sites square, 23% pill) | **Pick one radius language and apply it consistently.** AradLens currently uses 6/8/10/12/14/16/20/50 — a full ladder that never commits. |
| **Em dashes** | `em-dash-overuse` (advisory, fires on saturation) | "Complete em-dash ban" (taste-skill v2 §9) | Romanian parenthetical dashes are legitimate; keep them, but **stop using "—" as the universal empty-state placeholder** (§6.G). |
| **Emoji** | Not in the registry | "Emoji as icons or bullets" — **banned** | **Remove all emoji-as-icon.** This is the single cheapest, highest-visibility de-slopping move available. |
| **Photo credit lines** | Not a rule | "photo-credit captions… banned" | **Keep them.** Fortepan / Schoch Frigyes is public-domain attribution for the only historic asset in the app; a legal/ethical obligation outranks a style default. |

---

## 4. The measured baseline (the numbers to beat)

From Taste Skill's study of 247 sites [S4]. The high-scoring cohort (panel score ≥7.5) versus the
weak cohort (<6.5):

| Device | Top sites | Weak sites | AradLens today |
|---|---|---|---|
| Icon feature cards | **1%** | **28%** | ⚠️ The gamemode modal is *exactly* this: two identical cards, each with a big emoji icon above a heading above a paragraph above a list. |
| Pill badges | **14%** | **34%** | ⚠️ `.mode-badge-pill` (1280, 1297), `.mode-badge` (779), `.schematic-badge` (1172), `.cs-badge`, `.lore-badge`, `.reward-ribbon` (1369), `.chapter-period-badge` — six+ badge types. |
| Gradients | **22%** | **52%** | ✅ Clean. Only scrim gradients (41–42, 346, 699) and the divider. Defensible. |
| Shadows | **24%** | **48%** | ⚠️ Every card, panel and button carries `2px 8px 22px rgba(0,0,0,.5)`. |
| Tiny tracked caps | **16%** | **57%** | ⚠️ `letter-spacing: 1px`/`2px` on 11–12px uppercase in ~10 places. |
| Hero media ≥ half the first screen | **68%** | — | ✅ The start gate is a full-bleed 1901 photograph. |
| Largest type (median) | **8.4vw** | 5.0vw | ⚠️ `#start h1` is `clamp(26px, 7vw, 32px)` — a full sentence at 7vw. |
| Headline-to-body ratio (median) | 4.3 | — | ⚠️ 26px / 15px = 1.73. The ramp is 10→26px with 11 rungs. |
| Button corner style | 52% square, 23% pill | 9–16px "soft" radius | ⚠️ 12px on every button. |
| Media corner style | 73% square | — | ⚠️ `.cmp-card-img` at 8px, `.lore-photo-thumb` at 8px. |

Two further numbers worth quoting in the redesign brief, because they are counter-intuitive and
taste-skill bans them *against* the data: "measured thin rules 61% against 52%", "index numbering
38% against 21%", "monospace labels 44% against 24%" — award sites do these *more* than weak sites.
Taste Skill bans them anyway, because "they are the first things a generator copies from the gallery"
[S5 §4]. **This is the strongest available argument for AradLens to keep its hairline rules and its
chronological chapter numbering** — they are load-bearing here, and copying the gallery is precisely
the failure mode to avoid.

---

## 5. Tool-verified findings (deterministic, not opinion)

The Impeccable CLI is installed globally. I ran it read-only against this repo.

**Static scan** — `impeccable detect index.html`:

```
index.html
  [broken-image] <img> with no src attribute
1 anti-pattern found.
── Advisory (not counted as failures) ──
  [bounce-easing] animation: popBounce
  [bounce-easing] cubic-bezier(.34, 1.56, .64, 1)
  line 278: [design-system-color] Undocumented color rgba(47,158,140,.8) is outside DESIGN.md colors
  [em-dash-overuse] 16 em-dashes in body text
```

**Browser scan** (served locally, 390×844 mobile viewport) — `impeccable detect http://localhost:8011/index.html --viewport 390x844`:

```
  [undersized-ui-text] 10px functional text "Turnul de Apă" (below 11px floor)
  [undersized-ui-text] 10px functional text "Palatul Cultural" (below 11px floor)
  [overused-font] Primary font: arial (47% of text)
3 anti-patterns found.
── Advisory ──
  [straggler] "locația." alone on the last of 2 lines (14% of the measure)
```

**Reading the tool output carefully** [SYNTH]:

- `overused-font: "Primary font: arial (47% of text)"` — the scan machine has no Segoe UI, so the
  stack fell back. **That is the point**: the body face is not a designed face at all, it is
  "whatever the phone has". On iOS that is San Francisco; on Android it is **Roboto**, which is on
  the Impeccable `overused-font` list; on a Linux desktop it is Liberation Sans or DejaVu Sans.
  The *same* app renders in three different typefaces on three platforms, and the platform default
  is precisely the "no decision was made" tell.
- `undersized-ui-text` fired on `.cb-name` — the **landmark name** in the compass band is 10px
  (line 254–258) and `.cb-dist` is 10px (line 260). These are the two most important readouts in
  the app and they are the smallest text in it.
- `design-system-color` fired on `rgba(47,158,140,.8)` at line 278 — the teal used for the
  "completed" compass stop is **not in DESIGN.md**. Everything else in the CSS is documented; this
  one value drifted.
- `em-dash-overuse: 16 em-dashes in body text` — I traced all 17 body-HTML occurrences: **thirteen
  of them are the "—" empty-state placeholder** (lines 1225, 1226, 1352, 1357, 1378, 1379, 1466,
  1470, 1472, 1483, 1494), plus the `alt` text (1508) and the photo credit (1533). So the rule fired
  on a *convention*, not on prose cadence.
- `straggler` — "locația." alone on the last line of `.start-detail` (line 1541). Real, minor.
- The scan found **zero** `nested-cards`, `icon-tile-stack`, `cream-palette`, `dark-glow` or
  `monotonous-spacing` hits — because those rules need the browser/layout engine and the modal
  surfaces were `display:none` at scan time. **They are still real.** See §6.

---

## 6. Product ground truth (what AradLens actually is)

Before listing tells, the incumbent.

**Product.** A phone-first, camera-first AR tourism app for the centre of Arad, Romania. It is a
single static HTML file (3722 lines), no framework, no build, no backend, three `localStorage` keys.
Sensors (camera, GPS, compass) require HTTPS + mobile + a user gesture. [S22 `docs/codebase.md`,
`AGENTS.md`]

**The five landmarks and their real architecture** (from `REPERE`, lines 1559–1630):

| # | Landmark | Year | Architect | Style |
|---|---|---|---|---|
| 1 | Turnul de Apă | 1896 | Miklós Ybl | Neogotic industrial |
| 2 | Palatul Cultural | 1913 | Lajos Szántay | Eclectic monumental |
| 3 | Primăria Arad | 1876 | Ödön Lechner (proiect) + Francisc Pekar | Neorenascentist eclectic flamand |
| 4 | Teatrul I. Slavici | 1874 | Anton Czigler | Neoclasic |
| 5 | Catedrala Veche | 1865 | Anton Czigler | Baroc târziu / Neoclasic |

**This is the single most valuable, most under-used asset in the product.** [SYNTH, grounded in
S16–S18] The landmark set is *specifically* Central-European fin-de-siècle civic architecture:

- **Ödön Lechner** — the architect of the Arad City Hall — is the prime representative of the
  **Hungarian Szecesszió**, and the father of the "Hungarian National Style" [S16]. Lechner
  explicitly drew on **Magyar folk ornament and Transylvanian wooden churches** [S17], on Zsolnay
  polychrome ceramic, on Persian and Indian textile patterns, and on the 1898 ornament book
  *Magyarische Ornamentik* by József Huszka [S18].
- **Miklós Ybl** (Turnul de Apă) is the master of Hungarian historicism/Gothic Revival — the civic
  architecture of the Austro-Hungarian state.
- **Anton Czigler** (Teatrul, Catedrala) is late-Baroque/Neoclassical, the classical register.
- The **Szecesszió** vocabulary is: sinuous curvilinear ornament, stylized organic plant forms,
  textile-derived geometry, egg-and-dart / stylized-flower motifs, beehive and sunflower roundels,
  polychrome ceramic, and a strong **flat decorative banding** system.

**The app already owns a real, specific aesthetic**: it is the "1901 Fortepan city plate under a
pewter sky, bone type on near-black, one warm archive-paper beige". That is *not* a generic AI
aesthetic. It is, however, currently executed with AI-default *materials*: a Fraunces serif, a
cream/beige palette, soft 12px radii, hairline+shadow cards, emoji icons, and six kinds of pill
badge. **The fix is to change the materials, not the idea.**

**Committed visual world (DESIGN.md)** [S22]: "AradLens — Full-Bleed Feed HUD"; creative north
star "The Caption on the Living Street"; one accent on a near-black ground; "The One Beige Rule";
"The Tabular Meters Rule"; "The Offset-Blur Rule"; "Stay-Dark Standing Rules".

**Type system actually installed:** `fonts/fraunces-latin.woff2` (67,304 B) +
`fonts/fraunces-latin-ext.woff2` (59,388 B), SIL OFL 1.1, `fonts/OFL.txt`, aliased as
`"AradLens Display"` at lines 14–25, `font-weight: 100 900`, `font-display: swap`. **The face is
Fraunces** (Undercasetype, 2018). DESIGN.md calls it "an archival serif with an optical-size axis".
Body is the system stack `'Segoe UI', system-ui, sans-serif` (line 84). Fallback chain for display
is `Georgia, "Times New Roman", serif` (line 40).

**Component inventory** (all verified by line):

| Component | Lines | Notes |
|---|---|---|
| Live camera + HUD overlay | 106–113, 1404–1499 | Full-bleed `#cam`, unfiltered. |
| Top scrim row (brand, route step, mode badge) | 119–137, 1405–1427 | |
| Right action rail — 5 rings, 52px, 2px bone stroke | 166–186, 1436–1474 | |
| Center chevron (72px, 6px round stroke) | 150–156, 1429–1435 | |
| **Compass band** `#snapRail` | 200–271 (CSS), 2068–2320 (JS) | `perspective(760px) rotateX(13deg)`, `BAND_SLOT 108`, `BAND_SAG 26`; arc maths (`bandCurveR`, `bandDrop`, `bandArcDeg`) at 2108–2118; per-stop SVG dial with cardinal ticks + needle + padlock (`compassDialMarkup`, 2180–2205). |
| Bottom caption rail + distance row | 274–326 | Arrival floods the caption beige (`body.has-arrived`, 309–316). |
| Start gate | 328–419, 1532–1557 | Full-bleed 1901 photograph, scrim, `100dvh` no-scroll column, landscape 2-col grid at ≤560px height. |
| Info card (bottom sheet) | 445–467, 1501–1512 | |
| Then/Now photo compare | 469–505, 1514–1528 | Canvas vs. 1901 plate, `clip-path: inset()` wipe, range input. |
| Album + schematic map | 575–683, 1159–1271 | Hand-placed SVG pins (`mapPin0-4`), 20px grid pattern, Mureș river stroke. |
| Capture screen | 686–737, 1118–1133 | 240px dashed viewfinder frame, 72px shutter over 56px beige inner. |
| Gamemode modal | 805–871, 1274–1319 | Two cards: story (featured) + free. |
| Chapter modal | 874–919, 1322–1339 | |
| Lore modal | 922–961, 1342–1370 | |
| Reward + diploma modal | 963–1009, 1373–1397 | `.diploma-card` with `border: 4px double #7a6038`. |

**State / behaviour**: 3 chapters (lines 1636–1691) with `landmarkIndices` in strict construction
order; story mode enforces capture order; 50 m proximity gate; `localStorage` for theme, user photos
and story progress; TTS via Web Speech API `ro-RO`; the schematic map is an explicit **demo**, not
GPS-projected, and is labelled as such in the UI (line 1220, 1753) — **keep that disclaimer**.

---

## 7. The tell-checklist for THIS app

Every entry: (a) the tell, (b) the evidence in the current `index.html` with line numbers, (c) the fix
direction, (d) supporting sources. Ordered roughly by how much damage the tell does to the
"hand-designed" reading. **P0** = fix in the first pass; **P1** = fix in the redesign; **P2** = fix
when touching that area anyway.

### A. Typography

**T-01 — The display face is Fraunces, which is on the published AI-slop font list.** **P0**
- **Tell:** Impeccable's `overused-font` rule names the fonts that "no longer feel distinctive"
  because "each new wave of AI-generated UIs converges on the same handful of faces" — and the list
  is *Inter, Roboto, **Fraunces**, Geist, Plus Jakarta Sans, and Space Grotesk* [S1]. The
  `italic-serif-display` rule names Fraunces again [S1]. NewWebsite.ai names the same phenomenon
  for Instrument Sans/Geist/Inter Display: "Typography is one of the cheapest ways to give a brand
  its own voice, and AI tends to throw that away by default" [S8].
- **Evidence:** `index.html:14-25` — `@font-face { font-family: "AradLens Display"; src: url("fonts/fraunces-latin-ext.woff2") ... }` and `fonts/fraunces-latin.woff2`; `fonts/OFL.txt` confirms "Copyright 2018 The Fraunces Project Authors". The alias hides the face from every detector — **the disguise is the problem, not the disguise's existence**. DESIGN.md line 297 even names it openly: "AradLens Display (self-hosted Fraunces…)".
- **Fix direction:** Keep *a* serif — the serif is right for a 1901 archival plate. Replace the *face* with something whose letterforms carry Central-European fin-de-siècle print character and are not on any convergence list. Candidates worth evaluating (all OFL, all with Romanian ș/ț coverage): **Spectral** (Production Type, screen-first serif, 7 weights + small caps [S19]), **EB Garamond** (OFL, "one of the best open source fonts" per Spiekermann [S20]), **Cormorant / Cormorant Garamond**, **Alegreya**, **Source Serif 4**, **Literata**, **Besley**. For the *display* register specifically consider a face with engraved/letterpress character (**Gloock**, **Antonio**, **Bodoni Moda** are OFL; check none is on a 2026 convergence list) rather than another "wonky" serif. Whatever is chosen, self-host `latin` + `latin-ext` woff2 exactly as today so the offline/single-file deploy keeps working [S22 `AGENTS.md`].
- **Sources:** [S1] [S2] [S8] [S13] [S19] [S20]

**T-02 — The body face is not a face at all; it is "whatever the phone has."** **P0**
- **Tell:** [S1] `overused-font` names **Roboto**. [S2] "Don't use overused fonts (Arial, Inter, system defaults)." [S3] craft-floor refuses: "A system display face … as the display voice of an own-world page. Source and self-host a face whose character matches the approved lettering; **the closest installed font is a failure, not a fallback.**"
- **Evidence:** `index.html:84` — `html, body { … font-family: 'Segoe UI', system-ui, sans-serif; … }`. 'Segoe UI' exists only on Windows; on iOS the stack falls to San Francisco, on **Android to Roboto**, on a Linux desktop to Liberation Sans / DejaVu Sans. The same product therefore renders in three unrelated typefaces. The browser scan reported `overused-font: Primary font: arial (47% of text)` on the scan machine [TOOL].
- **Fix direction:** Self-host **one** body face, offline, woff2, latin + latin-ext, OFL. It must read as *civic print*, not as product UI. A humanist sans with a documentary feel (**Archivo**, **Public Sans**, **Source Sans 3**, **IBM Plex Sans**) reads as 20th-century civic wayfinding; a neutral grotesque reads as SaaS. Keep a system stack only as a *fallback* after the self-hosted face, never as the intended face. Budget two `@font-face` files per family (latin, latin-ext) as today — the ș/ț glyphs live in latin-ext and the app already proves the two-file pattern works.
- **Sources:** [S1] [S2] [S3] [S13]

**T-03 — The type scale has eleven rungs and no real steps.** **P0**
- **Tell:** Taste Skill's structural tell: "**Nine nearly equal font sizes** (warned over 9)"; and its law: "Two or three sizes do the visible work … Five sizes on a page is the ceiling." [S4][S5] Impeccable's `flat-type-hierarchy` fires when "heading and body roles are separated by less than 1.25× at every step" [S1].
- **Evidence:** DESIGN.md lines 25–86 documents an 11-step ramp (26/22/20/19/18/17/16/15/14/13/12/11/10). In `index.html` the actual sizes are: display 26 (line 302), title 22 (128/463/594), stat 20 (643/709/824/924), headline 19 (852), label 18 (135), action 17 (395), subhead 16 (294), body 15 (306), body-sm 14 (472/588), caption 13 (758/893/941), fine 12 (399/472/588/625/673/…), tag 11 (846/887/994/1010/1034), overline 10 (254/260/973). Adjacent steps of 1px (22→20, 20→19, 16→15, 15→14, 14→13, 13→12) carry different jobs. The largest-to-body ratio is 26/15 = **1.73**, against a studied median of **4.3** [S4].
- **Fix direction:** Collapse to a 5–6 step ramp with real gaps. A working shape: **hero 44–56px / title 26–30px / section 20–22px / body 15–16px / meta 12–13px / micro 11px**. Push the hero up and the meta down. Add one strong step so the hierarchy is unmistakable at a glance [S4 `typeset` analogue: "Can heading, body, label, metadata, and data roles be distinguished at a glance?"].
- **Sources:** [S1] [S4] [S5]

**T-04 — Functional text at 10px, in the most important readout in the app.** **P0**
- **Tell:** Impeccable `undersized-ui-text`: "Interactive and content-bearing UI text … below 11px is a legibility failure, not a style choice… Being ON the DESIGN.md size ramp does not exempt a value here: adding 8px to the ramp launders the token but not the legibility problem, and that is exactly the escape hatch this rule closes." [S1]
- **Evidence:** `index.html:254-259` — `.cb-name { font-family: var(--display); font-size: 10px; … white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }`; `index.html:260` — `.cb-dist { font-size: 10px; … }`. The **landmark name and its distance** — the two things a walker needs — are the smallest text in the product, inside a 104px-wide slot, and the name is truncated with an ellipsis ("Palatul Cult…"). The browser scan fired `undersized-ui-text` on exactly this, twice [TOOL]. Additional 10–11px functional text: `.diploma-seal` (983), `.reward-ribbon` (958), `.mode-badge-pill` (845), `.chapter-period-badge` (885), `.cl-item` (897), `.diploma-meta` (994), `.rbc-meta` (1034), `.lore-badge` (919), `.lore-ribbon` (936), `.lore-next-preview strong` (954).
- **Fix direction:** Raise the band to 11px minimum for anything the user must read, 12–13px for names and distances. **The real fix is structural**: the compass band slot is too narrow (104px) for a landmark name — "Teatrul I. Slavici" cannot fit. Widen `BAND_SLOT`, or set the name in two lines, or move the name to the caption rail and leave only the year + distance on the dial. Truncating the *name of a landmark* is the kind of small dishonesty that reads as unfinished.
- **Sources:** [S1] [S4 ("16% of top sites against 57% of weak ones" for tiny tracked caps)] [S3]

**T-05 — Negative tracking on display type, and the same serif everywhere.** **P1**
- **Tell:** [S1] `extreme-negative-tracking`; [S3] "Tighten display type optically, not destructively." AradLens uses `letter-spacing: -0.005em` on ~14 display rules and `-0.02em` on `.cm-title` (764).
- **Evidence:** `index.html:302, 355, 362, 463, 594, 643, 709, 764, 824, 852, 890, 924, 928, 973, 988, 1032` — `letter-spacing: -0.005em` repeated; `-0.02em` at 764.
- **Fix direction:** Tracking is fine *for the face you chose*; -0.005em is a non-decision that exists to cancel out a Fraunces-specific quirk. **Re-derive tracking after the face swap** and let the new face's own rhythm stand (Spectral and EB Garamond both need different optical correction than Fraunces). [S4] suggests -0.02 to -0.05em for display — but only after the face is chosen.
- **Sources:** [S1] [S3] [S4]

**T-06 — One family does everything, including the "editorial serif" shortcut.** **P1**
- **Tell:** [S5] third wave: "**High-contrast or soft serif display as the shortcut to 'premium'**"; [S4] "One family is normal … two is the limit."
- **Evidence:** `index.html:40` — `--display: "AradLens Display", Georgia, "Times New Roman", serif;` used for every heading (lines 128, 135, 254, 294, 302, 355, 361, 463, 594, 643, 709, 763, 777, 824, 852, 890, 924, 928, 973, 988, 1032), while the *body* is the system sans (84). So there are already two families — but the second one is the platform's, not a chosen one. The result: "serif for display, whatever for text," which is the **most common AI default of all** [S8, S9].
- **Fix direction:** Decide the pairing deliberately. A single self-hosted family with two optical registers, or a serif display + a self-hosted humanist sans for the *interface*, with the serif also used for long-form heritage text (the lore stories) — where the serif is the voice, not a costume. The UI in a documentary sans, the archive in a serif, is the correct split for this product and reads as decided.
- **Sources:** [S4] [S5] [S8] [S13]

### B. Colour

**T-07 — The light theme is the "safe warm off-white" reflex.** **P0**
- **Tell:** Impeccable `cream-palette`: "A warm cream or beige page background has become the default 'tasteful' AI surface, reached for by reflex. Choose a background that comes from a deliberate palette, not the safe warm off-white." [S1] Taste Skill wave 3: "Yellow-cream ground + terracotta / rust / clay accent — banned together; terracotta banned alone; cream warned." [S5] Bakaus: AI tells include "beige or tinted backgrounds … an *algorithmic Uniqlo or Ikea*." [S11]
- **Evidence:** `index.html:66` — `body.light-theme { --bg-main: #f6f2e9; … }`; `:67` `--bg-surface: #fffdf7`; `:68` `--bg-card: #ffffff`; `:70` `--text-main: #171106`; `:71` `--text-muted: #4a4234`; `:76` `--accent-green: #7a6038`. The accent is `#c8b088` (line 36) — a warm sand/beige — and the "deep" variant `#7a6038` is a brown. **Ground + accent together are exactly the banned combination.** DESIGN.md lines 6–8 name the palette "bone / amber / amber-deep" and line 66 defines `--amber-deep` as "bej închis" — the language itself is the tell.
- **Fix direction:** The **dark theme is fine and should be preserved** — near-black `#0b0e12` with a single warm signal is a *field* decision, not a default. The light theme needs a real ground. Options that are *not* cream: (a) **paper white with a cool cast** — `#FBFAF7` is still cream, so go cooler: `#F7F6F2` is borderline; a true archival alternative is a **light warm grey-blue** like `#EFEFEC` / `#F2F2EE`; (b) **oxblood / ox-red** ground (a historic Hungarian-Romanian civic colour — the Secession palette of Zsolnay tile: deep turquoise, ochre, oxblood [S17][S18]) with bone type; (c) **a saturated field used once** (a full-bleed chapter colour) rather than a default ground. Whatever is chosen, the **accent must move off beige**: the Szecesszió palette offers turquoise (`#1F6F65` is already in the file as `--deep-teal`!), oxblood, ochre and a saturated cobalt [S17][S18]. Teal is the obvious candidate because it is already the "completed" colour in the compass band — it would give the product a *second* real hue instead of a monochrome beige ramp.
- **Sources:** [S1] [S5] [S11] [S17] [S18]

**T-08 — One accent, used for everything, including decoration.** **P1**
- **Tell:** [S4] colour law: "One ground, one ink, one accent. The accent appears on the action and perhaps one other thing." [S1] `ai-color-palette` warns about "flat neon ink on a dark ground … charged once a second tell hue joins it."
- **Evidence:** `--amber #c8b088` (36) / `--accent-green #c8b088` (54) / `--accent-teal #14655a` (53) / `--deep-teal #14655a` (39). The "green" token holding a *beige* value is itself a smell of token rot [S1 `design-system-color` is a registered rule for exactly this class of drift]. Amber is used for: the chevron, the distance numerals, the route step, the primary button, the active compass stop, the active map pin, the compare divider, the shutter inner, the mode-card accent border (843), the active chapter border (873), the lore year stamp, the "next preview" border, the reward ribbon, the album tab active state, the capture-ready ring border — i.e. **on actions, on state, on decoration, and on brand**.
- **Fix direction:** Split the token honestly: `--signal` (the one live-direction colour, reserved for the chevron / distance / arrival) vs `--accent` (the action colour) vs `--ink` vs `--ground`. Two hues is legitimate and better than one over-used hue: the current `--deep-teal` should be promoted from a map-pin colour to a real second ink. Keep the "One Beige Rule" *if* the beige survives as signal; but move the accent off beige entirely (see T-07).
- **Sources:** [S1] [S4] [S5]

**T-09 — Coloured glow shadows on a dark ground.** **P1**
- **Tell:** [S1] `dark-glow`: "Colored glow shadows — a zero-offset chromatic halo … are the default 'cool' look of AI-generated UIs. Use neutral elevation shadows and subtle, purposeful lighting instead." Also `radial-spotlight-glow`.
- **Evidence:** `index.html:268` — `.compass-stop[aria-current="true"] .cb-dial { filter: drop-shadow(0 0 6px rgba(200,176,136,.4)); }` (zero-offset, chromatic, on a dark ground); `index.html:1048` — hover `box-shadow: 0 0 0 3px rgba(200,176,136,.35), 2px 8px 22px rgba(0,0,0,.7)` (a zero-offset chromatic ring, though it functions as a focus ring). Every other shadow in the file is a *neutral* offset blur (153, 177, 396, 509–520, 609, 640, 687, 727, 756, 814, 987) — so the rule is violated in exactly two places, both of them "make the live state glow".
- **Fix direction:** Delete the chromatic halos. The active compass stop already has four other state channels (halo stroke, ring stroke width, tip fill, hub fill, name colour — lines 252–270). Elevation over live footage should stay **neutral** (the app's own "Offset-Blur Rule" already says "never colored" — the CSS is drifting from its own design system). Where a glow is wanted, make it *behavioural*: the reticle, a light sweep, the arrival flood.
- **Sources:** [S1] [S3] [S22 DESIGN.md "The Offset-Blur Rule"]

**T-10 — A colour that is not in the design system.** **P2**
- **Tell:** [S1] `design-system-color` — "A literal color is outside the DESIGN.md palette and sidecar tonal ramps… it should be an intentional design-system addition rather than drift."
- **Evidence:** `index.html:278` — `.compass-stop.completed .cb-ring { stroke: rgba(47,158,140,.8); }` and the matching `.cb-hub { fill: #2f9e8c; }`. The detector confirmed: `line 278: [design-system-color] Undocumented color rgba(47,158,140,.8) is outside DESIGN.md colors` [TOOL]. Everything else in the CSS is documented.
- **Fix direction:** Either add it to DESIGN.md as a named token (`--complete`), or replace it with the documented `--deep-teal` / a new `--complete` you commit. One value; trivial; but it is the *only* proof that the design system is not being maintained, and a reviewer will look for exactly this.
- **Sources:** [S1]

### C. Shape, radius, elevation

**T-11 — One soft radius (12px) on nearly everything.** **P0**
- **Tell:** [S5] structural tell: "**One medium border radius (12–16px) on everything**" → "Square or fully round, chosen once". [S4] components law: "Buttons: flat, one fill colour, either square-cornered or fully round, decided once (top sites: 52% square, 23% pill; **the 9–16px 'soft' radius is the weak-site default**)."
- **Evidence:** the radius ladder in use is 6/8/10/12/14/16/20/50 across ~40 rules, but the *dominant* value is 12px: `#caption` (290), `.btn` (443), `.card-x` (467), `#card` (459), `.album-close-btn` (598), `.schematic-box` (607), `.album-detail` (638), `.cmp-card` (655), `.story-objective-banner` (792), `.compassWarning` (525), `#proximityToast` (559), `.cs-cancel-btn` (737), `.cm-card` (753), `.cs-badge` (702), `#startBtn` (392), `.reward-badge-card` (1022), `.album-action-btn` (683). Meanwhile the *signature* components are already round (52px rings) or square (map pins, 0-radius) — the app contradicts itself.
- **Fix direction:** **Pick one language and apply it ruthlessly.** For an archival plate / engraved civic document the right answer is **square or near-square (0–2px) for plates, cards, buttons, images, badges**; **full round only for the 52px rail rings and the shutter** (which are literally instruments). Never 8/10/12/14/16 mixed. If square is chosen, the hairline rules and the map grid read as a *drafting sheet*; if round is chosen, the app becomes a consumer app and loses the archival voice. **Square is the correct answer for this product** — and it also solves T-12 for free.
- **Sources:** [S4] [S5]

**T-12 — Every card wears a hairline border *and* a wide diffuse shadow.** **P0**
- **Tell:** [S1] `gpt-thin-border-wide-shadow`: "Every card of this row wears a hairline border paired with a wide, diffuse shadow, which is a recurring generated-UI signature. One floating panel earns both; a whole row wearing them reads as a default nobody chose. **Across the row, commit to one: a defined edge or a soft elevation.**"
- **Evidence:** `index.html:609` — `.schematic-box { … border: 1px solid var(--border-color); … box-shadow: 2px 8px 22px rgba(0,0,0,.5); }`; `index.html:640` — `.album-detail { … border: 1px solid var(--border-color); … box-shadow: 2px 8px 22px rgba(0,0,0,.5); }` — **the identical pairing, the identical shadow value, twice, adjacent**. Also `.reward-badge-card` (1024: border 1.5px, no shadow), `.mode-select-card` (839: border 1.5px, no shadow), `.chapter-card` (869: border 1.5px, no shadow), `.lore-story-box` (933: border 1.5px, no shadow). So the app already has both languages — it just doesn't commit. And `.modal-card` (814) has a border *and* `box-shadow: 2px 14px 40px rgba(0,0,0,.8)`.
- **Fix direction:** **Commit to the hairline.** Every surface in the archive world is a ruled plate: keep the 1px rule, **remove the resting shadow from all surfaces**, and reserve the offset-blur shadow for genuinely floating things (the modal, the toast, the shutter — the app's own DESIGN.md already says this: "No cards, no panels, no resting shadows on surfaces — depth exists to keep bone legible over sunlit street footage"). The `gpt-thin-border-wide-shadow` rule is *satisfied* by removing the shadow, not the border.
- **Sources:** [S1] [S3] [S22 DESIGN.md "Elevation & Depth" / "The Offset-Blur Rule"]

**T-13 — `border-radius: 0` in one place, 12px in forty.** **P2**
- **Tell:** general consistency, not a registered rule; [S4] "One grid, one pair of tight margins" / component consistency.
- **Evidence:** `.cmp-old` and `.cmp-now` (472–474) are full-bleed with no radius; `.schematic-pin` circles are 16px radius (1194); `#caption` (290) is 12px; `#startBtn` (395) is 12px; `.diploma-card` (978) is 12px with a `4px double` border.
- **Fix direction:** Fixed by T-11.

### D. Layout, spacing, nesting

**T-14 — Cards inside cards inside cards, four levels deep.** **P0**
- **Tell:** [S1] `nested-cards`: "Cards inside cards create visual noise and excessive depth. Flatten the hierarchy — use spacing, typography, and dividers instead of nesting containers." [S3] craft-floor refuses: "Cards are the lazy container; **nested cards are always wrong**." Bakaus names it "cardocalypse" [S10].
- **Evidence:** the album screen is card → card → card:
  - `.schematic-box` (606) — a bordered, shadowed card — contains `.schematic-svg-wrap` (623) — another bordered, radius-10 panel with its own background — which contains the SVG map (1183–1216).
  - `.album-detail` (637) — another bordered, shadowed card — contains `.cmp-card` (654) — another bordered card — which contains `.cmp-card-content` (665) — a *fourth* bordered/radius-8/background-filled box with a **dashed** border.
  - `.reward-badge-card` (1022) is a bordered card inside `.rewards-list-container` inside a modal card.
  - `.mode-select-card` (838) and `.chapter-card` (868) are bordered cards inside a `.modal-card` (811) — itself a bordered, shadowed card. **Card inside card inside card, on every modal in the app.**
- **Fix direction:** **Flatten completely.** In the album, the map should be a *plate on the ground*, not a card in a card: remove `.schematic-box`'s own border+shadow+background, let the map sit directly on the modal ground with a hairline rule above and below. The Then/Now comparison should be **two columns separated by one vertical hairline**, not two bordered boxes each containing a dashed box. In the modals, `.modal-card` is the only card; the mode cards and chapter cards inside it should be **rows or ruled entries**, not boxes. [S4]: "each section has a different composition from its neighbours; none is a card grid."
- **Sources:** [S1] [S3] [S10] [S4]

**T-15 — The gamemode modal is the literal AI feature-card template.** **P0**
- **Tell:** [S1] `icon-tile-stack`: "A small rounded-square icon container above a heading is the universal AI feature-card template — **every generator outputs this exact shape**." [S1] `kicker-above-heading`: "banned outright, repeated or not." [S4] house rule: "**No icon-topped feature cards, no rows of identical cards.**" And the measured numbers: icon feature cards appear in **1%** of top-scored sites vs **28%** of weak ones [S4]. [S12] "Six identical cards in a row, each with an icon, a heading, and two lines of text." [S10] "cardocalypse."
- **Evidence:** `index.html:1279–1293` and `1296–1310` — two `.mode-select-card`s, structurally identical, each = `.mode-badge-pill` (845, 11px uppercase tracked) → `.mode-icon` (850, **32px emoji**) → `.mode-card-title` (852) → `.mode-card-subtitle` (856, 12px accent-coloured) → `.mode-card-desc` (858, 13px) → `.mode-card-perks` (861, three "✓" lines) → a full-width button. This is **the** AI template, in its entirety, in the app's most-seen decision surface. The same shape repeats in the chapter list: `.chapter-card` (868) with `.chapter-number` (881, 12px uppercase tracked) → `.chapter-title` (890) → `.chapter-desc` (893) → `.chapter-landmarks-list` → `.chapter-reward-snippet` (908) → a button.
- **Fix direction:** **Rebuild the mode chooser as an argument, not a card pair.** Concretely: one full-width ruled entry per mode (a hairline between them), the mode name as a real heading at 20–24px, the mode's distinguishing fact in one line ("5 repere, 1865 → 1913, în ordine cronologică"), and the CTA as a plain right-aligned text action. **Delete the 32px emoji tile entirely.** The "Recomandat · Modul Liber" pill at 1297 is a badge; it belongs in the sentence or nowhere. Same for the chapter list: turn it into a **chronological index** — a ruled list of three chapters with their year ranges right-aligned in tabular figures, because the *chronology is the content*. That is also a real improvement: the chapter list is currently hiding the app's best idea (1865 → 1874 → 1876 → 1896 → 1913) behind three identical boxes.
- **Sources:** [S1] [S4] [S5] [S10] [S12]

**T-16 — Monotonous spacing: the same four numbers everywhere.** **P1**
- **Tell:** [S1] `monotonous-spacing`: "The same spacing value used everywhere — no rhythm, no variation. Use tight groupings for related items and generous separations between sections." [S4] space law: "The gap between sections is clearly larger than any gap inside one"; "Text blocks share two or three left edges on the whole page."
- **Evidence:** the modal grid uses `gap: 12px` (821, 649) and `gap: 14px` (837, 867, 1020); nearly every block ends in `margin-bottom: 14px` (591, 604, 625, 638, 869, 932, 949, 1006); `padding: 12px 14px` (525, 563, 936); `padding: 16px` (838, 868, 932, 946); `border-radius: 12px` everywhere. The vertical rhythm inside every modal is 12/14/16 — a 4px band, repeated. There is **no** "section gap" distinct from "item gap"; the largest space in a modal is 14px + a 1px rule.
- **Fix direction:** Define **two** gaps (e.g. 6/10 for items inside a group, 28–40 for group boundaries) and use them consistently. In a 440px modal on a phone, a 40px separation between the two mode choices is the single highest-leverage spacing change in the app.
- **Sources:** [S1] [S4] [S5]

**T-17 — Everything is centred in the modals; nothing is in the HUD.** **P1**
- **Tell:** [S5] structural tell: "Everything centred (warned over 72%)"; [S4] "Left-anchored, one centred moment."
- **Evidence:** `.cs-top { text-align: center }` (701), `.cs-bottom { align-items: center }` (722), the capture modal centred (`.cm-card { text-align: center }`, 753–756), `.celebratory { text-align: center }` (957), `#captureModal { align-items: center; justify-content: center }` (749), `#desktopPlaceholder { align-items: center; justify-content: center; text-align: center }` (770–774), `.story-objective-banner` centred via `margin-left:auto; margin-right:auto` (797). The HUD itself is left-anchored and correct.
- **Fix direction:** **Keep the HUD left-anchored** (it is right). Un-centre the modals: the mode chooser, the chapter list, the album, and the info card should all be **left-aligned with a ragged right**. Reserve centring for exactly one moment per surface — the reward/diploma, which is a certificate and *should* be centred.
- **Sources:** [S4] [S5]

**T-18 — The album is a 2-column card grid.** **P1**
- **Tell:** [S5] "Every section the same layout family"; [S4] "none is a card grid".
- **Evidence:** `.cmp-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }` (648–649) collapsing to one column under 480px (651–652); `.mode-cards-grid` (837) is a flex column of 14px-gapped cards; `.chapters-grid` (867) likewise; `.album-tab-bar` (1006) an 8px-gapped flex row.
- **Fix direction:** The Then/Now comparison is a **single before/after plate with a divider** (the app already has that mechanic in `#photoCmp`!) rather than two side-by-side boxes. Reuse the compare wipe from 469–505 inside the album instead of rebuilding it as a grid. That is both better design and less code.
- **Sources:** [S4] [S5]

**T-19 — The map grid overlay.** **P2 (keep, but justify)**
- **Tell:** [S1] `codex-grid-background`: "A decorative grid or line-field background drawn with hairline linear-gradient layers tiled by a fixed pixel cell is a recurring generated-UI signature. **Reserve grid overlays for actual canvas, map, blueprint, or measurement surfaces**; elsewhere use product structure or a plain surface."
- **Evidence:** `index.html:1178–1182` — an SVG `<pattern id="gridPattern" width="20" height="20">` with a hairline L-path at `rgba(246,242,233,0.06)`, tiled across the map.
- **Fix direction:** **This one is legitimate** — it *is* a map/plate surface, which the rule explicitly exempts, and a drafting grid is exactly the right device for a schematic city plate. **Keep it, and make it more deliberate**: give the grid a named token, a slightly warmer or cooler ink, and a 25-unit cell (a round number a drafter would use) instead of 20. Note the exemption in DESIGN.md so a later reviewer doesn't "fix" it.
- **Sources:** [S1] [S5]

### E. Iconography

**T-20 — Emoji used as the icon system, and as the icon system in the design system.** **P0**
- **Tell:** [S5] wave 1: "**Emoji as icons or bullets** — banned. → Words, or a real picture." [S3] craft-floor refuses: "Unicode glyphs or emoji standing in for an icon system. **Icons are drawn, from a real library or authored SVG, in one consistent stroke and weight.**" [S2] "the rounded-square icon tile above every heading." [S1] `icon-tile-stack`.
- **Evidence — the DOM:** album tab buttons 📷 and 🏆 (1163, 1164); the two mode cards 📜 and 🧭 (1281, 1298); the lore ribbon 📜 (1351); the reward icon 🏆 (1370); the story objective banner ⏳ (1411); the chapter icons 🏛️ ⚙️ 👑 (1644, 1662, 1680) and the reward medals 🥈 🥇 🏆 (1650, 1668, 1686); the chapter-landmark chips ⏳ / ✓ / 📍 (2010–2017); the reward badge cards 🔒 / medal (3356); the lore title 📜 (3369). **Emoji also leak into button labels** as arrows: ➔ (1292, 1361, 1386), ★ (1369, 2055), ✓ (1288–1290, 1305–1307).
- **Evidence — the design system ratifies it:** `DESIGN.md` lines 87–98 define `icon-hero: "Apple Color Emoji", "Segoe UI Emoji", sans-serif` at 64px, `icon-lg` at 36px, `icon-md` at 32px. **The emoji *is* the documented icon system.** That is the deepest form of this tell: the design system was written to match the generated output, instead of the output being made to match a design system. [S13]: the AI output *taught* the system.
- **Fix direction:** **Replace the emoji with a drawn icon set.** The app already draws its own SVG — the rail icons (1437–1473) are Feather/Lucide-derived paths at `stroke-width: 2`, `stroke-linecap: round`, `stroke-linejoin: round`, 24×24 viewBox, in bone. The compass dial is a hand-authored SVG (2180–2205). So the app *has* a house icon language; the emoji are the intruder. Extend the drawn set: a **scroll/chronicle** glyph for the story mode, a **compass rose** for free mode, a **map** for the album tab, a **medal/seal** for rewards, a **padlock** (already exists in the band, 2199–2202) for locked steps. Keep one stroke weight, one 24-grid, one colour. **Emoji in a heritage AR app also read as a demographic signal**: on Android they render in the manufacturer's system face (Noto Color Emoji), not the app's, so the icon style changes per device — the opposite of a designed system. Note the *cost*: the `icon-hero`/`icon-lg`/`icon-md` tokens in DESIGN.md must be rewritten, and the CHAPTERS `icon:` field (1644, 1651, 1659) and `reward.icon` (1665, 1673, 1681) must become SVG keys.
- **Sources:** [S1] [S2] [S3] [S5] [S13]

**T-21 — Arrows and stars as button-label glyphs.** **P2**
- **Tell:** [S3] "Controls name their action."
- **Evidence:** "Alege Capitolul & Începe Povestea ➔" (1292), "Continuă Călătoria în Timp ➔" (1361), "Alege Următorul Capitol ➔" (1386), "★ CAPITOL FINALIZAT ★" (1369), "★ Capitolul I" (2055), "Revendică Recompensa de Cronicar! 🏆" (3251).
- **Fix direction:** Buttons name the action; the arrow adds nothing a right-aligned label doesn't already say. The ★ in a "CAPITOL FINALIZAT" ribbon is decoration on decoration. Remove the arrows; keep at most one meaningful mark where it carries information (the padlock on locked steps, which does).
- **Sources:** [S3] [S4]

### F. Motion

**T-22 — Bounce easing on the reward icon.** **P1 (detector-confirmed)**
- **Tell:** [S1] `bounce-easing`: "Bounce and elastic easing feel dated and tacky. Real objects decelerate smoothly — use exponential easing (ease-out-quart/quint/expo) instead." [S5] motion tells: "bounce easing." [S3]: "Motion: one authored moment, not scattered effects… Exponential ease-out from an already-visible default."
- **Evidence:** `index.html:963–970` — `.reward-icon-huge { font-size: 64px; … animation: popBounce .6s cubic-bezier(.34,1.56,.64,1); }` with `@keyframes popBounce { 0% { transform: scale(0.3); opacity: 0; } 80% { transform: scale(1.15); opacity: 1; } 100% { transform: scale(1); } }` — a back-out overshoot on a 64px emoji.
- **Fix direction:** Two problems, one fix. (a) The easing is dated — use `cubic-bezier(.16,1,.3,1)` (ease-out-quart) or similar. (b) **The element it animates is a 64px emoji** (T-20) — so the fix is to delete the animation along with the emoji, and replace it with **one authored moment for the whole reward surface**: the certificate itself arriving (a plate sliding up + a hairline rule drawing across + the seal stamping in), on exponential ease-out, ~600ms, once, `prefers-reduced-motion` respected (the app already has a reduced-motion block at 1060–1069).
- **Sources:** [S1] [S3] [S5]

**T-23 — The shutter pulse is legitimate; the "live" pulse is not.** **P2**
- **Tell:** [S1] `pulsing-dot`: "Small pulsing status dots simulate liveness decoratively. Reserve pulse animation for indicators tied to genuinely live, changing data."
- **Evidence:** `index.html:519–520` — `@keyframes shutterPulse` on `#rail .ring.capture-ready` (line 193: `animation: shutterPulse 1.6s ease-in-out infinite`). This one is **legitimate**: the pulse is bound to the live proximity sensor (≤50 m) and stops the moment you are in range. Also `toastIn` (559) on the proximity toast.
- **Fix direction:** **Keep the shutter pulse** — it is the app's one honest use of motion and it is bound to real data. Consider making the capture-ready state *not* infinite (e.g. a 3-pulse attention gesture, then a static ring) so a stationary user isn't nagged.
- **Sources:** [S1] [S3]

**T-24 — The band's arc motion is a real piece of craft — do not touch it.** **P0 (protect)**
- **Tell:** [S4] "one signature move"; [S3] "one authored moment".
- **Evidence:** `index.html:2068–2320` — `BAND_SLOT 108`, `BAND_SAG 26`, `perspective(760px) rotateX(13deg)` (215), real arc maths (`bandCurveR` 2110, `bandDrop` 2113, `bandArcDeg` 2118), per-stop SVG dials with cardinal ticks and a needle (2180–2205), opacity falloff `1 - (adx/fade)^1.6` (2148), a `band-anim` transition class with `cubic-bezier(.22,.61,.36,1)` (209–210).
- **Fix direction:** **This is the app's best-original idea and it must survive the redesign intact.** It is the opposite of an AI default: an instrument, not a container. Do not replace it with a tab bar, a chip row, a bottom sheet of buttons, or a horizontal scroller. If the redesign changes the type scale, the 10px `.cb-name` (T-04) must be fixed *without* breaking the 104px slot geometry — e.g. by widening `BAND_SLOT` proportionally, or by moving the name off the dial.
- **Sources:** [S3] [S4] [S22 DESIGN.md]

### G. Copy and microcopy

**T-25 — "—" as the universal empty-state placeholder.** **P1**
- **Tell:** [S1] `em-dash-overuse` (advisory; fired here [TOOL]); [S5] copy tells: "more than a handful of em dashes".
- **Evidence:** **thirteen** body-HTML occurrences are the bare character "—" used as a placeholder: `#albumLandmarkTitle` (1225), `#albumLandmarkMeta` (1226), `#loreStoryText` (1352), `#loreNextName` (1357), `#diplomaText` (1378), `#diplomaMeta` (1379), `#captureDistLabel` (1466), `#targetName` (1470), `#alName` (1472), `#coords` (1483), `#cardTitle` (1494), plus `b.querySelector(".cb-dist")` (2247) and the "Distanță indisponibilă" path (1802). The detector's "16 em-dashes in body text" is these plus the `alt` text (1508) and the photo credit (1533).
- **Fix direction:** A dash is an *absence marker*; a *hand-designed* app either shows a real empty state ("Nici o fotografie capturată încă. Deschide Albumul → Acum.") or shows nothing. Replace the eleven static placeholders with **written empty states in Romanian** (this is the app's biggest copy win: the album and the reward surfaces have real empty states that were never written). Keep the em-dash in the photo credit and the `alt` text, where it is a legitimate parenthetical.
- **Sources:** [S1] [S5] [S4 copy.md via S4]

**T-26 — The gamemode modal copy is marketing voice, not product voice.** **P0**
- **Tell:** [S1] `marketing-buzzword`: "Generic SaaS phrases (streamline / empower / supercharge / world-class / enterprise-grade / next-generation / cutting-edge / etc) are instant AI tells. Pick a specific verb and noun that says what the product literally does." [S1] `aphoristic-cadence`. [S5] copy tells: genre verbs/adjectives; the correction ("not just X, it's Y"); tricolon headlines; "Get started"/"Learn more" as labels. [S4] "Every headline fits in two lines or fewer… the studied gallery heroes have a median of 5 words and 32 characters." [S14]: AI-obvious copy is a "reputation killer".
- **Evidence:** `index.html:1285` — "Pășește într-o veritabilă călătorie în timp! Alege un capitol, mergi la repere și fotografiază-le în ordinea construcției lor (1865 → 1913). La fiecare oprire deblochezi file de istorie, iar la finalul fiecărui capitol primești diplome și recompense de cronicar!" — "Pășește", "veritabilă", "deblochezi", "recompense de cronicar" are **no counterpart anywhere else in the app**. The app's actual voice (start gate, 1531–1547) is quiet and specific: "O plimbă prin istoria Aradului.", "Fără cont, fără server: fotografiile rămân pe telefonul tău." The **modal contradicts the product's own voice.**
- Other instances: the bilingual parentheticals — "(Story & Lore)" (1282), "(Explorer)" (1299), "(Demo)" (1172), "(Istoric)" (1231), "(Album personal)" (1239), "(Recompense & Cronologie)" (1164) — are hedges that read as machine translation of a spec, not as a Romanian product. `mode-badge-pill` (1280, 1297) with a ⭐/★ glyph. The `.mode-card-perks` "✓" bullets (1288–1290, 1305–1307) as a tricolon.
- **Fix direction:** **Write the mode chooser in the app's own register.** E.g. *Poveste* — "Cinci repere, în ordinea în care au fost ridicate. 1865 → 1913." *Liber* — "Orice reper, în orice ordine." Then the CTA: "Alege un capitol" / "Începe cu liber". Drop "(Story & Lore)" and "(Explorer)". Drop the ✓ tricolons — the sentence above says the same thing. **The test: could this sentence be pasted into a CRM app? If yes, rewrite it.**
- **Sources:** [S1] [S4] [S5] [S14]

**T-27 — "Ai reconstituit cu succes cronologia istorică a Aradului!"** **P1**
- **Tell:** [S1] `aphoristic-cadence`; [S5] tricolons; [S8] "Perfectly Generic Copy".
- **Evidence:** `index.html:1372` — "Ai reconstituit cu succes cronologia istorică a Aradului!"; `1376` — "OMOLOGAT ARADLENS ARCHIVE"; `1377` — "Diplomă de Cronicar"; the chapter titles at 1641 ("Zorii Renașterii Civice"), 1659 ("Epoca Inovației și Artelor"), 1677 ("Marea Odisee a Aradului"); the reward titles 1649/1667/1685 ("Pionier al Aradului Modern", "Maestru al Inovației Arădene", "Cronicar de Onoare al Aradului"); the seals 1651/1669/1687 ("OMOLOGAT 1876 · ARADLENS ARCHIVE", "MARELE SIGILIU DE AUR · ARADLENS ARCHIVE").
- **Fix direction:** **"Cronicar" (chronicler) is a genuinely good, specific, Romanian invention — keep the concept and cut the adjectives.** "Diplomă de Cronicar" survives; "Maestru al Inovației Arădene" does not (it is a LinkedIn compliment). Replace the reward titles with **the actual thing earned**: "5 monumente, 1865–1913" / "Catedrala, 1865" / "Primăria, 1876" — a *record*, not a compliment. "MARELE SIGILIU DE AUR" is a fantasy coin; "OMOLOGAT · ARADLENS · 1913" is a stamp. Also the em-dash-free but exclamation-heavy endings: the app's own start copy has no exclamation marks and no emoji, and the reward surfaces have both.
- **Sources:** [S1] [S5] [S8] [S14]

**T-28 — The chapter reward snippet and the inline "Repere în ordine cronologică:" label.** **P2**
- **Tell:** [S1] `kicker-above-heading`; [S5] "agency micro-meta"; [S3] "Controls name their action."
- **Evidence:** `index.html:2028` — an inline-styled `<div>` label "Repere în ordine cronologică:" in 12px/700 accent colour, sitting above the chip list; `2026` — the chapter title carries the emoji inline: `${ch.icon} ${ch.titlu}`; `2033` — `<span class="r-icon">${ch.reward.icon}</span>`; `2036` — an inline-styled 11px opacity-0.8 status line. Three inline styles in one card.
- **Fix direction:** Delete the "Repere în ordine cronologică:" label — the list *is* the list, and the chapter already says "1865 – 1876". Replace the three inline `style="…"` attributes with named classes (they are the visual signature of generated markup, and they make the design system unenforceable).
- **Sources:** [S1] [S5]

**T-29 — "Story & Lore", "File Deblocate", "Lore" as product nouns.** **P1**
- **Tell:** [S1] `marketing-buzzword`; [S3] "Copy: the product's own language"; [S9] "if your homepage copy could belong to any startup, it will be forgotten."
- **Evidence:** "Lore" appears as a *product term* in Romanian UI at 1289 ("Istorisiri secrete (\"Lore\") deblocate"), 1351 ("Filă din Cronica Aradului" with a 📜), 3369 ("📜 Cronica Aradului - File Deblocate"), and the CSS class names `storyLoreModal`, `.lore-*`. "File" (fișă/filă) is used for both the landmark info card ("Fișă & audio", "Vezi fișa") and the story reward ("File Deblocate"), which collide.
- **Fix direction:** One Romanian word per concept, used everywhere: **fișă** (the landmark record), **filă** (a leaf of the chronicle) or better **capitol**/**pagină**, and **poveste** — never "Lore". Drop "Story & Lore", "File Deblocate", "Mod Poveste (Story & Lore)".
- **Sources:** [S1] [S3] [S9]

### H. Component-level

**T-30 — The reward/diploma card is a stock AI "certificate" template.** **P0**
- **Tell:** [S3] craft-floor: "The floor holds the mechanics; it never picks the direction." General: a double-ruled border with a centred seal, an uppercase tracked "seal" line, a centred name, a centred body, a meta line, and a steps list is the **default AI certificate**, found in every generated gamification screen.
- **Evidence:** `index.html:977–1008` — `.diploma-card { background: #fffdf7; color: #171106; border: 4px double #7a6038; border-radius: 12px; padding: 18px 16px; margin-bottom: 18px; text-align: center; box-shadow: inset 0 0 20px rgba(122,96,56,.1), 2px 8px 24px rgba(0,0,0,.6); }` with `.diploma-seal` (983, 10px/800/2px tracking, uppercase, `border-bottom`), `.diploma-name` (987, 19px serif), `.diploma-text` (991, 13px), `.diploma-meta` (994, 11px), `.diploma-steps` (997, a centred list). Plus `.reward-ribbon` (958, a 20px-radius pill with 2px tracking) above it and a 64px emoji (963) above that.
- **Fix direction:** **Make it an actual 19th-century Hungarian civic document.** The Arad landmarks *are* the reference: an 1870s Hungarian official document used a specific letterhead, a specific rule under the heading, a specific seal, and tabular entries — not a rounded card with a double border. Design it as a **document**: square corners, one hairline frame inset from the paper edge, the heading in a *condensed plate lettering* (the way Fortepan photo-plate titles are set), the year range set as a large tabular figure, the five photographed monuments listed as a ruled index with their years, and a drawn seal (a 19th-century *központi pecsét* roundel — concentric rings with a date) instead of "OMOLOGAT ARADLENS ARCHIVE". **This is the highest-value redesign surface in the app**, because it is the emotional payoff of the whole product and it is currently the most generic thing in it.
- **Sources:** [S3] [S17] [S18] [S22]

**T-31 — The album tab bar uses emoji as its only distinguishing feature.** **P1**
- **Tell:** [S5] "Emoji as icons or bullets — banned."
- **Evidence:** `index.html:1163–1164` — `<button class="album-tab-btn active" id="tabMapBtn" aria-pressed="true">📷 Repere & Hartă</button>` and `<button class="album-tab-btn" id="tabRewardsBtn" aria-pressed="false">🏆 Recompense & Cronologie (<span id="rewardsCountBadge">0</span>)</button>`. The active state is `background: rgba(200,176,136,.15); color: var(--accent-green); border-color: var(--accent-green); border-radius: 12px` (1016–1017) — a **pill-shaped tab** with a beige fill and a beige border, which is the "pill badge" tell in a tab.
- **Fix direction:** Tabs as **underlined words** (a 2px rule under the active tab, no fill, no border, no radius) — the way a printed index page marks the current section. Drop the count-in-parentheses badge style; set the count as a tabular figure in the same ink.
- **Sources:** [S4] [S5]

**T-32 — The capture modal is a centred card with a big icon.** **P1**
- **Tell:** [S1] `icon-tile-stack`; [S5] "No icon-topped feature cards"; [S4] "Centre at most one moment."
- **Evidence:** `index.html:749–760` — `#captureModal` centred with `backdrop-filter: blur(4px)` (751), containing `.cm-card` (753, 12px radius, 22px/20px padding, `text-align: center`), a 40px camera SVG icon in `--accent-green` (760–762), `.cm-title` 22px serif (763), `.cm-desc` 13px (767), and two stacked full-width buttons (1136–1140) — one of which is `display:none` until the photo exists.
- **Fix direction:** A capture confirmation is a **system message, not a celebration**. Make it a single bottom sheet (the app already has the `#card` bottom-sheet pattern at 445–467) with the captured frame shown as a small plate at the top, a single line of copy, and one action. Delete the 40px icon. The `backdrop-filter` blur is defensible (a modal genuinely floats) but it should be the *only* blurred surface in the app — currently `#captureModal` (751) and `.full-modal` (808) both blur, which is a "glass everywhere" habit [S5 wave 1].
- **Sources:** [S1] [S3] [S4] [S5]

**T-33 — The desktop placeholder is a generic centred "sorry" page.** **P2**
- **Tell:** [S5] wave 3 "performative labels"; [S4] "Everything centred".
- **Evidence:** `index.html:1073–1079` and 770–787 — a centred `h1` "Experiență AR", two centred paragraphs, one centred button "Continuă în mod previzualizare (Desktop)".
- **Fix direction:** Keep the function (it is a real device gate and it protects the sensor UX), but give it the app's voice and the 1901 plate: the archive photograph at a third of the width, the explanation set as a left-aligned note in the *body* face, and the preview button as a plain text action with a rule above it. This page is seen by every desktop reviewer, so it is a cheap place to make an impression.
- **Sources:** [S4] [S5]

**T-34 — The story objective banner and the top-row badges are pills floating over the lens.** **P1**
- **Tell:** [S5] wave 2: "Pill badge above the hero headline"; "Floating rounded pill navigation with blur" (warned). [S3] "A colored border-left or border-right above 1px" (not applicable) but the spirit — a filled pill on a live image is the "AI HUD" cliché.
- **Evidence:** `index.html:792–799` — `.story-objective-banner { background: rgba(5,7,10,.85); border: 1.5px solid var(--amber); border-radius: 10px; padding: 6px 12px; … box-shadow: 2px 6px 18px rgba(0,0,0,.5); }`, centred with `margin-left:auto; margin-right:auto` (797), and it contains a 15px ⏳ emoji (800, 1411). `.mode-badge-pill` (845) is an 8px-radius uppercase 11px pill. `.cs-badge` (702) is a 12px-radius uppercase 12px pill with an amber border.
- **Fix direction:** Over live camera footage, a **filled pill with a coloured border is the loudest possible thing on screen.** The HUD's own grammar (DESIGN.md: "Bone glyphs are the only interface color; beige means live/arrival") says a beige *border* is decoration. The objective should be **plain bone type on the scrim, with the current landmark's name in the display face** — no box, no border, no emoji. Same for the capture badge: the word "Mod Fotografiere" in bone caps on the scrim.
- **Sources:** [S1] [S3] [S5]

### I. Structural and meta

**T-35 — DESIGN.md documents the generated output instead of constraining it.** **P0**
- **Tell:** [S3] "Visual authority is evidence, not a filename"; [S4] "Each section has a different composition from its neighbours; none is a card grid"; [S1] `design-system-*` rules.
- **Evidence:** `DESIGN.md` declares `icon-hero: "Apple Color Emoji", "Segoe UI Emoji"` (lines 87–98) — the emoji system ratified. It declares an 11-rung size ramp (25–86) that the detector calls flat. It declares `rounded: { ring: 50%, caption: 12px, focus: 6px, snap: 6px, chip: 8px, control: 10px, panel: 14px, sheet: 16px, pill: 20px }` (99–108) — **nine radius values**, i.e. no radius decision. And the colour block (4–24) documents a monochrome bone/amber world with no second hue.
- **Fix direction:** **Rewrite DESIGN.md as a constraint, not as a description.** It should state the *rules* the design must obey (one ground, one ink, one signal, one accent; square corners; hairline rules; a 5-step type ramp; no emoji; no icon tiles; no nested cards; the mode chooser is a ruled list) and only then list the tokens. [S3]'s own framing: "the brief wins… Refinement preserves; redesign replaces… Never split the difference between polish on the discarded look."
- **Sources:** [S1] [S3] [S4]

**T-36 — The previous pass was itself an anti-AI pass, and it landed in the third wave.** **P0 — read this before designing**
- **Tell:** [S5] wave 3 is titled "**the 'fix' that became the look**": "The remedy published for the first two waves was 'warm it up and make it editorial'. Models adopted the remedy wholesale and it is now the most recognisable generated look of all."
- **Evidence — the working tree contains an uncommitted previous pass** (`git status`: `M index.html`, `M DESIGN.md`, `M PRODUCT.md`, `M docs/codebase.md`, `M fonts/OFL.txt`, `D fonts/oswald-*.woff2`, `?? fonts/fraunces-*.woff2`; `git diff --stat`: index.html +386/−… lines, DESIGN.md 250 lines changed). That pass: replaced the display face **Oswald** (a condensed grotesque) with **Fraunces**; changed the accent from a saturated **`#e8a33d`** to a muted **`#c8b088`**; changed `--amber-deep` from `#8a5f14` to `#7a6038`; rebuilt the type ramp from 30/24/… to 26/22/20/19/…/10; and re-ordered the gamemode modal so that **Modul Liber** is the featured/recommended card (1296–1297) and Modul Poveste is "Opțional" (1280).
- **What this means:** the *previous* anti-AI pass moved the app **out of the second wave (saturated amber + condensed grotesque + pill badges) and into the third wave (muted sand + wonky serif + editorial copy)**. Both are on the tell lists. The redesign must not do the same move again. It should aim at the **fourth wave**: a palette and a type system that are *derived from Arad's own materials*, not from the current fashion cycle.
- **Also note:** the previous pass's font swap **broke** something. The old `fonts/OFL.txt` said "Copyright 2016 The Oswald Project Authors"; the new one says "Copyright 2018 The Fraunces Project Authors" — but the `http://` vs `https://` URL was also downgraded (a licence-text change nobody needed). And `docs/codebase.md` is now stale (it still says 3634 lines and still describes the old gamemode ordering and the old fonts).
- **Fix direction:** (1) Do not repeat the warm-editorial move. (2) Before choosing a new display face, ask "which of these is on the 2026 convergence list?" — Fraunces, Inter, Roboto, Geist, Plus Jakarta Sans and Space Grotesk are all *named* on it [S1]. (3) Derive the palette from the subject, not from the trend. (4) Update `docs/codebase.md` and `DESIGN.md` in the same commit as any visual change.
- **Sources:** [S1] [S5] [S8] [S11] [S13] + local git evidence

**T-37 — `<img>` without a `src` ships a broken-image box.** **P2**
- **Tell:** [S1] `broken-image` (severity `error`, and one of the 12 "immediate tier" rules the Impeccable hook fixes at edit time).
- **Evidence:** `index.html:1508` — `<img class="cmp-old" id="cmpOld" alt="Fotografie istorică — Primăria Arad, 1901">` has no `src`; the source is injected by JS at compare time. Detector: `[broken-image] <img> with no src attribute` [TOOL].
- **Fix direction:** Set the `src` in the markup to the known historic asset and swap it in JS, or create the `<img>` only when a photo exists. Trivial, but it is the one **error-severity** finding in the app and it will be the first thing a checker agent reports.
- **Sources:** [S1]

**T-38 — A stray last word under the start-gate paragraph.** **P2**
- **Tell:** [S1] `straggler` (advisory): "The last line of this paragraph holds one word, which leaves a hole under the block."
- **Evidence:** the browser scan: `[straggler] "locația." alone on the last of 2 lines (14% of the measure)` [TOOL] — the `.start-detail` paragraph (1532).
- **Fix direction:** `text-wrap: pretty` is already set on `.start-promise` (367) and `.start-detail` (371)? — check that the class carries it; otherwise bind the last two words with a non-breaking space, or re-cut the sentence. [S3] "Set `text-wrap: pretty` on body copy."
- **Sources:** [S1] [S3]

---

## 8. What to KEEP — the hand-designed parts that must not be lost

This is the most important section for the redesign agent. A de-slopping pass that strips the good
parts produces the "avoidance aesthetic" that Taste Skill warns about at the end of its tells
registry: "A page with every tell removed and nothing put in their place is an empty page with good
manners, and that is a tell too." [S5 §8]

**K-01 — The compass band (`#snapRail`, CSS 209–271, JS 2068–2320).** A real instrument with real
arc maths (`BAND_SLOT 108` at 2072, `BAND_SAG 26` at 2073, `bandCurveR` 2110, `bandDrop` 2113,
`bandArcDeg` 2118), a per-stop SVG dial with cardinal ticks, a needle and a padlock (2180–2205), an
opacity falloff, and a story-aware lock/complete state machine. **It is the one component in the app
that a generic generator would never produce.** Do not replace it with a tab bar, a chip row or a
horizontal scroller. (T-24)

**K-02 — The full-bleed, unfiltered camera with two scrims.** `index.html:106–113` — `#cam` is
`opacity: 1; filter: none; object-fit: cover`. DESIGN.md: "Camera full-bleed, no blur, no dimming —
only thin top/bottom scrims." This is a *field* decision made for a real use scene (a phone in
sunlight), and [S3] explicitly says "Light or dark picked by category" is a tell — the dark HUD is
picked by the **use scene**: who, where, under what ambient light. Keep it. This is also the app's
biggest divergence from every AI-AR-app reference, which blurs the camera feed.

**K-03 — The "One Beige Rule" and the "bone = only interface colour" rule.** The discipline that
the beige is *reserved* for live direction and arrival is a real design rule, not a default. Even
though the *beige* must go (T-07), the **rule** — one signal colour, used only for live/arrival —
should survive the palette change. That is the difference between a palette and a system.

**K-04 — "The Tabular Meters Rule."** `font-variant-numeric: tabular-nums` on every distance, count
and meta numeral (a `.tnum` utility at 102 plus explicit declarations on 306, 321–324, 351, 365,
371, 462, 499, 512, 574, 588, 637, 646, 665, 673, 676, 703, 711, 758, 769, 795, 826, 887, 931,
994, 1020). A meter that shifts width while you are walking is a defect. **Keep it and extend it** to
any new readout. [S4] "Use numeric, tabular, code, and label features when their content benefits."

**K-05 — The Offset-Blur Rule.** Shadows are always offset down-right (2px 6–8px) at 12–22px blur,
never centred, never coloured. It is stated in DESIGN.md and *mostly* honoured in the CSS. Keep the
rule; the two violations are T-09.

**K-06 — The start gate's no-scroll contract and its landscape two-column mode.** `index.html:337–427`
— `.start-inner` is a `100dvh` flex column with `margin-top: auto` on both the head and the foot, so
the copy floats in the middle and the CTA pins to thumb height; at `orientation: landscape and
max-height: 560px` it becomes a 2-column grid (415). It is documented to fit exactly at 320×568,
360×740, 390×844, 412×915 and 1440×900. **This is painstaking, human work.** Keep the contract;
change only the type, colour and copy.

**K-07 — The photo credit and the public-domain provenance.** `index.html:1533` — "Fotografie de
fundal: Primăria Arad, 1901 — Fortepan / Schoch Frigyes (domeniu public)"; and 1597 for the
in-card credit. The Fortepan/Schoch Frigyes plate is a real, citable, public-domain artefact and
the app's *entire* photographic ground truth. Taste Skill bans photo-credit captions [S5], but that
is a house-style rule about decorative stock captions, not about legal attribution. **Keep it, keep
it legible, and make it typographically deliberate** (it currently sits at 12px/.68 opacity).

**K-08 — The schematic-map disclaimer.** `index.html:1172` ("Hartă schematică temporară (Demo)") and
1220 ("Pozițiile de pe această hartă sunt demonstrative și orientative (fără proiecție GPS reală)").
Telling the truth about a demo is a human choice. **Keep it visible; do not hide it behind a
"(Demo)" parenthetical in a badge.** (This is a case where the *label* is right and the *pill* is
wrong.)

**K-09 — The Romanian voice of the start gate and the sensor row.** `index.html:1530` — "O plimbă
prin istoria Aradului."; 1531 — "AradLens îți arată ce era aici înainte: cinci obiective istorice
din centrul Aradului, de la 1865 la 1913."; 1543 — "Prima apăsare cere permisiunea de mișcare
(busola), apoi camera și locația."; 1545 — "Fără cont, fără server: fotografiile rămân pe
telefonul tău."; 1537–1541 — the sensor row with a drawn SVG icon per sensor and a `·` separator.
**This is the app's true voice.** It is quiet, specific, second-person, and it explains itself
without adjectives. Every modal should be rewritten into *this* register (T-26).

**K-10 — The real content.** The five landmarks with their architects and styles (1559–1630), the
three chapters with their year ranges and landmark order (1636–1690), the per-landmark `loreStory`
and `loreSnippet` prose (1570, 1583, 1598, 1611, 1624), the "Atunci / Acum" comparison mechanic
(469–505), the proximity-gated capture, the 50 m rule, the schematic river and the Bulevardul
Revoluției axis in the map (1184–1190). **The content is specific, dated, sourced and Romanian.**
The redesign must not replace content with placeholders. [S4]: "Write the full content… Thin
sections are the commonest reason a clean page loses to a busier one." [S7] Level 3 is "design it
for real" with the real content.

**K-11 — The archive photographs as the only imagery.** One real 1901 Fortepan plate used full-bleed
at the start gate, cropped into the compare view. [S4]'s imagery floor demands *at least four* real
pictures on a page; this app has one asset, which is why the 2026 redesign should **source more
open-archive material** — Wikimedia Commons, Europeana, the Arad city library, the Biblioteca
Digitală, and the Fortepan collection itself, all of which hold 1860s–1910s Arad plates
(Photoplan, Adalbert Baumann, Franz Mayer, the 1901 "Arad in 60 pictures" series). [S4] step 6:
"real pictures of the subject's world from the open collections, whenever an honest one exists…
Search them with `assets.mjs` (Openverse, Wikimedia Commons, the Art Institute of Chicago and the
Met)". This is a **content** fix, not a style fix, and it is the single best way to make the app stop
looking generated: real archives of this exact city.

**K-12 — The hand-drawn SVG icon language.** The rail icons (1436–1474) are 24×24, `stroke-width: 2`,
`stroke-linecap: round`, `stroke-linejoin: round`, in bone. The compass dial (2180–2205) is
authored. The start gate's three sensor glyphs (1538–1540) are authored. **There is already a
house icon style. The emoji are the intruder, not the icons.**

**K-13 — `prefers-reduced-motion` handled properly.** `index.html:1060–1069` — a full block that
neutralises animation and transitions and drops the capture flash. Better than most shipped
products. Keep, and extend to any new motion.

**K-14 — The accessibility floor.** 44px minimum hit targets (`.btn` 441, `.album-tab-btn` 1013,
`.modal-close-btn` 830, `.pt-close` 576, `.cs-cancel-btn` 737), `aria-label`/`aria-pressed`/
`aria-current`/`aria-live` on the rail, tabs, band stops and readouts, `role="alert"` on the
toasts, `:focus-visible` rings (88), `::selection` in the signal colour (85), and `text-wrap:
balance` on headings (363, 595, 644, 710, 764, 778, 1037). **Do not regress any of this.**

**K-15 — The story-mode design idea itself.** Chapter = a chronological constraint; each chapter is
a *subset* of the 5 landmarks; captures must happen in construction order; the reward is a
diploma. This is a **good game design** and a genuinely local idea (a "cronica"/"cronicar" frame
for a city whose monuments were built between 1865 and 1913). It is the app's spine. [S4] step 4:
"On this page, [something that belongs to the subject] becomes [the device the direction calls
for]." For AradLens: *the 1865→1913 construction chronology becomes the stop selector* — and it
already is, in the band.

---

## 9. Prioritised fix list

### P0 — do these first; they are the difference between "designed" and "generated"

| # | Fix | Tells closed | Why P0 |
|---|---|---|---|
| P0-1 | **Replace the display face** (not the serif — the face) and **self-host a body face** | T-01, T-02 | The only tells that survive on every screen of the app. Fraunces and Roboto are both *named* on the convergence list. |
| P0-2 | **Delete every emoji-as-icon**; draw the missing glyphs in the existing 24-grid stroke language; rewrite DESIGN.md's `icon-*` tokens | T-20, T-21, T-31 | The most visible single tell; the design system currently ratifies it. |
| P0-3 | **Rebuild the gamemode modal as a ruled list, not two icon cards** | T-15, T-26, T-17 | The app's most-seen decision surface is the textbook AI template. |
| P0-4 | **Move the light theme off cream/beige**; introduce a real second hue from the Secession palette (turquoise `#1F6F65` is already in the file) and keep beige only as the live-direction *signal* | T-07, T-08 | Two registered slop rules at once, on the app's two themes. |
| P0-5 | **Pick one radius language — square (0–2px) for plates/cards/buttons/badges, full round only for the 52px rail rings and the shutter** | T-11, T-13 | "The 9–16px soft radius is the weak-site default" (52% of top sites are square). |
| P0-6 | **Flatten the nesting**: remove the border+shadow pairing, drop one level of card in the album, and un-card the modal contents | T-12, T-14 | "Nested cards are always wrong" [S3]. |
| P0-7 | **Rebuild the type ramp to 5–6 real steps**; raise the hero; push meta down; re-derive tracking for the new face | T-03, T-05, T-06 | The flat ramp + the 1.73 headline-to-body ratio are measurable. |
| P0-8 | **Rewrite the reward/diploma as an actual 19th-century Hungarian civic document** (square corners, one hairline frame, plate lettering, tabular year, a drawn roundel seal) | T-30, T-27 | The emotional payoff is currently the most generic surface in the app. |
| P0-9 | **Rewrite DESIGN.md as a constraint set**, not a description of the current output | T-35 | Without this, every fix drifts back. |
| P0-10 | **Do not repeat the previous pass's move.** The last pass went Oswald+saturated-amber → Fraunces+muted-sand. That is wave 2 → wave 3. Go to wave 4: a palette and type derived from Arad's own materials. | T-36 | The single biggest strategic risk in the task. |

### P1 — the second pass

| # | Fix | Tells |
|---|---|---|
| P1-1 | Fix the compass band typography: 10px → 11–12px minimum, and **widen the slot or move the landmark name off the dial** so "Teatrul I. Slavici" is not truncated to an ellipsis | T-04 |
| P1-2 | Replace the 13 "—" placeholders with **written Romanian empty states** | T-25 |
| P1-3 | Rewrite the gamemode/chapter/reward copy in the app's own register; drop the bilingual parentheticals, the "Lore" vocabulary and the ✓ tricolons | T-26, T-27, T-29 |
| P1-4 | Delete the two chromatic glows (268, 1048) and the bounce easing (965) | T-09, T-22 |
| P1-5 | Un-centre the modals; left-align with a ragged right; keep centring only for the diploma | T-17 |
| P1-6 | Introduce two gaps (6/10 intra-group, 28–40 inter-group) and kill the 12/14/16 band | T-16 |
| P1-7 | Replace the album's Then/Now card grid with the **compare wipe the app already has** in `#photoCmp` | T-18 |
| P1-8 | Strip the pill/badge layer over the lens: the objective banner, the capture badge, the album tabs | T-34, T-31 |
| P1-9 | Rebuild the capture modal as a bottom sheet with a real empty state; keep exactly one blurred surface in the app | T-32 |
| P1-10 | Replace the generic centred desktop gate with the archive voice | T-33 |
| P1-11 | Source **at least four more real open-archive Arad images** (1860s–1910s) and use them: the start gate, the compare view, the album plates, the diploma | K-11 |
| P1-12 | Fix the three inline `style="…"` attributes in the chapter card | T-28 |

### P2 — while you are in there

| # | Fix | Tells |
|---|---|---|
| P2-1 | Give `<img id="cmpOld">` a `src` (the only **error-severity** detector hit) | T-37 |
| P2-2 | Document or replace the undocumented teal `rgba(47,158,140,.8)` at 278 | T-10 |
| P2-3 | Fix the straggler in the start paragraph | T-38 |
| P2-4 | Update `docs/codebase.md` (it still says 3634 lines and describes the old gamemode ordering, the old fonts and the old palette) | hygiene |
| P2-5 | Fix the `fonts/OFL.txt` URL downgrade (`http://` → `https://`) | hygiene |
| P2-6 | Keep the map's drafting grid, but give it a token and a 25-unit cell | T-19 |
| P2-7 | Make the capture-ready pulse a finite gesture rather than infinite | T-23 |

---

## 10. The voice — what a hand-designed, historically-grounded AradLens feels like

**This is the brief for the ten concepts.** Not a style, a *posture*.

### 10.1 The governing idea

**The 1901 city plate, in your hand, in the street it describes.** The Fortepan/Schoch Frigyes plate
of Primăria Arad is a *survey document*: a photograph, a ruled frame, a title in plate lettering, a
date, a scale, a credit. AradLens should feel like that object — a **survey instrument for a city
that is still standing** — not like a game and not like a travel app.

The one-sentence idea, in Taste Skill's own format [S4 step 4]:
> On this page, **the 1865→1913 construction chronology of Arad** becomes **the stop selector**.

The live thing (the one thing that is different each visit and that a visitor names first) [S4]:
> **the band** — you drag a curved dial of 1896 plate-dials through your own street and the city
> answers with its own dates.

### 10.2 Typography

- **A serif with 19th-century print manners, but not a "wonky" editorial serif.** The reference is a
  Hungarian/Austrian official printer's face of the 1870s–1890s: a transitional or old-style serif
  with modest contrast, short extenders, and a calm, slightly narrow colour. The named candidates
  are **Spectral** (Production Type, screen-first, 7 weights + small caps [S19]), **EB Garamond**
  (OFL [S20]), **Cormorant**, **Alegreya**, **Source Serif 4**, **Literata**, **Besley**. **Avoid:
  Fraunces, Inter, Roboto, Geist, Plus Jakarta Sans, Space Grotesk** — the first is on the
  Impeccable convergence list [S1] and the rest are the same class of problem.
- **For the display register, a condensed or slightly compressed grotesque, not another serif.** The
  1870s Hungarian civic plate and the Ödön Lechner *Magyar stílus* lettering are **flat, wide-set,
  all-caps with generous tracking** — think engraved shopfront and official notice lettering, not
  book typography. A face in the register of **Archivo / Archivo Narrow**, **Antonio**, **Oswald**,
  **Big Shoulders** or a small-caps cut of the serif itself would be right; it should be used for
  **wordmarks, section labels and the diploma seal**, and nothing else. This also gives the app a
  *pair* — a book serif for the archive, a civic grotesque for the labels — which reads as a
  decision, not a default. (The previous pass used Oswald for exactly this job and then threw it
  away; bringing back a *narrow civic grotesque* is a reversal, not a regression, **provided the
  serif changes too**.)
- **Numerals:** the band distances, the years, and the diploma index should be **tabular and
  unlined-up against a rule**, the way a survey table is set. `font-variant-numeric: tabular-nums`
  stays (K-04); add `font-feature-settings` for oldstyle figures on the prose serif if the chosen
  face supports them.
- **One body face, self-hosted, woff2, latin + latin-ext** (for ș/ț), for the interface — a
  humanist sans with civic/documentary manners, *not* a product sans. **Archivo** (or its
  sibling **Roboto Flex**? no — not Roboto), **Public Sans**, **Source Sans 3**, **IBM Plex Sans**,
  **Asap** are plausible; the deciding criterion is that it should look at home in a museum caption
  and in a tram timetable.
- **Sizes:** 5–6 steps with real gaps (P0-7). **Body never below 15px; meta never below 12px;
  nothing functional below 11px** [S1 `undersized-ui-text`].
- **Tracking:** near-neutral on the serif (−0.005em), **wide and deliberate on the caps labels**
  (0.12–0.2em) — because in this world the tracked caps are *engraved letters*, not UI chips. The
  difference is that they are **sentence-case content labels with meaning** (an architect's name, a
  year, a building style), not "NEW" or "BETA" chips.

### 10.3 Texture and material

- **Paper, not screen.** The light theme should feel like a **plate on a drafting table**: a warm
  off-white with a *cooler* cast (so it is not the "cream/beige" reflex [S1]), plus a *faint*
  fibre or plate-grain — the Impeccable `buried-raster` rule warns against a texture that never
  reaches the screen, so any texture must be visible, not implied [S1]. A 3–5% monochrome noise
  tile or a very low-contrast plate-edge is enough.
- **The 1901 plate itself is the hero material.** Crop the Fortepan photograph with its *original
  plate border and its paper tone* rather than bleeding it to the edge. The app currently does the
  opposite (`.start-photo` is `position: fixed; inset: 0; object-fit: cover` at 342–343) and covers
  the very thing that makes it authentic.
- **Real archival material over generated material.** Open-archive Arad photographs, the
  *Magyarische Ornamentik* plate vocabulary (Huszka, 1898) rendered as a **drawn** ornament
  (Zsolnay-tile geometry, stylized flower and beehive roundels [S17][S18]), a drawn
  *központi pecsét* roundel for the seal, and — where ornament is used at all — **one ornament per
  surface, at the edge, never behind text**.
- **Ink, not glow.** Neutral elevation only; no chromatic halos; no glass. Hairline rules at
  0.5–0.75px in the ink colour carry the structure — as they do in a printed plate.

### 10.4 Restraint

- **One signal colour** (live direction + arrival) and **one accent** (the action) and **one ink**,
  and **nothing else** [S4]. The signal is currently beige; it could be a **oxidised-copper
  turquoise** (already in the file as `--deep-teal #14655a`, and it is the actual colour of the
  Secession ceramic roofs [S17]) — a colour that belongs to Arad's buildings and that no AI
  palette has.
- **No gradients, no glass, no glow, no rounded blobs, no aurora, no bento tiles** — the app has
  almost none of these already, and that is a strength to protect.
- **No cards where a rule will do.** A plate is a *frame + rules + type*, not a rounded rectangle.
- **No badge layer.** Every label is either part of a sentence, a rule, or a table cell.
- **One authored motion, total.** The band's arc, and the diploma arriving. Nothing else moves
  except the values.

### 10.5 Asymmetry and editorial layout

- **Left-anchored, ragged right, one centred moment** (the diploma) [S4].
- **The band's asymmetry is already built** — the reticle sits at 50% of a tape that curves away on
  both sides, and the "current" stop is the only lit thing. Keep that; do not symmetrise it.
- **The HUD should read as a caption laid on the street**: a left-anchored block at the bottom with
  a hairline rule above it, the landmark name large, the distance in tabular figures on the rule's
  right — a *plate caption*, not a stack of chips.
- **The album should read as a bound plate book**: a ruled index, a plate, a caption, a colophon
  — not a scrolling grid of surfaces.
- **The mode chooser should read as a table of contents**: two ruled entries, the chapter list as
  a chronological index with right-aligned years. The 1865 → 1874 → 1876 → 1896 → 1913 sequence
  should be *visible as a line*, because it is the app's idea.

### 10.6 Bilingual accents

- **Romanian is the product language; Latin and German are the historical voices.** A landmark
  built by a Hungarian architect, in a Romanian city, in the Austro-Hungarian monarchy, is
  **legitimately multilingual** — and that is an opportunity, not a hedge.
- **Use the original names in the original orthography, with a Romanian gloss**, the way a museum
  caption does: *"Ödön Lechner (arhitect)"*, *"Anton Czigler"*, *"Miklós Ybl"* — the app already
  has the right names in `REPERE` (1576, 1602, 1617, 1630) but never gives them a typographic
  treatment.
- **One deliberate foreign word, used as a title:** the chronicle's own frame — *"Cronica"*, the
  Romanian word for a chronicle, is the app's best single word. Keep it and let it be the only
  "branded" noun. **Remove "Lore" entirely** (T-29).
- **Drop the parenthetical English** — "(Story & Lore)", "(Explorer)", "(Demo)", "(Istoric)",
  "(Album personal)", "(Recompense & Cronologie)" (T-26). The historical Latin/German/Hungarian is
  *meaningful*; the SaaS English is *noise*.
- **The years are the typography.** 1865, 1874, 1876, 1896, 1913 should be the largest numerals in
  the app after the distance readout, set in the display face, in a column. A 50-year span is the
  story.

### 10.7 What this voice is NOT

- Not "startup purple gradient". Not "aurora". Not "glassmorphism". Not "dark mode with a neon
  accent and a glow" [S5 wave 2].
- Not "warm cream + terracotta" [S5 wave 3] — the previous pass's destination.
- Not "monochrome sans + rounded cards" — the generic AI baseline.
- Not "editorial serif as a premium shortcut" [S5 wave 3].
- Not a game UI: no "★ CAPITOL FINALIZAT", no confetti, no trophy, no medal emoji, no
  "Recompensă deblocată!" exclamation.
- Not a US travel app: no "Explore", no "Uncover", no "Your journey", no "Start your adventure",
  no "Trusted by 10,000+ travellers", no 3-illustration feature grid.

---

## 11. Skills and commands inventory

### 11.1 Operational finding first — most of these commands cannot run

`.opencode/commands/*.md` are **thin wrappers**: each file is a 4-line front-matter stub whose body
is `Load the skill "<name>" with the skill tool and follow its instructions.` The *actual* skills
live in `.agents/skills/` — which is **gitignored (`.gitignore` line 3) and absent from this
checkout** (`Test-Path .agents` → False). The only skill installed on this machine is
`~/.config/opencode/skills/impeccable/`, plus `~/.config/opencode/commands/` stubs for
`grill-me`, `impeccable` and `web-design-guidelines`, and the `i-have-adhd` plugin.

**Consequence: 51 of the 54 commands will fail to load** ("skill not found"). Only three will
resolve: **`impeccable`**, **`web-design-guidelines`**, **`grill-me`**.

**Therefore:** the useful content of the uninstalled skills must be fetched from their upstream
repos and inlined, not "loaded". The three that matter most are already fetched in this report:
Taste Skill v2 `SKILL.md` [S4], its `references/tells.md` [S5], and the Impeccable registry [S1].

### 11.2 The table

Relevance is to **the next three tasks**: (1) write an HTML design-concept page, (2) redesign
`index.html`'s visual layer, (3) iterate with a checker agent.

| # | Command / skill | What it does | Relevance | One-line reason |
|---|---|---|---|---|
| 1 | **impeccable** | Design language + 61-rule deterministic detector + craft-floor; `detect --json` scans files and live URLs | **HIGH** | The only *installed* design skill; its CLI is the only automated checker available, and it already found 4 real defects here. |
| 2 | **web-design-guidelines** | Reviews UI code against Web Interface Guidelines (a11y, focus, forms, motion) | **HIGH** | Installed; it is the checker's second instrument and covers the a11y surface a detector cannot see. |
| 3 | **design-taste-frontend** (tasteskill v2) | Anti-slop house rules + the 247-site study + `draw.mjs` direction dealer + `inspect.mjs`/`lint.mjs` | **HIGH** | The single most on-topic skill: it *is* the anti-slop rulebook this report is built on. Must be fetched from upstream (not installed). |
| 4 | **redesign-existing-projects** | Audit-first redesign protocol for an existing app: record the before, keep the stack and content, change type → colour → frame → states → stock components | **HIGH** | The task is literally "redesign an existing static app"; this is its playbook. Same install caveat. |
| 5 | **research** | Investigate against high-trust primary sources and capture findings as a Markdown file in the repo | **MEDIUM** | The method that produced this report; the next agent inherits its output instead of re-running it. |
| 6 | **minimalist-ui** | Editorial product UI: warm monochrome, typographic contrast, flat bento grids, muted pastels, no gradients, no heavy shadows | **MEDIUM** | Closest existing style skill to an archival/editorial register — but its "warm monochrome" is the cream tell, so use it as a counter-example. |
| 7 | **industrial-brutalist-ui** | Swiss typographic print + military terminal: rigid grids, extreme type-scale contrast, utilitarian colour, analog degradation | **MEDIUM** | The mechanical/archival cousin of the target voice; useful as a *directional reference* for the concept page, wrong as a destination. |
| 8 | **imagegen-frontend-mobile** | Generates premium mobile screen concepts and flows as images | **MEDIUM** | Can produce reference boards for the 10 concepts before any code is written. |
| 9 | **imagegen-frontend-web** | Generates horizontal per-section design references with strong art direction | **MEDIUM** | Same use; the "one image per section" rule maps onto the concept page. |
| 10 | **image-to-code** | Generates design references first, analyses them, then implements the frontend to match | **MEDIUM** | A good fit for the concept-page → implementation handoff. |
| 11 | **full-output-enforcement** | Enforces complete code generation; bans placeholder patterns; handles token-limit splits | **MEDIUM** | Directly protects the concept page against "TODO / lorem / …" placeholders, which are themselves a tell [S5 copy tells]. |
| 12 | **prototype** | Throwaway prototype to answer a design question; explore what a UI should look like | **MEDIUM** | The concept page *is* a prototype; this skill names the discipline (one question, throwaway). |
| 13 | **high-end-visual-design** ("soft-skill") | Calm, expensive-looking UI: softer contrast, generous whitespace, premium fonts, spring motion | **LOW** | It *is* the third-wave "premium" look the app already fell into; use it as an anti-reference, not a guide. |
| 14 | **gpt-taste** | Stricter variant: Python-driven layout variance, strict AIDA page structure, wide editorial type, gapless bento grids, GSAP scroll | **LOW** | AIDA and bento grids are US-marketing shapes; wrong for a field AR app and wrong for the voice. |
| 15 | **stitch-design-taste** | Generates agent-friendly DESIGN.md files for Google Stitch | **LOW** | The repo already has a DESIGN.md and no Stitch dependency; the useful part (DESIGN.md as a contract) is covered by T-35. |
| 16 | **brandkit** | Brand-guidelines boards, logo systems, identity decks | **LOW** | There is no brand kit to produce; the app has a wordmark, not an identity system. |
| 17 | **grill-me** | Relentless interview to sharpen a plan or design | **LOW** | Useful only if a design decision is genuinely ambiguous and blocking; three near-duplicates exist (18, 19). |
| 18 | **grilling** | Same as grill-me, described as "grill the user relentlessly about a plan, decision, or idea" | **LOW** | Duplicate of 17. |
| 19 | **grill-with-docs** | grill-me + produces ADRs and a glossary as it goes | **LOW** | Duplicate of 17 plus documentation output; `domain-modeling` (24) covers the doc part. |
| 20 | **ask-matt** | Router: "which skill or flow fits your situation" | **LOW** | Useless while 51 of the skills it routes to cannot load. |
| 21 | **wayfinder** | Plans a huge multi-session chunk of work as decision tickets; resolves them one at a time | **LOW** | The redesign is one session; the ticket machinery is overhead. |
| 22 | **chief-of-staff** | Pursues a long-running goal in a single session by co-ordinating subagents | **LOW** | This task *is* already a subagent; duplicating the pattern adds nothing. |
| 23 | **claude-handoff** | Hands the conversation to a fresh background agent | **LOW** | Redundant with 24. |
| 24 | **handoff** | Compacts the conversation into a handoff document for another agent | **LOW** | Relevant only at the end of the multi-task sequence; redundant with 23. |
| 25 | **wait-what** | "Stop. That last message did not land: re-pitch it." | **LOW** | A re-pitch tool; not a design instrument. |
| 26 | **writing-for-agents** | Writing documents for agents; creating/editing skills, AGENTS.md, CLAUDE.md | **LOW** | Only if AGENTS.md is updated to point at the new design rules. |
| 27 | **writing-beats** | Assemble raw material into a journey of beats | **LOW** | A narrative-writing skill; not a UI skill. |
| 28 | **writing-shape** | Shape raw material into an article, paragraph by paragraph | **LOW** | Same family. |
| 29 | **writing-fragments** | Mine raw fragments, no structure yet | **LOW** | Same family; could in principle be used to draft the Romanian microcopy, but the app's voice is already known from the start gate (K-09). |
| 30 | **to-spec** | Turn the conversation into a spec and publish it to the issue tracker | **LOW** | No issue tracker is configured in this repo. |
| 31 | **to-tickets** | Break a plan into tracer-bullet tickets with blocking edges | **LOW** | Same — no tracker. |
| 32 | **implement** | Implement a piece of work from a spec or tickets | **LOW** | Without a tracker there is nothing to implement from. |
| 33 | **implement-spec** | Implement the result of /to-spec and /to-tickets | **LOW** | Same. |
| 34 | **to-questionnaire** | Turn an unanswerable decision into a questionnaire | **LOW** | Nothing in the redesign is blocked on an external answer. |
| 35 | **triage** | Move issues/PRs through a triage state machine | **LOW** | No tracker, no PR queue. |
| 36 | **pr** | Write a PR body | **LOW** | A PR body may be needed at the end, but the content is one paragraph. |
| 37 | **code-review** | Review changes since a fixed point along Standards and Spec axes | **LOW–MEDIUM** | Genuinely useful *once* the redesign lands, to check the diff against the repo's documented rules; not a design tool. |
| 38 | **codebase-design** | Vocabulary for deep modules; module interfaces and seams | **LOW** | The app is one file; there is no module boundary to design. |
| 39 | **improve-codebase-architecture** | Scan for deepening opportunities, present as an HTML report, then grill | **LOW** | Same; and it would fight the "do not split index.html" rule. |
| 40 | **domain-modeling** | Build a glossary / record ADRs | **LOW** | The domain terms *do* need fixing (T-29: "Lore", "fișă", "filă") — but that is a copy edit inside the design task, not a separate skill. |
| 41 | **diagnosing-bugs** | Diagnosis loop for hard bugs and perf regressions | **LOW** | Useful only if a redesign regresses the sensor flow. |
| 42 | **tdd** | Test-driven development | **LOW** | There is no test harness in this repo and no build step. |
| 43 | **retro** | Retrospective on a coding session | **LOW** | Not design work. |
| 44 | **teach** | Teach a new skill or concept in the workspace | **LOW** | Not needed. |
| 45 | **loop-me** | Grill about specs for workflows in this workspace | **LOW** | Duplicate of the grill family (17–19). |
| 46 | **setup-matt-pocock-skills** | Configure issue tracker, triage labels, domain doc layout | **LOW** | Infra for the skills that will not load. |
| 47 | **setup-pre-commit** | Husky + lint-staged + typecheck + tests | **LOW** | No package.json, no lint, no tests. |
| 48 | **setup-ts-deep-modules** | Wire dependency-cruiser into a TS repo | **LOW** | The repo has no TypeScript. |
| 49 | **migrate-to-shoehorn** | Migrate `as` assertions to `@total-typescript/shoehorn` | **LOW** | No TypeScript. |
| 50 | **scaffold-exercises** | Create course-exercise directory structures | **LOW** | Unrelated. |
| 51 | **wizard** | Generate an interactive bash wizard for human-only steps | **LOW** | Unrelated. |
| 52 | **git-guardrails-claude-code** | Claude Code hooks blocking dangerous git commands | **LOW** | The agent already has the repo's deploy/guardrail conventions in AGENTS.md. |
| 53 | **setup-matt-pocock-skills** → *(see 46)* | — | — | — |
| 54 | **grill-me** (also installed as a real skill) | Relentless interview to sharpen a plan or design | **LOW** | Installed; keep in the toolbox for the concept-selection step. |

*(Rows 53–54 duplicate 46 and 17 respectively; the list above is the full 54-command inventory
deduplicated for reading — the `.opencode/commands/` directory contains exactly 54 files.)*

### 11.3 The ranked eight that actually matter

1. **`impeccable`** — the only installed design skill and the only automated checker. Use
   `impeccable detect --json index.html` and the browser variant (`--viewport 390x844`) as the
   checker agent's ground truth, and read `reference/craft-floor.md` before any edit [S3].
2. **`design-taste-frontend`** (tasteskill v2) — the house rules, the 247-site data, the direction
   dealer and the inspector. **Fetch `SKILL.md` + `references/tells.md` from upstream** (URLs in
   [S4][S5]) and inline the relevant bans into the concept brief.
3. **`redesign-existing-projects`** — the audit-first redesign protocol; the exact shape of this
   task (record the before, keep stack + content, change type → colour → frame → states → stock
   components).
4. **`web-design-guidelines`** — installed; the a11y/interaction half of the checker.
5. **`research`** — already applied; the output is this report and its summary. Its next use is
   sourcing the open-archive Arad images (K-11) with licences.
6. **`imagegen-frontend-mobile` + `imagegen-frontend-web`** — for the concept page: generate
   reference boards for the 10 directions, *then* design against them rather than against a
   prompt.
7. **`full-output-enforcement`** — guards the concept page and the redesign against placeholder
   content, which is a tell in itself.
8. **`prototype`** — the concept page's contract: one throwaway artefact answering one design
   question, not a production file.

**Redundancy map** [SYNTH]:
- `grill-me` ≈ `grilling` ≈ `grill-with-docs` ≈ `loop-me` — **one family, pick `grill-me`**.
- `to-spec` → `to-tickets` → `implement` → `implement-spec` — **one chain, and it is unusable here**
  (no tracker configured). Skip the whole family.
- `claude-handoff` ≈ `handoff` — pick `handoff`.
- `design-taste-frontend-v1` and `design-taste-frontend-v2-experimental` — **archived predecessors of
  the same skill**; the command descriptions say so explicitly ("preserved for projects depending on
  its exact behavior"). **Do not load them.** The current `design-taste-frontend` is v2.
- `high-end-visual-design` ≈ `minimalist-ui` ≈ `industrial-brutalist-ui` — three *style* skills from
  the same upstream family (soft / editorial / brutalist). Pick **one** direction family, and prefer
  `industrial-brutalist-ui`'s *print* discipline over `high-end-visual-design`'s "premium" framing.
- `research` ≈ `writing-*` — different jobs; keep `research`.
- `impeccable` overlaps `design-taste-frontend` substantially (both are anti-slop rulebooks) but
  they are complementary: Impeccable is **deterministic and file-scannable**, Taste Skill is
  **measured and opinionated**. Use both; when they conflict, the committed visual world wins
  [S3].

---

## 12. Risks, unknowns, and open questions

1. **The working tree is dirty.** `git status` shows `M index.html`, `M DESIGN.md`, `M PRODUCT.md`,
   `M docs/codebase.md`, `M fonts/OFL.txt`, `D fonts/oswald-*.woff2`, `?? fonts/fraunces-*.woff2`.
   The redesign should be committed **on top of this state**, and the stale docs fixed (P2-4).
2. **The `read` tool served a stale snapshot of `index.html` during this research** (it showed the
   pre-reorder gamemode modal). All line numbers here were verified with
   `Get-Content index.html -Encoding UTF8`. **Re-verify before editing.**
3. **`docs/codebase.md` is out of date** (says 3634 lines; the file is 3722; describes the old
   gamemode ordering, the old fonts and the old palette).
4. **Only one historic photograph exists** (`primaria-1901.jpg`). Four of five landmarks have no
   archive image, and the album's "Atunci" box is therefore empty for them — the app renders an
   empty state that was never designed. **Sourcing 4+ open-archive Arad plates is the highest-value
   non-visual task** (K-11, P1-11) and it changes the design problem, not just the design.
5. **The schematic map is a demo.** It must stay labelled as one, and any redesign of the map must
   keep the disclaimer (K-08).
6. **The offline constraint is hard.** No CDN, no build step, a flat static root served by nginx.
   Every font must be self-hosted woff2 (latin + latin-ext) and every asset must live in the repo.
7. **The Romanian diacritics require a `latin-ext` subset** for any new family. Verify ș (U+0219 /
   U+015F) and ț (U+021B / U+0163) coverage **before** committing to a face, and test the ș/ț
   glyphs in the *display* face specifically (many display serifs carry a substituted or
   incorrectly-shaped comma-below).
8. **The previous pass's `DESIGN.md` is a description, not a contract** (T-35). If the redesign does
   not rewrite it, the next pass will re-derive the same tells.
9. **Sensor and gesture constraints are load-bearing.** The `#startBtn` handler must request motion
   permission *inside the user gesture*; the start gate has a documented no-scroll contract at five
   viewport sizes (K-06). Any layout change to the gate must be re-verified at 320×568, 360×740,
   390×844, 412×915 and 1440×900, plus landscape at ≤560px height.
10. **The 10 concepts must not be 10 palettes.** Per [S4] step 3 and [S7] Level 3, a concept is a
    *direction* — an idea + a type system + a palette + a composition + a motion idea — not a
    recolour. If two of the ten differ only in hue, they are one concept.

---

*Report ends. Companion: `docs/research/01-anti-ai-signals-summary.md`.*



