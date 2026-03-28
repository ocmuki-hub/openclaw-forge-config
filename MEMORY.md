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

- **Host:** Murat's Mac mini (Darwin 25.4.0 arm64)
- **Sleep prevention:** caffeinate running in tmux session `keepalive`
- **Config repo:** https://github.com/ocmuki-hub/openclaw-forge-config

---

## Setup Milestones

### 2026-03-28 — Initial Configuration
- ✅ Core config files created (AGENTS, HEARTBEAT, IDENTITY, SOUL, TOOLS, USER)
- ✅ Model assignments configured per agent type
- ✅ GitHub CLI authenticated (`ocmuki-hub`)
- ✅ Remote repo created and verified (`openclaw-forge-config`)
- ✅ Push/pull workflow tested
- ✅ Caffeinate running for Mac sleep prevention
- ✅ Memory files initialized

---

## Pending Setup

- [ ] Obsidian vault — knowledge base location
- [ ] Telegram integration — for reports/notifications
- [ ] Cron jobs — scheduled security reviews, daily reports
- [ ] Tech stack definition — for security audits

---

## Lessons Learned

*Add lessons as they are discovered during work.*

---

## Key Decisions

*Document significant architectural or workflow decisions here.*
**GitHub App Status:** Installed 2026-03-28 — webhook active via smee.io

## Webhook Verified
- Smee relay: https://smee.io/uWA4H8psVoOciewv

## GitHub App Events Test
- Push event subscription: enabled
- Webhook URL: https://smee.io/uWA4H8psVoOciewv

## App Installation Test - Sat Mar 28 18:20:07 CET 2026

- Webhook test: 18:20

## Webhook Test - Sat Mar 28 18:58:16 CET 2026
