# Learning Index

> Progressive disclosure index. Read this file first; read card body only when trigger matches.

| id | trigger | scope | domain | confidence | related | file |
|---|---|---|---|---:|---|---|
| project-init | Initialize project learning library; explain .copilot scope | project | workflow | 0.5 | `.copilot/PROJECT_BRIEF.md`, `.copilot/LEARNING_INDEX.md` | `cards/project/project-init.md` |
| harness-config-hub | User asks to improve harness, service process, agent rules, skills, wiki, MCP, or project AI configuration | project | harness | 0.7 | `AGENTS.md`, `CLAUDE.md`, `.github/copilot-instructions.md`, `.codebuddy/rules/pua-default-flow/RULE.mdc`, `skills/agent-customization-pua/SKILL.md` | `cards/project/harness-config-hub.md` |

## Read Rules

- Do not read learning cards without user correction, repeated failure, workflow deviation, missing verification, or project convention question.
- Read only cards matching trigger/domain/related.
- Do not full-read `cards/**` or `archive/**` at startup.
- Repeated match raises confidence; 3+ matches can promote to `AGENTS.md`, CodeBuddy `RULE.mdc`, or PUA skill.
