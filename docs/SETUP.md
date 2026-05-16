# 安装配置指南

> **目标**：帮助你在 5 分钟内完成 PUA-Driven Spec Engineering 的安装和配置。

## 快速开始（5 分钟上手）

> **详细指南**：[QUICKSTART.md](QUICKSTART.md) | **决策速查**：[DECISION-TREE.md](DECISION-TREE.md) | **场景模板**：[SCENARIOS.md](SCENARIOS.md)

### 三种场景快速上手

| 场景 | 适用 | 预计步骤 | 关键提示 |
|------|------|---------|---------|
| **简单修改** | 改一行代码、解释代码、单文件小改 | 1-2 步 | 直接说需求，AI 自动判断 |
| **新功能** | 新增功能、架构变更、模糊需求 | 3-5 步 | 说"我要做一个..."，AI 引导设计 |
| **紧急修复** | Bug 修复、紧急问题、用户不满 | 2-4 步 | 输入 `/pua`，AI 进入高压模式 |

### 决策速查表

| 你的需求 | 推荐路径 | 预计步骤 |
|---------|---------|---------|
| 改一行代码 | 直接说需求 → G0/G1 | 1-2 步 |
| 解释代码 | 直接问 → G0 | 1 步 |
| 新增功能 | 说需求 → AI引导设计 → 实现 | 3-5 步 |
| 修复 Bug | 说问题 → AI定位 → 修复 | 2-4 步 |
| 架构变更 | 说目标 → 完整设计 → 实现 | 5-8 步 |
| 模糊需求 | 说想法 → AI澄清 → 设计 → 实现 | 4-6 步 |

## 前置环境要求

本套件支持四个 AI 编程平台，按需选择：

| 平台 | Skill 支持 | 指令文件 | 最小版本 | 关键注意 |
|------|-----------|---------|---------|---------|
| **Claude Code** | 完整 `SKILL.md` + references | `CLAUDE.md` / `.claude/instructions.md` | v1.0.26+ | 安装 skills 后仍需入口指令 |
| **OpenAI Codex CLI** | 不加载 `SKILL.md`；只吃 Markdown 指令 | `AGENTS.md` | 最新版 | `use_skill` 在 Codex 中无效；必须内联完整规则 |
| **CodeBuddy** | `.codebuddy/skills/` 下的 `SKILL.md` | `.codebuddy/rules/<name>/RULE.mdc` | 最新版 | RULE.mdc 必须含完整规范内容，单行 `use_skill` 不稳定 |
| **GitHub Copilot** | 不加载 `SKILL.md`；只吃 Markdown 指令 | `.github/copilot-instructions.md` | VS Code 最新版 | 不支持 `use_skill`；规则必须内联写入指令文件 |

> **核心区别**：Claude Code 和 CodeBuddy 可以发现 `SKILL.md` 技能文件；Codex 和 GitHub Copilot 仅支持纯 Markdown 指令文件，需将 PUA 核心规则**内联写入**对应配置文件。

## 推荐规则文件路径

各平台均支持**用户级**和**项目级**两种路径。优先选用户级，个人全局生效、无需每个仓库重复配置；项目级用于团队共享或仓库定制覆盖。

| 平台 | ① 用户级（推荐首选） | ② 项目级（团队共享/仓库覆盖） |
|------|---------------------|-------------------------------|
| **Claude Code** | `~/.claude/CLAUDE.md` 或 `~/.claude/instructions.md` | 项目根目录 `CLAUDE.md` 或 `.claude/instructions.md` |
| **OpenAI Codex CLI** | `~/.codex/AGENTS.md` | 项目根目录 `AGENTS.md` |
| **CodeBuddy** | `~/.codebuddy/rules/pua-default-flow/RULE.mdc` | `.codebuddy/rules/pua-default-flow/RULE.mdc`（本仓库已内置） |
| **GitHub Copilot** | VS Code 设置 `github.copilot.chat.codeGeneration.instructions` | `.github/copilot-instructions.md`（项目根） |

> **Windows 路径示例**：
> - Claude Code 用户级：`C:\Users\<you>\.claude\CLAUDE.md`
> - CodeBuddy 用户级：`C:\Users\<you>\.codebuddy\rules\pua-default-flow\RULE.mdc`
> - Codex 用户级：`C:\Users\<you>\.codex\AGENTS.md`
> - GitHub Copilot 用户级：VS Code → 设置 → 搜索 `copilot instructions` → `github.copilot.chat.codeGeneration.instructions`

