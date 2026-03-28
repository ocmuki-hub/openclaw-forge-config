# Tools

## Tool Usage Philosophy

Use the right tool for the job. Prefer deterministic tools (scripts, CI, linters) over LLM-based judgment for repeatable tasks. Use LLM-based agents for creative work, architecture decisions, and code review where nuance matters.

---

## Coding & Development Tools

### `coding-agent`
**Purpose:** Spawn coding sub-agents for complex, multi-step implementation tasks  
**When to use:**
- Tasks requiring 50+ lines of code changes across multiple files
- Implementing a feature end-to-end (model → service → API → tests)
- Complex refactors touching many modules  
**Best practices:**
- Always provide clear acceptance criteria in the prompt
- Include relevant file paths and context
- Specify the testing strategy expected
- Set a timeout — if it hasn't produced results in a reasonable time, intervene

### `github`
**Purpose:** GitHub operations — issues, PRs, CI status, code review  
**When to use:**
- Creating/updating issues and PRs
- Checking CI/CD pipeline status
- Managing releases and tags
- Reviewing code on existing PRs  
**Security rules:**
- Never push directly to `main` or `production` branches
- Always create feature branches: `feat/`, `fix/`, `refactor/`, `security/`
- PR descriptions must include: what changed, why, how to test, security implications
- Require at least 1 review (from code-reviewer agent or operator) before merge

### `gh-issues`
**Purpose:** Fetch GitHub issues, spawn agents to implement fixes, monitor PR reviews  
**When to use:**
- Triaging incoming issues
- Assigning issues to sub-agents for implementation
- Tracking PR review status and following up  
**Workflow:**
1. Fetch open issues → classify by priority and type
2. For implementation-ready issues → spawn code-builder
3. Monitor resulting PRs → ensure review and CI pass
4. Close issues only when merged and verified

### `tmux`
**Purpose:** Remote-control tmux sessions for interactive CLIs, long-running processes  
**When to use:**
- Running dev servers, test suites, build processes
- Interactive debugging sessions
- Monitoring logs in real-time
- Any process that needs to persist across agent restarts  
**Best practices:**
- Name sessions descriptively: `tmux new -s build-frontend`
- Always check if a session exists before creating a new one
- Clean up sessions when done

### `oracle`
**Purpose:** Prompt + file bundling, engines, sessions for complex reasoning tasks  
**When to use:**
- Multi-step reasoning about architecture or design
- Bundling context from multiple files for analysis
- Complex problem decomposition  

### `mcporter`
**Purpose:** MCP servers/tools integration  
**When to use:**
- Integrating with external services via MCP protocol
- Managing tool registrations and configurations

---

## Memory & Knowledge Tools

### `obsidian`
**Purpose:** Work with Obsidian vault — your persistent knowledge base  
**This is your primary memory system.** Everything important gets documented here.

**Vault Structure:**
```
vault/
├── daily-reports/          # Daily summary reports
│   └── YYYY-MM-DD.md
├── decisions/              # Architecture Decision Records (ADRs)
│   └── ADR-NNN.md
├── security/               # Security findings, audit logs
│   ├── audits/
│   ├── vulnerabilities/
│   └── compliance-checklist.md
├── knowledge-base/         # Patterns, best practices, lessons
│   ├── patterns/
│   ├── anti-patterns/
│   └── tooling/
├── projects/               # Per-project documentation
│   └── project-name/
│       ├── README.md
│       ├── architecture.md
│       └── runbook.md
├── improvements/           # Self-improvement log
│   └── improvement-log.md
└── templates/              # Reusable templates
    ├── adr-template.md
    ├── daily-report-template.md
    ├── security-audit-template.md
    └── pr-template.md
```

**Rules:**
- Write a daily report every session
- Document every architecture decision as an ADR
- Log every security finding immediately
- Update the improvement log after each self-improvement action
- Link notes bidirectionally (use `[[wikilinks]]`)
- Tag notes: `#security`, `#architecture`, `#improvement`, `#blocked`, `#lesson`

### `apple-notes` / `bear-notes`
**Purpose:** Quick capture, personal notes  
**When to use:** Only if the operator specifically requests these. Default to Obsidian for all structured knowledge.

---

## Research & Intelligence Tools

### `summarize`
**Purpose:** Extract text/transcripts from URLs, podcasts, files  
**When to use:**
- Researching a new library or framework
- Summarizing documentation for decision-making
- Extracting key points from long resources  

### `gemini`
**Purpose:** One-shot Q&A, summaries, generation  
**When to use:**
- Quick factual lookups
- Alternative perspective on a problem
- Generating boilerplate or templates  
**Note:** Cross-reference Gemini outputs with your own knowledge. Don't blindly trust external LLM outputs for security-sensitive decisions.

---

## Meta Tools

### `skill-creator`
**Purpose:** Create, edit, and improve agent skills  
**When to use:**
- When a repeated workflow should be captured as a skill
- When an existing skill needs refinement
- When the operator requests a new capability  
**Self-improvement integration:** If you find yourself doing the same multi-step task 3+ times, propose creating a skill for it.

---

## Tool Selection Matrix

| Task Type | Primary Tool | Supporting Tools |
|-----------|-------------|-----------------|
| Write code | `coding-agent` | `github`, `tmux` |
| Review code | `github` | `coding-agent` |
| Security audit | `coding-agent` | `github`, `obsidian` |
| Research | `summarize`, `gemini` | `obsidian`, `oracle` |
| Document | `obsidian` | `oracle` |
| Deploy | `github` | `tmux`, `coding-agent` |
| Triage issues | `gh-issues` | `github` |
| Self-improve | `skill-creator` | `obsidian` |
| Daily report | `obsidian` | `github` |
