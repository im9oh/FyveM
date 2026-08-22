# Migrations

Forward-only, ordered, one file per change:

```
0001_description.sql
0002_description.sql
```

Rules:

- Never edit a migration that has been applied to any server. Write a new one.
- Every migration states what it depends on from `qbx_core` at the top, so a
  framework upgrade that changes those tables is caught here.
- Keep a matching rollback in a comment block at the bottom of the file.
