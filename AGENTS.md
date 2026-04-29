# AGENTS.md — 如何在项目中启用 PUA-Driven Spec Engineering 流程

本文档说明如何在 **Claude Code**、**OpenAI Codex CLI** 和 **CodeBuddy** 三个平台上配置和触发这套 PUA-Driven Spec Engineering 技能套件。

## 一、前置环境要求

本套件支持三个 AI 编程平台，按需选择：

| 平台 | Skill 支持 | 指令文件 | 最小版本 | 关键注意 |
|------|-----------|---------|---------|---------|
| **Claude Code** | 完整 `SKILL.md` + references | `CLAUDE.md` / `.claude/instructions.md` | v1.0.26+ | 安装 skills 后仍需入口指令 |
| **OpenAI Codex CLI** | 不加载 `SKILL.md`；只吃 Markdown 指令 | `AGENTS.md` | 最新版 | 不要复制 `skills/` 当作 Codex skill |
| **CodeBuddy** | `.codebuddy/skills/` 下的 `SKILL.md` | `.codebuddy/` 指令 / `.instructions.md` | 最新版 | `list skills` 只证明可发现，自动流程还需指令或手动触发 |

> **核心区别**：Claude Code 和 CodeBuddy 可以发现 `SKILL.md` 技能文件；Codex 仅支持纯 Markdown 指令文件，需将 PUA 核心规则内联到 `AGENTS.md`。对 Claude Code / CodeBuddy 来说，"安装 skill"只代表可用；要保证完整套件启动，必须显式触发 `use_skill("using-superpowers-pua")`，或在项目指令中要求每次对话第一动作执行它。

---

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
每次对话开始时，第一个动作必须是 `use_skill("using-superpowers-pua")`。
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

Codex 不支持 SKILL.md 格式，通过 **AGENTS.md 纯 Markdown** 注入 PUA 流程规则。

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

### OpenSpec SDD 四层渐进确认
变更风险 ≥ R2 时，做一步确认一步：
1. Proposal → 2. Specs → 3. Design → 4. Tasks
前一层未确认，后一层无法正确生成。

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

CodeBuddy 支持在 `.codebuddy/skills/` 下发现 `SKILL.md` 技能，支持两种部署路径。注意：技能出现在 `list skills` 中只表示可发现；要运行完整 PUA 流程，还需要手动触发 `use_skill("using-superpowers-pua")`，或配置 CodeBuddy Rule 自动要求入口执行。

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

## OpenSpec 四层渐进确认
变更风险 ≥ R2 时，做一步确认一步：Proposal → Specs → Design → Tasks

## 编码准则
- 编码行为准则由 `karpathy-guidelines` skill 定义，首次涉及写代码、review 或重构时执行 `use_skill("karpathy-guidelines")` 获取完整规则

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

每次对话开始时，第一个动作必须是 `use_skill("using-superpowers-pua")`。
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
use_skill("using-superpowers-pua")
```

期望现象：模型先加载 `using-superpowers-pua`，再进入 `pua-gate`。如果只加载 `pua`，说明核心味道层可用，但完整套件路由还没接上。

---

### 4. 项目学习库（可选，跨平台通用）

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

## 二、如何触发 PUA 流程

### Claude Code 触发

**自动触发**：在项目的 `CLAUDE.md` 或 `.claude/instructions.md` 中添加：

```markdown
## 默认技能流程
本仓库默认使用 `superpowers-pua` 技能套件。每次对话开始时，第一个动作必须是 `use_skill("using-superpowers-pua")`。
```

**手动触发完整套件**：在对话中输入 `use_skill("using-superpowers-pua")`。

> 注意：`/pua` 在部分客户端可能只命中 `pua` 核心味道层；需要完整门禁、升级和验证流程时，优先使用 `use_skill("using-superpowers-pua")`。

### Codex CLI 触发

Codex 通过 `AGENTS.md` 加载指令，**自动生效**——只要项目根目录或 `~/.codex/` 下有配置好的 AGENTS.md，每次会话都会加载。

也可在对话开头显式提醒：

```
按照 AGENTS.md 中的 PUA 流程约束执行
```

### CodeBuddy 触发

**Skill 触发**：Skills 安装后，在对话中输入：

```
use_skill("using-superpowers-pua")
```

**子代理触发**：如果配置了 `.codebuddy/agents/pua-engineer.md`：

```
使用 pua-engineer 子代理执行这个任务
```

**Rule 自动触发**：在 CodeBuddy Rules 中配置 `alwaysApply: true` 的 `RULE.mdc`，例如：

- 用户级：`~/.codebuddy/rules/default-agent-flow/RULE.mdc`（Windows 示例：`C:\Users\huangwen\.codebuddy\rules\default-agent-flow\RULE.mdc`）
- 项目级：`.codebuddy/rules/default-agent-flow/RULE.mdc`

规则内容中要求每次对话第一动作执行 `use_skill("using-superpowers-pua")`。修改规则后需要新建对话会话才会生效。

### 压力触发词（三个平台通用）

以下关键词会自动触发 PUA 升级：

- 中文：`加油` `别偷懒` `你再试试` `为什么还不行` `你怎么又失败了` `又错了` `能不能靠谱点` `认真点` `不行啊` `降智了` `你又在原地打转` `你把之前的改坏了` `别让我手动处理` `换个方法`
- 英文：`try harder` `figure it out` `stop giving up` `you keep failing` `stop spinning` `you broke it` `why does this still not work` `this is the third time`

## 三、AGENTS.md 编写指南（按平台）

### Claude Code 项目模板

在项目根目录创建 `CLAUDE.md`（自动加载）或 `.claude/instructions.md`（优先级最高）：

```markdown
# CLAUDE.md

