# Home Single Resume Action Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace a lone first-row Continue Watching thumbnail with a compact
localized `Reprendre` hero action while retaining the normal carousel for every
multi-item or non-resumable case.

**Architecture:** Keep the native first hub populated as the sole media-state
owner, derive a single `home.resume.visible` Window property from that list,
and route a new focusable hero control back through the existing
`hubItemClicked(400, auto_play=True)` path. Kodi XML hides only the first visual
row and collapses the unscrolled stack; the browser preview mirrors this
contract without becoming the source of truth.

**Tech Stack:** Python 3, Kodi WindowXML/Jinja templates, gettext PO catalogs,
vanilla HTML/CSS/JavaScript preview, `unittest`, native Kodi JSON-RPC.

## Global Constraints

- Activate button-only mode only for first-hub `continueWatching` or
  `home.continue` with one in-progress movie/episode and no next Plex page.
- Keep zero-item, paginated, multi-item, unwatched, and unsupported hubs on the
  current carousel.
- Preserve the populated list, hero identity, context actions, watched action,
  and existing resume playback implementation.
- Do not start playback during visual QA.
- Native Kodi XML is authoritative; the browser preview is approximate.
- Work in the existing dirty tree because this feature depends on its Home
  redesign. Do not stage or commit pre-existing implementation changes.

---

### Task 1: Singleton Eligibility And Native State

**Files:**
- Modify: `tests/test_home_layout_contract.py`
- Modify: `lib/windows/home.py`

**Interfaces:**
- Consumes: managed Home list items exposing `dataSource`, `getProperty()`, and
  Plex media fields `TYPE`/`type` and `in_progress`.
- Produces: `HomeWindow._singleResumeItem(control, identifier, has_more)` and
  `HomeWindow._syncHomeResumeAction(index, identifier, control, has_more)`;
  Window property `home.resume.visible`.

- [ ] **Step 1: Write failing eligibility and state tests**

Add focused unit cases which extract the two Home methods through the existing
AST harness:

```python
def test_single_resume_requires_one_unpaginated_in_progress_video(self):
    item = _HubListItem(_HubMedia("Resume me", "1", media_type="episode", in_progress=True))
    window = _resume_window([item])

    self.assertIs(window._singleResumeItem(window.hubControls[0], "home.continue", False), item)
    self.assertIsNone(window._singleResumeItem(window.hubControls[0], "home.continue", True))
    self.assertIsNone(window._singleResumeItem(window.hubControls[0], "home.test", False))

def test_single_resume_rejects_multiple_or_unstarted_items(self):
    resumable = _HubListItem(_HubMedia("Resume me", "1", in_progress=True))
    fresh = _HubListItem(_HubMedia("Fresh", "2", in_progress=False))

    self.assertIsNone(_resume_window([resumable, fresh])._singleResumeItem(
        _HubControl([resumable, fresh]), "continueWatching", False
    ))
    self.assertIsNone(_resume_window([fresh])._singleResumeItem(
        _HubControl([fresh]), "continueWatching", False
    ))

def test_resume_property_is_owned_only_by_first_hub_and_clears_with_home(self):
    window = _resume_window([
        _HubListItem(_HubMedia("Resume me", "1", in_progress=True))
    ])

    window._syncHomeResumeAction(0, "home.continue", window.hubControls[0], False)
    self.assertEqual(window.properties["home.resume.visible"], "1")
    window._syncHomeResumeAction(1, "home.test", _HubControl(), False)
    self.assertEqual(window.properties["home.resume.visible"], "1")
    window._syncHomeResumeAction(0, "home.continue", _HubControl(), False)
    self.assertEqual(window.properties["home.resume.visible"], "")
```

Extend `_HubMedia` with optional `media_type` and `in_progress` fields, and add
a `_resume_window()` harness with `properties`, `getProperty()`,
`setProperty()`, `getFocusId()`, and `setFocusId()`.

- [ ] **Step 2: Run the focused tests and confirm RED**

Run:

```bash
python3 -m unittest \
  tests.test_home_layout_contract.HomeLayoutContractTests.test_single_resume_requires_one_unpaginated_in_progress_video \
  tests.test_home_layout_contract.HomeLayoutContractTests.test_single_resume_rejects_multiple_or_unstarted_items \
  tests.test_home_layout_contract.HomeLayoutContractTests.test_resume_property_is_owned_only_by_first_hub_and_clears_with_home
```

Expected: failures reporting missing `_singleResumeItem` or
`_syncHomeResumeAction`.

- [ ] **Step 3: Implement eligibility and property synchronization**

Add `SINGLE_RESUME_HUBS = frozenset(("continueWatching", "home.continue"))` to
`HomeWindow`, then implement:

