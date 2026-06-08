# 🏭 Company Mode v3.1

> **Turn Claude Code into a 9-role, 4-phase virtual software company.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-3.1.0-blue)](https://github.com/YZX20061117/company-mode/releases)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-plugin-8A2BE2)](https://claude.ai/code)

**Company Mode** orchestrates multiple Claude Code agents into a structured software development pipeline. Instead of one AI doing everything, you get a virtual company with specialized roles, adversarial review, self-healing failure recovery, and token budget control — all running on Claude Code.

---

## ✨ Why Company Mode?

| Single Agent | Company Mode |
|-------------|--------------|
| One model, no second opinion | **Cross-model adversarial review** — different models audit each other |
| Context grows unbounded | **Subagent-per-task** — each agent sees only what it needs (60-70% token savings) |
| No structured process | **4-phase pipeline** with gated checkpoints |
| No failure recovery | **Self-healing** — classifies failures, retries with strategy (up to 3 rounds) |
| No cost control | **Token budgets** per task type (10K-60K), auto-downgrade at 80%, hard stop at 100% |
| "Build first, think later" | **Pre-Clarify** — Socratic product discovery BEFORE architecture |

---

## 🏗 Architecture

### 4-Phase Pipeline

```
Pre-Clarify ──→ Align ──────────→ Build ──────────→ Verify
(Requirements)  (One-time Align)  (Agent Teams)     (Final Audit)

🛑 User confirms  🛑 User confirms  CEO reports       🛑 User confirms
   product image     direction      every 3 tasks        release
```

| Phase | What Happens | Who's Involved |
|-------|-------------|----------------|
| **Pre-Clarify** (-1) | Socratic product discovery | Requirement Analyst |
| **Align** (0) | Architecture design, task breakdown | CTO + PM + DA |
| **Build** (1) | Agent teams autonomously build | All 9 roles (event-driven) |
| **Verify** (2) | Cross-model audit, metrics report | DA + CSO + QA Director |

### 9 Specialized Roles

| # | Role | Agent/Skill | Trigger | Model |
|---|------|------------|---------|-------|
| 1 | **CEO** | Main thread | Always-on | Inherited |
| 2 | **CTO** | `architect` | Align phase | Sonnet |
| 3 | **PM** | `pm-planner` | Align phase | Sonnet |
| 4 | **Devil's Advocate** | `da-adversary` | Architecture change / security | Haiku / Opus |
| 5 | **Code Architect** | `code-reviewer` | Every task completion | Haiku |
| 6 | **QA Director** | `tdd-guide` | Every task completion | Sonnet |
| 7 | **CSO** | `security-reviewer` | Auth/payment/data code | Sonnet |
| 8 | **Requirement Analyst** | `requirement-analyst` | Vague requirements | Sonnet |
| 9 | **Design Director** | `studio` | UI / visual tasks | Sonnet |

Agents **only appear when needed** — not all 9 roles sit in context at once.

---

## ⚡ Fast Path vs Strict Mode

| Task Type | Reviewers | Builder | Budget/Task |
|-----------|:---:|---------|:-----------:|
| Regular CRUD | CA + QA | Reasonix | ~10K |
| Complex Business Logic | CA + QA | Reasonix/Subagent | ~20K |
| UI / Visual | CA + QA + Design Dir | Studio + Reasonix | ~25K |
| Architecture Change | CA + QA + DA | Reasonix | ~30K |
| Security-Sensitive | CA + QA + DA + CSO | Claude Subagent | ~40K |
| High-Risk Core | CA + QA + DA + CSO | Parallel | ~60K |

---

## 🚀 Quick Start

```bash
# Clone
git clone https://github.com/YZX20061117/company-mode.git
cd company-mode

# Install to Claude Code
./install.sh          # macOS / Linux
# or
.\install.ps1         # Windows

# Use in Claude Code
/company start "Build a markdown-based blog with tags and RSS"
/company start --strict "Payment processing microservice"
/company status
/company abort
```

---

## 🛡️ Key Features

- **Cross-Model Adversarial Review** — DA must use a different model than the builder. Catches 40-50% more issues (Google Jules research)
- **Self-Healing Failure Recovery** — Classifies failures (spec ambiguous / implementation complex / tool limitation / model capability), retries with strategy up to 3 rounds
- **Token Budget Control** — Per-task budgets, 80% auto-downgrade, 100% hard stop
- **Worktree Isolation** — Build in isolated git worktree, merge only after Verify passes
- **Checkpoint Recovery** — Auto-commit every 3-4 tasks, resume from last checkpoint
- **Metrics-Driven** — Every phase logs tokens, pass rates, interception rates, failure distribution

---

## 🎯 Design Principles

| # | Principle | Source |
|---|-----------|--------|
| 1 | Context isolation > global sharing | Anthropic multi-agent research |
| 2 | Cross-model parallel verification | "Beyond Trusting Trust" |
| 3 | 3-5 agent sweet spot | Flat Mesh anti-pattern research |
| 4 | Review cost proportional to risk | Google Agent Bake-Off |
| 5 | Metrics-driven optimization | First principles |
| 6 | Requirements before architecture | v3.1 |

---

## 📊 Comparison

| Feature | Company Mode | Cursor | Devin | Copilot |
|---------|:-----------:|:------:|:-----:|:-------:|
| Multi-agent orchestration | ✅ 9 roles | ❌ | ✅ | ❌ |
| Cross-model adversarial review | ✅ | ❌ | ❌ | ❌ |
| Structured pipeline with gates | ✅ | ❌ | ❌ | ❌ |
| Token budget control | ✅ | ❌ | ❌ | ❌ |
| Self-healing recovery | ✅ | ❌ | ❌ | ❌ |
| Open source | ✅ MIT | ❌ | ❌ | ❌ |
| Works with Claude Code | ✅ Native | ❌ | ❌ | ❌ |

---

## 🤝 Contributing

Open an issue or PR if you find edge cases, have ideas for new roles, or want to improve the pipeline.

## 📜 License

MIT © 2026
