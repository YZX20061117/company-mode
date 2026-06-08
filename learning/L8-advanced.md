# L8: 进阶——Memory、RAG与Fine-tuning

> 阶段：5（项目完成后）
> 目标：理解更高级的Agent能力

## 1. Memory——让Agent记住

### 三层Memory

```
工作记忆 (Context Window)     ← 当前对话，实时
    ↓ 会话结束就消失
短期记忆 (RAG/向量数据库)     ← 跨会话，基于检索
    ↓ 需要时才加载
长期记忆 (Fine-tuned模型)    ← 永久内化
    ↓ 成为模型的一部分
```

### 在Company Mode中

- 工作记忆：当前Phase的所有讨论
- 短期记忆：项目的 `.claude/company/` 目录（state.json、decisions/、retrospectives/）
- 长期记忆：你的 `~/.claude/CLAUDE.md` 和 编码规则（影响每次对话）

## 2. RAG——检索增强生成

**本质**：不是把所有信息塞进Context Window，而是需要的时候再去查。

```
用户问题 → 检索相关文档 → 把检索结果追加到对话 → LLM生成回答
```

**关键参数**：
- 文档怎么切分（Chunk Size）
- 用什么Embedding模型（文本→向量）
- 检索多少条（Top-K）
- 怎么排序（Reranking）

**什么时候需要RAG**：
- 文档太多，Context Window装不下
- 信息经常更新，不想每次重新训练
- 需要精确引用（从文档中找答案）

## 3. Fine-tuning——让模型学新技能

**本质**：拿一个基础模型，用你自己的数据再训练一下。

**对比**：

| | Prompt | RAG | Fine-tuning |
|--|--------|-----|-------------|
| 原理 | 在对话中给指令 | 检索+注入 | 改变模型权重 |
| 成本 | 低 | 中 | 高 |
| 更新速度 | 即时 | 即时 | 需要重新训练 |
| 适合 | 临时任务 | 知识检索 | 改变行为风格 |

**什么时候值得Fine-tune**：
- 有大量高质量标注数据（至少500+条）
- Prompt+ RAG已经到瓶颈
- 需要模型学会特定的输出格式/风格（不是知识）

**实际上**：对个人开发者来说，Fine-tuning通常不是优先选项。先把Prompt和RAG用到极致。

## 4. Evaluation——怎么知道Agent变好了

### LLM-as-Judge

用一个强大的LLM给另一个Agent的输出打分：

```markdown
# 评估提示
你是代码审查专家。对以下代码从以下维度打分（1-10）：
- 可读性
- 错误处理
- 性能
...
```

### 关键原则
1. 先建Golden Test Set（人工标注的10-50条标准答案）
2. LLM Judge和人工标注一致性 ≥ 80%才算可用
3. 不要只打分，要结构化反馈（具体哪里好/不好）

## 5. 从用户到架构师——你学完了

回顾学习路线：
```
L1 → L4 → L3 → L5 → L6 → L7 → L8
基础  工具  Agent  架构  编排  生产  进阶
```

**95分的Agent工程师应该能**：
- 设计多Agent系统架构
- 选择合适的编排模式
- 设计Agent间的通信协议
- 处理Agent的失败模式
- 评估Agent系统的质量
- 做出"建"vs"买"vs"不做"的判断

**继续精进的方向**：
- 读源码：LangGraph、AutoGen、CrewAI的源码
- 做项目：用学到的知识自己设计一个Agent系统
- 写分享：写文章/录视频教别人（教是最好的学）
- 跟踪前沿：arXiv、行业博客、开源项目更新

## 深度思考

1. 如果Fine-tuning能让模型学会Company Mode的流程，还需要 `~/.claude/skills/company-mode/` 这么长的规则文件吗？
2. RAG和Google搜索的区别是什么？在Agent系统中各适合什么场景？
3. 学完8篇，你对"AI Agent工程师"的理解和最开始有什么不同？

## 最后的动手验证

不看任何文档，手动画出Company Mode的完整架构图。包含：7个岗位、6个Phase、3个系统、文件流、Agent间通信方式。
