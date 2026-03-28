# Workspace ↔ Obsidian Sync

Working files and Obsidian vault are kept in sync automatically.

---

## Locations

| Purpose | Path |
|---------|------|
| Working files | `~/.openclaw/workspace/` |
| Obsidian vault | `~/Documents/Obsidian/ForgeVault/` |

---

## Synced Directories

| Working | Obsidian |
|---------|----------|
| `knowledge-base/` | `knowledge-base/` |
| `MEMORY.md` | `MEMORY.md` |
| `memory/` | `daily-reports/` |
| `scripts/` | `scripts/` |

---

## Automatic Sync

| Trigger | Action |
|---------|--------|
| Cron job | Every 30 minutes |
| After changes | Run sync script |

---

## Manual Sync

```bash
~/.openclaw/workspace/scripts/sync-to-obsidian.sh
```

---

## Notes

- Sync is **one-way**: workspace → Obsidian
- Obsidian is for browsing, workspace is for Forge to read/write
- Both locations are backed up to GitHub

---

**Created:** 2026-03-28