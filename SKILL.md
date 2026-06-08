---
name: company-mode
description: 公司模式 — 9岗位×4阶段的多Agent协作开发系统，v3.1 含Reasonix主力施工、Pre-Clarify需求探明、Design Director视觉审查、Agent Teams、事件驱动审查、度量埋点
version: 3.1.0
---

# 公司模式 (Company Mode) v3.1

三系统架构：执行系统（9岗位×4阶段 + Agent Teams）+ 复盘系统（度量驱动 + RAG索引）+ 学习系统（伴随式知识成长 + 模式缓存）

## 设计原则

| # | 原则 | 来源 |
|---|------|------|
| 1 | **上下文隔离优于全局共享** — 每个 Agent 只看自己需要的文件 | Anthropic 多Agent协调研究 |
| 2 | **跨模型独立验证不串行** — 不同模型并行出方案后交叉验 | "Beyond Trusting Trust"论文 |
| 3 | **Agent 3-5人甜点区** — 超过6个协调税吃掉并行收益 | Flat Mesh反模式研究 |
| 4 | **审查成本与风险成正比** — 低风险Fast Path，高风险全流程 | Google Agent Bake-Off |
| 5 | **度量驱动优化** — 每次施工埋点，复盘用数据说话 | 第一性原理 |
| 6 | **需求先行于架构** — 模糊需求先探明再设计，不带猜测进Align | v3.1 新增 |

## 命令接口

| 命令 | 功能 |
|------|------|
| `/company start` | 启动公司模式（默认 Fast Path） |
| `/company start --strict` | 启动严格模式（完整门控，高风险项目） |
| `/company status` | 查看进度、Token消耗、Agent状态 |
| `/company escalate` | 手动介入当前 Task |
| `/company abort` | 紧急停止，保存 checkpoint |

## 四阶段流水线

```
Pre-Clarify ──→ Align ────────────→ Build ────────────→ Verify
(需求探明)      (一次性对齐)         (Agent Teams 施工)   (最终审计)

Requirement     CTO + PM 并行        Task Queue 自领      交叉模型审计
Analyst 苏格    DA Pre-Mortem        Subagent-per-task    度量报告
拉底式追问      → Kill List          事件驱动审查         用户验收
                                       + Studio 视觉审查
🛑 确认产品镜像  🛑 用户确认(1次)     施工→更新规格        🛑 用户验收(1次)
```

详见 [pipeline.md](docs/pipeline.md)。

## 角色拆分

详见 [roles.md](docs/roles.md)。

| # | 岗位 | 背后 Agent/Skill | 常驻? | 触发条件 |
|---|------|-----------|------|---------|
| 1 | CEO | 主线程 | ✅ 常驻 | 全程 |
| 2 | CTO | `architect` | Align | Phase 启动 |
| 3 | PM | `pm-planner` | Align | Phase 启动 |
| 4 | DA | `da-adversary` | ❌ 事件 | 架构变更 / 安全敏感 / 跨模块影响 |
| 5 | Code Architect | `code-reviewer` | ❌ 事件 | 每个 Task 完成 |
| 6 | QA Director | `tdd-guide` | ✅ 常驻 | 每个 Task 完成（测试用不同模型） |
| 7 | CSO | `security-reviewer` | ❌ 事件 | 认证/支付/数据/文件操作代码 |
| 8 | Requirement Analyst | `requirement-analyst` | Pre-Align | 需求模糊 / 一句话需求 |
| 9 | Design Director | `studio` | ❌ 事件 | UI/视觉/像素艺术 Task |

## 施工队

| 工具 | 角色 | 适用场景 |
|------|------|---------|
| Reasonix | **主力施工** | 常规 CRUD/业务逻辑/UI，DeepSeek prefix-cache 极致降本 |
| Claude Subagent | 第二施工 | 安全敏感/高风险并行/复杂推理，Claude 独立生成 |
| OpenCode | 备用施工 | Reasonix 不可用时降级，灵活多模型 |
| CEO | 兜底施工 | 三者都不可用时，记录为降级事件 |

## 审查触发矩阵（Fast Path）

| Task 类型 | Code Architect | QA Director | DA | CSO | Design Dir | 施工工具 | Token 预算 |
|----------|:---:|:---:|:---:|:---:|:---:|---------|:---------:|
| 常规 CRUD | ✅ | ✅ | — | — | — | Reasonix | ~10K |
| 复杂业务逻辑 | ✅ | ✅ | — | — | — | Reasonix/Subagent | ~20K |
| UI/视觉/像素 | ✅ | ✅ | — | — | ✅ | Studio → Reasonix | ~25K |
| 架构变更 | ✅ | ✅ | ✅ haiku | — | — | Reasonix | ~30K |
| 安全敏感 | ✅ | ✅ | ✅ opus | ✅ | — | Claude Subagent | ~40K |
| 高风险核心 | ✅ | ✅ | ✅ opus | ✅ | — | Reasonix+Subagent 并行 | ~60K |

## 关键规则

### v3.1 新增

1. **Reasonix 主力施工**：替代 OpenCode 成为默认施工工具。围绕 DeepSeek prefix-cache 优化，长会话缓存命中率 90%+，施工成本大幅降低。Claude Subagent 继续负责安全/高风险 Task
2. **Pre-Clarify 需求探明**：可选 Phase -1。Requirement Analyst 苏格拉底式追问 → 产品镜像 → 喂给 CTO+PM。不带模糊需求进架构设计
3. **Design Director 视觉审查**：studio 技能集成。UI/视觉/像素艺术 Task 先设计再施工，6 维度 doubao Vision review
4. **OpenCode 备用施工**：OpenCode 保留为 Reasonix 不稳定时的降级路径，不再作为主力
5. **产品镜像驱动 Align**：Pre-Clarify 产出直接作为 CTO+PM 的共享输入，减少"建筑师猜产品经理想要什么"

