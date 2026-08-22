# Custom resources

One resource per folder. Every folder gets an `fxmanifest.lua`
(start from `tools/fxmanifest.template.lua`).

**Naming is not settled yet.** Resources will share a short prefix so
they group together and are easy to tell apart from third-party code —
e.g. `<prefix>_jobs_mechanic`, `<prefix>_ui_hud`.

TODO: pick the prefix. It appears in folder names, event names and
export calls, so it is expensive to change later. It does NOT have to
match the city name — the city name is content and can change freely.

Standard layout inside a resource:

```
fxmanifest.lua
config.lua      -- shared tuning values, no secrets, no security logic
client/         -- presentation only
server/         -- all validation, money, inventory, SQL
shared/         -- shared helpers
web/            -- React NUI source
```
