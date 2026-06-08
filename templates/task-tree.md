# 任务分解树

## Task 类型系统

| 类型 | 标识 | 施工工具 | 设计审查 | 审查触发 |
|------|------|---------|---------|---------|
| 常规 CRUD | `CRUD` | Reasonix | — | CA + QA |
| 复杂业务逻辑 | `BusinessLogic` | Reasonix/Subagent | — | CA + QA |
| UI / 视觉 / 像素艺术 | `UI` | Studio → Reasonix | ✅ **强制** studio | CA + QA + Design Dir |
| 架构变更 | `Architecture` | Reasonix | — | CA + QA + DA |
| 安全敏感 | `Security` | Claude Subagent | — | CA + QA + DA + CSO |
| 高风险核心 | `Core` | Reasonix+Subagent 并行 | — | CA + QA + DA + CSO |

> **类型 = `UI` 时，Design Director (studio) 为强制门控**：施工前必须产出 `design-brief-{TASK_ID}.md`，施工后必须产出 `design-review-{TASK_ID}.md`。缺少任一文件 → CEO 阻塞，不得标记完成。

## 项目里程碑

| 里程碑 | 目标 | 完成标志 |
|--------|------|---------|
| M1 | | |
| M2 | | |
| M3 | | |

## 任务树

```
根任务：项目总目标
├── Phase 1: 基础设施
│   ├── T-001: [任务描述]
│   │   依赖：无
│   │   类型：CRUD
│   │   施工：Reasonix
│   ├── T-002: [任务描述]
│   │   依赖：T-001
│   │   类型：BusinessLogic
│   │   施工：Reasonix
│   └── T-003: [任务描述]
│       依赖：无
│       类型：UI
│       施工：Studio → Reasonix
│       设计审查：studio（强制）
│
├── Phase 2: 功能模块（可并行）
│   ├── T-004: [任务描述]
│   │   依赖：T-001, T-002
│   │   类型：BusinessLogic
│   │   施工：Reasonix
│   ├── T-005: [任务描述]
│   │   依赖：T-001, T-003
│   │   类型：UI
│   │   施工：Studio → Reasonix
│   │   设计审查：studio（强制）
│   └── T-006: [任务描述]
│       依赖：T-003
│       类型：Security
│       施工：Claude Subagent
│
└── Phase 3: 集成
    ├── T-007: [任务描述]
    │   依赖：T-004, T-005
    │   类型：Core
    │   施工：Reasonix + Subagent 并行
    └── T-008: [任务描述]
        依赖：T-005, T-006
        类型：CRUD
        施工：Reasonix
```

## 依赖图

```
T-001 ──→ T-002 ──→ T-004 ──┐
                             ├──→ T-007
T-003 ──→ T-005 ─────────────┘
     └──→ T-006 ──→ T-008
```

## 执行Wave

| Wave | 任务 | 并行度 | 预估耗时 |
|------|------|--------|---------|
| Wave 1 | T-001, T-003 | 2 | |
| Wave 2 | T-002, T-005, T-006 | 3 | |
| Wave 3 | T-004, T-008 | 2 | |
| Wave 4 | T-007 | 1 | |

## UI Task 门控规则

对于 `类型 = UI` 的 Task，CEO 在两个节点执行文件存在性检查：

```
派发前门控（Pre-Dispatch Gate）:
  检查: .company/design-brief-{TASK_ID}.md 是否存在
  → 存在 → 派发给 Reasonix 施工
  → 不存在 → 🛑 阻塞，必须先调用 studio 完成设计思考 + Design Token 交付

完成前门控（Pre-Completion Gate）:
  检查: .company/design-review-{TASK_ID}.md 是否存在且结论为"通过"
  → 通过 → Task 标记 done
  → 不通过 → 退回 Reasonix 修复 → 再次 studio review
```

### Studio 产出物约定

| 文件 | 时机 | 内容 |
|------|------|------|
| `.company/design-brief-{TASK_ID}.md` | 施工前 | Design Thinking 5 问 + 方向选择 + 设计 Token |
| `.company/design-review-{TASK_ID}.md` | 施工后 | 6 维度 doubao Vision review 结果 + 通过/不通过 |
