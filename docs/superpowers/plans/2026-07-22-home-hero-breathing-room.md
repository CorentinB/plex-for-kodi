# Home Hero Breathing Room Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Disable episode spoiler hiding for the active Kodi profile and give the Home hero a balanced, readable vertical rhythm without changing lower-row focus placement.

**Architecture:** Keep spoiler policy code and defaults intact, persisting only a local profile override. Re-space the two native XML hero compositions and mirror those coordinates in the browser preview; move the first hub down 32 px and add equal inverse scroll compensation so lower hubs retain their existing focused baseline.

**Tech Stack:** Kodi XML templates rendered with Ibis, Python `unittest`, JavaScript/CSS preview, Kodi profile XML, Kodi JSON-RPC/native screenshots.

## Global Constraints

- Preserve the 700 x 112 full clearLogo and 620 x 84 compact clearLogo boxes.
- Preserve art-only cards, 475/370/350 px hub cadence, inline ratings, and no-logo/subtitle collapse behavior.
- Change `no_episode_spoilers4` only in `/Users/corentin/Library/Application Support/Kodi/userdata/addon_data/script.plexmod/settings.xml`.
- Do not commit or revert the existing uncommitted Home redesign work.

---

### Task 1: Pin the New Hero Geometry with Failing Contracts

**Files:**
- Modify: `tests/test_home_layout_contract.py`
- Modify: `tests/test_home_preview_contract.py`

**Interfaces:**
- Consumes: `script-plex-home.xml.tpl`, `home_hero_metadata.xml.tpl`, and preview CSS/JS as text contracts.
- Produces: regression assertions for the 32 px row shift, balanced hero slots, wider copy, and matching preview scroll compensation.

- [ ] **Step 1: Replace the old spacing assertions with exact desired geometry**

Assert full hero values `subtitle y=82 height=34 width=880`, `meta y=126 height=32`, `summary y=168 height=60 width=920`, `logo shift=28`, and empty-subtitle shift `-44`. Assert compact values `subtitle y=70 height=30`, `meta y=112 height=30`, `summary y=154 height=56`, `logo shift=26`, and empty-subtitle shift `-42`. Assert first-row base `407`, group height suffix `407`, and initial scroll `-622`.

- [ ] **Step 2: Add equivalent preview contracts**

Assert `.hub-stack` top `435px`, `hubScrollShift()` base `-147`, the widened hero copy, and full/compact slot coordinates matching the XML.

- [ ] **Step 3: Run the targeted tests and verify RED**

Run:

```bash
python3 -m unittest tests.test_home_layout_contract tests.test_home_preview_contract
```

Expected: failures show the existing compressed coordinates (`76/112/150`, `403`, and `-115`) instead of the requested geometry.

---

### Task 2: Implement the Balanced Native and Preview Layouts

**Files:**
- Modify: `resources/skins/Main/1080i/templates/script-plex-home.xml.tpl`
- Modify: `resources/skins/Main/1080i/templates/includes/home_hero_metadata.xml.tpl`
- Modify: `tools/kodi-ui-preview/styles.css`
- Modify: `tools/kodi-ui-preview/app.js`

**Interfaces:**
- Consumes: hero Window properties and existing subtitle/logo conditional animations.
- Produces: the same identity, subtitle, facts/ratings, and synopsis hierarchy with explicit 10-18 px gaps and preserved lower-row focus placement.

- [ ] **Step 1: Update the full native hero**

Keep the logo at `700 x 112`; set the subtitle to `y=82`, `w=880`, `h=34`; metadata to `y=126`, `h=32`, `empty=-44`, `logo=28`; synopsis to `y=168`, `w=920`, `h=60`, with matching `-44/+28` conditional shifts. Increase the hero group height enough to contain the synopsis.

- [ ] **Step 2: Update the compact native hero**

Keep the logo at `620 x 84`; set subtitle to `y=70`, `w=880`, `h=30`; metadata to `y=112`, `h=30`, `empty=-42`, `logo=26`; synopsis to `y=154`, `w=1120`, `h=56`, with matching `-42/+26` shifts.

- [ ] **Step 3: Protect the first hub and preserve lower hubs**

Change row base and group-height suffix from `375` to `407`; change the first lower-hub scroll from `-590` to `-622`. Leave poster/square/16:9 row steps and geometry compensation untouched.

- [ ] **Step 4: Mirror geometry in the preview**

Move `.hub-stack` from `403px` to `435px`, change `hubScrollShift()` from `-115` to `-147`, widen full subtitle/summary bounds, and apply the same full/compact slot coordinates and heights as native XML.

- [ ] **Step 5: Run targeted tests and verify GREEN**

Run:

```bash
python3 -m unittest tests.test_home_layout_contract tests.test_home_preview_contract
node --check tools/kodi-ui-preview/app.js
```

Expected: all targeted tests pass and Node reports no syntax error.

---

### Task 3: Disable Spoiler Protection for This Profile

**Files:**
- Modify: `/Users/corentin/Library/Application Support/Kodi/userdata/addon_data/script.plexmod/settings.xml`

**Interfaces:**
- Consumes: Kodi add-on profile setting `no_episode_spoilers4` as JSON.
- Produces: an explicit local value of `[]`; repository defaults remain unchanged.

- [ ] **Step 1: Stop Kodi cleanly before profile mutation**

Use Kodi `Application.Quit`, wait for add-on unload, and terminate only a lingering already-unloaded process if necessary. Confirm no Kodi PID remains.

- [ ] **Step 2: Add the profile override with a structured XML-safe edit**

Insert exactly:

```xml
<setting id="no_episode_spoilers4">[]</setting>
```

Do not change `lib/windows/settings.py` or the spoiler mixin.

- [ ] **Step 3: Parse and inspect the profile**

Run an XML parse and assert the setting exists once with text `[]`.

- [ ] **Step 4: Restart Kodi once**

Launch the configured development Kodi app and confirm exactly one process and no active playback.

---

### Task 4: Full and Native Verification

**Files:**
- Modify when implementation is validated: Brain project/current/worklog notes already covering the Home redesign.

**Interfaces:**
- Consumes: rendered templates, tests, live Home data, and current profile setting.
- Produces: automated and native evidence that real episode details fit without collisions.

- [ ] **Step 1: Run complete automated verification**

Run the full 268+ test discovery suite, Python compilation, JavaScript syntax checks, all 47 template renders/parses at 3024 x 1832 and 1920 x 1080, and `git diff --check`.

- [ ] **Step 2: Verify native top and compact states**

On an unwatched episode, confirm the real synopsis replaces `[Spoilers removed]`; capture the top hero and at least one lower focused hub. Check logo/title, subtitle, facts/ratings, synopsis, and hub heading do not overlap.

- [ ] **Step 3: Verify runtime safety**

Confirm one Kodi process, no active player, and no `script.plexmod` traceback or XML parse error in the fresh log.

- [ ] **Step 4: Refresh durable Brain context**

Update the Plex for Kodi project page, current note, and existing Home art-only worklog with the profile-only spoiler override and final geometry. Run the explicit-file Brain vault checker.
