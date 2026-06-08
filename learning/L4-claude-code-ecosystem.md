# L4: Claude Code生态系统——MCP、Skills、Hooks

> 阶段：1（伴随Phase 1-2）
> 目标：理解Claude Code的扩展机制

## 1. 三层扩展架构

```
┌─────────────────────────┐
│ Claude Code 核心         │  ← 终端交互、代码读写、Agent调度
├─────────────────────────┤
│ MCP (Model Context Prot) │  ← 连接外部工具（数据库、浏览器、API）
├─────────────────────────┤
│ Skills & Hooks           │  ← 自定义行为和自动化
└─────────────────────────┘
```

## 2. MCP——给Agent装外设

MCP让你可以通过标准协议给Claude Code接入任何外部工具：

```
Claude Code ──MCP──→ GitHub API ──→ 创建Issue/PR
            ──MCP──→ PostgreSQL ──→ 查询数据库
            ──MCP──→ Playwright ──→ 操作浏览器
            ──MCP──→ 自定义服务器 ──→ 任何你想做的事
```

**在Company Mode中**：Codex和OpenCode也支持MCP。理论上我可以通过MCP直接调度它们而不需要CLI命令。

**当前使用的MCP工具**：
- `mcp__github__*` — GitHub操作
- `mcp__playwright__*` — 浏览器自动化
- `mcp__context7__*` — 文档查询

## 3. Skills——给Agent装技能包

Skill是一个包含 `SKILL.md` 的文件夹，定义了一组专门的行为。

```
~/.claude/skills/company-mode/SKILL.md  ← 就是我们正在建的
```

**两个关键位置**：
| 位置 | 范围 |
|------|------|
| `~/.claude/skills/` | 全局，所有项目可用 |
| `<项目>/.claude/skills/` | 仅当前项目 |

**调用方式**：`/skill-name` 触发

## 4. Hooks——给Agent装自动化

三种Hook：
- **PreToolUse**：工具调用前触发（"用Write之前先检查文件大小"）
- **PostToolUse**：工具调用后触发（"编辑完代码自动格式化"）
- **Stop**：会话结束时触发（"结束时跑一遍构建"）

## 5. CLAUDE.md——给Agent装人格

加载优先级（高→低）：
```
CLAUDE.local.md > 项目CLAUDE.md > ~/.claude/CLAUDE.md > 组织策略
```

**在Company Mode中**：你的 `~/.claude/CLAUDE.md` 就是我的人格层。Company Mode的技能文件是我的技能层。两者互不冲突——人格层影响"我怎么想"，技能层影响"我怎么做"。

## 6. 这些机制的关系

```
CLAUDE.md        → 我是谁（人格）
Skills           → 我会什么（能力）
Hooks            → 自动做什么（习惯）
MCP              → 我能用什么工具（外设）
Company Mode     → 怎么组织这些一起干活（组织架构）
```

## 深度思考

1. 如果把Company Mode做成MCP Server而不是Skill，会有什么不同？
2. Hooks能不能用来强制执行5层死循环防护？（提示：PreToolUse可以拦截工具调用）
3. 你现在的 `~/.claude/CLAUDE.md` 和 `D:\Claudecode\CLAUDE.md` 会不会冲突？

## 动手验证

运行 `/skills` 看看当前加载了哪些Skill。找到 `company-mode`，确认它是从 `~/.claude/skills/` 加载的。
