# 03 — AradLens Baseline Checklist (binary rubric for the redesign loop)

`ID | RULE | STATUS | EVIDENCE`
Legend: **PASS** = keep as-is · **FAIL** = must be fixed or explicitly waived · **PARTIAL** = partly satisfied, tighten it · **N/A** = not applicable.
Scope: `index.html` (3722 lines). Baseline 2026-10-22. Companion: `docs/research/03-baseline-audit.md`.
Re-check mechanically: every EVIDENCE cell names a `index.html:LINE` or a shell/DOM query. Contrast ratios in this file were computed from the source CSS with the model in §1 of the audit (browser tooling was unavailable for this pass — re-verify in a browser when one is attached).

---

## TOUCH TARGETS (44px floor — `PRODUCT.md` "Accessibility & Inclusion"; `DESIGN.md` "Don't shrink rail rings below 52px or snap targets below 44px")

```
TT-01 | Rail rings, incl. #themeToggleBtn, are >=44px          | PASS    | index.html:171 "#rail .ring{width:52px;height:52px}"; #rail .ring (1,1,0) beats .theme-toggle-btn (0,1,0) so #themeToggleBtn (index.html:1449) is 52px, not the 34px declared at index.html:140
TT-02 | #compassWarningBadge >=44x44px                          | FAIL    | index.html:547-554 "width:34px;height:34px" -> raise to 44px
TT-03 | .modal-close-btn (gmCloseBtn, chapterCloseBtn) >=44x44  | FAIL    | index.html:828-833 "width:36px;height:36px" -> raise to 44px
TT-04 | Schematic map pin target >=44px                          | FAIL    | index.html:1194-1216 <circle r="16"> = 32px dia; enlarge r or add a transparent 44px hit circle
TT-05 | .story-objective-banner >=44px tall                     | FAIL    | index.html:792-799 12px font + 6px 12px padding + 1.5px border = ~29px; set min-height:44px
TT-06 | .btn >=44px                                            | PASS    | index.html:441-445 "min-height:44px"
TT-07 | .cw-close and .pt-close >=44x44                          | PASS    | index.html:539-543 and 576-579 "min-width:44px;min-height:44px"
TT-08 | .card-x, .album-close-btn, .album-tab-btn, .album-action-btn, .cs-cancel-btn >=44px | PASS | index.html:467-470, 598-602, 1010-1015, 683-686, 736-739
TT-09 | .compass-stop hit box >=44px                             | PASS    | index.html:230-236 width:104px; content 40+3+12+3+10 = ~68px tall (dial glyph itself is 40px)
```

## CONTRAST (WCAG AA: 4.5:1 text, 3:1 non-text)

```
CT-01 | Dark: bone #f6f2e9 on bg-main/bg-surface/bg-modal >=4.5 | PASS   | 17.31 / 15.67 / 17.31 - index.html:46, 47, 49, 50
CT-02 | Dark: amber #c8b088 on #0b0e12 >=4.5                    | PASS   | 9.23:1 - index.html:36
CT-03 | Dark: amber-ink #1c1409 on amber #c8b088 >=4.5          | PASS   | 8.69:1 - index.html:37; used at index.html:393, 687, 847, 434
CT-04 | Dark: --text-muted rgba(246,242,233,.72) on bg-surface >=4.5 | PASS | 8.58:1 - index.html:51
CT-05 | Dark: --accent-green #c8b088 on bg-surface >=4.5        | PASS   | 8.36:1 - index.html:54
CT-06 | Dark+light: bone on deep-teal #14655a badges >=4.5      | PASS   | 6.19:1 - index.html:615-619 (.schematic-badge), 919-922 (.lore-badge)
CT-07 | Light: text-main/text-muted/accent-green on #fffdf7+#fff >=4.5 | PASS | 18.45 / 9.74 / 5.80 (on #fff: 18.76 / 9.91 / 5.90) - index.html:70-76
CT-08 | Dark: .reward-badge-card.locked body text >=4.5         | FAIL   | index.html:1029 "opacity:.55" -> .rbc-desc 2.20:1, .rbc-title 2.84:1; dim the icon/border instead of the whole card
CT-09 | HUD text over live camera has a >=4.5:1 floor            | FAIL   | over white pavement: .al-name 1.01:1 (index.html:301), .al-meta 1.01:1 (305), .dist .num 1.67:1 (322), .hint 2.29:1 (437), .cb-name 4.31:1 (254), .cb-dist 3.58:1 (260), .route-step 3.49:1 (134); bottom scrim ramp index.html:42
CT-10 | Non-text UI components (hairlines, .btn border) >=3:1    | PARTIAL | dark hairline 1.94:1 (index.html:43), light hairline 1.55:1 (72), .btn border 2.93:1 (442); rules are decorative, glyphs carry the affordance - do not let a hairline become a control's only boundary
```

