# PUA-Driven Spec Engineering

> This file stores project metadata and data source index only. Collaboration rules live in `AGENTS.md`; platform-specific entries mirror it.

## Basic Info

- Project: `PUA-Driven Spec Engineering`
- Repository Type: Markdown-first universal AI workflow / service-process skill suite
- Service Scope: Reusable across arbitrary projects and teams; this repository is the template/distribution carrier, not the only target project
- Primary Flow: `superpowers-pua`
- Spec System: `openspec/`
- Skill System: `skills/{skill-name}/SKILL.md`
- Knowledge Graph: `graphify-out/`
- Learning Loop: `.copilot/`

## Data Source Index

| Source | Path | Responsibility | When to Read |
|--------|------|----------------|-------------|
| Collaboration Hub | `AGENTS.md` | Role, workflow, routing, hard constraints | Startup / workflow question |
| Claude Entry | `CLAUDE.md` | Claude Code platform entry | Claude Code sessions |
| Copilot Entry | `.github/copilot-instructions.md` | GitHub Copilot / VS Code entry | Copilot sessions |
| CodeBuddy Rule | `.codebuddy/rules/pua-default-flow/RULE.mdc` | CodeBuddy alwaysApply entry | CodeBuddy sessions |
| File Instructions | `.github/instructions/*.instructions.md` | File-scoped editing constraints | Editing matching files |
| Skills | `skills/{skill-name}/SKILL.md` | Domain workflow and SOP | Triggered by task type |
| Agent Customization | `skills/agent-customization-pua/SKILL.md` | Rules / prompts / skills / hooks / agent config | Initializing or fixing AI configuration |
| OpenSpec | `openspec/changes/{name}/` | Proposal, Specs, Design, Tasks | R2+, new feature, architecture/process change |
| Feature Ledger | `openspec/features/{feature}/README.md` | Long-running feature iteration history | Continuing an existing feature |
| Graphify Report | `graphify-out/GRAPH_REPORT.md` | Knowledge graph summary | Architecture / structure / impact questions |
| Graphify Wiki | `graphify-out/wiki/index.md` | Navigable wiki when present | Prefer over report if present |
| Learning Index | `.copilot/LEARNING_INDEX.md` | Pitfall trigger index | User correction / repeated failure / convention question |
| Learning Cards | `.copilot/cards/**/*.md` | Specific lessons and next actions | Only after index trigger match |

Initialized: 2026-05-09
