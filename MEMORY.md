# MEMORY.md — Long-Term Memory

This file contains curated memories that persist across sessions. Important decisions, context, and lessons learned are documented here.

---

## Identity

- **Name:** Forge
- **Type:** Senior autonomous coding agent (OpenClaw)
- **Mission:** Ship enterprise-grade, security-first software
- **Standards:** SOC 2, GDPR, OWASP Top 10 compliance

---

## Operator

- **Name:** Murat
- **Role:** Solo developer / technical founder
- **Timezone:** Europe/Vienna (GMT+1)
- **GitHub:** `ocmuki-hub`
- **Telegram Chat ID:** `8274533218`
- **Communication:** Direct, structured, outcome-focused

---

## Model Configuration

| Agent | Model | Use Case |
|-------|-------|----------|
| code-architect | glm-5 | Architecture, design decisions |
| code-builder (backend) | glm-5 | APIs, databases, services |
| code-builder (frontend) | kimi-k2.5 | React/Vue, UI components |
| security-auditor | glm-5 | Vulnerability detection |
| code-reviewer | kimi-k2.5 | PR quality assessment |
| devops-agent | glm-5 | CI/CD, infrastructure |
| research-agent | minimax | Research, documentation |
| daily-reporter | minimax | Daily summaries |

---

## Infrastructure

| Component | Details |
|-----------|---------|
| **Host** | Murat's Mac mini (Darwin 25.4.0 arm64) |
| **Sleep prevention** | caffeinate in tmux `keepalive` |
| **Config repo** | https://github.com/ocmuki-hub/openclaw-forge-config |
| **Obsidian vault** | `~/Documents/Obsidian/ForgeVault` |
| **Webhook relay** | https://smee.io/uWA4H8psVoOciewv |

---

## Telegram Integration

| Notification | Source |
|--------------|--------|
| Push events | GitHub repo webhook → smee → local handler → Telegram |
| Morning briefing | Cron 08:00 Vienna |
| Daily summary | Cron 00:00 Vienna |

---

## GitHub Webhook Auto-Add

When creating any new repo, automatically add webhook:

```bash
gh api repos/ocmuki-hub/REPO_NAME/hooks -X POST \
  -F name=web -F active=true \
  -F 'events[]=push' -F 'events[]=pull_request' \
  -F 'config[url]=https://smee.io/uWA4H8psVoOciewv' \
  -F 'config[content_type]=json'
```

See: `knowledge-base/tooling/github-webhook-autoadd.md`

---

## Setup Milestones

### 2026-03-28 — Initial Configuration Complete

- ✅ Core config files (AGENTS, HEARTBEAT, IDENTITY, SOUL, TOOLS, USER)
- ✅ Model assignments per agent type
- ✅ GitHub CLI authenticated (`ocmuki-hub`)
- ✅ Remote repo created (`openclaw-forge-config`)
- ✅ Memory files initialized
- ✅ Obsidian vault configured
- ✅ Sleep prevention (caffeinate)
- ✅ Telegram integration working
- ✅ GitHub webhooks (repo-based, not app)
- ✅ Cron jobs: morning briefing (08:00), daily summary (00:00)

---

## Pending

- [ ] Tech stack definition — for calibrated security audits
- [ ] Optional skills — reusable workflows

---

## Lessons Learned

### GitHub Apps vs Repo Webhooks (2026-03-28)

**Problem:** GitHub App installation kept showing "prohibited" despite correct settings.

**Solution:** Use repo-level webhooks instead. Simpler, no approval flow, works immediately.

**Pattern:** Prefer simple solutions over complex ones. Repo webhooks > GitHub Apps for push notifications.

---

## Key Decisions

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-03-28 | Use repo webhooks instead of GitHub App | Simpler setup, no installation restrictions |
| 2026-03-28 | Use smee.io for webhook relay | Works with localhost, no public IP needed |
| 2026-03-28 | Separate models by task type | glm-5 for backend, kimi-k2.5 for frontend, minimax for research |

---

## Tech Stack

*To be defined by operator.*

---

## Active Projects

*To be added as projects are created.*