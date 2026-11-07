# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Day-trippers and city tourists walking Arad with a phone. Situation: on foot, outdoors, one-handed, in sunlight, frequently interrupted. Job: discover heritage landmarks around them, understand what they are looking at, and take home a souvenir of having stood there.

## Product Purpose

AradLens guides a visitor on foot between heritage landmarks and bridges time at each spot: stand where history stood and compare the landmark then vs now. Success means a tourist completes the walk, grasps each landmark's story, and keeps at least one Then/Now souvenir.

## Positioning

The time-bridge: at the real spot, the app holds the archival photo against the present view. A neighboring city guide cannot truthfully copy the per-landmark archival pairing — each Then photo is anchored to a year meaningful for that building (opening, construction, or another defining moment), not a single fixed year.

## Operating Context

Field use: mobile web, camera + GPS + compass required, works best outdoors with GPS on. Permissions (camera, location, motion/orientation) are requested in a start-gate flow before guidance begins. No backend: captures persist in-browser only. Desktop access shows a placeholder gate with a preview bypass for layout review.

## Capabilities and Constraints

- Static single `index.html` served as flat static root (nginx, port 8010); offline-capable; no framework, no build step.
- 5 landmarks with static coordinates (`const REPERE`); proximity gate 200 m for capture; schematic album map is demonstrative, not GPS-projected (disclaimer stays).
- Then/Now comparison and full info card exist per landmark only where archival material is on hand; landmarks without material yet show honest placeholders, never fabricated history.
- Permanent album save awaits backend integration (undecided: timeline open).
- Schematic-map disclaimer and sensor/shutter honesty are non-negotiable.

## Brand Commitments

Name `AradLens` is binding. Voice: Romanian-language UI, plain walker wording over engineering jargon. Committed direction (from grilling): 1901-rooted archival identity generalized per landmark year; ordered walking route with progress over the circular selector; permission priming that names the sensors and spells out what the first tap asks for. Look: archival beige accent on a near-black ground, self-hosted Fraunces (SIL OFL) for display type and the system sans for body (see `DESIGN.md`).

## Evidence on Hand

- `primaria-1901.jpg` — archival photo of Primăria Arad, 1901 (Fortepan / Schoch Frigyes, public domain), referenced by `REPERE[2].foto` with credit line.
- More Fortepan/archive photos for the remaining landmarks are expected (no confirmed delivery date — do not fabricate; absences must render as honest placeholders).
- Absences future work must not fabricate: archival photos for 4 of 5 landmarks, construction/opening years per landmark, backend for permanent album.

## Product Principles

1. The lens first: the camera view of Arad is the product; UI recedes behind it.
2. Honesty over completeness: a labeled placeholder beats an invented fact or a fake map pin.
3. Glanceable in motion: guidance must read in a one-second look while walking.
4. Arrival pays off: every walk segment ends in a keepsake, never a dead end.
5. Time is per-building: each landmark's Then year is its own defining moment, not a house style.

## Accessibility & Inclusion

Field-first a11y floor: 44px minimum touch targets, keyboard-operable selector and map, labeled controls, live-region status announcements, WCAG AA contrast (4.5:1 text). Established by critique remediation; redesign must not regress it.
