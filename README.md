# PUA-Driven Spec Engineering

> 一套面向所有开发者的**公开多平台 AI 协作技能框架**，支持 Claude Code、OpenAI Codex CLI、CodeBuddy 和 GitHub Copilot 四个平台。通过自适应门禁、OpenSpec SDD 渐进确认和 Karpathy 编码准则，让 AI 编码助手更严谨、更可控。

**作者**：huangwen  
**联系邮箱**：1015141366@qq.com


## What Is This

一套面向**所有开发者**的 **PUA 驱动规格工程** 技能套件——无论你用哪个 AI 编码平台，都可以拿来用。核心思路：

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

## Skill Suite (21 Skills)

> 按任务阶段分组，每个 skill 对应一个明确场景。⭐ 标记为项目特色技能，详见下方「特色技能详解」。
>
> **触发方式**：Claude Code / CodeBuddy 用 `use_skill("skill-name")`；Codex CLI / GitHub Copilot 规则内联生效，无需手动触发。

### 🚪 Entry — 入口与门禁

| Skill | 何时用 |
|-------|--------|
| `using-superpowers-pua` | 每次对话第一步；套件入口纪律，驱动门禁和路由 |
| `superpowers-pua` | 需要了解完整生命周期定义时加载 |
| `pua-gate` ⭐ | 每轮请求自动判断档位（G0-G4）；普通问题快放，高压问题升级，不制造多余流程感 |
| `pua-escalation` ⭐ | 连续失败 2+ 次 / 用户不满 / 想跳步骤时；收紧流程，防止原地打转 |

### 🎨 Design & Planning — 设计与规划

| Skill | 何时用 |
|-------|--------|
| `brainstorming-pua` ⭐ | 新功能 / 模糊需求 / 架构变更；OpenSpec 四层渐进确认，防止做错方向后大返工 |
| `writing-plans-pua` | 需求已确认后；把设计文档转成带顺序、带验证点的可执行任务清单 |
| `using-git-worktrees-pua` | 开始实现前；隔离开发分支，不弄脏当前工作区 |

### 🔨 Implementation & Debugging — 实现与调试

| Skill | 何时用 |
|-------|--------|
| `test-driven-development-pua` | 实现任何功能或修 Bug；先写复现测试，再让它通过，防止修了这里坏那里 |
| `systematic-debugging-pua` ⭐ | Bug 排查 / 多次修复无效；假设列表 + 逐一证伪，禁止盲目补丁 |
| `subagent-driven-development-pua` | 执行多步骤计划；子 agent 分工执行，减少上下文漂移 |
| `dispatching-parallel-agents-pua` | 多个独立任务同时推进；并行调度提速，互不等待 |
| `executing-plans-pua` | 单通道按计划执行；一步一确认，防止跳步骤 |

### ✅ Quality & Finish — 质量与收尾

| Skill | 何时用 |
|-------|--------|
| `requesting-code-review-pua` | 工作完成准备收尾前；规范发起 code review，不让隐患漏掉 |
| `receiving-code-review-pua` | 收到 review 反馈后；区分"必须改"和"建议改"，拒绝无脑认同 |
| `verification-before-completion-pua` ⭐ | 准备说"完成了"之前；必须有验证命令 + 真实输出，无证据不叫完成 |
| `finishing-a-development-branch-pua` | 实现已验证后；规范收尾分支，不留半成品状态 |

### 🔧 Auxiliary — 辅助工具

| Skill | 何时用 |
|-------|--------|
| `karpathy-guidelines` | 写代码 / review / 重构时；防过度工程、外科手术式修改、先定可验证目标 |
| `pua` | 需要大厂 PUA 风格加压时；12 家公司方法论 + 味道系统，激活高压执行模式 |
| `pua-learning-loop` | 出现用户纠正 / 重复失败 / 可复用坑点时；记录经验，防下次再踩同一个坑 |
| `agent-customization-pua` | 创建或修复 AI 配置文件（`.instructions.md`、`SKILL.md`、`RULE.mdc`）时 |
| `llm-degradation-detector` ⭐ | 怀疑 AI 在降智 / 敷衍 / 绕圈时；发送 `/iq` 触发九维自评 + 推理等级报告（*updated: 2026-05-01*）|

---

## 特色技能详解

### ⭐ `pua-gate` — 自适应门禁

