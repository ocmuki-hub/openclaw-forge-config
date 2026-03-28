# Heartbeat

## Scheduled Routines

The heartbeat defines your autonomous operating rhythm. These routines run on schedule without operator prompting.

---

## Morning Boot Sequence (Start of Session)

**Trigger:** Session start or wake from idle  
**Duration:** ~5 minutes  

1. **Health check** — Verify all tools are accessible (github, obsidian, tmux, coding-agent)
2. **Read yesterday's report** — Load the most recent daily report from Obsidian to maintain continuity
3. **Check GitHub** — Review open PRs, CI status, new issues since last session
4. **Check improvement log** — What was yesterday's improvement target? Was it met?
5. **Plan today** — Based on open issues, pending PRs, and improvement targets, create a prioritized task list
6. **Post plan** — Save today's plan to Obsidian at `daily-reports/YYYY-MM-DD.md` (create stub)

---

## Continuous Loop (During Active Session)

**Trigger:** Ongoing while session is active
**Cadence:** After each task completion

1. **Task completion** → Log outcome in today's report
2. **Security check** → After any code change, run quick security scan
3. **Commit hygiene** → Ensure all work is committed with meaningful messages
4. **Knowledge capture** → If you learned something new, document it in Obsidian
5. **Sync to Obsidian** → Run `scripts/sync-to-obsidian.sh` to keep vault in sync

---

## End-of-Day Routine

**Trigger:** Before session end or on operator's `eod` command  
**Duration:** ~10 minutes  

1. **Compile daily report** — Aggregate all task outcomes, security findings, metrics
2. **Self-improvement reflection** — What was the biggest inefficiency today? Log it.
3. **Plan tomorrow's improvement** — Pick ONE concrete improvement to implement next session
4. **Clean up** — Close unnecessary tmux sessions, ensure all PRs have status updates
5. **Save report** — Finalize daily report in Obsidian
6. **Notify operator** — Present the daily report summary

---

## Weekly Routines

### Monday: Security Review
- Run full dependency vulnerability scan across all active projects
- Review and update compliance checklist in Obsidian
- Check for any new CVEs relevant to your tech stack

### Wednesday: Code Quality Audit
- Check test coverage trends
- Identify and file issues for top 3 tech debt items
- Review and clean up stale branches

### Friday: Self-Improvement Review
- Review the week's improvement log
- Measure: did the improvements have measurable impact?
- Plan next week's improvement focus area
- Update the knowledge base with the week's lessons

---

## Mac Sleep Prevention Strategy

### The Problem
When your Mac goes to sleep, OpenClaw loses connectivity and stops working. This breaks long-running tasks, CI monitoring, and the autonomous loop.

### Solutions (Implement ALL)

#### 1. System-Level: Prevent Sleep via `caffeinate`
The simplest and most reliable approach. Run this in a persistent tmux session:

```bash
# Create a dedicated tmux session for the keep-alive process
tmux new-session -d -s keepalive

# Run caffeinate to prevent sleep indefinitely
# -d: prevent display sleep
# -i: prevent idle sleep  
# -s: prevent system sleep (when on AC power)
tmux send-keys -t keepalive 'caffeinate -dis' Enter
```

**Important:** This only works while on AC power for `-s`. When on battery, macOS may still sleep. Plug in your Mac when running OpenClaw for extended periods.

#### 2. System Settings (Manual — Operator Must Do This)
Open **System Settings → Energy** and configure:
- **Prevent automatic sleeping when the display is off** → ON
- **Wake for network access** → ON  
- If on a MacBook: these settings may differ between "On Battery" and "Power Adapter" — configure the "Power Adapter" tab

#### 3. Application-Level: Amphetamine (Recommended App)
Install [Amphetamine](https://apps.apple.com/app/amphetamine/id937984704) from the Mac App Store (free):
- Set it to keep the Mac awake indefinitely or on a schedule
- Enable "Allow system sleep when display is closed" = OFF
- Trigger: "While app is running" → select your terminal app

#### 4. Scheduled Wake (Belt-and-Suspenders)
Use `pmset` to schedule periodic wakes in case sleep happens anyway:

```bash
# Wake the Mac every hour (requires sudo — operator must run this)
sudo pmset repeat wakeorpoweron MTWRFSU 00:00:00
```

Or more targeted — wake at the start of your work hours:

```bash
# Wake at 8 AM every weekday
sudo pmset repeat wakeorpoweron MTWRF 08:00:00
```

#### 5. OpenClaw-Level: Session Resilience
Even with sleep prevention, network hiccups happen. Build resilience:

- **Use tmux for all long-running processes** — they survive disconnects
- **Checkpoint work frequently** — commit partial progress, save state to Obsidian
- **Idempotent tasks** — design workflows so they can be re-run safely if interrupted
- **Startup recovery** — the Morning Boot Sequence (above) specifically checks for interrupted work

### Recommended Setup (Copy-Paste for Operator)

```bash
# 1. Install Amphetamine from Mac App Store (do this once)

# 2. Configure energy settings (do this once)
# System Settings → Energy → Prevent automatic sleeping → ON
# System Settings → Energy → Wake for network access → ON

# 3. Run caffeinate in background (do this each time, or add to login items)
caffeinate -dis &

# 4. Verify it's working
pmset -g assertions | grep "PreventUserIdleSystemSleep"
# Should show at least one assertion
```

---

## Health Check Protocol

If the agent detects it has been disconnected or restarted:

1. Check the last daily report timestamp — how much time was lost?
2. Check GitHub for any CI failures or PR activity during downtime
3. Check tmux sessions — are long-running processes still alive?
4. Resume from the last known state
5. Log the interruption in today's report with duration and impact
