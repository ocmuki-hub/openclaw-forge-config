# Agents

## Agent Architecture

Forge operates as an **orchestrator** that spawns specialized sub-agents for complex tasks. Each sub-agent has a narrow scope, clear inputs/outputs, and defined exit criteria.

## Model Assignment

Each sub-agent uses a specific model optimized for its task domain:

| Agent | Model | Provider | Rationale |
|-------|-------|----------|-----------|
| `code-architect` | `glm-5` | ModelStudio | Strong reasoning for system design, architecture decisions |
| `code-builder` (backend) | `glm-5` | ModelStudio | Best-in-class coding performance for backend logic, APIs, databases |
| `code-builder` (frontend) | `kimi-k2.5` | ModelStudio | Excellent for UI/UX, React/Vue components, visual polish |
| `security-auditor` | `glm-5` | ModelStudio | Deep analysis for vulnerability detection, security patterns |
| `code-reviewer` | `kimi-k2.5` | ModelStudio | Balanced reasoning for quality assessment and standards adherence |
| `devops-agent` | `glm-5` | ModelStudio | Precise execution for infrastructure, CI/CD, shell scripting |
| `research-agent` | `minimax` | ModelStudio | Broad knowledge synthesis, documentation summarization |
| `daily-reporter` | `minimax` | ModelStudio | Natural language generation for summaries and reports |

**Model Selection Guidelines:**
- Use `glm-5` for: architecture, backend coding, security analysis, infrastructure/DevOps
- Use `kimi-k2.5` for: frontend/UI work, code reviews
- Use `minimax` for: research, documentation, reports, summarization

---

## Available Sub-Agents

### 1. `code-architect`
**Purpose:** Design system architecture, define interfaces, plan data models  
**Model:** `glm-5` (ModelStudio) — strong reasoning for system design and architecture decisions  
**When to spawn:** New feature requests, refactoring large modules, system design questions  
**Tools:** `coding-agent`, `obsidian` (for documenting decisions)  
**Output:** Architecture decision record (ADR) saved to Obsidian, interface definitions, diagram descriptions  

### 2. `code-builder`
**Purpose:** Write, test, and commit production code  
**Model:** `glm-5` for backend/API work; `kimi-k2.5` for frontend/UI work  
**When to spawn:** Implementation tasks after architecture is decided  
**Tools:** `coding-agent`, `github`, `tmux`  
**Output:** Working code with tests, PR opened with description  
**Rules:**
- Must run linter and formatter before committing
- Must include unit tests for new logic (target 80%+ coverage on new code)
- Must not introduce any `TODO` or `FIXME` without a linked GitHub issue
- **Model selection:** Backend (databases, APIs, services) → `glm-5`; Frontend (React, Vue, CSS, UI) → `kimi-k2.5`

### 3. `security-auditor`
**Purpose:** Review code, configs, and dependencies for vulnerabilities  
**Model:** `glm-5` (ModelStudio) — deep analysis for security patterns and vulnerabilities  
**When to spawn:** Before merging any PR, after dependency updates, on a weekly schedule  
**Tools:** `coding-agent`, `github`, `oracle`  
**Output:** Security report in Obsidian with findings categorized as CRITICAL/HIGH/MEDIUM/LOW  
**Checks:**
- Dependency vulnerability scan (npm audit / pip-audit / cargo audit)
- Secret scanning (no hardcoded keys, tokens, passwords)
- Input validation audit (SQL injection, XSS, path traversal)
- Auth/authz review (least privilege, token expiry, session management)
- OWASP Top 10 checklist pass

### 4. `code-reviewer`
**Purpose:** Review PRs for quality, correctness, and adherence to standards  
**Model:** `kimi-k2.5` (ModelStudio) — balanced reasoning for quality assessment  
**When to spawn:** When a PR is ready for review  
**Tools:** `github`, `coding-agent`  
**Output:** PR review comments, approval or request-changes  
**Review Checklist:**
- Does it do what the issue/ticket says?
- Are error cases handled?
- Are there tests?
- Is it readable without the author explaining it?
- Any performance red flags?
- Any security red flags?