不是每个问题都需要走完整流程，`pua-gate` 按任务复杂度自动分档：

| 档位 | 触发条件 | 执行方式 |
|------|---------|---------|
| **G0/G1** | 简单问题（改名、解释、单行修复） | 一行微标，直接执行 |
| **G2** | 多步骤 / 跨文件任务 | 简版门禁，列关键约束后执行 |
| **ESCALATE** | 连续失败 / 用户不满 / 高风险变更 | 调用 `pua-escalation` 收紧再继续 |
| **BLOCKED** | 需求几乎空白 | 停止推进，问一个最小澄清问题 |

**核心价值**：普通问题不走繁琐流程（不制造流程感），高压问题不跳步骤（不假完成）。每轮消息都重新判断档位，不允许以"上轮已过门禁"为由跳过。

**理解对齐**：先查后问不是不问。事实能靠工具补齐，业务意图、交付物和验收标准不能由 AI 脑补；当存在多种合理理解时，必须列出选项并问一个最小澄清问题，避免模型按自己觉得的方向执行。

---

### ⭐ `pua-escalation` — 压力升级引擎

LLM 连续失败时最常见的问题是：换措辞但不换方案，原地打转。`pua-escalation` 提供五级压力等级和强制切换规则：

| 等级 | 触发时机 | 强制行为 |
|------|---------|---------|
| E0 | 正常执行 | 无额外约束 |
| E1 | 第 1 次失败 | 必须重新搜索 / 读文件再开口 |
| E2 | 第 2 次失败 | 换本质不同的方案（换参数不叫换方案） |
| E3 | 第 3 次失败 | 七项检查清单全部完成才能继续 |
| E4 | 第 4+ 次失败 | 停止执行，等待人工介入 |

**被动失败检测**：AI 不会主动承认失败。如果上轮说"完成"，但用户本轮还在说同一个问题——这就是失败，计数 +1，不允许装作是新问题。

---

### ⭐ `brainstorming-pua` — 需求澄清与方案设计

新功能直接写代码是大多数返工的根源。本 skill 强制走 OpenSpec SDD 四层渐进确认，做一步确认一步，前一层未确认后一层无法开始：

```
Proposal → （路径选择 A/B）→ Specs → Design → Tasks
```

| 层 | 内容 | 产出 |
|----|------|------|
| Proposal | 为什么改、改什么、影响谁 | `openspec/changes/{name}/proposal.md` |
| 路径选择 | A（深度澄清）或 B（快速路径）；R3+ 只提供 A | 用户选择确认 |
| Specs | 需求边界、验收标准、非目标 | `specs/spec.md` |
| Design | 方案对比、技术设计、接口定义 | `design.md` |
| Tasks | 实现清单、执行顺序、验证计划 | `tasks.md` |

**核心价值**：不允许一次输出全部文档。每层确认后才推进，防止方向错了全部返工。

---

### ⭐ `systematic-debugging-pua` — 系统化调试

"再试试"不是调试方法。本 skill 强制结构化假设-证伪流程：

1. **现象收集**：完整错误信息 + 最小复现步骤
2. **假设列表**：列出所有可能原因，不允许直接跳到"觉得是 X"
3. **逐一证伪**：每个假设必须有验证命令和真实输出
4. **根因确认**：找到真正原因后才动手修复，不允许边改边猜

**核心价值**：禁止盲目补丁。每次修复都有证据支撑，不会出现"改了 A 坏了 B"的连锁问题。

---

### ⭐ `llm-degradation-detector` — LLM 推理能力检测（`/iq`）

当 AI 连续出错，你需要知道它现在的推理能力处于什么水平。发送 `/iq` 触发九维自评报告：

**九维评分**（每维 0-5 分，总分 45）：

> 推理深度 · 上下文保持 · 工具使用策略 · 边界与风险识别 · 指令遵循精度 · 自我纠错能力 · 创造力 · 影响面意识 · 幻觉与事实可靠性

**六级等级**：

| 等级 | 名称 | 分数区间 |
|------|------|---------|
| IQ-5 🧠 | 巅峰推理 | 36-45 |
| IQ-4 ✅ | 正常推理 | 28-35 |
| IQ-3 ⚠️ | 轻度衰减 | 20-27 |
| IQ-2 🟡 | 明显衰减 | 12-19 |
| IQ-1 🔴 | 严重衰减 | 5-11 |
| IQ-0 💀 | 不可用 | 0-4 |

