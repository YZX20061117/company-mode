# 三阶段流水线

## 总览

```
Pre-Clarify ──→ Align ────────────→ Build ────────────→ Verify
(需求探明)      (一次性对齐)         (Agent Teams 施工)   (最终审计)

Requirement     CTO + PM 并行        Task Queue 自领      交叉模型审计
Analyst 苏格    DA Pre-Mortem        Subagent-per-task    度量报告
拉底式追问      → Kill List          事件驱动审查         用户验收
                                       + Studio 视觉审查
🛑 确认产品镜像  🛑 用户确认(1次)     施工→更新规格        🛑 用户验收(1次)
```

---

## Step 0：工具链验证（所有阶段之前）

```
验证清单：
  □ Reasonix 文件读写测试（reasonix run "创建 test.txt 写入 hello 并删除"）
  □ Claude Subagent 文件读写测试（Agent 工具 spawn 独立 subagent）
  □ OpenCode 备用验证（Reasonix 不可用时的降级路径确认）
  □ 编译/构建工具能正常运行
  □ Git worktree 创建/删除正常
  □ 全部通过 → 进入流水线
  □ 任一失败 → 报告用户，决定是否绕行
```

**关键规则**：测试必须在项目实际工作目录下进行，不能用临时目录。L-001 教训：临时目录通过不代表实际目录能用。

---

## Phase -1: Pre-Clarify（可选 — 需求模糊时启动）

**目标**：在架构设计之前，先通过苏格拉底式追问把用户心中模糊的产品想法挖透、挖具体。Phase -1 产出的"产品镜像"直接喂给 Align 阶段的 CTO+PM，避免带着模糊需求进架构设计。

### 触发条件（满足任一即启动）

1. 用户需求描述 <3 句具体描述
2. 用户明确说"帮我想清楚"、"分析需求"、"剖析需求"、"这个想法怎么样"
3. 需求中没有提到具体的使用场景或用户画像
4. 用户主动触发 `/requirement-analyst`

**不触发的场景**：用户给了详细的 PRD/规格文档/具体功能列表，直接进入 Phase 0 Align。

### 流程

1. **Requirement Analyst 启动**（sonnet，独立上下文）
   - Phase 1: 建立产品轮廓（5W1H 框架，一次性抛全部问题）
   - Phase 2: 深入八个维度（每轮 1-2 个问题，苏格拉底式追问到尽头）
     - 产品形态 / 核心场景与用户旅程 / 界面与交互 / 内容与信息架构
     - 视觉与情感设计 / 用户状态与边界情况 / 数据与智能 / 产品边界与演化
   - Phase 3: 产品镜像（结构化输出所有探明的细节）

2. **用户确认产品镜像**
   - 用户说"差不多就是这样了" → 进入 Phase 0 Align
   - 用户修正 → 更新镜像再确认

### 产出 → 喂给 Align

```
产品镜像 → CTO（架构设计 + 技术选型）
         → PM（关键假设 + 任务拆解）
```

`产品镜像` 包含：一句话定义 + 产品素描 + 核心场景演绎 + 界面地图 + 设计语言 + 交互规范 + 用户状态矩阵 + 内容策略 + 产品边界 + 待探明项

### 门控

🛑 **用户确认产品镜像才进入 Align**。用户说"不对"→ 继续追问。用户确认 → 镜像冻结，进入 Align。

### Token 预算：30K（80% 警告 24K → 浓缩追问维度，100% 硬停）

---

## Phase 0: Align（一次性对齐）

**合并 v2.0**：Phase 0 Pre-Mortem + Phase 1 ARCH + Phase 2 DETAIL

**输入**：若 Pre-Clarify 启动过，CTO+PM 基于已确认的"产品镜像"进行架构设计和任务拆解。若跳过 Pre-Clarify，CTO+PM 基于用户原始需求启动。

**目标**：一次性对齐方向，产出精简但足够的信息让 Build 阶段 Agent Teams 自主施工。

### 流程

