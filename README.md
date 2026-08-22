# FiveM roleplay server

Serious economy roleplay. Qbox (`qbx_core`) on the ox stack.

Read **[CLAUDE.md](CLAUDE.md)** first — it holds the stack decisions, the
server-side validation rules, and the code conventions.

## Layout

```
resources/
  [qbox]/            qbx_core (vendored, do not edit)
  [ox]/              oxmysql, ox_lib, ox_inventory, ox_target (vendored, do not edit)
  [standalone]/      third-party standalone resources (vendored, do not edit)
  [maps]/            map resources
  [custom]/          everything written for this server
docs/
  verified-api.md       confirmed exports/natives/columns
  vendored-versions.md  upstream commit per vendored resource
sql/
  migrations/        ordered, forward-only schema migrations
tools/
  fxmanifest.template.lua
server.cfg.example   copy to server.cfg and fill in
```

## Setup

```
cp server.cfg.example server.cfg
```

Then fill in the licence key, database connection string and hostname.
`server.cfg` is gitignored and must never be committed — if the licence key
or database password is ever pushed, rotate it, don't just delete the commit.

The load order in `server.cfg` is mandatory:
`oxmysql → ox_lib → qbx_core → ox_inventory`, everything else after.
