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
- Mirrors the native art-only Home hubs, type-aware hero hierarchy, rating
  rail, compact lower-row hero, deterministic row viewport, and
  poster/square/16:9 focus treatment.
- Supports keyboard focus (`Arrow` keys and `Escape`) so row transitions and
  metadata changes can be inspected without Kodi.
- Includes basic read-only source-template inspection.
- Keeps all preview code isolated under `tools/kodi-ui-preview`.

The native Kodi XML and Python remain authoritative. Use Kodi itself for final
verification because `$INFO[...]` bindings, focus routing, media data, and
animation semantics are only approximated here.