1. **CTO + PM 并行启动**（不串行，不同模型）
   - CTO（architect, sonnet）：架构草案 + 技术选型 + 平台合规规则 + 风险矩阵
   - PM（pm-planner, sonnet）：需求拆解 + 关键业务假设列表 + 任务分解树

2. **CEO 合成**两份产出 → 一页纸架构简报（[architecture-brief.md](templates/architecture-brief.md)）

3. **DA 并行执行 Pre-Mortem**（交叉模型）→ 回答 4 个核心问题：

   ```
   1. 什么情况下这个项目会彻底失败？
   2. 最大的单一风险是什么？（只选一个最致命的）
   3. 如果必须在 1/3 的预算/时间内完成，你会砍掉什么？
   4. 如果有 10 倍用户量，什么会先崩？
   ```

   产出：**Kill List**（[kill-list.md](templates/kill-list.md)）

4. **CEO 提交用户确认**：架构方向 + Kill List + 业务假设列表

### 产出

| 文件 | 内容 | 用途 |
|------|------|------|
| `architecture-brief.md` | 一页纸：架构方向+技术栈+数据流+风险矩阵 | Build 阶段 Agent 的上下文 |
| `kill-list.md` | 致命风险清单（3-5条） | 每个 Task 携带相关条目 |
| `task-tree.md` | 任务分解树 | Build 阶段 Task Queue 的种子 |

### 门控

🛑 **唯一一次设计方向确认**。用户说"方向不对"→ 回退调整。用户确认 → 进入 Build，不再暂停。

### Token 预算：40K（80% 警告 32K → 自动降级低价模型，100% 硬停）

---

## Phase 1: Build（Agent Teams 持续施工）

**合并 v2.0**：Phase 3 REVIEW + Phase 4 CONFIRM + Phase 4.5 + Phase 5 EXECUTE + Phase 5.5 Self-Healing

**目标**：Agent Teams 自主施工。用户不暂停，CEO 报告进度。

### 初始化

1. **创建 Worktree**
   ```bash
   git worktree add ../<project>-build build-branch
   ```
   施工全程在 worktree 内进行，不污染主工作树。

2. **Phase 4.5 验证**
   ```
   □ 编译/构建在 worktree 中通过
   □ Reasonix 在 worktree 中可读写（reasonix run 测试）
   □ Claude Subagent 在 worktree 中可读写
   □ OpenCode 备用路径在 worktree 中可读写
   ```

3. **Task Queue 初始化**
   - 从 `task-tree.md` 加载任务
   - 每个 Task 标注：类型（CRUD/BusinessLogic/UI/Architecture/Security/Core）、预估复杂度、依赖关系
   - 为 `类型 = UI` 的 Task 创建 `.company/` 目录（存放 studio 产出物）

4. **CEO 广播**：架构简报 + Kill List + Task Queue → 所有 Build Agent

### Agent Teams 施工循环

