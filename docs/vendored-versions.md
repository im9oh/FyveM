# Vendored resource versions

Every third-party resource copied into `resources/` is recorded here with the
exact version it came from, so an upgrade is a reviewable diff rather than a
mystery.

**These are official release artifacts, not git clones.** That matters:
`ox_lib` and `ox_inventory` keep their built `web/build` output out of git
upstream, so a `git clone` of either produces a resource that will not run.
Always vendor from the release zip.

| Resource | Folder | Upstream | Version | Vendored on |
| --- | --- | --- | --- | --- |
| oxmysql | `[ox]` | overextended/oxmysql | 2.14.1 | 2026-08-23 |
| ox_lib | `[ox]` | overextended/ox_lib | 3.39.0 | 2026-08-23 |
| ox_inventory | `[ox]` | overextended/ox_inventory | 2.47.9 | 2026-08-23 |
| ox_target | `[ox]` | overextended/ox_target | 1.18.1 | 2026-08-23 |
| qbx_core | `[qbox]` | Qbox-project/qbx_core | 1.24.0 | 2026-08-23 |

Versions read from each resource's own `fxmanifest.lua`.

## Upgrading

1. Download the new release zip and replace the folder.
2. Read the diff before deploying. Column renames and changed export
   signatures show up here — that is the whole point of vendoring.
3. Update the version and date above.
4. Re-check anything in `docs/verified-api.md` that touched what changed.