```python
def _singleResumeItem(self, control, identifier, has_more=False):
    if identifier not in self.SINGLE_RESUME_HUBS or has_more:
        return None
    media_items = [
        item for item in control
        if item and item.dataSource and item.getProperty("is.end") != "1"
    ]
    if len(media_items) != 1:
        return None
    item = media_items[0]
    media_type = getattr(item.dataSource, "TYPE", None) or getattr(item.dataSource, "type", None)
    if media_type not in ("movie", "episode") or not item.dataSource.in_progress:
        return None
    return item

def _syncHomeResumeAction(self, index, identifier, control, has_more=False):
    if index != 0:
        return False
    visible = self._singleResumeItem(control, identifier, has_more) is not None
    was_visible = bool(self.getProperty("home.resume.visible"))
    self.setProperty("home.resume.visible", "1" if visible else "")
    if visible != was_visible:
        focus_id = self.getFocusId()
        if visible and focus_id == self.HUB_BASE_ID:
            self.setFocusId(self.RESUME_BUTTON_ID)
        elif not visible and focus_id == self.RESUME_BUTTON_ID:
            self.setFocusId(self.HUB_BASE_ID)
    return visible
```

Declare `RESUME_BUTTON_ID = 205`, clear `home.resume.visible` in `clearHubs()`,
call the synchronizer after the first list replacement, and clear it in the
empty-first-hub branch.

- [ ] **Step 4: Run focused tests and confirm GREEN**

Run the command from Step 2.

Expected: all three tests pass.

---

### Task 2: Resume Focus And Playback Delegation

**Files:**
- Modify: `tests/test_home_layout_contract.py`
- Modify: `lib/windows/home.py`

**Interfaces:**
- Consumes: `RESUME_BUTTON_ID`, `home.resume.visible`, first managed hub
  control, existing `hubItemClicked()`, `hubMenu()`, and `toggleWatched()`.
- Produces: `_homeResumeVisible()`, `_firstHubControlID(start_index)`, and
  `_focusHomeResumeItem()` helpers plus remote and click routing for control
  `205`.

- [ ] **Step 1: Write failing routing tests**

Add executable method tests proving:

```python
def test_resume_click_delegates_to_first_hub_direct_playback(self):
    window = _resume_action_window()
    window.onClick(window.RESUME_BUTTON_ID)
    self.assertEqual(window.play_calls, [(window.HUB_BASE_ID, True)])

def test_resume_focus_restores_first_item_hero_and_full_composition(self):
    window = _resume_action_window()
    window.onFocus(window.RESUME_BUTTON_ID)
    self.assertEqual(window.hub_focus, [None])
    self.assertEqual(window.synced, [(0, True)])

def test_resume_remote_navigation_bridges_header_and_next_populated_hub(self):
    window = _resume_action_window(second_hub=True)
    self.assertFalse(window._routeHomeResumeAction(window.SECTION_LIST_ID, ACTION_MOVE_DOWN))
    self.assertEqual(window.focused, window.RESUME_BUTTON_ID)
    self.assertFalse(window._routeHomeResumeAction(window.RESUME_BUTTON_ID, ACTION_MOVE_DOWN))
    self.assertEqual(window.focused, window.HUB_BASE_ID + 1)
    self.assertFalse(window._routeHomeResumeAction(window.HUB_BASE_ID + 1, ACTION_MOVE_UP))
    self.assertEqual(window.focused, window.RESUME_BUTTON_ID)
```

The helper returns `False` when it consumes an action and `True` when normal
Home processing must continue.

- [ ] **Step 2: Run routing tests and confirm RED**

Run the three new test methods directly with `python3 -m unittest`.

Expected: missing helper/routing failures.

- [ ] **Step 3: Implement button behavior through existing Home paths**

Add helpers that:

- Treat non-empty `home.resume.visible` as active.
- Find the first populated managed hub after index zero.
- Restore first-item hero ownership and clear `hub.scrolled` on button focus.
- Intercept Header Down, button Up/Down, and first-visible-lower-hub Up.

Update `onAction()` so Select and Play on control `205` call
`hubItemClicked(400, auto_play=True)`, Context opens `hubMenu(400)`, and the
existing watched action calls `toggleWatched(400)`. Update `onClick()` to use
the same direct playback path. Add control `205` to the top-composition branch
of `onFocus()`.

- [ ] **Step 4: Run routing tests and confirm GREEN**

Run the command from Step 2.

Expected: all routing tests pass without invoking Kodi playback.

---

### Task 3: Native CTA, Collapsed Geometry, Translation, And Preview

**Files:**
- Modify: `tests/test_home_layout_contract.py`
- Modify: `tests/test_home_preview_contract.py`
- Modify: `resources/skins/Main/1080i/templates/script-plex-home.xml.tpl`
- Modify: `resources/language/resource.language.fr_fr/strings.po`
- Modify: `tools/kodi-ui-preview/index.html`
- Modify: `tools/kodi-ui-preview/app.js`
- Modify: `tools/kodi-ui-preview/styles.css`

**Interfaces:**
- Consumes: `Window.Property(home.resume.visible)`, localized add-on string
  `32316`, existing `script.plex/buttons/player/modern/play.png` glyph, and
  preview hub fixtures.
- Produces: native control `205`, a hidden first visual row in singleton mode,
  a 425-design-pixel native next-hub baseline without a synopsis, a safe 472
  baseline with one, and preview `.resume-action`.

