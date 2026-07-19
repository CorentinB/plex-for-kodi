# tvOS Home Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Redesign the real Plex for Kodi Home screen toward the tvOS Plex composition, then keep the browser preview aligned as a secondary aid.

**Architecture:** Preserve Kodi control IDs and existing hub/section data flow while changing the Home skin composition in XML. Add a small pure Python metadata helper so focused hub items can populate hero properties without tangling Kodi-specific code into tests. Verify native behavior through template rendering, Kodi JSON-RPC/recompile, and screenshots.

**Tech Stack:** Kodi WindowXML templates, Python 3/kodi_six runtime, dependency-free Node preview, Python `unittest`.

---

### Task 1: Add Tested Hero Metadata Helper

**Files:**
- Create: `lib/home_hero.py`
- Create: `tests/test_home_hero.py`
- Modify: `lib/windows/home.py`

- [x] Write `tests/test_home_hero.py` with fake media objects proving that a movie-like object produces title, year, duration, genre, summary, cast, rating, and art fields, and that missing fields produce empty strings instead of exceptions.
- [x] Run `python3 -m unittest tests.test_home_hero` and confirm it fails because `lib.home_hero` is missing.
- [x] Create `lib/home_hero.py` with a pure `build_hero_properties(obj)` function and private formatting helpers.
- [x] Run `python3 -m unittest tests.test_home_hero` and confirm it passes.
- [x] Wire `HomeWindow` to call the helper when a hub item receives focus and expose `home.hero.*` window properties.

### Task 2: Reshape Real Home XML

**Files:**
- Modify: `resources/skins/Main/1080i/templates/script-plex-home.xml.tpl`
- Modify: `resources/skins/Main/1080i/templates/includes/default_background.xml.tpl`

- [x] Add source-backed tvOS-style overlays over the existing dynamic background: dark left readability wash and bottom row wash.
- [x] Convert the section area into a slimmer top navigation treatment while preserving control `101`.
- [x] Add a left icon rail using existing search/home/user/settings-style assets where possible.
- [x] Add a hero metadata block using `Window.Property(home.hero.*)` with conservative fallback visibility.
- [x] Move hub rows lower into the tvOS-style poster rail zone and retune `hub.focus` slide distances.

### Task 3: Modernize Hub Card Treatment

**Files:**
- Modify: `resources/skins/Main/1080i/templates/includes/hub_itemlayout_poster.xml.tpl`
- Modify: `resources/skins/Main/1080i/templates/includes/hub_focusedlayout_poster.xml.tpl`
- Modify: `resources/skins/Main/1080i/templates/includes/hub_itemlayout_ar16x9.xml.tpl`
- Modify: `resources/skins/Main/1080i/templates/includes/hub_focusedlayout_ar16x9.xml.tpl`
- Modify if needed: square hub includes.

- [x] Reduce old label-heavy/card-border treatment.
- [x] Use subtler shadows and white/frosted focus rings instead of the orange slab.
- [x] Keep progress bars and watched indicators functional.
- [x] Preserve `hub.display.4xx` conditional layouts and list dimensions.

### Task 4: Native Kodi Verification And Tuning

**Files:**
- No source files unless tuning reveals layout/focus problems.

- [x] Run Python unit tests and syntax checks.
- [x] Render Kodi templates or trigger add-on recompile.
- [x] Launch/activate Kodi Home add-on through the existing local profile.
- [x] Capture native screenshots through Kodi's internal screenshot action without foregrounding its window.
- [x] Inspect focus movement across top nav and hub rows, then tune XML if row/header overlap or focus routing is wrong.

### Task 5: Update Browser Preview As Companion

**Files:**
- Modify: `tools/kodi-ui-preview/app.js`
- Modify: `tools/kodi-ui-preview/styles.css`
- Modify if needed: `tools/kodi-ui-preview/index.html`
- Modify: `tools/kodi-ui-preview/README.md`

- [x] Update the preview to mirror the new source-backed tvOS Home composition.
- [x] Keep the source/template panel explicit that it is an approximation, not a Kodi renderer.
- [x] Verify preview desktop/mobile with browser checks after native Kodi source changes are proven.

### Task 6: Documentation, Commit, And Brain Save

**Files:**
- Modify: `docs/superpowers/plans/2026-07-07-tvos-home-redesign.md`
- Update Brain worklog/project notes if the implementation lands.

- [x] Run `git diff --check`.
- [x] Run the relevant Python and Node checks.
- [x] Save the implementation result to Brain with file paths, screenshots, and verification.
- [ ] Commit and push if requested. Not requested for this implementation pass.
