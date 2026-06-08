---
description: Start Company Mode - 9-role x 4-phase multi-agent development pipeline
type: skill
skill: company-mode
argument-hint: "<project description> | --strict <project description>"
---

# /company

Launch the Company Mode multi-agent development pipeline.

**Input**: $ARGUMENTS

## Usage

```
/company start "Build a React todo app with local storage"
/company start --strict "Payment processing microservice"
```

## What Happens

1. **Step 0 - Toolchain Check**: Verify build tools, git worktree, Agent availability
2. **Pre-Clarify** (optional): If requirements are vague, Requirement Analyst starts Socratic discovery
3. **Align**: CTO + PM design architecture and task breakdown in parallel
4. **Build**: Agent Teams autonomously execute tasks with event-driven review
5. **Verify**: Cross-model audit, metrics report, user acceptance

## Fast Path (Default)

Review costs proportional to risk. Regular CRUD tasks get Code Architect + QA only (~10K tokens). Security-sensitive tasks get full DA+CSO review (~40K tokens).

## Strict Mode

Use `--strict` for high-risk projects (payments, auth, user data). Enables full gating: every task gets DA+CSO review, user confirmation at each wave.

## Subcommands

| Command | Purpose |
|---------|--------|
| `/company start` | Begin Company Mode pipeline |
| `/company status` | View progress, token usage, agent status |
| `/company escalate` | Manually intervene in current task |
| `/company abort` | Emergency stop with checkpoint save |
