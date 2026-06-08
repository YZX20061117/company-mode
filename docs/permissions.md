# 权限边界

## 核心原则

```
项目目录内 + Worktree 内        项目目录外
─────────────────────           ─────────
✅ CEO 可直接审批                 ❌ 必须询问用户
```

## 项目目录内（CEO 自动审批）

以下操作在项目工作目录或 Build worktree 内时，CEO 可以直接批准：

### 文件操作
- 读/写/编辑项目内的任何文件
- 创建/删除项目内的目录
- 移动/重命名项目文件

### 工具调用
- Git 操作（commit, branch, checkout, diff, log, worktree, merge）
- 运行 linter/formatter
- 运行测试
- 运行构建

### 依赖管理
- npm/pip/cargo 等包管理器安装依赖
- 更新 package.json/requirements.txt 等

### 开发运行
- 启动开发服务器
- 运行脚本
- 数据库迁移（项目内的迁移脚本）

## Worktree 权限（v3.0 新增）

Build 阶段在独立 worktree 中进行，额外权限：

- 创建 worktree：`git worktree add ../<project>-build <branch>`
- Worktree 内文件操作：完全权限（与主项目目录相同）
- Worktree 内 git 操作：commit, branch, merge（不影响主工作树）
- Checkpoint commit：`git commit -m "checkpoint: Wave N"`
- Verify 后合并：`git merge build-branch`
- 清理 worktree：`git worktree remove ../<project>-build`

## 项目目录外（必须询问用户）

### 系统操作
- 修改系统配置
- 安装全局软件/工具
- 修改环境变量
- 修改 hosts 文件

### 外部服务
- 访问/修改生产数据库
- 调用付费 API
- 发送邮件/消息（Slack、钉钉等）
- 推送到远程仓库（首次推送新分支时确认，后续推送同一分支可自动）

### 敏感操作
- 修改 ~/.claude/ 下的配置（除非用户明确要求）
- 读写项目外的文件
- 删除有用户数据的目录

## 危险操作黑名单（绝对禁止，除非用户明确打字确认）

以下操作必须用户打字"我确认执行XXX"才能执行：

- `rm -rf` 或类似不可恢复的删除
- `git push --force` 到 main/master
- `git reset --hard`
- `git worktree remove --force`（跳过未提交变更的 worktree 删除）
- 数据库 DROP/TRUNCATE
- 修改生产环境配置

## 施工队权限

OpenCode 和 Claude Subagent 在 Build 阶段施工时：

### OpenCode
- 运行在 worktree 内
- 使用默认权限（非 `--dangerously-skip-permissions`）
- 遇到需要权限的操作时，暂停并交给 CEO 处理

### Claude Subagent（Agent 工具）
- CEO 通过 Agent 工具 spawn，指定不同模型
- 只携带该 Task 需要的上下文（Subagent-per-task）
- 运行在 worktree 内，工具权限继承 CEO 设置
- 施工完成后自动返回结果

### 共同规则
- 施工队只能操作 worktree 内的文件
- Worktree 外的项目文件只读
- 施工队遇到权限阻塞时 → 暂停 → CEO 处理
- 施工队不可用时 → CEO 兜底（标注"施工队降级事件"）

## 你参与的权限节点

以下情况 CEO 会主动找你：
1. 项目目录外的操作
2. 危险操作黑名单中的操作
3. 施工队遇到权限阻塞
4. 费用相关的决策（如使用付费模型、付费 API）
5. Worktree 合并冲突需手动解决