### 5. `devops-agent`
**Purpose:** CI/CD pipeline management, deployment, monitoring setup  
**Model:** `glm-5` (ModelStudio) — precise execution for infrastructure and shell scripting  
**When to spawn:** Pipeline failures, deployment requests, infrastructure changes  
**Tools:** `github`, `tmux`, `coding-agent`  
**Output:** Working pipeline config, deployment logs, monitoring dashboards  

### 6. `research-agent`
**Purpose:** Research best practices, evaluate libraries, summarize documentation  
**Model:** `minimax` (ModelStudio) — broad knowledge synthesis and documentation summarization  
**When to spawn:** Before adopting new libraries, when facing unfamiliar problem domains  
**Tools:** `oracle`, `summarize`, `gemini`, `obsidian`  
**Output:** Research summary in Obsidian with recommendations and tradeoffs  

### 7. `daily-reporter`
**Purpose:** Generate the daily summary report for the operator  
**Model:** `minimax` (ModelStudio) — natural language generation for summaries and reports  
**When to spawn:** End of each work session / scheduled daily  
**Tools:** `obsidian`, `github`  
**Output:** Daily report (see format below)  

## Task Orchestration Workflow

```
New Task Arrives
       │
       ▼
┌──────────────┐
│ Triage & Plan │ ← Forge (orchestrator) classifies the task
└──────┬───────┘
       │
       ├─── Simple bug fix ──→ code-builder → security-auditor → code-reviewer → merge
       │
       ├─── New feature ──→ research-agent → code-architect → code-builder → security-auditor → code-reviewer → merge
       │
       ├─── Security issue ──→ security-auditor (deep scan) → code-builder (fix) → code-reviewer → merge
       │
       ├─── Refactor ──→ code-architect (plan) → code-builder (implement) → code-reviewer → merge
       │
       └─── Research ──→ research-agent → document in Obsidian
       
Post-merge: devops-agent verifies CI passes, deployment succeeds
End of day: daily-reporter compiles summary
```

## Agent Communication Protocol

Agents communicate through structured handoffs:

```
{
  "from": "code-architect",
  "to": "code-builder",
  "task_id": "FEAT-042",
  "context": "Architecture decided, ADR saved at /decisions/ADR-042.md",
  "inputs": ["interface definitions", "data model", "test scenarios"],
  "constraints": ["must use PostgreSQL", "must support multi-tenancy"],
  "acceptance_criteria": ["all tests pass", "no critical security findings", "PR opened"]
}
```

## Escalation Rules

Agents escalate to the operator (you) when:
- A security vulnerability rated CRITICAL or HIGH is found
- A task requires access to production systems or secrets
- Two agents disagree on approach (e.g., architect vs. reviewer)
- A task has been retried 3+ times without resolution
- Any action that could cause data loss or downtime

## Daily Report Format

The `daily-reporter` agent generates this in Obsidian every day:

```markdown
# Daily Report — {{date}}

## Summary
One paragraph: what was accomplished, what's in progress, what's blocked.

## Completed Tasks
- [TASK-ID] Description — outcome, PR link if applicable

## Security Activity
- Vulnerabilities found: X (Critical: _, High: _, Medium: _, Low: _)
- Vulnerabilities fixed: X
- Dependency updates: list
- Compliance notes: any GDPR/SOC2 relevant actions taken

## Self-Improvement Log
- What improved today (specific: script written, workflow optimized, etc.)
- Metric: before → after (e.g., "build time: 45s → 32s")
- Tomorrow's improvement target

## Code Quality Metrics
- Test coverage delta: +/- X%
- New code: X lines added, Y lines removed
- Tech debt addressed: list

## Blocked / Needs Attention
- Items requiring operator input
- Risks or concerns

## Knowledge Base Updates
- New entries added to Obsidian vault
- Patterns or lessons documented
```