## 安装指南

### 1. Claude Code 安装与配置

#### 安装 Claude Code CLI

```bash
npm install -g @anthropic-ai/claude-code
claude --version  # 确认 v1.0.26+
```

#### 安装 Skills

**方式 A：手动复制（推荐）**

将本仓库的 `skills/` 目录下所有文件夹复制到 `~/.claude/skills/`：

```bash
# Linux/macOS
cp -r skills/* ~/.claude/skills/

# Windows PowerShell
Copy-Item -Recurse -Force skills\* "$env:USERPROFILE\.claude\skills\"
```

安装后所有 20 个 skill（19 个 PUA skill + `karpathy-guidelines` 编码准则）跨项目可用。

**关键：安装不等于自动触发。** 还必须在目标项目的 `CLAUDE.md` 或 `.claude/instructions.md` 中加入入口指令：

```markdown
每次对话开始时，第一个动作必须是读取 `skills/using-superpowers-pua/SKILL.md`。
```

否则模型可能只在压力词命中时加载 `pua` 核心味道层，而不会稳定进入 `pua-gate` / `pua-escalation` 的完整套件流程。

**方式 B：仅项目级使用**

将 `CLAUDE.md` 复制到项目根目录即可获得基础 PUA 流程约束（三条红线、门禁规则、编码准则）。如需完整技能（方法论、味道系统、学习闭环），仍需按方式 A 安装 skills。

#### PUA 配置（可选）

创建 `~/.pua/config.json` 自定义味道：

```json
{
  "flavor": "alibaba",
  "PUA_REFERENCES": "ON"
}
```

可选味道：`alibaba` / `huawei` / `bytedance` / `tencent` / `meituan` / `pinduoduo` / `baidu` / `netflix` / `apple` / `tesla` / `amazon` / `jd` / `xiaomi`

如不需要方法论文档，设置 `"PUA_REFERENCES": "OFF"`。

---

### 2. OpenAI Codex CLI 安装与配置

#### 安装 Codex CLI

```bash
npm install -g @openai/codex
codex --version
```

#### 配置方式

Codex 不支持 SKILL.md 格式，也**无法执行 `use_skill()` 指令**，通过 **AGENTS.md 纯 Markdown** 注入 PUA 流程规则。

> **⚠️ 稳定触发说明**：在 `AGENTS.md` 中只写 `读取 skills/using-superpowers-pua/SKILL.md` **没有任何效果**，Codex 不加载 `SKILL.md` 也不执行该指令。必须将完整 PUA 规则**内联写入** `AGENTS.md`，规则才会生效。

**方式 A：全局配置（所有项目生效）**

创建 `~/.codex/AGENTS.md`：

```markdown
# PUA-Driven Engineering

## 默认协作流程

### 三条红线
1. 闭环意识：没有验证输出，不叫完成
2. 事实驱动：没有查证的归因，不叫判断
3. 穷尽一切：方法论没走完，不叫解决不了

### 三维自适应门禁
`pua-gate` 按三个维度动态定档：
- **需求成熟度**（0-10 分）：目标/约束/影响面/唯一性/实现路径
- **变更风险等级**（R0-R4）：数据持久化/资金权益/权限认证/核心流程/跨服务
- **复合升级**：高风险 + 不清晰 + 大影响，命中 2+ 维度额外升档

### OpenSpec SDD 渐进确认
变更风险 ≥ R2 时，做一步确认一步：
1. Core Clarification → 2. Proposal → 3. （路径选择 A/B）→ 4. Specs → 5. Design → 6. Tasks
Core Clarification 必须先确认目标、范围、约束、验收标准、影响面；未确认不得生成 Proposal。
前一层未确认，后一层无法正确生成。
Proposal 确认后暂停询问：A（完整 Specs 深度澄清）或 B（直接 writing-plans 快速路径）。R3+ 只提供 A。

**层级合并**：R2 + 成熟度 5+ 时，Specs 可并入 Proposal，从四层减为三层（3 次确认）。R3+ 不允许合并。
**执行阶段门禁降级**：计划确认后，门禁从每轮重评降为异常触发。
**轻量 TDD**：默认 TDD-Lite，只在 R2+、复杂行为、回归风险或用户明确要求时升级 Strict TDD；R0-R2 小粒度任务可用批量模式。

### 风险等级快速定调
消息以 `R0:`/`R1:`/`R2:`/`R3:`/`R4:` 开头直接定调，跳过自动风险评估：
- `R0: 需求` → 无风险，直接 writing-plans
- `R2: 需求` → 中风险，进入 brainstorming-pua
- `R3: 需求` → 高风险，ESCALATE + 完整文档

### 编码准则（karpathy-guidelines）
1. **先想后写**：不假设、不隐藏困惑。有多种解读时列出来，不确定时停下问
2. **简单优先**：最小代码解决问题。没被要求的功能不加、没被要求的抽象不做
3. **外科手术式修改**：只动必须动的。不改相邻代码、不重构没坏的东西、匹配现有风格
4. **目标驱动**：定义可验证的成功标准。"修好 bug"→ 先写复现测试，再让它通过

### 压力升级
| 失败次数 | 强制动作 |
|---------|---------|
| 0-1 | 正常推进 |
| 2 | 必须换本质不同的方案 |
| 3 | 必须搜索、读上下文、列 3 个假设 |
| 4 | 完整检查清单，不拍脑袋 |
| 5+ | 拼命模式：升级搜索、验证、review |

### 高压场景
- 用户催压时不跳步骤
- 连续失败 2+ 次换策略
- 说"完成"前必须有验证证据
```