## 默认技能流程
本项目默认使用 `superpowers-pua` 技能套件。
每次对话开始时，第一个动作必须是 `use_skill("using-superpowers-pua")`。

## PSE 核心纪律

### 三维自适应门禁
`pua-gate` 按三个维度动态定档：
- **需求成熟度**（0-10 分）：目标/约束/影响面/唯一性/实现路径，每项 0-2 分
- **变更风险等级**（R0-R4）：数据持久化/资金权益/权限认证/核心流程/跨服务/数据迁移
- **复合升级**：高风险(R2+) + 不清晰(成熟度≤6) + 大影响(3+文件/跨模块)，命中 2+ 维度额外升档

### OpenSpec SDD 四层渐进确认
变更风险 ≥ R2 时，**做一步确认一步**：
1. **Proposal**（`openspec/changes/{name}/proposal.md`）→ 用户确认
2. **Specs**（`openspec/changes/{name}/specs/spec.md`）→ 用户确认
3. **Design**（`openspec/changes/{name}/design.md`）→ 用户确认
4. **Tasks**（`openspec/changes/{name}/tasks.md`）→ 用户确认

前一层未确认，后一层无法正确生成。

### 多轮澄清协议
3-4 轮仍有核心模糊点则升档；5+ 轮则 ESCALATE + 结构化选项。

### 文档落地
R2+ 变更必须有 OpenSpec 文档落地。变更完成后归档至 `openspec/changes/archive/{date}-{name}/`。

## 编码准则
- 编码行为准则由 `karpathy-guidelines` skill 定义，首次涉及写代码、review 或重构时执行 `use_skill("karpathy-guidelines")` 获取完整规则

## 用户硬性规则
- 默认使用简体中文；代码、命令、路径、标识符保持原文
- 修改中文文件先评估编码风险；最小范围修改
- 只补必要注释（业务规则、边界条件、关键实现原因）

## 默认执行习惯
- 除非遇到真实阻塞，否则不要反复询问是否继续
- 默认连续执行到可交付结果

## 高压场景
- 连续失败 2+ 次自动升级
- 用户催压时不跳步骤
- 准备报完成但没证据时调用 `pua-escalation`

## 项目特定规则
[在此添加你的项目特定规则]
```

### Codex CLI 项目模板

在项目根目录创建 `AGENTS.md`（纯 Markdown，无 SKILL.md 支持）：

```markdown
# Project AGENTS.md

## Commands
- Build: `npm run build`
- Test: `npm test`
- Lint: `npm run lint`

## PUA Engineering Rules

### 三条红线
1. 闭环意识：没有验证输出，不叫完成。声称"已修复"之前必须跑验证命令。
2. 事实驱动：没有查证的归因，不叫判断。未验证 = 猜。
3. 穷尽一切：通用方法论没走完，不叫解决不了。

### 三维自适应门禁
`pua-gate` 按三个维度动态定档：
- **需求成熟度**（0-10 分）：目标/约束/影响面/唯一性/实现路径，每项 0-2 分
- **变更风险等级**（R0-R4）：数据持久化/资金权益/权限认证/核心流程/跨服务/数据迁移
- **复合升级**：高风险(R2+) + 不清晰(成熟度≤6) + 大影响(3+文件/跨模块)，命中 2+ 维度额外升档

### OpenSpec SDD 四层渐进确认
变更风险 ≥ R2 时，**做一步确认一步**：
1. **Proposal**（`openspec/changes/{name}/proposal.md`）→ 用户确认
2. **Specs**（`openspec/changes/{name}/specs/spec.md`）→ 用户确认
3. **Design**（`openspec/changes/{name}/design.md`）→ 用户确认
4. **Tasks**（`openspec/changes/{name}/tasks.md`）→ 用户确认

前一层未确认，后一层无法正确生成。不允许一次输出全部四层文档。

