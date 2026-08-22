# CLAUDE.md

Guidance for Claude Code when working in this repository.

## What this repo is

A FiveM roleplay server built for **serious economy RP**. This repo holds server
configuration, custom resources, database migrations, and design docs. It is not
a mod pack — every custom resource here is written for this server specifically.

## Stack

| Layer | Choice |
| --- | --- |
| Framework | **Qbox** (`qbx_core`) |
| Database wrapper | **oxmysql** |
| Shared library | **ox_lib** |
| Inventory | **ox_inventory** |
| Targeting | **ox_target** |
| NUI | **React** |

### Resource load order

This order is mandatory and must be preserved in `server.cfg`:

```
oxmysql  →  ox_lib  →  qbx_core  →  ox_inventory
```

Everything else (`ox_target`, custom resources) loads after `ox_inventory`.
A resource that starts before its dependency will fail in ways that look like
missing exports, so check load order first when an export is "nil".

---

## Security — non-negotiable

**The server never trusts a client-supplied value. Ever.**

The client is fully controllable by the player. Anything that reaches the server
from a client — event arguments, callback arguments, NUI messages, coordinates,
entity handles, item names, amounts, prices, IDs, booleans — is *an attacker-
chosen value*, not data. Treat it as a request, and re-derive the truth
server-side.

### Rules

1. **Every `RegisterNetEvent` handler validates before it acts.** No exceptions,
   including for events that "only" open a menu or play an animation.
2. **Capture `source` immediately** into a local at the top of the handler.
   Never read `source` after a yield/await — it can be clobbered. Never accept a
   player id as an *argument*; the only trustworthy identity is `source`.
3. **Position:** never accept coordinates from the client. Get the player's ped
   server-side and check distance against the server's own copy of the target
   coordinates. Reject if out of range. This is what stops teleport/remote
   exploitation of every shop, stash, and job interaction.
4. **Ownership:** re-query ownership from the database or server state. "The
   client said this vehicle/property/stash is theirs" is not ownership.
5. **State:** re-check job, grade, on-duty status, licence, and any gating flag
   server-side at the moment of the action. A client-side job check is a UX
   affordance, never an authorisation.
6. **Quantity and price:** the client may send an *identifier*. It may never send
   an amount, a price, or an item name that the server uses as-is. Look the
   price/definition up in a server-side table keyed by that identifier, and
   reject identifiers not present in the allowed set for this context.
7. **Validate types and ranges** on every argument before use:
   `type(n) == 'number'`, `math.type(n) == 'integer'` where an integer is
   required, `n > 0`, and an explicit upper bound. Reject `NaN`/`inf`. A missing
   upper bound is how negative-quantity and integer-overflow duping happens.
8. **Rate-limit anything that grants value.** Per-source cooldown, enforced
   server-side, on every event that pays money, spawns items, or writes to the
   DB. Concurrency guard too — the same event fired twice in one tick must not
   pass the check twice (validate, mark in-flight, then perform).
9. **Money and inventory mutations happen server-side only**, derived from
   server-side facts. The client never sends a delta.
10. **ox_lib callbacks are net events.** Same rules, no relaxation.
11. **NUI is a client, and the client is untrusted.** A NUI callback's payload is
    attacker-controlled just like an event argument.
12. Obfuscation, client-side encryption, and "nobody would find this event" are
    not security. Assume every event name and payload shape is public.

### Review checklist for any handler that touches value

- [ ] `source` captured first, no player id accepted as an argument
- [ ] Player object re-fetched server-side
- [ ] Distance check against server-owned coordinates
- [ ] Job / grade / duty / licence re-checked server-side
- [ ] Ownership re-queried
- [ ] Identifier validated against an allow-list; price/definition looked up server-side
- [ ] Amount type-checked, integer-checked, bounded above and below
- [ ] Cooldown + in-flight guard
- [ ] Inventory space / funds checked *before* the mutation, and the whole
      mutation ordered so a failure mid-way cannot dupe or void

---

## Do not guess APIs

If you are not certain a FiveM native, or a `qbx_core` / `ox_lib` /
`ox_inventory` / `ox_target` / `oxmysql` export exists — **say so and stop.**

- Do not invent function names.
- Do not invent function signatures, argument order, or return shapes.
- Do not assume an export exists because the equivalent exists in QBCore or ESX.
  Qbox diverged from QBCore; ox_inventory diverged from qb-inventory.
- "Probably `exports.x:DoThing()`" is not acceptable output. Either verify it or
  flag it as unverified in the response and leave a `-- TODO(verify):` comment.

**Verification means** reading the resource's own source in this repo (once
vendored) or the official documentation — not recalling it.

Confirmed APIs get recorded in `docs/verified-api.md` with the source they were
confirmed against, so the next session doesn't re-derive them. Anything not in
that ledger is unverified.

---

## Lua conventions

- One resource per folder under `resources/[custom]/`.
- Folder and file names are `snake_case`. Resource folders are prefixed to group
  them by domain (e.g. `fyve_jobs_*`, `fyve_ui_*`) — pick the prefix once and
  keep it.
- **Every** resource has an `fxmanifest.lua`, and every manifest declares
  `lua54 'yes'` explicitly. No `__resource.lua`.
- Standard file layout inside a resource:
  ```
  fxmanifest.lua
  config.lua          -- shared, non-secret tuning values
  client/             -- client_scripts
  server/             -- server_scripts, incl. all validation
  shared/             -- shared_scripts
  web/                -- React NUI source (built output committed or ignored per resource)
  ```
- Anything that is a security decision lives in `server/`. Never in `shared/`, so
  it cannot be read or reasoned about from the client for free, and never
  duplicated into `config.lua` where a future edit will only fix one copy.
- Prefer local variables and `local function`. No accidental globals.
- SQL through oxmysql only, always parameterised. String-concatenated SQL is a
  bug, not a style choice.

---

## NUI / React

The UI is a differentiator, not a checkbox. It should not look like stock QBCore.

- React, written as real components with real state management — not HTML strings
  injected into a div.
- Build tooling per UI resource; the dev loop should support hot reload in the
  browser against mocked NUI messages, so UI work does not require the game
  running.
- Every NUI screen must be developable and reviewable in a plain browser with
  mocked data. Assume the person building it may not have GTA V open.
- Design for the RP context: information density where it matters, no modal
  soup, readable at 1080p and 1440p, keyboard-navigable where sensible.
- The NUI never holds authoritative state. It renders what the server told the
  client, and it sends requests, not commands.

---

## Working constraints (current phase)

Prep work only. There is **no GTA V client and no running server** available to
test against right now.

- Do not write gameplay Lua that cannot be verified without the game running.
- Config, schema, migrations, docs, design, tooling, manifests, and browser-
  testable React are all in scope.
- If a task requires runtime verification, say so and stop rather than shipping
  untested gameplay code that looks finished.

---

## Secrets

- `server.cfg` is **not** committed. `server.cfg.example` is, with placeholders.
- The FiveM licence key, database credentials, and any API tokens never enter
  the repo — not in a config, not in a comment, not in an example file.
- If a secret is ever committed, it is compromised: rotate it, don't just remove
  the commit.
