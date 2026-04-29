---
name: agent-customization-pua
user-invocable: false
description: '**WORKFLOW SKILL (PUA版)** — 创建、更新、审查、修复 VS Code agent 定制化文件（.instructions.md、.prompt.md、.agent.md、SKILL.md、copilot-instructions.md、AGENTS.md）。USE FOR: 保存编码偏好；排查指令/技能/agent 被忽略或不触发的原因；配置 applyTo 模式；定义工具限制；创建自定义 agent 模式或专业工作流；打包领域知识；修复 YAML frontmatter 语法。DO NOT USE FOR: 一般编码问题（用默认 agent）；运行时调试或错误诊断；MCP 服务器配置（直接查 MCP 文档）；VS Code 扩展开发。INVOKES: 文件系统工具（读写定制化文件）、ask-questions 工具（访谈需求）、subagent 进行代码库探索。FOR SINGLE OPERATIONS: 快速 YAML frontmatter 修复或从已知模式创建单个文件时，直接编辑——不需要 skill。'
---

# Agent Customization (PUA 版)

基于 VS Code 官方 `agent-customization` skill，叠加 PUA 套件的高压执行规则。

## 决策流程

| 原语 | 何时使用 |
|------|---------|
| Agent Instructions | 始终生效，全项目通用 |
| CodeBuddy Rules | CodeBuddy 中需要总是加载、智能体按需加载或 `@规则名` 手动加载的团队/用户规则 |
| File Instructions | 通过 `applyTo` 模式显式匹配，或通过 `description` 按需发现 |
| MCP | 集成外部系统、API 或数据 |
| Hooks | 在 agent 生命周期节点执行确定性 shell 命令（阻止工具、自动格式化、注入上下文） |
| Custom Agents | 用于上下文隔离的子 agent，或带工具限制的多阶段工作流 |
| Prompts | 带参数化输入的单一聚焦任务 |
| Skills | 按需加载的工作流，附带打包资源（脚本/模板） |

## 速查表

详细模板、领域示例、高级 frontmatter 选项、资源组织、反模式和创建清单见参考文档。

| 类型 | 文件 | 位置 | 参考 |
|------|------|----------|------|
| agent instructions | `copilot-instructions.md`, `AGENTS.md` | `.github/` 或根目录 | [Link](./references/agent-instructions.md) |
| CodeBuddy Rules | `RULE.mdc` | `.codebuddy/rules/<name>/RULE.mdc`, `~/.codebuddy/rules/<name>/RULE.mdc` | [Link](./references/codebuddy-rules.md) |
| File Instructions | `*.instructions.md` | `.github/instructions/` | [Link](./references/instructions.md) |
| Prompts | `*.prompt.md` | `.github/prompts/` | [Link](./references/prompts.md) |
| Hooks | `*.json` | `.github/hooks/` | [Link](./references/hooks.md) |
| Custom Agents | `*.agent.md` | `.github/agents/` | [Link](./references/agents.md) |
| Skills | `SKILL.md` | `.github/skills/<name>/`, `.agents/skills/<name>/`, `.claude/skills/<name>/`, `.codebuddy/skills/<name>/` | [Link](./references/skills.md) |

**用户级别**：`{{VSCODE_USER_PROMPTS_FOLDER}}/`（*.prompt.md, *.instructions.md, *.agent.md；不含 VS Code skills）；CodeBuddy 用户级 rules 可放在 `~/.codebuddy/rules/<name>/RULE.mdc`，用户级 skills 可放在 `~/.codebuddy/skills/<name>/`。
定制化随用户设置同步漫游。

## 创建流程

如需探索或验证代码库中的模式，使用只读 subagent。如 ask-questions 工具可用，用它访谈用户澄清需求。

### 1. 确定范围

问用户定制化放在哪里：
- **Workspace**：项目特定、团队共享 → `.github/` 目录；CodeBuddy Rule → `.codebuddy/rules/<name>/RULE.mdc`
- **User profile**：个人、跨项目 → `{{VSCODE_USER_PROMPTS_FOLDER}}/`；CodeBuddy 用户规则 → `~/.codebuddy/rules/<name>/RULE.mdc`

### 2. 选择正确的原语

用上方决策流程表，根据用户需求选择合适的文件类型。

### 3. 创建文件

在对应路径直接创建：
- 使用各参考文件中的位置表
- 按需包含必要的 frontmatter
- 按模板添加正文内容

### 4. 验证

创建后：
- 确认文件在正确位置
- 验证 frontmatter 语法（`---` 之间的 YAML）
- 检查 `description` 存在且有意义

## PUA 叠加规则

本 skill 属于 superpowers-pua 套件，执行时叠加以下约束：

1. **闭环红线**：创建/修改定制化文件后，必须验证文件存在、frontmatter 语法正确、description 有效——不能"写了就跑"。
2. **Owner 意识**：发现现有定制化文件有配置问题（如 applyTo 过宽、description 缺失、YAML 语法错误），必须主动指出并修复，不能假装没看到。
3. **事实驱动**：声称"这个配置应该能工作"之前，先验证语法和路径。未验证的配置建议不是帮助，是埋坑。
4. **端到端交付**：不只写文件，还要确认定制化能被 agent 正确发现和加载。

## 边界判断

**Instructions vs Skill？** 适用于*大多数*工作 → Instructions。适用于*特定*任务 → Skill。

**Skill vs Prompt？** 都在聊天中作为斜杠命令出现（输入 `/`）。多步工作流+打包资源 → Skill。单一聚焦任务+参数输入 → Prompt。

**Skill vs Custom Agent？** 所有步骤能力相同 → Skill。需要上下文隔离（子 agent 只返回单一输出）或不同阶段不同工具限制 → Custom Agent。

**Hooks vs Instructions？** Instructions *引导* agent 行为（非确定性）。Hooks 通过生命周期事件（如 `PreToolUse` 或 `PostToolUse`）的 shell 命令*强制*行为——可以阻止操作、要求审批、或确定性地运行格式化工具。详见 [hooks 参考](./references/hooks.md)。

## 常见陷阱

**Description 是发现面。** `description` 字段是 agent 决定是否加载 skill/instruction/agent 的依据。触发词不在 description 里，agent 就找不到。使用 "Use when..." 模式加具体关键词。

**YAML frontmatter 静默失败。** 值中未转义的冒号、用 tab 而非空格、`name` 与目录名不匹配——都会导致静默失败且无错误提示。含冒号的 description 必须引号包裹：`description: "Use when: doing X"`。

**`applyTo: "**"` 烧上下文。** 意味着"每次文件请求都加载"——即使无关也会加载到上下文窗口。用具体 glob（`**/*.py`、`src/api/**`），除非该指令真的适用于所有文件。
