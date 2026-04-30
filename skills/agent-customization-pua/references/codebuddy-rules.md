# CodeBuddy Rules (`RULE.mdc`)

Use this when a CodeBuddy configuration must be loaded as a rule instead of a skill or ad-hoc instruction.

## Locations

| Path | Scope | Notes |
|------|-------|-------|
| `.codebuddy/rules/<name>/RULE.mdc` | Workspace / project | Tracked by Git, shared by the team |
| `~/.codebuddy/rules/<name>/RULE.mdc` | User profile | Personal/global, not tracked by Git |

Windows user-level example:

```text
C:\Users\huangwen\.codebuddy\rules\default-agent-flow\RULE.mdc
```

## Frontmatter

```yaml
---
description: 全局默认 AI 协作流程
alwaysApply: true
enabled: true
provider:
---
```

| Field | Meaning |
|---|---|
| `description` | Human/model-readable purpose of the rule |
| `alwaysApply` | `true` means load the full rule in every chat session |
| `enabled` | Whether the rule participates in loading |
| `provider` | Provider metadata; may be empty |

## Load modes

| Mode | Configuration / Trigger | Use case |
|---|---|---|
| Always | `alwaysApply: true` | Core workflow, coding standards, safety constraints |
| Agent-requested | `alwaysApply: false` plus useful `description` | Reference docs or optional workflow guidance |
| Manual | mention with `@rule-name` | One-off guidance |

## PUA default-agent-flow template

> **⚠️ 稳定触发要求（已验证）**：仅配置 `use_skill("using-superpowers-pua")` 的最小 RULE.mdc **不足以**稳定触发 PUA 流程。
> CodeBuddy 需要同时满足：
> 1. RULE.mdc 存在且 `alwaysApply: true`
> 2. RULE.mdc 内容包含完整协作规范（不能只有单行 `use_skill` 指令）
>
> 推荐直接复制项目 `.codebuddy/rules/pua-default-flow/RULE.mdc` 的完整内容模板。

```markdown
---
description: 全局默认 AI 协作流程（PUA-Driven Spec Engineering）
alwaysApply: true
enabled: true
provider:
---

# 仓库协作规范

## 默认技能流程

每次对话开始时，第一个动作必须是 `use_skill("using-superpowers-pua")`，由其完成接任务、门禁判断和技能路由。普通问题走 G0/G1 轻量快放，高压问题走完整 PUA 流程。

## PSE 核心纪律（概要）

- 三维自适应门禁：需求成熟度 + 变更风险 + 复合升级
- 风险等级快速设定：消息以 R0:/R1:/R2:/R3:/R4: 开头即直接定调
- Proposal 确认后路径选择：A（完整 Specs）或 B（writing-plans 快速路径）
- R2+ 变更必须有 OpenSpec 文档落地

## 用户硬性规则

- 默认简体中文；代码/命令/路径保持原文
- 最小范围修改；只补必要注释
- 默认自主执行到可交付结果；只在真正模糊/危险操作前提问
```

## Verification

After creating or editing a rule, start a new CodeBuddy chat session. Existing sessions do not automatically reload changed rules.

Ask:

```text
当前应用了哪些规则？
```

Expected: the response includes the rule name/description such as `default-agent-flow` / `全局默认 AI 协作流程`.

Then verify skill routing separately:

```text
use_skill("using-superpowers-pua")
```

Expected: the assistant loads `using-superpowers-pua` and then enters `pua-gate`.
