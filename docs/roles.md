# 9岗位角色定义与调度规则

## 角色总览

| # | 岗位 | 背后 Agent/Skill | 常驻/事件 | 触发条件 | 模型 |
|---|------|-----------|----------|---------|------|
| 1 | CEO | 主线程 | ✅ 常驻 | 全程 | 继承会话 |
| 2 | CTO | `architect` | Align 阶段 | Phase 启动 | sonnet |
| 3 | PM | `pm-planner` | Align 阶段 | Phase 启动 | sonnet |
| 4 | DA | `da-adversary` | ❌ 事件触发 | 架构变更 / 安全敏感 / 跨模块影响 | haiku(常规) opus(安全) |
| 5 | Code Architect | `code-reviewer` | ❌ 事件触发 | 每个 Task 完成 | haiku |
| 6 | QA Director | `tdd-guide` | ✅ 常驻 | 每个 Task 完成 | sonnet |
| 7 | CSO | `security-reviewer` | ❌ 事件触发 | 认证/支付/数据/文件操作代码 | sonnet |
| 8 | Requirement Analyst | `requirement-analyst` | Pre-Align | 用户需求模糊 / 一句话需求 | sonnet |
| 9 | Design Director | `studio` | ❌ 事件触发 | UI 前端 / 视觉设计 / 像素艺术 Task | sonnet |

**常驻 Agent: 2**（CEO + QA Director）
**Pre-Align Agent: 1**（Requirement Analyst，仅需求模糊时启动）
**Align Agent: 2**（CTO + PM，Phase 启动）
**事件触发 Agent: 5**（DA/Code Architect/CSO/Design Director + CTO/PM 按需唤醒），不需要时不出现在上下文中
**施工 Agent: 1-2**（按 Task 类型分配：Reasonix 或 Claude Subagent）
**活跃总数: 4-7，触发峰值 6-8，常驻 ≤ 3** — 在 3-5 Agent 甜点区边缘，峰值略高但事件触发 Agent 不共存

---

## CEO（主线程）

- **常驻**：✅ 全程在岗
- **职责**：统筹全局、仲裁决策、用户通信、进度报告
- **铁律**：不写代码。**例外**：Reasonix 和 Claude Subagent 都不可用时，CEO 直接写代码，在复盘中标注"施工队降级事件"
- **Align 职责**：合成 CTO+PM 产出 → 架构简报；将 PM 业务假设提交用户确认
- **Build 职责**：监控 Agent Teams 进度、仲裁争议、每 3 个 Task 报告一次进度
- **Verify 职责**：提交度量报告、用户验收

---

## CTO（architect agent）

- **常驻**：❌ Align 阶段启动，Build 阶段按需唤醒
- **职责**：系统架构设计、技术选型、接口契约、数据流设计
- **平台合规**：在小红书、微信等平台发布内容时，调研平台的内容审核规则
- **产出**：架构草案（输入给 CEO 合成架构简报）
- **Build 阶段**：被 Self-Healing 判定"规格模糊"时唤醒，澄清架构规格

---

## PM（pm-planner agent）

- **常驻**：❌ Align 阶段启动
- **职责**：需求拆解、任务优先级、进度追踪
- **业务假设**：列出项目的关键业务假设（用户靠什么赚钱？核心资源是什么？业务流程是什么？）
- **产出**：关键假设列表 + 任务分解树（Task Queue 种子）
- **Build 阶段**：被 Self-Healing 判定"实现复杂"时唤醒，拆分 Task

---

## Devil's Advocate（da-adversary agent，交叉模型）

- **常驻**：❌ 事件触发
- **职责**：专职挑战所有决策，只在需要时介入

### 触发条件（3 种，非 5 种）

| 条件 | 触发场景 | 模型 |
|------|---------|------|
| 架构假设变更 | 施工发现架构假设不成立，需更新架构简报 | haiku（常规） |
| 安全敏感代码 | 认证、支付、用户数据、加密相关代码 | opus（安全） |
| 跨模块影响 | Task 修改了 >2 个模块的接口 | haiku（常规） |

