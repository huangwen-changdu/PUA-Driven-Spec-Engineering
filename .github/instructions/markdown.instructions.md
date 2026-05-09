---
applyTo: "**/*.md"
description: "Markdown documentation rules for PUA-Driven Spec Engineering"
---

# Markdown 文档规则

## Scope

适用于本仓库作为通用 AI 协作服务流程模板时的 Markdown 文档、规则文件、技能说明和 OpenSpec 文档。

## Rules

- 默认使用简体中文；代码、命令、路径、标识符保持原文。
- 修改中文文档时做最小范围编辑，不无故重写整文件或中英混排替换。
- 规则文档必须优先写“何时触发、下一步做什么、禁止什么”，少写抽象口号。
- 涉及 workflow / harness / agent 配置时，优先链接到 `AGENTS.md`、`skills/`、`.copilot/`、`graphify-out/` 的真实路径。
- 跨平台入口矩阵只维护在 `AGENTS.md`；`CLAUDE.md`、`.github/copilot-instructions.md`、`.codebuddy/rules/*/RULE.mdc` 只写对应 IDE 会加载的规则和共享事实源。
- 新增 frontmatter 时保持 YAML 合法；含冒号的 `description` 用引号包裹。
- 不在文档中声明“已完成/已验证”，除非附带命令、真实输出和判定。