- [ ] **Step 1: Write failing XML, localization, and preview contracts**

Assert that native markup contains:

```python
self.assertIn('<control type="button" id="205">', home)
self.assertIn('$ADDON[script.plexmod 32316]', home)
self.assertIn('!String.IsEmpty(Window.Property(home.resume.visible))', home)
self.assertIn('String.IsEmpty(Window.Property(home.resume.visible))', first_hub_visibility)
self.assertIn('end="0,{{ vscale(-410) }}"', home)
self.assertIn('end="0,{{ vscale(-305) }}"', home)
self.assertIn('end="0,{{ vscale(-285) }}"', home)
self.assertIn('msgctxt "#32316"\\nmsgid "Resume"\\nmsgstr "Reprendre"', french)
```

Assert that preview markup/script/styles contain `data-resume-action`,
`is-single-resume`, `Reprendre`, first-row omission, and the conditional 396px
or 472px singleton hub-stack baseline.

- [ ] **Step 2: Run contract tests and confirm RED**

Run:

```bash
python3 -m unittest tests.test_home_layout_contract tests.test_home_preview_contract
```

Expected: the new resume contracts fail against the current templates and
preview.

- [ ] **Step 3: Implement the native action and geometry**

Inside the full hero group, add a 260 x 58 control at design `y=238` with:

- The same subtitle-empty `-44` and logo `+28` slide rules as the synopsis.
- An additional `-60` slide when the synopsis is empty.
- Transparent unfocused texture, white rounded focused plate, white/black
  text, and separately tinted white/black instances of
  `script.plex/buttons/player/modern/play.png`.
- Reversible 106 percent focus lift around the complete control.
- `onup` 101 and `ondown` 401 as XML fallbacks; Python supplies the dynamic
  populated-hub routing.

Hide group `500` when `home.resume.visible` is set. For every later hub in the
unscrolled top state, apply `-410` for poster, `-305` for square, or `-285` for
16:9 first-hub geometry. These place row 501 at design `y=472`; when the hero
synopsis is empty, add a `-47` top-state shift to land at `y=425`. This makes
the native button-to-heading and heading-to-poster optical gaps equal. Do not
apply these offsets once `hub.scrolled` is set.

Translate French string `32316` to `Reprendre`.

- [ ] **Step 4: Mirror the state in the browser preview**

Add a singleton `home.continue` fixture with one in-progress landscape item,
render a `button.resume-action` inside the hero, omit the first hub row when
eligible, add `.is-single-resume`, and route keyboard Down/Up between selected
navigation, the CTA, and the first rendered lower hub. Keep card ARIA labels
and all non-singleton code paths intact. Use a 396 px summary-free preview
baseline because its button is parented differently; this yields the same
18/18 control gaps as native Kodi.

- [ ] **Step 5: Run contract tests and confirm GREEN**

Run the command from Step 2 plus:

```bash
node --check tools/kodi-ui-preview/app.js
```

Expected: both test modules pass and Node exits 0.

---

### Task 4: Full Verification And Native Kodi QA

**Files:**
- Verify: all changed files
- Update: `/Users/corentin/Documents/Brain/Current.md`
- Update: `/Users/corentin/Documents/Brain/projects/plex-for-kodi/Plex for Kodi.md`
- Update: `/Users/corentin/Documents/Brain/worklog/2026-07-20-plex-for-kodi-home-art-only-hubs/2026-07-20 Plex for Kodi Home Art-Only Hubs.md`

**Interfaces:**
- Consumes: completed native and preview implementation.
- Produces: fresh automated evidence, native screenshot, empty active-player
  result, and current project context.

- [ ] **Step 1: Run complete static and automated verification**

Run:

```bash
python3 -m unittest discover -s tests
python3 -m compileall -q lib
node --check tools/kodi-ui-preview/app.js
python3 tools/render_skin_templates.py home --width 3024 --height 1832
python3 tools/render_skin_templates.py home --width 1920 --height 1080
git diff --check
```

Parse every generated XML file with `xml.etree.ElementTree`, compile the French
and English PO catalogs with the repository's available gettext tooling, and
confirm all commands exit 0.

- [ ] **Step 2: Verify the browser preview**

Start the existing preview server on a free local port. Use Playwright at
desktop and mobile viewports to verify the CTA, collapsed spacing, focus order,
zero horizontal overflow, and zero console errors.

- [ ] **Step 3: Verify native Kodi without playback**

Confirm exactly one local Kodi process and JSON-RPC availability. Refresh or
restart the add-on safely, then navigate:

`Accueil -> Reprendre -> first lower hub -> Reprendre`

Capture the top and lower-hub states with Kodi's screenshot action. Query
`Player.GetActivePlayers` before and after and require `[]`; do not activate
the CTA.

- [ ] **Step 4: Update Brain context and perform final review**

Record the adaptive singleton behavior, focus contract, test counts, native
screenshot paths, and no-playback evidence in the existing Plex-for-Kodi
project/worklog notes. Run the Brain vault checker, inspect `git status`,
`git diff --stat`, and the complete scoped diff, and report any unverified
surface explicitly.