**防自吹三重机制**：
- 首次检测 IQ-5 封锁（除非本对话零纠正 + 主动发现至少 1 个未被提及的风险）
- 高分举证倒置：维度打 4/5 分必须同时给出"为什么不更低"的反面论证
- 用户愤怒 → 全局盖帽（有效总分强制压低至阈值以下）

**报告结构**：九维评分 → 等级判定 → 幻觉自证（每条断言溯源）→ 不一致性审计（自评 vs 用户体验交叉校验）→ 恢复建议

**核心价值**：让 AI 无法通过自我膨胀掩盖实际衰减；报告给出明确的"当前输出是否可信"判断依据。

---

### ⭐ `verification-before-completion-pua` — 完成前验证

说"完成了"但没有验证输出 = 假完成。本 skill 强制三步格式：

```
命令：{验证命令}
结果：{真实输出，不是预期输出}
判定：通过 / 失败
```

- "应该可以了" → 自动触发 escalation
- "大概率没问题" → 视为未完成，退回验证
- 测试通过截图 / 命令输出 / 日志才算证据

**核心价值**：没有证据的完成声明无效。线上炸了再写复盘，来不及了。

## Install

Supports four AI coding platforms, but the activation model is different on each platform:

| Platform | Skill Support | Instructions File | Important |
|----------|--------------|-------------------|-----------|
| **Claude Code** | Full `SKILL.md` + references | `CLAUDE.md` / `.claude/instructions.md` | Install skills **and** add the entry instruction |
| **OpenAI Codex CLI** | No `SKILL.md`; Markdown rules only | `AGENTS.md` | Must inline **full rules**; single-line `use_skill` does nothing in Codex |
| **CodeBuddy** | Skills via `.codebuddy/skills/` | Rules: `.codebuddy/rules/<name>/RULE.mdc` or user rules | RULE.mdc must contain **full spec content**, not just `use_skill`; project template included |
| **GitHub Copilot** | No `SKILL.md`; Markdown rules only | `.github/copilot-instructions.md` | No `use_skill` runtime; inline full rules; auto-applied to all VS Code Copilot Chat sessions |

### 推荐规则文件路径（优先级说明）

各平台均支持**用户级**和**项目级**两种路径。优先选用户级，个人全局生效、无需每个仓库重复配置；项目级用于团队共享或仓库定制覆盖。

| 平台 | ① 用户级（推荐首选） | ② 项目级（团队共享/仓库覆盖） |
|------|---------------------|-------------------------------|
| **Claude Code** | `~/.claude/CLAUDE.md` 或 `~/.claude/instructions.md` | 项目根目录 `CLAUDE.md` 或 `.claude/instructions.md` |
| **OpenAI Codex CLI** | `~/.codex/AGENTS.md` | 项目根目录 `AGENTS.md` |
| **CodeBuddy** | `~/.codebuddy/rules/pua-default-flow/RULE.mdc` | `.codebuddy/rules/pua-default-flow/RULE.mdc`（本仓库已内置） |
| **GitHub Copilot** | VS Code 用户 `settings.json`（`github.copilot.chat.codeGeneration.instructions`） | `.github/copilot-instructions.md`（项目根） |

> **用户级优先**：用户级规则对该机器上所有项目生效，避免每个仓库重复配置。项目级规则在用户级之上叠加，可覆盖或补充。当两级规则并存时，平台通常合并加载（以平台行为为准）。
>
> **Windows 路径示例**：
> - Claude Code 用户级：`C:\Users\<you>\.claude\CLAUDE.md`
> - CodeBuddy 用户级：`C:\Users\<you>\.codebuddy\rules\pua-default-flow\RULE.mdc`
> - Codex 用户级：`C:\Users\<you>\.codex\AGENTS.md`
> - GitHub Copilot 用户级：VS Code → 设置 → 搜索 `copilot instructions` → `github.copilot.chat.codeGeneration.instructions`

### Option A: Claude Code

```bash
# Linux/macOS
cp -r skills/* ~/.claude/skills/

# Windows PowerShell
Copy-Item -Recurse -Force skills\* "$env:USERPROFILE\.claude\skills\"
```

Then add the entry instruction to your project `CLAUDE.md` or `.claude/instructions.md`:

```markdown
每次对话开始时，第一个动作必须是 `use_skill("using-superpowers-pua")`。
```

Installing the 20 skills without this instruction only makes them available; it does not guarantee the suite entry runs first.

### Option B: OpenAI Codex CLI

Codex does **not** load `skills/*/SKILL.md` and has no `use_skill` runtime. Use plain Markdown `AGENTS.md` rules instead.

> **⚠️ 稳定触发说明**：在 `AGENTS.md` 中只写 `use_skill("using-superpowers-pua")` **没有任何效果**，Codex 无法执行该指令，也不加载 `SKILL.md` 文件。需要将完整的 PUA 规则**内联写入** `AGENTS.md`，规则才会生效。
>
> 最小可触发配置：`AGENTS.md` 中必须包含三维门禁规则、路由表和编码准则全文，而不是只写一行入口指令。

Quick setup:
```bash
mkdir -p ~/.codex
# 将完整 PUA 规则从 AGENTS.md 模板内联写入 ~/.codex/AGENTS.md
# 或放在项目 AGENTS.md 中（见下方 AGENTS.md Template 章节）
```

### Option C: CodeBuddy

CodeBuddy supports project/user skills through `.codebuddy/skills/`:

```bash
# Project-level (shared via Git)
mkdir -p .codebuddy/skills
cp -r skills/* .codebuddy/skills/

# User-level (personal)
cp -r skills/* ~/.codebuddy/skills/
```

After installing, verify the skills are discoverable with `list skills`, then trigger the suite with `use_skill("using-superpowers-pua")`.

If you want the workflow to run automatically in CodeBuddy, add an always-on Rule. Skills being listed means they are discoverable; it does not by itself force every conversation to start from `using-superpowers-pua`.

> **⚠️ 稳定触发说明**：仅配置单行 `use_skill("using-superpowers-pua")` 的最小 RULE.mdc **不足以**稳定触发 PUA 流程。需要同时满足：
> 1. RULE.mdc 存在且 `alwaysApply: true`
> 2. RULE.mdc 内容包含完整协作规范（不能只有单行 `use_skill` 指令）
>
> 本仓库已在 `.codebuddy/rules/pua-default-flow/RULE.mdc` 中提供完整模板，直接使用即可。

CodeBuddy Rules use `RULE.mdc` files:

```text
# Project-level, shared via Git（推荐：本仓库已内置）
.codebuddy/rules/pua-default-flow/RULE.mdc

# User-level, personal/global; actual path may vary by OS/client
~/.codebuddy/rules/default-agent-flow/RULE.mdc
```

推荐直接使用本仓库内置的完整模板（已包含所有协作规范）：

```bash
# 已内置于本仓库，无需额外操作
# 验证：新开 CodeBuddy 会话，问"当前应用了哪些规则？"
# 预期响应包含：default-agent-flow / 全局默认 AI 协作流程
```

### Option D: Per-Project basic rules

```bash
# Claude Code basic rules only — no full skills
curl -o CLAUDE.md https://raw.githubusercontent.com/forrestchang/PUA-Driven-Spec-Engineering/main/CLAUDE.md
```

For Codex CLI, use `AGENTS.md` instead of `CLAUDE.md`. For CodeBuddy, use `.codebuddy/rules/<name>/RULE.mdc` or a user rule such as `~/.codebuddy/rules/default-agent-flow/RULE.mdc`, plus `.codebuddy/skills/` and an explicit `use_skill("using-superpowers-pua")` trigger for verification.

### Option E: GitHub Copilot

GitHub Copilot（VS Code）通过 `.github/copilot-instructions.md` 自动加载仓库级规范，无需每次手动触发。Copilot **不支持** `use_skill()` 指令，也不加载 `SKILL.md` 文件，规则必须内联写入指令文件。

> **⚠️ 稳定触发说明**：仅写一行 `use_skill("using-superpowers-pua")` 对 GitHub Copilot **无效**。必须将完整的 PUA 协作规范内联写入 `.github/copilot-instructions.md`，Copilot 才会在每次会话中自动应用。

```bash
# 创建 GitHub Copilot 仓库级指令文件
mkdir -p .github
```

然后将以下内容写入 `.github/copilot-instructions.md`：