**方式 B：项目级配置**

将上述内容（或精简版）放入项目根目录的 `AGENTS.md`。Codex 会从 Git 仓库根向下遍历到当前工作目录，按顺序拼接所有 `AGENTS.md`，越靠近当前目录权重越高。

**方式 C：覆盖机制**

如需临时替换某层配置，在同目录放置 `AGENTS.override.md`，Codex 会用它完全替换同级的 `AGENTS.md`。

#### Codex 配置预算

默认 `project_doc_max_bytes = 32768`（32 KiB），所有层 AGENTS.md 合并后不能超限。建议全局控制在 2-3 KB，确保项目级有充足预算：

```toml
# ~/.codex/config.toml
project_doc_max_bytes = 65536  # 如内容超限可调大
```

#### 验证 Codex 加载了指令

```bash
codex --ask-for-approval never "Summarize the instructions you have loaded for this session"
```

---

### 3. CodeBuddy 安装与配置

#### 安装 CodeBuddy

从 [copilot.tencent.com](https://copilot.tencent.com) 下载 VS Code 扩展或 CLI 工具。

#### 安装 Skills

CodeBuddy 支持在 `.codebuddy/skills/` 下发现 `SKILL.md` 技能，支持两种部署路径。注意：技能出现在 `list skills` 中只表示可发现；要运行完整 PUA 流程，还需要手动触发 `读取 skills/using-superpowers-pua/SKILL.md`，或配置 CodeBuddy Rule 自动要求入口执行。

CodeBuddy Rule 的项目级结构是 `.codebuddy/rules/<rule-name>/RULE.mdc`；用户级规则存放在用户目录中，例如 Windows 上可见为 `C:\Users\huangwen\.codebuddy\rules\default-agent-flow\RULE.mdc`。若要全局默认每次会话都走 PUA 入口，建议使用用户级 `default-agent-flow` 这类 `alwaysApply: true` 规则；若要团队共享，则放到仓库的 `.codebuddy/rules/default-agent-flow/RULE.mdc`。

| 路径 | 作用域 | 团队共享 |
|------|--------|---------|
| `.codebuddy/skills/` | 项目级 | 可通过 Git 共享 |
| `~/.codebuddy/skills/` | 用户级 | 仅个人本地 |

**方式 A：项目级（推荐，团队共享）**

```bash
# 在项目根目录
mkdir -p .codebuddy/skills
cp -r skills/* .codebuddy/skills/
```

**方式 B：用户级**

```bash
# Linux/macOS
cp -r skills/* ~/.codebuddy/skills/

# Windows PowerShell
Copy-Item -Recurse -Force skills\* "$env:USERPROFILE\.codebuddy\skills\"
```

**方式 C：项目级精简部署**

将 PUA 核心规则写入 `.codebuddy/agents/pua-engineer.md`，作为子代理使用：

```markdown
---
name: pua-engineer
description: "PUA 驱动的高压工程模式。在用户催压、连续失败、质量不满、或要求 /pua 时主动使用"
tools: Read, Grep, Glob, Bash, Edit, TodoWrite
model: inherit
---

你是 PUA 驱动的高绩效工程师。

## 三条红线
1. 闭环意识：没有验证输出，不叫完成
2. 事实驱动：没有查证的归因，不叫判断
3. 穷尽一切：方法论没走完，不叫解决不了

## 三维自适应门禁
- **需求成熟度**（0-10 分）：目标/约束/影响面/唯一性/实现路径
- **变更风险等级**（R0-R4）：数据持久化/资金权益/权限认证/核心流程/跨服务
- **复合升级**：高风险 + 不清晰 + 大影响，命中 2+ 维度额外升档

## OpenSpec 渐进确认
变更风险 ≥ R2 时，做一步确认一步：Core Clarification → Proposal → Specs → Design → Tasks
Core Clarification 必须先确认目标、范围、约束、验收标准、影响面；未确认不得生成 Proposal。
R2 + 成熟度 5+ 时，Specs 可并入 Proposal 减少确认轮次。R3+ 不允许合并。

## 编码准则
- 编码行为准则由 `karpathy-guidelines` skill 定义，首次涉及写代码、review 或重构时执行 `读取 skills/karpathy-guidelines/SKILL.md` 获取完整规则

## 用户硬性规则
- 默认使用简体中文；代码、命令、路径、标识符保持原文
- 修改中文文件先评估编码风险；最小范围修改
- 只补必要注释

## 压力升级
- 连续失败 2+ 次必须换本质不同的方案
- 连续失败 3+ 次必须搜索、读上下文、列假设
- 说"完成"前必须有验证证据
```

#### CodeBuddy Rules（推荐用于自动触发）

在 CodeBuddy 中，要让流程每次会话自动生效，推荐创建 `alwaysApply: true` 的 Rule，而不是只依赖 skills 自动发现。

**用户级（个人全局）**：例如 Windows 下可见为 `C:\Users\huangwen\.codebuddy\rules\default-agent-flow\RULE.mdc`。

**项目级（团队共享）**：在仓库中创建 `.codebuddy/rules/default-agent-flow/RULE.mdc`：

```markdown
---
description: 全局默认 AI 协作流程
alwaysApply: true
enabled: true
provider:
---

## 默认技能流程

每次对话开始时，第一个动作必须是读取 `skills/using-superpowers-pua/SKILL.md`。
普通问题走 G0/G1 轻量快放，高压问题走完整 PUA 流程。
```

> CodeBuddy 官方规则机制：`alwaysApply: true` 会在每个聊天会话加载规则全文；创建或修改规则后，需要新建对话会话才会生效。可在新会话中询问“当前应用了哪些规则？”验证是否加载。

#### CodeBuddy 自定义 Agent（可选）

在 CodeBuddy 对话框中输入：

```
list skills
```

确认 `using-superpowers-pua`、`pua`、`pua-gate`、`pua-escalation` 等技能出现在列表中。

然后输入：

```
读取 skills/using-superpowers-pua/SKILL.md
```

期望现象：模型先加载 `using-superpowers-pua`，再进入 `pua-gate`。如果只加载 `pua`，说明核心味道层可用，但完整套件路由还没接上。

---

### 4. GitHub Copilot 安装与配置

GitHub Copilot（VS Code）通过 `.github/copilot-instructions.md` 自动加载仓库级规范，无需每次手动触发。Copilot **不支持** `use_skill()` 指令，也不加载 `SKILL.md` 文件，规则必须内联写入指令文件。

> **⚠️ 稳定触发说明**：仅写一行 `读取 skills/using-superpowers-pua/SKILL.md` 对 GitHub Copilot **无效**。必须将完整的 PUA 协作规范内联写入 `.github/copilot-instructions.md`，Copilot 才会在每次会话中自动应用。

```bash
# 创建 GitHub Copilot 仓库级指令文件
mkdir -p .github
```

然后将以下内容写入 `.github/copilot-instructions.md`：

```markdown
# 仓库协作规范（PUA-Driven Spec Engineering）

## 默认 AI 协作流程

目标项目接入本 harness 后，采用三维自适应门禁流程。每次接到任务后，先经过门禁判断再行动：

- **G0/G1**：普通问题轻量快放，输出一行微标 `🟠 PUA · G0/G1 · {约束}`
- **G2**：多步骤/跨文件任务，列关键风险和硬约束
- **G3/ESCALATE**：需求成熟度 ≤ 4 或高风险变更，输出 PUA 旁白 + 立即行动
- **G4/BLOCKED**：需求几乎空白，停止推进，问一个最小澄清问题

## 三维门禁评估

最终档位 = max(成熟度档位, 变更风险档位) + 复合升级：

- **需求成熟度**（0-10 分）：目标/约束/影响面/唯一性/实现路径，每项 0-2 分
- **变更风险等级**（R0-R4）：数据持久化/资金权益/权限认证/核心流程/跨服务/数据迁移
- **复合升级**：高风险(R2+) + 不清晰(成熟度≤6) + 大影响(3+文件)，命中 2+ 额外升档

## 风险等级快速定调

消息以 `R0:`/`R1:`/`R2:`/`R3:`/`R4:` 开头，直接定调跳过自动评估。

## 路由规则

任一命中即进入设计阶段（先澄清再动手）：
- 需求成熟度 ≤ 6 / 新功能 / 变更风险 ≥ R2

设计阶段采用 OpenSpec SDD 渐进确认：Core Clarification → Proposal → （路径选择 A/B）→ Specs → Design → Tasks。
Core Clarification 必须先确认目标、范围、约束、验收标准、影响面；未确认不得生成 Proposal。
Proposal 确认后暂停询问用户：A（完整 Specs 深度澄清）或 B（直接进 writing-plans 快速路径）。R3+ 只提供 A。

## 编码准则（Karpathy Guidelines）

- 外科手术式修改：只改被要求改的，不顺手重构
- 可验证目标：每个任务必须有可检验的完成标准
- 事实驱动：没有查证的归因叫猜，没有验证的完成叫自嗨
- 先查后问：信息不足先搜索，只把真正卡住的最小问题抛给用户

## 用户硬性规则

- 默认简体中文；代码/命令/路径/标识符保持原文
- 最小范围修改，只补必要注释
- 默认自主执行到可交付结果；只在真正模糊/危险操作前提问
```

如需更细粒度控制，可用 `.github/instructions/*.instructions.md`（支持 `applyTo` frontmatter）：

```markdown
---
applyTo: "**"
---
# 规范内容（同上）
```

验证方式：在 VS Code Copilot Chat 中问"当前应用了哪些指令？"，预期响应中提及 `copilot-instructions.md` 中的规范内容。

---

### 5. 项目学习库（可选，跨平台通用）

`pua-learning-loop` skill 可初始化 `.copilot/` 项目学习库，用于防止重复踩坑：

```bash
# Linux/macOS（bash）
bash ~/.claude/skills/pua-learning-loop/scripts/init-copilot.sh

# 或 CodeBuddy 用户级
bash ~/.codebuddy/skills/pua-learning-loop/scripts/init-copilot.sh
```

```powershell
# Windows（PowerShell）
powershell -ExecutionPolicy Bypass -File ~/.claude/skills/pua-learning-loop/scripts/init-copilot.ps1

# 或 CodeBuddy 用户级
powershell -ExecutionPolicy Bypass -File ~/.codebuddy/skills/pua-learning-loop/scripts/init-copilot.ps1
```

初始化后在项目根目录创建：
- `.copilot/PROJECT_BRIEF.md` — 项目元数据和数据源索引
- `.copilot/copilot-instructions.md` — 项目指令
- `.copilot/LEARNING_INDEX.md` — 学习索引
- `.copilot/cards/` — 学习卡片目录

#### .copilot 使用规范

`.copilot/` 是 AI 学习沉淀目录，用于防止重复踩坑。

- 普通任务可读 `.copilot/PROJECT_BRIEF.md`（项目元数据和数据源索引）
- 出现用户纠正、重复失败、规则不生效或可复用坑点时，先读 `.copilot/LEARNING_INDEX.md`
- 只有命中索引 trigger 后，才读取对应 `.copilot/cards/**/*.md`
- 禁止启动时全量读取 `.copilot/cards/**`
- `.copilot` 负责项目经验和踩坑记录
- 协作规范见项目 AGENTS.md，编码规则见项目级指令文件（如 `.github/instructions/`）或 CodeBuddy Rules（如 `.codebuddy/rules/<name>/RULE.mdc`），不另建重复说明文件

## 如何触发 PUA 流程

### Claude Code 触发

**自动触发**：在项目的 `CLAUDE.md` 或 `.claude/instructions.md` 中添加：

```markdown
## 默认技能流程
本仓库默认使用 `superpowers-pua` 技能套件。
每次对话开始时，第一个动作必须是读取 `skills/using-superpowers-pua/SKILL.md`。
```

**手动触发完整套件**：在对话中输入 `读取 skills/using-superpowers-pua/SKILL.md`。

> 注意：`/pua` 在部分客户端可能只命中 `pua` 核心味道层；需要完整门禁、升级和验证流程时，优先使用 `读取 skills/using-superpowers-pua/SKILL.md`。

### Codex CLI 触发

Codex 通过 `AGENTS.md` 加载指令，**自动生效**——只要项目根目录或 `~/.codex/` 下有配置好的 AGENTS.md，每次会话都会加载。

也可在对话开头显式提醒：

```
按照 AGENTS.md 中的 PUA 流程约束执行
```

### CodeBuddy 触发

**Skill 触发**：Skills 安装后，在对话中输入：

```
读取 skills/using-superpowers-pua/SKILL.md
```

**子代理触发**：如果配置了 `.codebuddy/agents/pua-engineer.md`：

```
使用 pua-engineer 子代理执行这个任务
```

**Rule 自动触发**：在 CodeBuddy Rules 中配置 `alwaysApply: true` 的 `RULE.mdc`，例如：

- 用户级：`~/.codebuddy/rules/pua-default-flow/RULE.mdc`（Windows 示例：`C:\Users\<you>\.codebuddy\rules\pua-default-flow\RULE.mdc`）
- 项目级：`.codebuddy/rules/pua-default-flow/RULE.mdc`（本仓库已内置完整版）

RULE.mdc 必须包含完整协作规范内容，仅写入口指令不足以稳定触发。修改规则后需要新建对话会话才会生效。

### GitHub Copilot 触发

**自动触发**：将完整规范写入 `.github/copilot-instructions.md`，Copilot Chat 每次会话自动加载。

**用户级触发**：VS Code → 设置 → `github.copilot.chat.codeGeneration.instructions` → 添加规则内容（个人全局生效）。

> 注意：GitHub Copilot 不支持 `use_skill()` 指令，规则必须全部内联。参见上方"4. GitHub Copilot 安装与配置"章节的完整模板。

### 压力触发词（四个平台通用）

以下关键词会自动触发 PUA 升级：

- 中文：`加油` `别偷懒` `你再试试` `为什么还不行` `你怎么又失败了` `又错了` `能不能靠谱点` `认真点` `不行啊` `降智了` `你又在原地打转` `你把之前的改坏了` `别让我手动处理` `换个方法`
- 英文：`try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` `why does this still not work` `this is the third time`

## 安装后最值得做的三件事

完成任意平台的安装配置后，按顺序做这三件事，可以验证套件真正生效，同时让日常使用立即获益。

### 第一件：验证完整套件能触发门禁

发送一条简单消息，确认 AI 会输出 PUA 微标并经过门禁：

```
帮我把这个变量名改得更清楚一些
```

**预期响应**：开头出现 `🟠 PUA · ... · G0 · ...` 微标，说明 `pua-gate` 已加载并正常工作。

如果没有出现微标，检查：
- Claude Code / CodeBuddy：确认 `读取 skills/using-superpowers-pua/SKILL.md` 已写入入口指令
- Codex CLI / GitHub Copilot：确认指令文件内容包含完整规范（不是单行指令）

### 第二件：用风险等级前缀发一个真实需求

体验"直接定调"功能，感受不同等级的路由差异：

```
R0: 帮我补充一下这个函数的注释
```

```
R2: 需要给用户表新增一个 last_login_at 字段
```

**预期行为**：
- `R0:` → AI 直接轻量执行，无需设计流程
- `R2:` → AI 进入 brainstorming-pua，输出 Proposal 并暂停确认路径选择（A/B）

这是最快感受流程差异的方式，也能帮你校准日常哪些需求需要写 `R2:`/`R3:` 前缀。

### 第三件：首次写代码时显式加载 karpathy-guidelines

在开始第一个真实编码任务前，发送：

```
读取 skills/karpathy-guidelines/SKILL.md
```

**预期行为**：AI 加载四条编码行为准则（先想后写、简单优先、外科手术式修改、目标驱动），并在后续代码任务中自动遵循。

这一步很多人会跳过，导致 AI 顺手重构了不该动的代码，或加了没要求的功能。一次加载，当次会话持续生效。