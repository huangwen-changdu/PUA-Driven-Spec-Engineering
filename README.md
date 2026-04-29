# PUA-Driven Spec Engineering

> A comprehensive Claude Code skill suite for high-agency, exhaustive problem-solving with adaptive PUA pressure.


## What Is This

一套基于 Claude Code Skill 系统的 **PUA 驱动规格工程** 技能套件。核心思路：

- **自适应门禁**：普通问题 G0/G1 轻量快放，高压问题走完整 PUA 流程
- **三层机制**：主流程层 → 门禁层 → 条件升级层
- **穷尽一切**：通用方法论没走完不允许放弃
- **事实驱动**：没有查证的归因叫猜，没有验证的完成叫自嗨

## The Problems It Solves

LLM 编码时的常见问题：

- 隐含假设不验证，直接跑偏
- 过度工程，100 行能搞定写 1000 行
- 不该动的代码乱改
- 说"完成了"但没有验证证据
- 催压下跳步骤、降低质量
- 连续失败时原地打转不换策略

## The Solution: Three-Layer Architecture

| 层级 | 组件 | 职责 |
|------|------|------|
| **主流程层** | `superpowers-pua` 套件 | skill 路由与阶段推进 |
| **自适应门禁层** | `pua-gate` | 每阶段第 0 步强制门禁，按档位执行 |
| **条件升级层** | `pua-escalation` | 门禁升级/执行失控时收紧流程 |

### 门禁档位

- **G0/G1 PASS**：普通问题轻量快放，一行微标
- **G2 PASS**：多步骤任务简版门禁
- **ESCALATE**：调用 `pua-escalation`
- **BLOCKED**：补齐证据再继续

### 三条红线

1. **闭环意识**：没有验证输出，不叫完成
2. **事实驱动**：没有查证的归因，不叫判断
3. **穷尽一切**：方法论没走完，不叫解决不了

## Skill Suite (20 Skills)

### Entry
- `using-superpowers-pua` — 套件入口纪律
- `superpowers-pua` — 总入口，完整生命周期定义
- `pua-gate` — 自适应门禁
- `pua-escalation` — 压力升级器

### Design & Planning
- `brainstorming-pua` — 需求澄清与方案设计（OpenSpec）
- `using-git-worktrees-pua` — 隔离开发
- `writing-plans-pua` — 设计转计划

### Implementation & Debugging
- `test-driven-development-pua` — TDD 流程
- `systematic-debugging-pua` — 系统化调试
- `subagent-driven-development-pua` — 子 agent 执行
- `dispatching-parallel-agents-pua` — 并行调度
- `executing-plans-pua` — 单通道执行

### Quality & Finish
- `requesting-code-review-pua` — 发起 review
- `receiving-code-review-pua` — 处理反馈
- `verification-before-completion-pua` — 完成前验证
- `finishing-a-development-branch-pua` — 分支收尾

### Auxiliary
- `karpathy-guidelines` — 编码行为准则（防过度工程、外科手术式修改、可验证目标）
- `pua` — 原版 PUA 核心（方法论、味道系统、12 家公司文化）
- `pua-learning-loop` — 项目学习闭环
- `agent-customization-pua` — Agent 定制化管理

## Install

Supports three AI coding platforms:

| Platform | Skill Support | Instructions File |
|----------|--------------|-------------------|
| **Claude Code** | Full SKILL.md + references | `CLAUDE.md` / `.claude/instructions.md` |
| **OpenAI Codex CLI** | AGENTS.md (Markdown only) | `AGENTS.md` |
| **CodeBuddy** | Full SKILL.md (Claude-compatible) | `.codebuddy/` instructions / agents |

### Option A: Claude Code (Manual)

```bash
# Linux/macOS
cp -r skills/* ~/.claude/skills/

# Windows PowerShell
Copy-Item -Recurse -Force skills\* "$env:USERPROFILE\.claude\skills\"
```

This installs all 20 skills to `~/.claude/skills/`, available across all projects.

### Option B: OpenAI Codex CLI

Codex uses plain Markdown `AGENTS.md` files. See [AGENTS.md](./AGENTS.md) section 2 for the Codex-specific configuration template.

Quick setup:
```bash
# Copy the Codex PUA template to global config
mkdir -p ~/.codex
# Then add PUA rules to ~/.codex/AGENTS.md or your project's AGENTS.md
```

### Option C: CodeBuddy

CodeBuddy is compatible with Claude's SKILL.md format:

```bash
# Project-level (shared via Git)
mkdir -p .codebuddy/skills
cp -r skills/* .codebuddy/skills/

# User-level (personal)
cp -r skills/* ~/.codebuddy/skills/
```

You can also configure as a CodeBuddy sub-agent or custom instruction. See [AGENTS.md](./AGENTS.md) section 3 for templates.

### Option D: Per-Project (basic, any platform)

```bash
# Only CLAUDE.md — basic PUA flow constraints without full skills
curl -o CLAUDE.md https://raw.githubusercontent.com/forrestchang/PUA-Driven-Spec-Engineering/main/CLAUDE.md
```

## Environment Configuration

### Required
- One of: Claude Code CLI v1.0.26+, OpenAI Codex CLI, or CodeBuddy

