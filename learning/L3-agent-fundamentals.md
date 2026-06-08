# L3: Agent基础——ReAct循环与Tool Calling

> 阶段：2（伴随Phase 3-4）
> 目标：理解Agent的内部运行机制

## 1. Agent是什么

**本质**：Agent = LLM + 工具 + 循环决策

```
普通LLM：问 → 答（一轮结束）
Agent：  思考 → 行动 → 观察 → 思考 → 行动 → ... → 完成
```

**类比**：普通LLM是打电话问一个人问题，Agent是给这个人一本操作手册、一个工具箱、一个目标，让他自己在房间里干活。

## 2. ReAct循环——Agent的心脏

ReAct = Reasoning（推理）+ Acting（行动）

```
Step 1: [思考] "用户要我创建一个React项目"
Step 2: [行动] 执行 npx create-react-app my-app
Step 3: [观察] 命令执行成功，生成了项目文件
Step 4: [思考] "项目已创建，接下来需要添加路由"
Step 5: [行动] 执行 npm install react-router-dom
Step 6: [观察] 安装成功
Step 7: [思考] "所有依赖已就绪，任务完成"
```

**为什么重要**：Agent不是靠一次性算出的答案，而是靠"试→看→想→再试"的循环逼近目标。这解释了为什么Agent可能会在某个步骤卡住（工具调用失败→反复重试→陷入循环）——这就是我们为什么需要5层死循环防护。

## 3. Tool Calling——Agent的手

LLM本身只能生成文本。要让它能操作文件、执行命令、调用API，需要通过"工具"：

```json
{
  "tools": [{
    "name": "read_file",
    "description": "读取文件内容",
    "parameters": {"path": "string"}
  }, {
    "name": "execute_command", 
    "description": "执行终端命令",
    "parameters": {"command": "string"}
  }]
}
```

**关键细节**：LLM不执行工具，它只"说想用哪个工具"。真正执行的是框架层（Claude Code、OpenCode、Codex都自带这一层）。执行完后，结果会追加回对话，LLM再继续思考。

## 4. 三种Agent架构对比

| 架构 | 模式 | 代表 |
|------|------|------|
| 单Agent+多工具 | 一个Agent用多个工具 | Claude Code基础模式 |
| 多Agent分工 | 多个Agent各管一部分 | Company Mode（我们） |
| 层次化Agent | 上层Agent调度下层Agent | AutoGen、CrewAI |

**Company Mode是哪一种**？第3种——层次化。CEO（我）是上层，CTO/PM/DA是中层，OpenCode/Codex是施工层。

## 5. Agent的决策质量取决于什么

1. **上下文质量**（给了多少有用信息?）
2. **工具设计**（工具是否易用、参数是否清晰?）
3. **反馈质量**（工具的返回信息是否有用?）
4. **停止条件**（什么时候算完成?什么情况该停止?）

## 深度思考

1. 如果Agent的一个工具调用返回了错误，它怎么判断是"再试一次"还是"换个方法"？
2. Company Mode为什么要把CEO和施工队分开？如果让施工队自己决定做什么会怎样？
3. ReAct循环可能的最大问题是什么？（提示：想想Token消耗）

## 动手验证

在终端运行 `opencode run "在当前目录创建一个hello.txt文件，里面写hello world"`，观察它是怎么一步步思考→执行→验证的。
