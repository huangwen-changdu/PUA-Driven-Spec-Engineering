# .copilot Project Learning Library

This directory stores project-level AI learning data.

## Progressive Disclosure

1. Normal task: read `PROJECT_BRIEF.md` if needed.
2. Learning signal: read `LEARNING_INDEX.md`.
3. Trigger match: read only the matched `cards/**/*.md`.
4. Architecture or impact question: search code and read project docs.

## Commands

```powershell
.\.copilot\commands\init-project-learning.ps1 -Force
.\.copilot\commands\add-learning-card.ps1 -Id "example" -Trigger "signal text" -Scope "project" -Domain "workflow" -Lesson "lesson text" -Action "next time do Y, not Z"
```