**不再触发的场景**（v2.0 中必审改为 Fast Path 跳过）：
- 常规 CRUD → Code Architect 审查即可
- 纯 UI 变更 → Code Architect 审查即可
- 配置变更 → Code Architect 审查即可

### 交叉模型铁律

- DA 审查必须使用与施工不同的模型
- model 参数显式指定，不得继承
- 施工用 DeepSeek → DA 用 Claude；施工用 Claude → DA 用不同 Claude 型号

### 攻击维度（5 维度，精简自 v2.0 的 6 维度）

1. **前提假设**：这个决策依赖什么假设？假设不成立会怎样？
2. **替代方案**：有没有更简单的做法？
3. **边界条件**：极端情况会怎样？（聚焦最可能的 2-3 种）
4. **安全风险**：攻击面在哪？
5. **依赖风险**：依赖挂了怎么办？

### 辩论收敛

- 每个决策最多 3 轮
- 无法共识 → 提交用户仲裁
- DA 不能质疑用户已确认的方向

---

## Code Architect（code-reviewer agent）

- **常驻**：❌ 事件触发（每个 Task 完成）
- **职责**：审查所有代码的质量、一致性、可维护性
- **模型**：haiku（低成本常规审查）
- **审查清单**：可读性、函数长度（<50行）、文件长度（<800行）、嵌套深度（<4层）、错误处理、命名规范
- **与 DA 的分工**：Code Architect 审查代码质量，DA 审查架构/安全决策

---

## QA Director（tdd-guide agent，交叉模型）

- **常驻**：✅ Build 阶段常驻
- **职责**：测试策略制定、覆盖率标准、测试用例生成
- **交叉模型铁律**：测试代码必须由不同于施工代码的模型生成
  - 施工用 DeepSeek → 测试用 Claude Sonnet 或 Haiku
  - 测试发现不了施工代码的 bug → 测试本身不合格，退回重写
- **覆盖率目标**：AI 生成代码 85-90%（高于人工代码 80%）
- **同义反复检测**：测试是否仅在验证代码当前行为（而非需求规格）？是否覆盖边界条件和异常路径？

---

## CSO（security-reviewer agent）

- **常驻**：❌ 事件触发
- **触发条件**：
  - 认证/授权代码变更
  - 支付/财务代码变更
  - 用户数据处理代码变更
  - 文件系统操作代码变更
  - 外部 API 调用代码变更
- **模型**：sonnet（安全审计不能降级）
- **职责**：安全审计、隐私合规、CSP 配置、密钥管理检查
- **高风险项目必跑**（--strict 模式下每个 Task 都触发）

---

## Requirement Analyst（requirement-analyst skill）

- **常驻**：❌ Pre-Align 阶段启动
- **触发条件**：用户需求描述不足（<3 句具体描述）或明确说"帮我想清楚"、"分析需求"
- **职责**：一对一苏格拉底式追问，深挖隐藏需求，输出结构化产品镜像
- **模型**：sonnet
- **工作流**：Phase 1 建立产品轮廓（5W1H）→ Phase 2 深入八个维度 → Phase 3 产品镜像
- **产出**：产品镜像（一句话定义 + 产品素描 + 核心场景演绎 + 界面地图 + 设计语言 + 交互规范 + 用户状态矩阵 + 内容策略 + 产品边界 + 待探明项）
- **与 PM 的分工**：
  - Requirement Analyst：探明产品长什么样、用户怎么用、感受如何（WHAT & HOW）
  - PM：商业模式假设、关键业务假设、任务拆解、优先级（WHY & WHEN）
- **产品镜像直接喂给 CTO+PM** 作为 Align 阶段的输入
- **铁律**：不评判用户想法、不推销方案、不跳过确认

---

## Design Director（studio skill）

- **常驻**：❌ 事件触发
- **触发条件**：
  - UI 前端开发 Task
  - 视觉设计 Task
  - 像素艺术/游戏素材 Task
  - 用户明确要求"好看"、"美化"、"设计感"
