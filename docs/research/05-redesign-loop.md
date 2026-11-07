# Redesign loop protocol — worker + checker

Operational contract for step 5 of the plan. Two roles, one loop, until the
checker says **PASS**.

Loop shape: `WORKER (edit) → CHECKER (gate) → WORKER (fix) → CHECKER …`
Max 6 rounds. After round 6, stop and escalate to the human with the exact
list of failing items — do not keep grinding.

---

## Inputs every agent must read first

1. `docs/design/concepts.html` — the 10 concepts + the chosen one (human picks).
2. `docs/research/01-anti-ai-signals-summary.md` — what "AI-looking" means here.
3. `docs/research/02-design-psychology-summary.md` — the 20 rules, type scale,
   OKLCH palette, motion tokens.
4. `docs/research/03-baseline-checklist.md` — the 60 binary gate items.
5. `docs/research/03-baseline-audit.md` §fragile code map — what breaks if touched.
6. `DESIGN.md` + `PRODUCT.md` — the current system and the product's non-negotiables.

---

## Role A — WORKER

**Job:** apply the chosen concept to `index.html` (and `DESIGN.md`).

**Allowed to touch**
- `index.html` — the `<style>` block, the `#overlay` markup, the modals' markup,
  the JS that feeds them.
- `DESIGN.md` — rewrite the token tables so the doc matches the build.

**Must NOT touch**
- `REPERE` coordinates, `CHAPTERS` content, the lore prose, the 1901 photo and
  its Fortepan/Schoch Frigyes credit, the schematic-map disclaimer, the
  "save permanently later" honesty note.
- The compass band's gesture contract: drag, wheel, arrow keys, 108 px slot
  rhythm, `bandSuppressClickUntil` arbitration.
- The start gate's no-scroll contract (0 px scroll at 320×568, 360×740, 390×844,
  412×915, 1440×900) and its landscape two-column mode.
- `localStorage` keys and their shapes: `aradlens_theme`, `aradlens_user_photos`,
  `aradlens_story_state`.

**Rules of the trade**
- One concern per round. No "while I'm in here" edits. Each round ends with a
  clean console and a screenshot.
- Never trade a PASS for a FAIL. If a concept choice breaks a checklist item,
  the concept is adjusted, not the floor.
- Fonts: only self-host what ships in `fonts/`; a proposed face is a proposal
  until the woff2 files exist in the repo.
- Keep `index.html` UTF-8, CRLF, no BOM. Never "fix" Romanian strings from a
  garbled (non-UTF8) read.

**Report format (max 20 lines)**
```
ROUND n
Changed: <file> — <what> (<line ranges>)
Checklist: <PASS 41/60> (fixed: C-07, C-12; still failing: F-03, F-11)
Console: clean | <error>
Screenshot: <path>
Next: <the single next action>
```

---

## Role B — CHECKER

**Job:** say PASS or FAIL. No edits to source files, ever. If a fix is obvious,
report the fix — the worker applies it.

**The gate (all must pass for PASS)**

| # | Gate | How it is checked |
|---|---|---|
| G1 | All 19 baseline FAILs and 4 PARTIALs from `03-baseline-checklist.md` are now PASS | Re-run each checklist item mechanically against the working tree |
| G2 | No previously PASSing item regressed | Diff the checklist before/after |
| G3 | Contrast over live video | Every text surface over `#cam` has a computed ratio ≥ 4.5:1 against a **white pavement** reference frame, not only against the dark scrim |
| G4 | Touch targets | Every interactive element ≥ 44×44 px (48 px for the rail rings is the current bar) |
| G5 | Anti-AI tells | `impeccable detect --json index.html` shows no new hit vs the saved baseline; zero emoji-as-icon, zero bounce easing, zero pill-above-heading, ≤1 accent hue, ≤6 type steps, no two sizes within 3 px |
| G6 | Keyboard + ARIA | Every modal traps focus, closes on `Escape`, restores focus to its trigger; the band is arrow-key operable; focus ring visible at 3:1 against its background |
| G7 | Reduced motion | `prefers-reduced-motion: reduce` → no infinite animation, no `backdrop-filter` over `#cam` |
| G8 | Safe area | `viewport-fit=cover` present **and** every fixed/absolute element consumes `env(safe-area-inset-left/right/bottom)` where it touches a screen edge |
| G9 | Functional smoke | Console clean; start gate → preview bypass → HUD; band drag selects a stop; album opens, map pin selects, compare opens; free mode boots; story mode selectable and resumable; theme toggle persists |
| G10 | Concept conformance | The built UI matches the chosen concept's spec table (fonts, palette, type scale, layout, band treatment) — deviations are listed and justified in one line each |
| G11 | Honesty | Disclaimer, credit, and TODO copy all still present |
| G12 | Deliverable | `DESIGN.md` updated to the shipped tokens; `docs/codebase.md` updated where structure changed |

**Report format (max 25 lines)**
```
CHECK ROUND n — PASS | FAIL
Gates: G1 PASS · G2 PASS · G3 FAIL ...
Failing items: <ID> — <rule> — <evidence> — <suggested fix>
Regressions: <ID list, or none>
Console: <errors, or clean>
Blocking: <the single thing that must change first>
```

---

## Done criteria

PASS on G1–G12 **and** the human's chosen concept is visibly implemented
(screenshot matches the concept mockup at 390×844) **and** the worker reports
0 remaining FAIL/PARTIAL items.

## Escalation

If the checker FAILs the same item 3 rounds in a row, the worker stops editing
and reports the conflict between the concept and the floor. The human decides.
