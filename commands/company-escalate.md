---
description: Manually escalate - intervene in current Company Mode task
type: skill
skill: company-mode
---

# /company-escalate

Manually intervene in the currently executing task. CEO presents current task details and offers intervention options.

**Input**: $ARGUMENTS

## Options

1. **Retry** - Force task to retry with current strategy
2. **Switch Builder** - Change builder (Reasonix ↔ Claude Subagent)
3. **Skip** - Skip current task and continue queue
4. **Manual Fix** - Output current task details, user provides fix
5. **Pause Queue** - Halt task queue, preserve all state
