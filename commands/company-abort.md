---
description: Emergency stop Company Mode - save checkpoint, clean up worktree
type: skill
skill: company-mode
---

# /company-abort

Emergency stop. Saves all state and exits cleanly.

**Input**: $ARGUMENTS

## What This Does

1. **Save Checkpoint** - Commit all worktree changes with status annotation
2. **Kill Active Tasks** - Send abort signal to all running agents
3. **Preserve Worktree** - Keep worktree for later inspection/recovery
4. **Generate Abort Report** - List completed tasks, in-progress tasks, blocked tasks
5. **Clean Exit** - Return to main working tree

## Recovery

To resume from the abort checkpoint:
```bash
git worktree list  # Find the saved worktree
# Re-run /company start to resume from last checkpoint
```