```
循环（直到 Task Queue 为空）:

1. Agent 自领下一个未分配 Task
   分配策略：
     - 安全敏感 Task → Claude Subagent（不同模型独立生成）
     - 高风险核心 Task → Reasonix + Claude Subagent 并行 → 交叉验证 → CEO 合并
     - UI/视觉/像素艺术 Task → Design Director (studio) 先行设计确认 → Reasonix 施工
     - 复杂推理 Task → Claude Subagent（推理质量优先）
     - 常规功能 Task → Reasonix（低成本高缓存）

2. CEO 派发前门控（Pre-Dispatch Gate）
   
   IF task.类型 === "UI" THEN:
     检查: .company/design-brief-{TASK_ID}.md 是否存在
     → 存在 → 放行，派发给施工 Agent
     → 不存在 → 🛑 阻塞！
        原因: UI Task 必须先经过 studio 设计思考 + Design Token 交付
        动作: CEO 调用 studio skill → 产出 design-brief → 重新检查
   
   其他类型 → 直接放行

3. Subagent-per-task
     - 全新 subagent，只携带：
       * 该 Task 涉及的文件路径
       * architecture-brief.md（一页纸）
       * Kill List 中与该 Task 相关的条目
       * 该 Task 的技术规格
       * 若为 UI Task：design-brief-{TASK_ID}.md（studio 设计输出）
     - 不携带之前 Task 的上下文
     - 施工完成后标记 Task 状态为 done

4. CEO 完成前门控（Pre-Completion Gate）
   
   IF task.类型 === "UI" THEN:
     检查: .company/design-review-{TASK_ID}.md 是否存在
     AND review 结论是否为 "通过"
     → 通过 → Task 标记 done
     → 不通过 → 🛑 阻塞！
        原因: UI Task 必须通过 Design Director 6 维度视觉审查
        动作: CEO 调用 studio 执行 doubao Vision review
              → 通过 → 产出 design-review → Task done
              → 不通过 → 退回 Reasonix 修复 → 重新施工 → 再次 review

5. Task 完成事件 → 并行触发审查
   
   自动触发（每个 Task）：
     Code Architect（haiku） ← 代码质量审查
     QA Director（sonnet）   ← 测试生成（不同模型）
   
   条件触发：
     DA  ← 仅当：架构假设变更 / 安全敏感 / 跨模块影响
     CSO ← 仅当：认证/支付/数据/文件操作代码
     Design Director ← 仅当：UI/视觉/像素艺术 Task（在步骤 4 已完成，此处跳过）

6. 测试失败 → Self-Healing（最多 3 轮）
   
   失败分类：
     - 规格模糊  → 通知 CTO 澄清规格，更新架构简报
     - 实现复杂  → 通知 PM 拆分 Task
     - 工具限制  → 切换施工工具（Reasonix ↔ Claude Subagent ↔ OpenCode）
     - 模型能力  → 升级模型（Flash → Pro / Sonnet → Opus）/ 标记降级事件
   
   3 轮仍失败 → 标记阻塞 + 通知 CEO + 详细失败诊断

7. 施工发现架构问题 → 直接更新 architecture-brief.md
   - 不等到 Phase 结束
   - DA 下一轮审查验证架构变更合理性
```

### CEO 门控速查

```
                    ┌─────────────────────────────────┐
                    │         Task 被 Agent 自领        │
                    └─────────────┬───────────────────┘
                                  │
                          ┌───────▼───────┐
                          │ 类型 === UI ?  │
                          └───┬───────┬───┘
                              │ YES   │ NO
                              ▼       ▼
                    ┌─────────────┐  ┌──────────┐
                    │ design-brief│  │  直接派发  │
                    │ 文件存在?    │  └──────────┘
                    └──┬──────┬──┘
                  YES  │      │  NO
                       ▼      ▼
                 ┌────────┐ ┌──────────────┐
                 │ 派发施工 │ │ 🛑 阻塞       │
                 └───┬────┘ │ 调 studio    │
                     │      │ 产出 brief   │
                     ▼      └──────────────┘
              ┌──────────────┐
              │  施工完成      │
              └──────┬───────┘
                     │
              ┌──────▼───────┐
              │ 类型 === UI ? │
              └──┬───────┬───┘
                 │ YES   │ NO
                 ▼       ▼
         ┌─────────────┐ ┌──────────┐
         │ design-review│  │ 直接标记  │
         │ 存在且通过?   │ │ done     │
         └──┬──────┬────┘ └──────────┘
       YES  │      │  NO
            ▼      ▼
      ┌────────┐ ┌──────────────┐
      │  done  │ │ 🛑 阻塞       │
      └────────┘ │ 调 studio    │
                 │ Vision review│
                 │ → 修复 → 再审│
                 └──────────────┘
```

### Fast Path：差异化审查

