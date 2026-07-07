# Kodi UI Preview

Browser workbench for iterating on the PM4K/Kodi home UI without launching Kodi.

This is not a Kodi skin engine. It approximates the visible home surface with HTML/CSS,
mock Plex data, and the real skin assets from `resources/skins/Main/media`.

## Run

```bash
node tools/kodi-ui-preview/server.mjs
```

Then open the printed local URL.

## Scope

- Uses real skin PNG/GIF assets through `/skin-media/...`.
- Models the home header, section rail, hub rows, poster/square/16:9 cards, focus
  states, progress bars, and basic source-template inspection.
- Keeps all preview code isolated under `tools/kodi-ui-preview`.

Use Kodi itself for final verification because Kodi-only XML controls, `$INFO[...]`
bindings, focus routing, and animation semantics are only approximated here.