## KEYBOARD OPERABILITY

```
KB-01 | Escape closes every modal                               | FAIL   | grep -c "Escape" index.html = 0; add a keydown handler closing #gamemodeModal/#chapterModal/#storyLoreModal/#rewardModal/#albumModal/#captureModal/#card/#photoCmp
KB-02 | Open modals trap focus                                  | FAIL   | no focus-trap code anywhere; only .focus() call is index.html:2397 (band arrow-nav)
KB-03 | Focus returns to the trigger after a modal closes        | FAIL   | close handlers only set display:none - index.html:1970, 1980, 3067, 3280, 3313, 3528, 3591
KB-04 | Background is inert while a modal is open                | FAIL   | no inert/aria-hidden swap; #rail (index.html:1426) and #snapRail stops (1488) stay tabbable behind modals
KB-05 | #snapRail arrow keys move the selected stop              | PASS   | index.html:2382-2399 - ArrowLeft/Right/Up/Down, clamped at both ends, skips locked steps, focuses the new stop
KB-06 | All interactive elements are real <button>/<input> and tab-reachable | PASS | no div-as-button; onclick only on SVG <g role="button" tabindex="0"> - index.html:1193-1217
KB-07 | Visible :focus-visible ring on every focusable element   | PASS   | index.html:88 "outline:2px solid var(--accent-green);outline-offset:3px"; 9.23:1 dark / 5.28:1 light; SVG pins index.html:633
```

## ARIA / SEMANTICS

```
AR-01 | Document language declared                               | PASS   | index.html:2 <html lang="ro">
AR-02 | Every dialog has role=dialog + aria-modal + aria-labelledby, and the target exists | PASS | index.html:1132, 1152, 1267, 1316, 1336, 1367 -> cmTitle/albumTitle/gmTitle/cmHeadTitle/loreTitle/rewardTitle all present
AR-03 | Band stops expose aria-current and a descriptive aria-label | PASS | index.html:2283 (aria-current), 2333 (aria-label with step/distance/state)
AR-04 | No live region is rewritten on every animation frame     | FAIL   | #humanStatus aria-live (index.html:1415) written at 2682 and .dist aria-live (1477) written at 2706, both per rAF in update()
AR-05 | Album tabs expose tab semantics and the panel swap is announced | FAIL | index.html:1163-1164 use aria-pressed only, no role=tablist/tabpanel; switchAlbumTab index.html:3318
AR-06 | #card and #photoCmp are exposed as dialogs                | FAIL   | index.html:1492 and 1505 have no role/aria-modal/aria-labelledby
AR-07 | Mode/chapter state reaches AT after #gameModeBadge removal | PASS | #railModeDot aria-hidden (index.html:1433) + gamemodeRailBtn title/aria-label set at 1900-1901 and 1915-1916
```

## MOTION / VIEWPORT / METERS

```
MO-01 | prefers-reduced-motion disables animation and transition | PASS   | index.html:1060-1069
MO-02 | Capture flash suppressed under reduced motion            | PASS   | index.html:1068 "#captureFlash{opacity:0 !important}"
MO-03 | env(safe-area-inset-*) applied to top/bottom/fixed surfaces | PASS | index.html:120, 284, 350, 416, 433, 458, 494, 504, 507, 511, 526, 560, 587, 698
MO-04 | Viewport opts into safe areas (viewport-fit=cover)        | FAIL   | index.html:5 content="width=device-width, initial-scale=1.0" - every env() call is a no-op on iOS
MO-05 | Fixed gutters respect env(safe-area-inset-right)         | FAIL   | #rail right:14px (index.html:167), #compassWarning left/right:14px (526), #proximityToast (560) - notch/home-indicator collision in landscape
MO-06 | Every meter/count/meta numeral uses tabular-nums         | PARTIAL | missing on .lore-year-stamp (index.html:923), #rewardsCountBadge (1164), .chapter-period-badge (885), .chapter-number (881); present on .dist (321-323), .al-meta (307), .route-step (137), .cb-dist (260)
```

## LAYOUT / GEOMETRY

```
LY-01 | 68px caption clearance from the right rails              | FAIL   | no "68px" in index.html; DESIGN.md spacing.caption-clearance = 68px and requires it 3x - implement explicitly
LY-02 | Ring 52px, band height 108px, BAND_SLOT 108px unchanged  | PASS   | index.html:171, 211, 2072
LY-03 | Start gate fits 320x568 / 360x740 / 390x844 / 412x915 / 1440x900 with 0px scroll | PARTIAL | contract index.html:337-378 (min-height:100dvh + margin-top:auto on .start-head and .start-foot); safety net overflow-y:auto index.html:339; not re-measured after the copy at index.html:1530-1533 changed
LY-04 | HUD has a short-viewport / landscape fallback             | FAIL   | only media query is the start-gate landscape branch index.html:412-428; #rail top:22% (167) x 308px tall overlaps .bottom on <=640px-tall viewports
```