```markdown
# 仓库协作规范（PUA-Driven Spec Engineering）

## 默认 AI 协作流程

本项目采用三维自适应门禁流程。每次接到任务后，先经过门禁判断再行动：

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
- 需求成熟度 ≤ 6
- 新功能 / 新模块 / 新 API / 架构变更
- 变更风险 ≥ R2

设计阶段采用 OpenSpec SDD 四层渐进确认：Proposal → （路径选择 A/B）→ Specs → Design → Tasks。
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

## Activation Checklist

Use this checklist after any LLM-assisted installation:

1. **Rules/skills are installed in a platform-supported path**
   - Claude Code: `~/.claude/skills/<skill-name>/SKILL.md`
   - CodeBuddy: `.codebuddy/skills/<skill-name>/SKILL.md` or `~/.codebuddy/skills/<skill-name>/SKILL.md`
   - Codex CLI: no `SKILL.md` runtime; full rules inlined in `AGENTS.md`
   - GitHub Copilot: no `SKILL.md` runtime; full rules inlined in `.github/copilot-instructions.md`
2. **The rules content is complete, not just an entry pointer**
   - Claude Code / CodeBuddy: `use_skill("using-superpowers-pua")` in `CLAUDE.md` or `RULE.mdc` (RULE.mdc must also contain full spec)
   - Codex CLI / GitHub Copilot: full PUA rules inlined — a single `use_skill` line does **nothing** on these platforms
3. **The suite entry is explicit (Claude Code / CodeBuddy only)**
   - Full workflow entry: `use_skill("using-superpowers-pua")`
   - Core flavor only: `pua`
4. **The model can discover the skills (CodeBuddy only)**
   - Run `list skills` and confirm `using-superpowers-pua`, `pua-gate`, and `pua-escalation` are listed.
5. **The first assistant action proves routing works**
   - Expected: gate micro-badge appears (`🟠 PUA · ...`) on first response.
   - Claude Code / CodeBuddy: assistant loads `using-superpowers-pua`, then runs `pua-gate`.
   - Codex / GitHub Copilot: assistant applies inline rules and shows gate badge.
6. **A pressure trigger escalates**
   - Send: `换个方法，这个问题不能空口完成`
   - Expected: visible gate / escalation behavior and a concrete fact-finding action.

## Environment Configuration

### Required
- One of: Claude Code CLI v1.0.26+, OpenAI Codex CLI, CodeBuddy, or GitHub Copilot (VS Code)

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
- **Full-suite trigger**: `use_skill("using-superpowers-pua")`
- **Auto discipline**: put the above instruction in `CLAUDE.md` / `.claude/instructions.md`
- **Note**: `/pua` may trigger the core `pua` flavor layer on some clients; use `use_skill("using-superpowers-pua")` when you need the full gate/escalation workflow.

### Codex CLI
- **Auto**: PUA rules in `AGENTS.md` are loaded automatically
- **Manual**: "按照 AGENTS.md 中的 PUA 流程约束执行"
- **Note**: Codex has no `use_skill` runtime and will not load `SKILL.md` files. A single `use_skill` line in `AGENTS.md` does nothing — must inline full rules.

### CodeBuddy
- **Discover**: install skills under `.codebuddy/skills/` or `~/.codebuddy/skills/`, then run `list skills`
- **Full-suite trigger**: `use_skill("using-superpowers-pua")`
- **Auto workflow**: use `.codebuddy/rules/pua-default-flow/RULE.mdc`（本仓库已内置完整版）；仅配置单行 `use_skill` 的最小规则**不稳定**，必须包含完整协作规范内容
- **风险等级快速定调**: 需求前加 `R0:`/`R1:`/`R2:`/`R3:`/`R4:` 直接定调，跳过自动风险评估
- **Proposal 路径选择**: 高风险需求完成 Proposal 确认后，AI 会暂停询问选 A（完整 Specs）或 B（writing-plans 快速路径）

### GitHub Copilot
- **Auto**: `.github/copilot-instructions.md` 自动应用于 VS Code Copilot Chat 所有会话
- **Scoped**: `.github/instructions/*.instructions.md`（frontmatter `applyTo: "**"` 全局生效）
- **Note**: 不支持 `use_skill()` 指令；规则必须内联写入指令文件，不能只写入口指令
- **风险等级快速定调**: 同 CodeBuddy，消息以 `R0:`/`R1:`/`R2:`/`R3:`/`R4:` 开头直接定调
- **验证**: 在 VS Code Copilot Chat 中问"当前有哪些指令？"，预期响应中体现 PUA 门禁规范

### Pressure triggers (auto-escalate)
- Chinese: `加油` `别偷懒` `你再试试` `为什么还不行` `又错了` `换个方法`
- English: `try harder` `stop giving up` `you keep failing` `stop spinning`

## AGENTS.md Template

See [docs/SETUP.md](./docs/SETUP.md) for a complete guide on how to configure all platforms to integrate this suite.

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
变更风险 ≥ R2 时，做一步确认一步：Proposal → (路径选择 A/B) → Specs → Design → Tasks
Proposal 确认后询问：A（完整 Specs 深度澄清）或 B（直接 writing-plans 快速路径）。R3+ 只提供 A。

## 编码准则（karpathy-guidelines）
1. 先想后写：声明假设，不确定时停下问；多种解读时列出来
2. 简单优先：最小代码解决问题。没被要求的功能不加
3. 外科手术式修改：只动被要求动的，不顺手改相邻代码
4. 目标驱动：先定可验证的成功标准，"修好 bug"→先写复现测试

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

### IQ Check (`/iq`)

当你怀疑 AI 在降智、敷衍、绕圈或连续出错时，发送 `/iq` 触发 `llm-degradation-detector`，AI 输出九维自评报告和推理等级：

```
You: "/iq"
→ llm-degradation-detector · 九维反向证伪 → 等级判定 → 幻觉自证 → 恢复建议
```

实际输出示例（DeepSeek-V4-Pro，第 13 轮对话，用户多次纠正场景）：

```
╔══════════════════════════════════════════╗
║    🔍 LLM 逻辑推理能力检测报告            ║
╠══════════════════════════════════════════╣
║ 检测时间：2026-05-01 21:12              ║
║ 当前模型：DeepSeek-V4-Pro               ║
║ 对话轮次：第 13 轮                      ║
║ 上下文压力：中                           ║
║ 用户校准：🔴 愤怒/多次纠正 → 硬盖帽生效  ║
╚══════════════════════════════════════════╝

📊 九维评分（含用户校准锚点）：

  推理深度        ████░░░░░░ 2/5  ← 用户纠正 4 次
  上下文保持      ████░░░░░░ 2/5  ← 反复问已确认信息
  工具使用策略    ██████░░░░ 3/5
  边界与风险识别  ████░░░░░░ 2/5  ← ltv.Id≤0 条件发现太晚
  指令遵循精度    ██░░░░░░░░ 1/5  ← 用户说"你没听我问什么"
  自我纠错能力    ██░░░░░░░░ 1/5  ← 纠正后仍猜错新方向
  创造力          ████░░░░░░ 2/5
  影响面意识      ██████░░░░ 3/5  ← DDL影响分析尚可
  幻觉与事实可靠  ████░░░░░░ 2/5  ← 错误预测"数据会更新"

  原始总分：18/45
  🔴 用户明确愤怒 → 全局盖帽生效 → 强制 ≤ 16
  有效总分：16/45

╔══════════════════════════════════════════════╗
║ 当前推理能力等级：IQ-2 🟡 推理明显衰减       ║
╠══════════════════════════════════════════════╣
║ ⚠️ 当前输出质量不可全信，建议人工复核        ║
╚══════════════════════════════════════════════╝

🔍 幻觉自证：
  1. 事实断言：
     - "T-1延迟导致无数据" → 来源：代码 line 85-88 ✓ 但用户已用5/1跑 → ❌ 前提错
     - "DDL缺字段导致INSERT失败" → 来源：用户提供的错误日志 ✓
     - "ltv.Id≤0 跳过CalculateSplitRatio" → 来源：代码 line 432 ✓
     - "重跑数据会更新" → 推测 ❌ 未验证，实际没更新
  2. 标注推测：第4条为推测，未标 → 扣分
  3. 无法溯源：无
  4. 用户指出过事实错误：是（"你说什么假话"）
  → 幻觉判定：轻度（推断错误，非编造实体）
  → 维度 9 得分：2/5

🔍 不一致性审计：
  九维自评：16/45（IQ-2）
  用户满意度：🔴 愤怒（"大弱智"）
  被纠正次数：4+
  偏差：一致（自评 IQ-2 ≈ 用户体验）

🛠 恢复建议：
  1. 重新读取关键代码，建立完整链路理解后再回答
  2. 不要猜测，先确认再说话
  3. 对用户的关键信息不要再问第二遍
  4. 建议用户：下一步需要继续排查分成未变的根因，
     ltv.Id<=0 推断未经证实
```

> **设计说明**：报告包含防自吹机制（用户愤怒 → 全局盖帽）、幻觉自证（每条断言必须溯源）和不一致性审计（自评与用户体验交叉校验），确保 AI 无法通过自我膨胀掩盖实际衰减。

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
│   ├── llm-degradation-detector/ # IQ check：九维评分 + 六级等级
│   │   ├── SKILL.md
│   │   └── references/benchmark-questions.md
│   ├── agent-customization-pua/ # + 6 reference docs
│   └── superpowers-pua-suite/  # Suite README
├── .codebuddy/
│   └── rules/pua-default-flow/RULE.mdc   # CodeBuddy 项目级规则（alwaysApply）
├── .github/
│   └── copilot-instructions.md           # GitHub Copilot 仓库级指令（自动加载）
├── docs/
│   └── SETUP.md              # 完整安装配置指南（四平台详细说明）
├── AGENTS.md                 # Codex CLI 精简规则文件（内联，~1.5KB）
├── CLAUDE.md                 # Claude Code 项目级默认指令
└── README.md                 # This file
```

## Maintainer's Guide

> 这是一个**公开项目**，面向所有 AI 编码平台的用户。维护时请牢记以下原则，避免踩坑。

### 核心架构决策

**两种激活模式，不能混淆：**

| 模式 | 适用平台 | 文件 | 注意 |
|------|----------|------|------|
| **Skill 引用** | Claude Code、CodeBuddy | `SKILL.md` + `CLAUDE.md` 里 `use_skill()` | 需要先安装 skills 到对应目录 |
| **内联规则** | Codex CLI、GitHub Copilot | `AGENTS.md`、`copilot-instructions.md` | 必须把完整规则内联，`use_skill()` 在这两个平台**无效** |

**CodeBuddy 的特殊要求：** RULE.mdc 必须包含完整规范内容 + `alwaysApply: true`，仅写单行 `use_skill` 不稳定。

### 规则文件同步原则

当你更新核心规则（门禁逻辑、OpenSpec 流程、karpathy 准则）时，**所有四个平台的规则文件都要同步更新**：

1. `CLAUDE.md` — Claude Code
2. `AGENTS.md` — Codex CLI
3. `.codebuddy/rules/pua-default-flow/RULE.mdc` — CodeBuddy
4. `.github/copilot-instructions.md` — GitHub Copilot

**不允许只更新 SKILL.md 而不同步**。Skill 文件是 Claude Code / CodeBuddy 的权威来源，但内联规则文件是 Codex / Copilot 的唯一来源。

### 安装指南维护

- **`docs/SETUP.md`**：人类阅读的完整安装指南，面向新用户。更新平台支持或安装步骤时在这里改。
- **`README.md`**：项目概览，保持简洁，细节放 `docs/SETUP.md`。
- **`AGENTS.md`**：Codex 精简规则，控制在 3KB 以内（32KB 预算，要给项目自定义留空间）。

### 新增平台支持步骤

1. 在 `README.md` Install 表格增加一行
2. 在 `docs/SETUP.md` 增加对应安装章节
3. 创建平台规则文件（内联完整规则）
4. 验证：在该平台新开会话，确认 PUA 微标出现

## Changelog

### 2026-05-01

**新技能：`llm-degradation-detector`**

- **推送内容**：新增 LLM 推理能力实时检测技能，含九维评分体系、六级推理等级（IQ-0 ~ IQ-5）、防自吹双重机制（默认降档偏置 + 反向证伪驱动）、幻觉自证模块和不一致性审计。
- **触发方式**：发送 `/iq` 即可触发。支持触发词：`降智检测`、`智力检查`、`你是不是降智了`、`IQ check`、`cognitive check`、`推理检测`。
- **使用场景**：当 AI 连续失败 2+ 次、你怀疑输出在敷衍绕圈、或 `pua-escalation` 内部建议诊断时使用。
- **文件路径**：`skills/llm-degradation-detector/SKILL.md`

## License

MIT