### 多轮澄清协议
3-4 轮仍有核心模糊点则升档；5+ 轮则 ESCALATE + 结构化选项。

### 文档落地
R2+ 变更必须有 OpenSpec 文档落地，没有文档不允许开写。

### 编码准则（karpathy-guidelines）
1. **先想后写**：不假设、不隐藏困惑。有多种解读时列出来，不确定时停下问
2. **简单优先**：最小代码解决问题。没被要求的功能不加、没被要求的抽象不做
3. **外科手术式修改**：只动必须动的。不改相邻代码、不重构没坏的东西、匹配现有风格
4. **目标驱动**：定义可验证的成功标准。"修好 bug"→ 先写复现测试，再让它通过

### 用户硬性规则
- 默认使用简体中文；代码、命令、路径、标识符保持原文
- 修改中文文件先评估编码风险；最小范围修改
- 只补必要注释

### 默认执行习惯
- 除非遇到真实阻塞，否则不要反复询问是否继续
- 默认连续执行到可交付结果

### 压力升级
| 失败次数 | 强制动作 |
|---------|---------|
| 0-1 | 正常推进 |
| 2 | 必须换本质不同的方案 |
| 3 | 必须搜索、读上下文、列 3 个假设 |
| 4 | 完整检查清单 |
| 5+ | 拼命模式 |

### Boundaries
- 修改核心模块前必须运行测试
- 不允许跳步骤声称完成