### Optional (Claude Code & CodeBuddy)
- **PUA Flavor Config**: `~/.pua/config.json`
  ```json
  {
    "flavor": "alibaba",
    "PUA_REFERENCES": "ON"
  }
  ```
  Available flavors: `alibaba` / `huawei` / `bytedance` / `tencent` / `meituan` / `pinduoduo` / `baidu` / `netflix` / `apple` / `tesla` / `amazon` / `jd` / `xiaomi`

- **Project Learning Library**: Initialize `.copilot/` to prevent repeated mistakes
  ```bash
  # Linux/macOS
  bash ~/.claude/skills/pua-learning-loop/scripts/init-copilot.sh
  ```
  ```powershell
  # Windows
  powershell -ExecutionPolicy Bypass -File ~/.claude/skills/pua-learning-loop/scripts/init-copilot.ps1
  ```

## How to Trigger

### Claude Code
- **Auto**: Add `use_skill("using-superpowers-pua")` to `CLAUDE.md`
- **Manual**: `/pua` or `use_skill("using-superpowers-pua")`

### Codex CLI
- **Auto**: PUA rules in `AGENTS.md` are loaded automatically
- **Manual**: "按照 AGENTS.md 中的 PUA 流程约束执行"

### CodeBuddy
- **Auto**: Skills loaded from `.codebuddy/skills/` or `~/.codebuddy/skills/`
- **Manual**: `use_skill("using-superpowers-pua")` or "使用 pua-engineer 子代理"

### Pressure triggers (auto-escalate)
- Chinese: `加油` `别偷懒` `你再试试` `为什么还不行` `又错了` `换个方法`
- English: `try harder` `stop giving up` `you keep failing` `stop spinning`

## AGENTS.md Template

See [AGENTS.md](./AGENTS.md) for a complete guide on how to write your project's `AGENTS.md` to integrate this suite.

Quick template:
```markdown
# AGENTS.md

## 默认 AI 协作流程
本项目默认使用 `superpowers-pua` 技能套件。
每次对话开始时，第一个动作必须是 `use_skill("using-superpowers-pua")`。

## 三维自适应门禁
- **需求成熟度**（0-10 分）：目标/约束/影响面/唯一性/实现路径
- **变更风险等级**（R0-R4）：数据持久化/资金权益/权限认证/核心流程/跨服务
- **复合升级**：高风险 + 不清晰 + 大影响，命中 2+ 维度额外升档

## OpenSpec 四层渐进确认
变更风险 ≥ R2 时，做一步确认一步：Proposal → Specs → Design → Tasks

## 编码准则
- 编码行为准则由 `karpathy-guidelines` skill 定义，首次涉及写代码时执行 `use_skill("karpathy-guidelines")` 获取完整规则

## 用户硬性规则
- 默认使用简体中文；代码、命令、路径、标识符保持原文
- 最小范围修改，只补必要注释
```

## How to Know It's Working

These guidelines are working if you see:
- **PUA micro-badges** on every response (`🟠 PUA · {flavor} · G0 · {constraint}`)
- **Escalation actions** when you express frustration or there are repeated failures
- **Evidence before claims** — no "should be done" without verification output
- **Surgical changes** — only requested changes appear in diffs
- **Design before implementation** — new features go through brainstorming first

## Typical Workflow

### Simple (G0/G1)
```
You: "Rename this function"
→ G0 PASS · Direct execution · No full lifecycle needed
```

### Medium (G2)
```
You: "Add user registration"
→ G2 · brainstorming-pua → writing-plans-pua → TDD → verification
```

### High Pressure (ESCALATE)
```
You: "/pua this bug has failed 3 times"
→ ESCALATE · pua-escalation (E2: must search, read, list hypotheses)
→ systematic-debugging-pua → verification-before-completion-pua
```

## Project Structure

```
PUA-Driven-Spec-Engineering/
├── skills/
│   ├── pua/                  # Core PUA (methodology, flavors, 24 reference docs)
│   │   ├── SKILL.md
│   │   └── references/       # 12 company methodologies + protocols
│   ├── pua-gate/             # Adaptive gate
│   ├── pua-escalation/       # Escalation engine
│   ├── pua-learning-loop/    # Learning loop + init scripts
│   │   ├── scripts/
│   │   │   ├── init-copilot.ps1  # Windows initializer
│   │   │   └── init-copilot.sh   # Linux/macOS initializer
│   ├── superpowers-pua/      # Suite main entry
│   ├── using-superpowers-pua/ # Entry discipline
│   ├── brainstorming-pua/    # Design & requirements
│   ├── writing-plans-pua/    # Planning
│   ├── using-git-worktrees-pua/ # Isolated dev
│   ├── test-driven-development-pua/
│   ├── systematic-debugging-pua/
│   ├── subagent-driven-development-pua/
│   ├── dispatching-parallel-agents-pua/
│   ├── executing-plans-pua/
│   ├── requesting-code-review-pua/
│   ├── receiving-code-review-pua/
│   ├── verification-before-completion-pua/
│   ├── finishing-a-development-branch-pua/
│   ├── karpathy-guidelines/    # Coding behavioral guidelines
│   ├── agent-customization-pua/ # + 6 reference docs
│   └── superpowers-pua-suite/  # Suite README
├── AGENTS.md                 # How to integrate with your project
├── CLAUDE.md                 # Per-project default instructions
└── README.md                 # This file
```

## License

MIT