## THEMING (light lens rules — `DESIGN.md` "Stay-Dark Standing Rules", master comment index.html:61-64)

```
TH-01 | Light theme remaps overlays/modals/cards only (12 vars)  | PASS   | index.html:65-81
TH-02 | Stay-dark set keeps a dark ground in light theme         | PASS   | lens HUD index.html:116, capture screen 695, photo compare 479, proximity toast 559, compass warning 525, status 432, schematic map ground 623
TH-03 | Light theme flips #start and #desktopPlaceholder to bone + amber-ink | PASS | index.html:400-407, 787
TH-04 | Theme persists, updates <meta theme-color> and swaps the sun/moon glyph | PASS | index.html:1820-1835, 1812-1818, 1450, 1461
TH-05 | .story-objective-banner is a lens element but is light-themed | PARTIAL | index.html:801-803 flips it to rgba(255,253,247,.95) + amber-ink over the lens in light theme
```

## CONTENT HONESTY (non-negotiable — `PRODUCT.md` "Schematic-map disclaimer and sensor/shutter honesty are non-negotiable")

```
CN-01 | Schematic-map disclaimer stays                            | PASS   | index.html:1220 "Pozițiile ... sunt demonstrative și orientative (fără proiecție GPS reală)."; badge :1172; header :1156
CN-02 | The map stays a hand-placed demo, never GPS-projected     | PASS   | pin coords are literal SVG attrs index.html:1194-1216; renderAlbum sets fills by attribute index.html:3553-3572
CN-03 | The 1901 photo credit stays                               | PASS   | index.html:1533 (start gate), 1597 (REPERE[2].fotoCredit), 3584 (album Then-box), 2584 (#cmpCredit)
CN-04 | The 4 landmarks without an archive photo show an honest placeholder | PASS | index.html:3586-3592 "Fotografia istorică va fi disponibilă ulterior" / "Arhiva fotografică ... este în curs de completare."; only REPERE[2].foto exists (1596)
CN-05 | No fabricated history for the other 4 landmarks           | PASS   | REPERE index.html:1559-1627 carries real sourced years/architects (1865 Czigler, 1874 Czigler, 1876 Lechner, 1896 Ybl, 1913 Szántay); only the photo is missing and that is declared
CN-06 | "No backend, photos stay on your phone" honesty           | PASS   | index.html:1545, 3199
CN-07 | Storage-full / session-only honesty                        | PASS   | index.html:3138-3153 (sessionOnly:true fallback), 3198 "păstrată doar pentru sesiunea curentă"
CN-08 | A visible statement that permanent album save awaits backend | FAIL | grep -i "TODO|permanent|definitiv" index.html = 0 hits; AGENTS.md claims this TODO lives in executePhotoCapture()/capture-modal text - add one honest line, keep the local-only copy
```

## ASSETS / INTEGRITY

```
AS-01 | Self-hosted display-face woff2 files exist on disk         | PASS   | fonts/fraunces-latin.woff2 (67304 B), fonts/fraunces-latin-ext.woff2 (59388 B); referenced index.html:16, 22
AS-02 | Display-face woff2 files are committed to git             | FAIL   | git ls-files fonts -> fonts/OFL.txt only; both woff2 are untracked ("??" in git status) -> deploy.sh git pull would 404 the @font-face and silently fall back to Georgia
AS-03 | fonts/OFL.txt is committed and travels with the face      | PASS   | git ls-files fonts -> fonts/OFL.txt tracked; @font-face block index.html:14-25
AS-04 | primaria-1901.jpg present and referenced                  | PASS   | index.html:1524 (start gate background), 1596 (REPERE[2].foto)
```

---

## Summary of the baseline

| Area | Items | PASS | FAIL | PARTIAL |
|---|---|---|---|---|
| Touch targets | 9 | 5 | 4 | 0 |
| Contrast | 10 | 7 | 2 | 1 |
| Keyboard | 7 | 3 | 4 | 0 |
| ARIA | 7 | 4 | 3 | 0 |
| Motion / viewport | 6 | 3 | 2 | 1 |
| Layout | 4 | 1 | 2 | 1 |
| Theming | 5 | 4 | 0 | 1 |
| Content honesty | 8 | 7 | 1 | 0 |
| Assets / integrity | 4 | 3 | 1 | 0 |
| **TOTAL** | **60** | **37** | **19** | **4** |

**Do not regress (already applied, intentional):** `#gameModeBadge` stays deleted; `storyState.currentMode = "free"` (index.html:1729) stays after the localStorage parse block; `#railModeDot` + `gamemodeRailBtn` title/aria-label stay the mode indicator.
