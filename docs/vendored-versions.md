# Vendored resource versions

Every third-party resource copied into `resources/` is recorded here with
the exact upstream commit it came from, so an upgrade is a reviewable diff
rather than a mystery.

| Resource | Folder | Upstream | Commit | Vendored on |
| --- | --- | --- | --- | --- |
| oxmysql | `[ox]` | | | |
| ox_lib | `[ox]` | | | |
| qbx_core | `[qbox]` | | | |
| ox_inventory | `[ox]` | | | |
| ox_target | `[ox]` | | | |

## Upgrading

1. Replace the folder with the new upstream copy.
2. Read the diff before deploying. Column renames and changed export
   signatures show up here — that is the whole point of vendoring.
3. Update the commit and date above.
4. Re-check anything in `docs/verified-api.md` that touched what changed.
