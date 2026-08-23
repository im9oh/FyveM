# Verified API ledger

Exports, natives and database columns **confirmed against real source** — not
recalled. If it is not in this file, it is unverified. See `CLAUDE.md`,
"Do not guess APIs".

---

## qbx_core database schema

Confirmed against `resources/[qbox]/qbx_core/qbx_core.sql`, qbx_core 1.24.0,
read 2026-08-23.

### `players`

| Column | Type | Notes |
| --- | --- | --- |
| `id` | int(11) AUTO_INCREMENT | **Not the primary key.** Ordinary index only. |
| `userId` | int unsigned NULL | |
| `citizenid` | varchar(50) | **PRIMARY KEY.** This is what foreign keys reference. |
| `cid` | int(11) NULL | |
| `license` | varchar(255) | indexed |
| `name` | varchar(255) | |
| `money` | **text** | JSON blob |
| `charinfo` | text NULL | JSON blob |
| `job` | **text** | JSON blob |
| `gang` | text NULL | JSON blob |
| `position` | text | JSON blob |
| `metadata` | text | JSON blob |
| `inventory` | longtext NULL | |
| `phone_number` | varchar(20) NULL | |
| `last_updated` | timestamp | auto-updates, indexed |
| `last_logged_out` | timestamp NULL | |

Charset `utf8mb4`, collation `utf8mb4_unicode_ci`, engine InnoDB.

### `player_groups`

Composite primary key `(citizenid, type, group)`, with:

```sql
CONSTRAINT `fk_citizenid` FOREIGN KEY (`citizenid`)
  REFERENCES `players` (`citizenid`)
  ON UPDATE CASCADE ON DELETE CASCADE
```

This is the pattern our own tables should copy.

### `bans`

`id` PK, indexed on `license`, `discord`, `ip`.

---

## Consequences for our schema — read before writing a migration

1. **Foreign keys reference `players(citizenid)`, never `players(id)`.**
   `id` is only an index; `citizenid` is the primary key.
2. **Our `citizenid` columns must be `varchar(50)` with collation
   `utf8mb4_unicode_ci`.** A mismatched type or collation makes MySQL refuse to
   create the foreign key, with an unhelpful error.
3. **`money` is a JSON text blob, not columns.** There is no `cash` or `bank`
   column to query, join or aggregate. All money changes go through the
   qbx_core API, and any economy reporting needs **our own ledger table** —
   the framework cannot answer "how much money exists on this server".
4. **`job` and `gang` are JSON text too.** Server-side job checks go through
   the framework, not a SQL join.
5. `ON DELETE CASCADE` from `players` is the established convention here — a
   deleted character should take its owned rows with it.

---

## Exports and natives

Nothing confirmed yet. Add rows here as they are read from vendored source.

| What | Signature / shape | Confirmed against | Date |
| --- | --- | --- | --- |
| | | | |