### v3.0 保留规则

1. **Agent Teams 施工模式**：Task Queue + 自领任务 + 直接通信。CEO 不转发信息，Agent 间结构化消息直传
2. **Subagent-per-task**：每个 Task 分配全新 subagent，只带该 Task 需要的内容。Token 消耗降 60-70%
3. **事件驱动审查**：DA/CSO/Code Architect/Design Director 不再全时在岗，Task 完成事件自动触发
4. **Fast Path 差异化预算**：常规 CRUD ~10K，高风险核心 ~60K。审查成本与风险成正比
5. **双施工 Generator-Verifier**：Reasonix + Claude Subagent 并列。高风险 Task 并行独立施工 → 交叉验证
6. **设计不冻结**：Build 阶段施工发现问题 → 直接更新架构简报。不等 Phase 结束
7. **Worktree 隔离**：Build 全程在独立 git worktree 进行，通过 Verify 后合并
8. **Checkpoint 恢复**：每完成 3-4 个 Task 自动 commit。会话中断从最近 checkpoint 恢复
9. **度量埋点**：每 Phase 自动记录 Token/通过率/拦截率/失败分布。复盘用数据说话
10. **Self-Healing 失败分类**：规格模糊 / 实现复杂 / 工具限制 / 模型能力。不再只说"需人工介入"
11. **--strict 降级模式**：完整门控恢复，高风险项目或用户要求时启用

### v2.0 保留规则

1. **交叉模型对抗审查**：DA 审查必须使用与施工不同的模型。Google Jules 验证：多发现 40-50% 问题
2. **Phase 0 Pre-Mortem**：架构设计前先问"什么会杀死这个项目？"，产出 Kill List
3. **Phase 5.5 Self-Healing**：施工后自动测试→失败分析→修复循环，最多 3 轮
4. **动态 Token 预算 + 熔断**：80% 自动降级低价模型，按角色熔断，100% 硬停
5. **状态哈希循环检测**：每轮辩论提取 State 哈希指纹，与历史 5 轮比对
6. **测试与代码生成分离**：测试代码必须由不同于施工模型的 Agent 生成，覆盖率目标 85-90%
7. **结构化中间产物**：架构文档和技术规格增加 Schema 验证清单
8. **复盘 RAG 索引**：关键教训存入 [retro-index.md](learning/retro-index.md)，新项目 Phase 0 检索
9. **模式缓存**：4 类预置架构模板，新项目从缓存启动
10. **专用 Subagent 定义**：DA (`da-adversary`) 和 PM (`pm-planner`) 有独立 agent 定义文件

### v1.1 保留规则

1. **Phase 1 商业模式验证**：PM 列出关键业务假设 → CEO 提交用户确认 → 不确认不进 Build
2. **Step 0 工具链验证**：项目启动前测试 Reasonix + Claude Subagent + git worktree 能力
3. **DA 审查对象强制指定**：调用 DA 时必须显式给出文件路径，禁止 DA 自动搜索
4. **Phase 4.5 施工前验证**：编译通过 + worktree 可读写 → 全部通过才进 Build
5. **CEO 施工兜底**：施工队不可用时 CEO 可直接写代码，在复盘中标注"施工队降级事件"

## 复盘系统

每次 Phase 结束产出复盘文档，关键教训存入 [retro-index.md](learning/retro-index.md)。新项目 Phase 0 启动时检索相关历史教训。

v3.0 新增：度量报告自动生成，Token 分布 / 通过率 / 拦截率 / 失败分类分布。

## 学习系统

详见 [learning/README.md](learning/README.md)。8 篇伴随式学习文档 + 复盘 RAG 索引 + 4 类模式缓存。

## 专用 Agent/Skill 定义

| Agent/Skill | 文件 | 特殊配置 |
|-------|------|---------|
| PM | `pm-planner.md` | model: sonnet，限 Read/Grep/Glob |
| DA | `da-adversary.md` | model: 按场景选择(常规 haiku, 安全 opus)，交叉模型审查，限 Read/Grep/Glob |
| Requirement Analyst | `requirement-analyst` skill | model: sonnet，苏格拉底式追问，独立上下文 |
| Design Director | `studio` skill | model: sonnet，集成 doubao Vision/Seedream，设计思维前置 |

其余岗位使用标准 agent 定义（architect, code-reviewer, tdd-guide, security-reviewer）。

## --strict 降级模式

| 差异 | 默认（Fast Path） | --strict |
|------|-----------------|---------|
| Pre-Clarify | 需求模糊时触发 | 始终启动（即使需求看似清晰） |
| Align 用户确认 | 1 次 | 3 次（Kill List → 架构 → 任务树） |
| Build DA 触发 | 事件触发（3 种条件） | 每个 Task |
| Build 用户暂停 | 无 | 每个 Wave 结束 |
| Build CSO | 事件触发 | 每个 Task |
| Build Design Dir | UI Task 触发 | 每个 UI Task + 3 轮 doubao review |
| Verify | DA 终审 | DA + CSO 全量 + Studio 全量视觉审计 |

`/company start --strict` 用于高风险项目（支付、认证、用户数据）。
