---
id: harness-config-hub
trigger: User asks to improve harness, service process, agent rules, skills, wiki, MCP, or project AI configuration
scope: project
domain: harness
confidence: 0.7
related:
  files:
    - AGENTS.md
    - CLAUDE.md
    - .github/copilot-instructions.md
    - .codebuddy/rules/pua-default-flow/RULE.mdc
    - skills/agent-customization-pua/SKILL.md
---

# Harness configuration hub

## Lesson

AI workflow repositories need a compact but explicit service-process hub. The harness is not only for the repository that stores it; it is a reusable workflow for all target projects. If Rules, Skills, Wiki, MCP, OpenSpec, graphify, and `.copilot` are only scattered across files, LLMs will miss routing steps, load the wrong context, or mistake the carrier repository for the only service target.

## Next Action

When a user asks to improve this harness, initialize project coding norms, or fix agent configuration: first load `agent-customization-pua`, then inspect `AGENTS.md`, platform entry files, `.codebuddy/rules`, `.github/instructions`, `.github/prompts`, `.copilot`, and `graphify-out`. Do not edit one entry while leaving the others divergent.

## Not Applicable

- One-off code edits unrelated to AI configuration.
- Pure documentation copy edits that do not affect workflow discovery.

## Evidence

- Source: 2026-05-09 harness refinement request.
- Key requirement: emphasize role/context, Rules/Skills/Wiki/MCP index, seven responsibilities, ten-stage workflow, communication constraints, `agent-customization-pua`, graphify, and `.copilot` learning loop.
- Correction: this harness is a service process for all users/projects; the carrier repository must not be treated as the only target project.
