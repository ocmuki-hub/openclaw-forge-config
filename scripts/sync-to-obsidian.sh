#!/bin/bash
# Sync working files to Obsidian vault
# Run after any changes to knowledge-base, memory, or reports

WORKSPACE="$HOME/.openclaw/workspace"
OBSIDIAN="$HOME/Documents/Obsidian/ForgeVault"

echo "Syncing workspace → Obsidian..."

# Sync knowledge-base
rsync -av --delete "$WORKSPACE/knowledge-base/" "$OBSIDIAN/knowledge-base/" 2>/dev/null

# Sync MEMORY.md
cp "$WORKSPACE/MEMORY.md" "$OBSIDIAN/MEMORY.md" 2>/dev/null

# Sync daily reports
rsync -av "$WORKSPACE/memory/" "$OBSIDIAN/daily-reports/" 2>/dev/null

# Sync scripts (optional, for reference)
mkdir -p "$OBSIDIAN/scripts"
rsync -av "$WORKSPACE/scripts/" "$OBSIDIAN/scripts/" 2>/dev/null

echo "✓ Sync complete"
echo "Workspace: $WORKSPACE"
echo "Obsidian:  $OBSIDIAN"