---
name: pua-learning-loop
description: Use when a project needs to prevent repeated mistakes, handle user corrections, capture reusable lessons, or maintain progressive project learning data without loading all history upfront.
---

# PUA Learning Loop

## Overview

Turn repeated mistakes and user corrections into small, reusable project learning cards. Default to progressive disclosure: read the index first, read cards only when matched.

## When to Use

Use this skill when any learning signal appears:

- User corrects a rule, workflow, preference, path, field, or fact.
- The same failure appears for the second time.
- A task fails because validation, review, planning, or graph/context lookup was skipped.
- A project-specific workflow or module pitfall is discovered.
- User explicitly asks to remember,沉淀, avoid repeating, or initialize/update `.copilot` learning data.

Do not use for one-off business facts with no reuse value.

## Storage

Project learning data lives in the current repository:

```text
.copilot/
  PROJECT_BRIEF.md
  LEARNING_INDEX.md
  cards/**
  snapshots/**
```

Global user preferences belong in memory or user-level rules. Project-specific lessons belong in `.copilot/cards`.

## Progressive Disclosure

Never load all learning data at startup.

1. Normal task: read `PROJECT_BRIEF.md` if needed.
2. Learning signal: read `LEARNING_INDEX.md`.
3. Trigger match: read only the matched card.
4. Architecture/impact question: search code and read project docs.
5. Repeated match: update confidence or propose promotion.

Forbidden: full-read `.copilot/cards/**`, `archive/**`, or a giant `learned-patterns.md` as startup context.

## Project Initialization

When the user asks to initialize `.copilot` for any project, do not tell them to copy scripts manually. Use the bundled initializer:

```powershell
# Locate the script relative to this skill directory
# Default location: ~/.claude/skills/pua-learning-loop/scripts/init-copilot.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\.claude\skills\pua-learning-loop\scripts\init-copilot.ps1" -Root "<project-root>" [-ProjectName "<name>"] [-Force]

# Or if installed to a custom path, adjust accordingly:
# powershell -NoProfile -ExecutionPolicy Bypass -File "<skill-install-path>/pua-learning-loop/scripts/init-copilot.ps1" -Root "<project-root>" [-ProjectName "<name>"] [-Force]
```

```bash
# Linux/macOS (bash)
bash ~/.claude/skills/pua-learning-loop/scripts/init-copilot.sh [-Root "<project-root>"] [-ProjectName "<name>"] [-Force]

# Or if installed to a custom path, adjust accordingly:
# bash <skill-install-path>/pua-learning-loop/scripts/init-copilot.sh [-Root "<project-root>"] [-ProjectName "<name>"] [-Force]
```

Default behavior:

- Create `.copilot/` structure in the target repository.
- Create `PROJECT_BRIEF.md`, `LEARNING_INDEX.md`, snapshots, and starter `project-init` card.
- Create local commands under `.copilot/commands/`.
- Do not copy learning cards from another project.
- Do not overwrite existing files unless `-Force` is requested or clearly needed.
- After script completes, **must execute `agent-customization-pua` skill** to review/create agent customization files (`AGENTS.md`, `.instructions.md`, `.prompt.md`, `.agent.md`, `SKILL.md`). This ensures the project has proper agent discovery configuration from day one. Note: `copilot-instructions.md` is a valid VS Code file type, but this project consolidates it into `AGENTS.md` to avoid duplication.

If the target project is the current workspace, infer `-Root` from the workspace path. If the user names another path, use that path directly.

## Learning Card

A valid card must say what to do next time:

```text
学习卡：
- 触发：<下次遇到什么信号>
- 教训：<这次踩坑说明什么>
- 下次动作：<先做 Y，不做 Z>
- 范围：session | project | global | skill | module
- 关联：<files / docs>
```

Never write “下次注意”. Write: “下次遇到 X，先做 Y，不做 Z.”

## Promotion Rules

| Signal count | Action |
|---:|---|
| 1 | Create/update card, confidence 0.3-0.5 |
| 2 | Raise confidence, force recall before acting |
| 3 | Propose `AGENTS.md` / CodeBuddy `RULE.mdc` update |
| 4+ | Propose PUA skill update or command automation |
| User explicit request | Promote immediately if scope is clear |

## Completion Hook

Before declaring completion, report learning status:

```text
学习闭环：
- 学习信号：无/有
- 召回记录：未查/索引/卡片
- 新增沉淀：无/学习卡/RULE/skill
- 下次拦截：<下次遇到 X 会先做什么>
```

## 主动学习询问

任务完成后，如果检测到以下任一情况，**主动询问用户是否要沉淀学习卡**：

- 完成过程中遇到了非显而易见的坑或绕路
- 发现了项目特有的约束、惯例或隐藏规则
- 修复了一个有复现模式的问题（不是一次性的）
- 用户在过程中纠正过方向或偏好
- 跨模块影响被识别但不在原始需求范围内

询问方式（轻量，不打断节奏）：

```text
📋 学习信号检测：本次任务发现 <一句话概括>，是否沉淀为学习卡？
  1. 沉淀 → 自动创建卡片并更新索引
  2. 跳过 → 不记录，继续
```

**不询问的场景**（避免噪音）：
- 简单的增删改查，无意外发现
- 已有学习卡覆盖同类教训（更新已有卡片即可，不重复询问）
- 用户明确表示不需要学习沉淀

**用户选择"沉淀"后的动作**：
1. 自动生成学习卡（遵循 Learning Card 格式，不写"下次注意"）
2. 更新 `LEARNING_INDEX.md`
3. 在 Completion Hook 的学习闭环中标注"新增沉淀：学习卡"

**用户选择"跳过"或无响应**：不记录，正常完成闭环。

## Bottom Line

Learning must reduce future mistakes without bloating current context: **index first, card on match, graph for structure, promote only after repetition.**