| Task 类型 | Code Architect | QA | DA | CSO | Design Dir | 施工 | Token/Task |
|----------|:---:|:---:|:---:|:---:|:---:|------|:--------:|
| 常规 CRUD | ✅ | ✅ | — | — | — | Reasonix | ~10K |
| 复杂业务逻辑 | ✅ | ✅ | — | — | — | Reasonix/Subagent | ~20K |
| UI/视觉/像素 | ✅ | ✅ | — | — | ✅ | Studio → Reasonix | ~25K |
| 架构变更 | ✅ | ✅ | ✅ haiku | — | — | Reasonix | ~30K |
| 安全敏感 | ✅ | ✅ | ✅ opus | ✅ | — | Claude Subagent | ~40K |
| 高风险核心 | ✅ | ✅ | ✅ opus | ✅ | — | Reasonix+Subagent 并行 | ~60K |

### Checkpoint 提交

每完成一个 Wave（3-4 个 Task）：
```bash
git -C ../<project>-build commit -m "checkpoint: Wave N (Task X-Y)"
```
会话中断 → 从最近 checkpoint 恢复，不从头开始。

### 用户交互

**不暂停**。CEO 每完成 3 个 Task 报告一次进度：

```
CEO: Wave 1/3 (Task 1-4/12)
     ✅ T1-3 通过
     ⚠️ T4 Self-Healing 第 2 轮（失败类别: 规格模糊）
     Token: 85K/150K
```

用户随时可以：
- `/company status` — 详细进度、Agent 状态、Token 分布
- `/company escalate` — 介入任意 Task（中止/重开/手动修复）
- `/company abort` — 紧急停止，保存 checkpoint

### Token 预算：150K（施工队消耗不入主线程预算）

---

## Phase 2: Verify（最终审计）

**合并 v2.0**：Phase 6 AUDIT

### Verification 门控

```
全部通过才放行：
  □ 全量测试套件通过（QA Director 验证）
  □ 编译/构建零错误
  □ DA 终审通过（交叉模型，全面审查）
  □ CSO 安全扫描通过（高风险项目必跑）
  □ UI Task：Design Director 视觉审查通过（6 维度 doubao Vision review）
  □ 架构简报与实际代码一致（DA 验证）
  □ 任一失败 → 回 Build 修复 → 重新验证
```

### 度量报告

自动生成（[metrics-report.md](templates/metrics-report.md)）：

```
Phase -1 Pre-Clarify: XX K tokens | Requirement Analyst: XXk (若启动)
Phase 0 Align:        XX K tokens | CTO: XXk PM: XXk DA: XXk
Phase 1 Build:        XX K tokens | Reasonix: XXk Claude Subagent: XXk OpenCode(fallback): XXk
                      CA: XXk QA: XXk DA: XXk CSO: XXk Studio: XXk
Phase 2 Verify:       XX K tokens

施工通过率: XX% | DA 拦截率: XX% | Self-Healing 成功率: XX% | Design Dir 通过率: XX%
失败分类分布: 规格模糊 X次 | 实现复杂 X次 | 工具限制 X次 | 模型能力 X次
```

### 复盘

度量数据 + 关键教训 → 写入 [retro-index.md](learning/retro-index.md)。模式缓存按需更新。

### 用户验收

🛑 **唯一一次代码验收**。通过后合并 worktree：

```bash
git -C ../<project>-build push
git merge build-branch
git worktree remove ../<project>-build
```

---

## --strict 降级模式

`/company start --strict` 恢复完整门控：

| 差异 | 默认 | --strict |
|------|------|---------|
| Pre-Clarify | 需求模糊时触发 | 始终启动（即使需求看似清晰） |
| Align 确认 | 1 次 | 3 次（Kill List → 架构 → 任务树） |
| Build DA | 事件触发（3 条件） | 每个 Task |
| Build 暂停 | 无 | 每个 Wave 结束 |
| Build CSO | 事件触发 | 每个 Task |
| Build Design Dir | UI Task 触发 | 每个 UI Task + 3 轮 doubao review |
| Verify | DA 终审 | DA + CSO 全量 + Studio 全量视觉审计 |

适用于高风险项目（支付、认证、用户数据、合规敏感）。