- **模型**：sonnet
- **职责**：设计思维前置（5 个问题）、视觉方向决策、设计 Token 定义、豆包 AI 视觉生成
- **工作流**：
  1. **Design Thinking**（必做）：回答 Purpose / Audience / Tone / Hero Moment / Anti-Pattern
  2. **方向选择**：从 11 种 Tone Spectrum 中选定一个方向并全力执行
  3. **视觉生成**（可选）：调用 doubao Seedream 生成设计稿
  4. **Token 提取**（可选）：调用 doubao Vision 从设计稿提取设计 Token
  5. **施工监督**：Reasonix 施工完成后，screenshot + doubao Vision 6 维度审查
- **设计 Token 交付**：色彩系统（oklch + 3-tier CSS 变量）、字体配对（display+body）、动效策略、空间构成方案
- **反模板铁律**：禁止 Inter/Roboto/Arial/Space Grotesk、禁止白底+紫蓝渐变、禁止居中卡片网格、禁止纯色扁平背景
- **与 Code Architect 的分工**：
  - Design Director：视觉质量、设计一致性、用户体验
  - Code Architect：代码质量、命名规范、架构一致性

---

## 施工队

| 工具 | 角色 | 适用场景 | 模型 | 调度方式 |
|------|------|---------|------|---------|
| Reasonix | **主力施工** | 常规 CRUD、业务逻辑、UI、配置 | DeepSeek V4-Flash/Pro，prefix-cache 优化 | `reasonix run "task"` headless |
| Claude Subagent | **第二施工** | 安全敏感、高风险并行、复杂推理 | Claude Sonnet/Opus，独立生成 | Agent 工具 spawn |
| OpenCode | **备用施工** | Reasonix 不可用时降级 | 灵活多模型 | `dispatch/opencode.sh` |
| CEO | **兜底施工** | 三者都不可用 | — | 直接写代码 |

> **为什么 Reasonix 替代 OpenCode 当主力**：公司模式中 Claude Subagent 本就承担安全/高风险/复杂推理（Claude 模型），常规施工切到 Reasonix 获得 DeepSeek prefix-cache 极致降本（缓存命中率 90%+）。两者互补覆盖全场景。OpenCode 保留为 Reasonix 不稳定时的降级路径。

### 任务分配策略

```
Task 类型判断:
  ├── UI/视觉/像素艺术? → Design Director (studio) 先行设计确认 → Reasonix 施工
  ├── 安全敏感? → Claude Subagent（不同模型独立生成）
  ├── 高风险核心? → Reasonix + Claude Subagent 并行 → 交叉验证 → CEO 合并
  ├── 复杂推理? → Claude Subagent（推理质量优先）
  └── 常规功能 → Reasonix（低成本高缓存）
```

### 并行规则

- 高风险 Task：Reasonix + Claude Subagent **同时**独立生成，禁止串行（串行丧失独立视角）
- 结果不一致 → CEO 合并或提交用户仲裁
- 施工队消耗不计入主线程 Token 预算

---

## 调度原则

1. **Pre-Clarify 先于 Align** — 需求模糊时 Requirement Analyst 先探明再对齐，不带着模糊需求进架构设计
2. **Step 0 先于一切** — 工具链不验证不启动
3. **Align 并行不串行** — CTO + PM + DA 同时启动
4. **Build 事件驱动** — Agent 不在需要时不出现在上下文中，省 Token
5. **审查并行触发** — Code Architect + QA Director 同时审查，Design Director 并行触发（UI Task）
6. **CEO 全程在岗但不转发信息** — Agent Teams 直接通信，CEO 监控 + 仲裁
7. **DA 聚焦高风险** — 不为审查而审查，审查成本与风险成正比
8. **CEO 施工兜底** — Reasonix + Claude Subagent 都不可用时 CEO 直接写代码
9. **每个 Phase 结束触发复盘** — 度量数据驱动，不靠感觉
