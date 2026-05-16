# PUA-Driven Spec Engineering

> 一套面向所有开发者和团队的**通用 AI 协作服务流程 / 多平台技能框架**，支持 Claude Code、OpenAI Codex CLI、CodeBuddy 和 GitHub Copilot 四个平台。通过自适应门禁、OpenSpec SDD 渐进确认和 Karpathy 编码准则，让 AI 编码助手更严谨、更可控。

**作者**：huangwen  
**联系邮箱**：fanwen887@gmail.com

## 核心价值

**一句话**：让 AI 编码助手更严谨、更可控，防止"说完成但没验证"、"跳过设计直接写代码"等问题。

**三个关键点**：
1. **自适应门禁**：普通问题轻量快放，高压问题走完整流程
2. **先设计后实现**：新功能必须先做方案对比，再写代码
3. **验证闭环**：说"完成"前必须有验证命令和真实输出

## 快速上手（5 分钟）

> **详细指南**：[docs/QUICKSTART.md](docs/QUICKSTART.md) | **决策速查**：[docs/DECISION-TREE.md](docs/DECISION-TREE.md) | **场景模板**：[docs/SCENARIOS.md](docs/SCENARIOS.md)

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

## 核心机制

### 三层架构

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

## 特色技能详解

### `pua-gate` — 自适应门禁

不是每个问题都需要走完整流程，`pua-gate` 按任务复杂度自动分档：

| 档位 | 触发条件 | 执行方式 |
|------|---------|---------|
| **G0/G1** | 简单问题（改名、解释、单行修复） | 一行微标，直接执行 |
| **G2** | 多步骤 / 跨文件任务 | 简版门禁，列关键约束后执行 |
| **ESCALATE** | 连续失败 / 用户不满 / 高风险变更 | 调用 `pua-escalation` 收紧再继续 |
| **BLOCKED** | 需求几乎空白 | 停止推进，问一个最小澄清问题 |

### `pua-escalation` — 压力升级引擎

LLM 连续失败时最常见的问题是：换措辞但不换方案，原地打转。`pua-escalation` 提供五级压力等级和强制切换规则：

| 等级 | 触发时机 | 强制行为 |
|------|---------|---------|
| E0 | 正常执行 | 无额外约束 |
| E1 | 第 1 次失败 | 必须重新搜索 / 读文件再开口 |
| E2 | 第 2 次失败 | 换本质不同的方案（换参数不叫换方案） |
| E3 | 第 3 次失败 | 七项检查清单全部完成才能继续 |
| E4 | 第 4+ 次失败 | 停止执行，等待人工介入 |

### `brainstorming-pua` — 需求澄清与方案设计

新功能直接写代码是大多数返工的根源。本 skill 强制先完成核心问题澄清，再走 OpenSpec SDD 渐进确认，做一步确认一步：

```
完整路径（R3+ / 低成熟度）：
Core Clarification → Proposal → Specs → Design → Tasks（4 次确认）

合并路径（R2 + 成熟度 5+）：
Core Clarification → Proposal+Specs → Design → Tasks（3 次确认）
```

### `llm-degradation-detector` — LLM 推理能力检测（`/iq`）

当 AI 连续出错，你需要知道它现在的推理能力处于什么水平。发送 `/iq` 触发九维自评报告：

**九维评分**（每维 0-5 分，总分 45）：

> 推理深度 · 上下文保持 · 工具使用策略 · 边界与风险识别 · 指令遵循精度 · 自我纠错能力 · 创造力 · 影响面意识 · 幻觉与事实可靠性

## 安装指南

支持四个 AI 编码平台，按需选择：

| 平台 | Skill 支持 | 指令文件 | 重要 |
|------|-----------|---------|------|
| **Claude Code** | 完整 `SKILL.md` + references | `CLAUDE.md` / `.claude/instructions.md` | 安装 skills **和** 添加入口指令 |
| **OpenAI Codex CLI** | 不加载 `SKILL.md`；Markdown 规则 | `AGENTS.md` | 必须内联**完整规则** |
| **CodeBuddy** | Skills via `.codebuddy/skills/` | Rules: `.codebuddy/rules/<name>/RULE.mdc` | RULE.mdc 必须含**完整规范内容** |
| **GitHub Copilot** | 不加载 `SKILL.md`；Markdown 规则 | `.github/copilot-instructions.md` | 规则必须内联写入指令文件 |

> **详细安装指南**：[docs/SETUP.md](docs/SETUP.md)

### 快速安装（Claude Code）

```bash
# 复制 skills 到用户目录
cp -r skills/* ~/.claude/skills/

# 在项目 CLAUDE.md 中添加入口指令
echo '每次对话开始时，第一个动作必须是读取 `skills/using-superpowers-pua/SKILL.md`。' >> CLAUDE.md
```

## 流程状态看板

AI 会在每轮输出中显示流程进度：

```text
🟠 PUA · 阿里味 · G2 · 设计阶段
进度：[██████░░░░] 60% (3/5 层)
当前：Design 技术设计
下一步：确认技术方案 → Tasks 任务清单
```

## 快速通道条件

满足以下**全部**条件时，可直接进入实现（跳过设计）：
1. 需求成熟度 ≥ 8
2. 变更风险 ≤ R1
3. 影响文件 ≤ 2 个
4. 用户明确说"我知道怎么做"
5. 无新功能/新模块/新API

## 回退命令

- `/back`：回到上一步
- `/restart`：重新开始当前阶段
- `/simplify`：切换到简化模式
- `/full`：切换到完整模式
- `/diagnose`：流程诊断

## 项目结构

```
PUA-Driven-Spec-Engineering/
├── skills/                    # 21 个技能文件
├── .codebuddy/               # CodeBuddy 项目级规则
├── .github/                  # GitHub Copilot 指令
├── docs/                     # 文档目录
├── AGENTS.md                 # Codex CLI 规则
├── CLAUDE.md                 # Claude Code 指令
└── README.md                 # 本文件
```

## 典型工作流

### 简单任务（G0/G1）
```
You: "Rename this function"
→ G0 PASS · Direct execution · No full lifecycle needed
```

### 中等任务（G2）
```
You: "Add user registration"
→ G2 · brainstorming-pua → writing-plans-pua → TDD → verification
```

### 高压任务（ESCALATE）
```
You: "/pua this bug has failed 3 times"
→ ESCALATE · pua-escalation (E2: must search, read, list hypotheses)
→ systematic-debugging-pua → verification-before-completion-pua
```

## 如何知道流程在工作

这些指南在工作时，你会看到：
- **PUA 微标**：每轮响应开头的 `🟠 PUA · {flavor} · G0 · {constraint}`
- **升级动作**：当你表达不满或连续失败时
- **证据先于声明**：没有验证输出就不会说"完成了"
- **外科手术式修改**：只有被要求的修改才会出现在 diff 中
- **设计先于实现**：新功能会先经过 brainstorming

## License

MIT