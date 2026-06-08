# L6: 多Agent编排——指挥官模式

> 阶段：3（伴随Phase 5）
> 目标：理解多Agent协作的核心模式和通信协议

## 1. 为什么需要多Agent

**单Agent的局限**：
- Context Window有限（塞不下所有上下文）
- 一个模型很难同时在架构和代码细节上都做好
- 没有自我纠错机制（自己的错自己很难看出来）

**多Agent的优势**：
- 每个Agent只带自己需要的信息（Context隔离）
- 专人专事（架构师做设计，施工队写代码）
- 互相制衡（DA挑战CEO，Code Architect审查施工队）

## 2. 五种编排模式

### 2.1 顺序管道（Pipeline）
```
Agent1 → Agent2 → Agent3
```
Company Mode的Phase 1→2→3就是这种。

### 2.2 并行执行（Parallel）
```
       ┌→ Agent A
Coord  ┼→ Agent B
       └→ Agent C
```
Phase 5中OpenCode和Codex同时施工不同模块。

### 2.3 辩论模式（Debate）
```
Agent A → 辩论 ← Agent B
         ↓
       裁决者
```
CEO和DA的对抗审查就是这种。

### 2.4 审查模式（Reviewer）
```
Agent A → 产出 → Agent B → 审查意见 → Agent A → 修正
```
Code Architect审查施工队代码 -> 施工队修改。

### 2.5 层次化（Hierarchical）
```
      SuperVisor
     /    |    \
  Agent1 Agent2 Agent3
```
Company Mode的整体架构：CEO → CTO/PM/DA → OpenCode/Codex。

## 3. Agent间通信的三种方式

| 方式 | 优点 | 缺点 | Company Mode中使用 |
|------|------|------|-------------------|
| 文件传递 | 可靠、可追溯 | 有延迟 | 架构文档、任务文件 |
| MCP协议 | 实时、标准化 | 需要服务端 | Codex的MCP Server |
| 结构化消息 | 精确、可验证 | 需要定义格式 | 决策记录、审查报告 |

## 4. 上下文隔离——多Agent的核心价值

**问题**：如果所有信息都塞给一个Agent，它会"迷失"——分不清什么重要。

**解决**：每个Agent只获取它需要的上下文：
- CTO不需要看测试细节
- 施工队不需要看安全策略
- DA只需要看决策内容，不需要看完整架构

**代价**：隔离可能导致信息不对称。解决方案——CEO作为信息中枢，判断什么信息需要跨Agent传递。

## 5. Agent的失败模式

| 模式 | 表现 | 预防 |
|------|------|------|
| 无限循环 | 反复做同一件事 | Layer 4重复检测 |
| 幻觉 | 编造不存在的API | 代码审查+测试 |
| 过度工程 | 写了不需要的代码 | "只做要求的"规则 |
| 方向漂移 | 偏离原始目标 | CEO监控纠偏 |
| 自我重复 | 争论已解决的事 | Layer 1轮次上限 |

## 深度思考

1. Company Mode的5种编排模式分别用在哪些地方？为什么选那种？
2. 如果把DA（对抗者）和CEO（决策者）角色互换会怎样？
3. Context隔离的"度"怎么把握？隔离太多会怎样？隔离太少会怎样？

## 动手验证

在Company Mode的当前项目中，找出至少3个Agent间传递的文件。画出这些文件的流向图。
