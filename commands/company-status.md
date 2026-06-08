---
description: View Company Mode progress - token usage, agent status, task queue
type: skill
skill: company-mode
---

# /company-status

Display current Company Mode pipeline status.

**Input**: $ARGUMENTS

## What This Shows

1. **Phase**: Current phase (Pre-Clarify / Align / Build / Verify)
2. **Task Queue**: Completed / in-progress / pending tasks
3. **Token Usage**: Per-phase and total token consumption
4. **Agent Status**: Active agents, idle agents, triggered events
5. **Checkpoint**: Last checkpoint commit reference
6. **Budget**: Remaining token budget, warning thresholds

## Format

```
CEO: Wave 2/4 (Task 5-8/14)
     ✅ T5-6 passed
     🔄 T7 in progress (Reasonix)
     ⏳ T8 pending (UI task - awaiting Design Director)
     Token: 85K/150K | Checkpoint: Wave 1 (commit a3f2b1c)
```