## Conventions
[在此添加你的项目特定约定]
```

### CodeBuddy 项目模板

**方式 A：通过 Skills（推荐，完整功能）**

```bash
# 复制 skills 到项目级
mkdir -p .codebuddy/skills
cp -r /path/to/PUA-Driven-Spec-Engineering/skills/* .codebuddy/skills/
```

在对话中先用 `list skills` 确认可发现，再使用 `use_skill("using-superpowers-pua")` 触发完整套件。仅复制 skills 不会强制每轮自动从入口启动。

**方式 B：通过子代理**

创建 `.codebuddy/agents/pua-engineer.md`：

```markdown
---
name: pua-engineer
description: "PUA 驱动的高压工程模式。在用户催压、连续失败、质量不满、要求 /pua 时主动使用"
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

## OpenSpec 四层渐进确认
变更风险 ≥ R2 时，做一步确认一步：Proposal → Specs → Design → Tasks

## 编码准则
- 编码行为准则由 `karpathy-guidelines` skill 定义，首次涉及写代码、review 或重构时执行 `use_skill("karpathy-guidelines")` 获取完整规则

## 用户硬性规则
- 默认使用简体中文；代码、命令、路径、标识符保持原文
- 修改中文文件先评估编码风险；最小范围修改
- 只补必要注释

## 压力升级
- 连续失败 2+ 次：必须换本质不同的方案
- 连续失败 3+ 次：必须搜索、读上下文、列假设
- 说"完成"前：必须有验证证据
```

**方式 C：通过 CodeBuddy Rule 自动触发**

创建 `.codebuddy/rules/default-agent-flow/RULE.mdc`：

```markdown
---
description: 全局默认 AI 协作流程
alwaysApply: true
enabled: true
provider:
---

## 默认技能流程
- 每次开始编码、调试、设计、review、验证或安装排查任务时，第一个动作必须是 `use_skill("using-superpowers-pua")`。
- 如果用户使用 `/pua`、催压、不满、指出事实错误或要求返工，也必须先进入 `using-superpowers-pua`，再由 `pua-gate` 判定是否升级。

## PUA 流程约束
- 编码行为准则由 `karpathy-guidelines` skill 定义，首次涉及写代码时执行 `use_skill("karpathy-guidelines")` 获取完整规则
- 三维门禁：需求成熟度 + 变更风险 + 复合升级，命中 2+ 维度额外升档
- 变更风险 ≥ R2 时走 OpenSpec 四层渐进确认（做一步确认一步）
- 说"完成"前必须有验证证据
- 连续失败时换策略不换语气
```

> 个人全局规则可放在用户目录，例如 `C:\Users\huangwen\.codebuddy\rules\default-agent-flow\RULE.mdc`；团队共享规则放在项目 `.codebuddy/rules/` 下。

### 各平台文件优先级

#### Claude Code
`.claude/instructions.md` > `CLAUDE.md` > `AGENTS.md`

#### Codex CLI
`AGENTS.override.md`（替换同级） > `AGENTS.md`（累加拼接），深层文件权重高于浅层

#### CodeBuddy
项目级 `.codebuddy/` > 用户级 `~/.codebuddy/`；`.instructions.md`（applyTo 匹配时自动注入）> 子代理（按需调用）> Skills（按需加载）

## 四、套件完整技能清单

### 入口层
| 技能名 | 说明 |
|--------|------|
| `using-superpowers-pua` | 套件入口纪律，路由到正确技能 |
| `superpowers-pua` | 套件总入口，定义完整生命周期 |
| `pua-gate` | 自适应门禁，每阶段必经 |
| `pua-escalation` | 压力升级器，门禁升级时调用 |

### 设计与规划
| 技能名 | 说明 |
|--------|------|
| `brainstorming-pua` | 需求澄清与方案设计（含 OpenSpec 流程） |
| `using-git-worktrees-pua` | 隔离开发环境 |
| `writing-plans-pua` | 将设计转为可执行计划 |

### 实现与调试
| 技能名 | 说明 |
|--------|------|
| `test-driven-development-pua` | TDD 流程 |
| `systematic-debugging-pua` | 系统化调试 |
| `subagent-driven-development-pua` | 子 agent 并行执行 |
| `dispatching-parallel-agents-pua` | 并行任务调度 |
| `executing-plans-pua` | 单通道计划执行 |

### 质量与收尾
| 技能名 | 说明 |
|--------|------|
| `requesting-code-review-pua` | 发起代码审查 |
| `receiving-code-review-pua` | 处理审查反馈 |
| `verification-before-completion-pua` | 完成前验证 |
| `finishing-a-development-branch-pua` | 开发分支收尾 |

### 辅助
| 技能名 | 说明 |
|--------|------|
| `karpathy-guidelines` | 编码行为准则（防过度工程、确保外科手术式修改、定义可验证目标） |
| `pua-learning-loop` | 项目学习闭环（防重复踩坑） |
| `agent-customization-pua` | Agent 定制化文件管理 |
| `pua` | 原版 PUA 核心（含方法论、味道系统） |

## 五、典型工作流

### 简单任务（G0/G1）

```
用户: "帮我把这个函数改个名"
→ pua-gate: G0 PASS 🟠 PUA · 重构 · G0 · 最小范围修改
→ 直接执行，不需要进入完整流程
```

### 中等任务（G2）

```
用户: "添加用户注册功能"
→ pua-gate: G2 PASS · 新功能 · 需设计澄清
→ brainstorming-pua（OpenSpec Proposal → Specs）
→ writing-plans-pua
→ test-driven-development-pua
→ verification-before-completion-pua
```

### 高压任务（G3/ESCALATE）

```
用户: "/pua 这个bug修了三次还没好，你到底行不行"
→ pua-gate: ESCALATE · 连续失败 + 用户不满
→ pua-escalation（E2: 必须搜索、读上下文、列假设）
→ systematic-debugging-pua
→ verification-before-completion-pua
```

## 六、故障排除

### 通用问题

#### Q: PUA 流程没生效
1. 确认指令文件在正确位置（见各平台优先级）
2. 确认内容包含三条红线和门禁规则
3. 在对话开头手动触发（见"如何触发"部分）

#### Q: 想部分使用而非全套
- **Claude Code / CodeBuddy**：只安装需要的 skills，在 `CLAUDE.md` 中只引用特定技能
- **Codex**：在 AGENTS.md 中只保留需要的规则段落

### Claude Code 专项

#### Q: Skill 没有被触发
1. 确认 skills 已安装到 `~/.claude/skills/`
2. 确认 `CLAUDE.md` 或 `.claude/instructions.md` 中有入口配置
3. 手动执行 `use_skill("using-superpowers-pua")`

#### Q: PUA references 读取报错
1. 确认 `skills/pua/references/` 目录完整（24 个文件）
2. 设置 `PUA_REFERENCES=OFF` 跳过方法论文档

### Codex CLI 专项

#### Q: AGENTS.md 内容被截断
1. 检查 `~/.codex/config.toml` 中 `project_doc_max_bytes` 设置
2. 全局 AGENTS.md 控制在 2-3 KB，给项目级留预算
3. 使用 `codex --ask-for-approval never "Summarize the instructions"` 验证

#### Q: 多层 AGENTS.md 规则冲突
1. 冲突目录用 `AGENTS.override.md` 完全替换
2. 或将冲突规则合并到最深层的 AGENTS.md（权重最高）

### CodeBuddy 专项

#### Q: Skills 没出现在 list skills
1. 确认目录是 `.codebuddy/skills/`（项目级）或 `~/.codebuddy/skills/`（用户级）
2. 确认每个 skill 文件夹下有 `SKILL.md`（含 YAML frontmatter）
3. 重新打开对话窗口

#### Q: 子代理没被自动调用
1. 确认 `description` 字段包含触发关键词（如"在用户催压时主动使用"）
2. 确认文件名或 `name` 字段使用小写字母和连字符
3. 尝试手动调用：`使用 pua-engineer 子代理`

#### Q: init-copilot.ps1 执行策略报错
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```
