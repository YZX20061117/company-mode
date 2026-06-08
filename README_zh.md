# 🏭 公司模式 (Company Mode) v3.1

> **把你的 Claude Code 变成一个 9 人虚拟软件公司。**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-3.1.0-blue)](https://github.com/YOUR_USER/company-mode/releases)

**公司模式** 将多个 Claude Code Agent 编排为结构化的软件开发流水线。不再是"一个 AI 包揽一切"，而是一个有专职角色、对抗审查、自我修复、Token 预算控制的虚拟公司。

---

## ✨ 为什么需要 Company Mode？

| 单 Agent 模式 | Company Mode |
|--------------|--------------|
| 单一模型，没有第二意见 | **交叉模型对抗审查** — 不同模型互相审计 |
| 上下文无限膨胀 | **Subagent-per-task** — 每个 Agent 只看需要的文件（省 60-70% Token） |
| 没有结构化流程 | **4 阶段流水线** + 门控检查点 |
| 失败只能人工介入 | **自愈分类** — 4 种失败类型自动应对（最多 3 轮） |
| 成本无控制 | **Token 预算** 按 Task 类型（10K-60K），80% 降级，100% 硬停 |
| 上来就写代码 | **Pre-Clarify** — 苏格拉底式追问，先想清楚再动手 |

---

## 🏗 四阶段流水线

```
Pre-Clarify ──→ Align ──────────→ Build ──────────→ Verify
(需求探明)      (一次性对齐)       (Agent Teams 施工)  (最终审计)

🛑 确认产品镜像   🛑 确认方向        CEO 报告进度       🛑 用户验收
```

### 9 岗位角色

| # | 岗位 | 背后 Agent | 触发方式 |
|---|------|-----------|---------|
| 1 | CEO | 主线程 | 全程在岗 |
| 2 | CTO | `architect` | Align 阶段 |
| 3 | PM | `pm-planner` | Align 阶段 |
| 4 | Devil's Advocate | `da-adversary` | 架构变更/安全/跨模块 |
| 5 | Code Architect | `code-reviewer` | 每个 Task 完成 |
| 6 | QA Director | `tdd-guide` | 每个 Task 完成 |
| 7 | CSO | `security-reviewer` | 认证/支付/数据代码 |
| 8 | Requirement Analyst | `requirement-analyst` | 需求模糊时 |
| 9 | Design Director | `studio` | UI/视觉 Task |

---

## ⚡ Fast Path 差异化审查

| Task 类型 | 审查者 | 施工工具 | Token/Task |
|----------|:---:|------|:--------:|
| 常规 CRUD | CA + QA | Reasonix | ~10K |
| 复杂业务逻辑 | CA + QA | Reasonix/Subagent | ~20K |
| UI/视觉 | CA + QA + Design Dir | Studio + Reasonix | ~25K |
| 架构变更 | CA + QA + DA | Reasonix | ~30K |
| 安全敏感 | CA + QA + DA + CSO | Claude Subagent | ~40K |
| 高风险核心 | CA + QA + DA + CSO | 并行施工 | ~60K |

---

## 🚀 快速开始

```bash
git clone https://github.com/YOUR_USER/company-mode.git
cd company-mode

# 安装到 Claude Code
./install.sh          # macOS / Linux
.\install.ps1         # Windows

# 使用
/company start "用 React 做一个待办事项应用"
/company start --strict "支付处理微服务"
/company status
/company abort
```

---

## 🛡️ 核心特性

- **交叉模型对抗审查** — DA 强制使用与施工方不同的模型，多发现 40-50% 问题
- **自愈失败恢复** — 失败分类：规格模糊/实现复杂/工具限制/模型能力，自动应对
- **Token 预算管控** — 按 Task 分级，80% 警告降级，100% 硬停
- **Worktree 隔离** — Build 全程在独立 git worktree，Verify 通过才合并
- **Checkpoint 恢复** — 每 3-4 个 Task 自动 commit，中断从检查点恢复
- **度量驱动** — 每 Phase 记录 Token/通过率/拦截率/失败分布

---

## 📜 License

MIT © 2026
