# 度量报告

> 每次 `/company start` 完成后自动生成。数据驱动复盘。

---

## 项目信息

- **项目名**：[填入]
- **模式**：[Fast Path / --strict]
- **启动时间**：[填入]
- **完成时间**：[填入]
- **总耗时**：[填入]

---

## Token 消耗分布

### 按 Phase

| Phase | 预算 | 实际 | 占比 | 状态 |
|-------|------|------|------|------|
| Pre-Clarify (若启动) | 30K | XXK | XX% | ✅/⚠️/🔴 |
| Align | 40K | XXK | XX% | ✅/⚠️/🔴 |
| Build | 150K | XXK | XX% | ✅/⚠️/🔴 |
| Verify | 20K | XXK | XX% | ✅/⚠️/🔴 |
| **合计** | **240K** | **XXK** | 100% | — |

### 按 Agent

| Agent | Token 消耗 | 占比 | 调用次数 | 平均/次 |
|-------|-----------|------|---------|--------|
| CEO | XXK | XX% | — | — |
| Requirement Analyst | XXK | XX% | 1（若启动） | XXK |
| CTO | XXK | XX% | 1 | XXK |
| PM | XXK | XX% | 1 | XXK |
| DA | XXK | XX% | X 次触发 | XXK |
| Code Architect | XXK | XX% | X Task | XXK |
| QA Director | XXK | XX% | X Task | XXK |
| CSO | XXK | XX% | X 次触发 | XXK |
| Design Director | XXK | XX% | X 次触发 | XXK |

### 按施工工具

| 工具 | Token 消耗 | Task 数 | 通过 | 失败 | 通过率 |
|------|-----------|--------|------|------|------|
| Reasonix | XXK | X | X | X | XX% |
| Claude Subagent | XXK | X | X | X | XX% |
| OpenCode (fallback) | XXK | X | X | X | XX% |
| Studio → Reasonix | XXK | X | X | X | XX% |
| Reasonix+Subagent 并行 | XXK | X | X（合并后） | — | — |

---

## 质量指标

| 指标 | 值 | 目标 | 状态 | 趋势 |
|------|-----|------|------|------|
| 施工一次通过率 | XX% | >80% | ✅/⚠️/🔴 | ↑/→/↓ |
| DA 拦截率 | XX% | 10-30% | ✅/⚠️ | ↑/→/↓ |
| Design Dir 通过率 | XX% | >90% | ✅/⚠️/🔴 | ↑/→/↓ |
| Self-Healing 成功率 | XX% | >60% | ✅/⚠️/🔴 | ↑/→/↓ |
| 测试覆盖率 | XX% | ≥85% | ✅/⚠️/🔴 | ↑/→/↓ |
| 安全漏洞发现数 | X | 0 高危 | ✅/⚠️/🔴 | — |

---

## 失败分类分布

| 类别 | 次数 | 占比 | 涉及 Task | 是否已解决 |
|------|------|------|---------|----------|
| 规格模糊 | X | XX% | T-X, T-Y | ✅/❌ |
| 实现复杂 | X | XX% | T-X | ✅/❌ |
| 工具限制 | X | XX% | T-X | ✅/❌ |
| 模型能力 | X | XX% | T-X | ✅/❌ |

---

## 施工队降级事件

| # | Task | 原因 | 兜底方式 | 影响 |
|---|------|------|---------|------|
| 1 | T-X | Reasonix 不可用 | OpenCode 降级施工 | 延迟 10min |
| 2 | T-Y | Reasonix + OpenCode 均不可用 | CEO 直接写代码 | 延迟 30min |

---

## 复盘教训

| # | 教训 | 严重度 | 存入 retro-index? |
|---|------|--------|------------------|
| 1 | [一句话] | 🔴/🟡/🟢 | ✅/❌ |

---

## 对比上次项目

| 指标 | 上次 | 本次 | 变化 |
|------|------|------|------|
| 总 Token | XXK | XXK | ±XX% |
| 施工通过率 | XX% | XX% | ±XX% |
| DA 拦截率 | XX% | XX% | ±XX% |

---

> 此报告由 CEO 在 Verify 阶段自动生成。数据来源于各 Agent 调用记录和 Task 状态追踪。
