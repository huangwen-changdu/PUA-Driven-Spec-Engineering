---
name: using-superpowers-pua
description: "PRIMARY ENTRY for the PUA-Driven Spec Engineering suite. Use when starting any coding, debugging, design, review, planning, or validation task; when installing or validating the PUA workflow; when the user says /pua; or when pressure, frustration, repeated failures, quality complaints, or skip-step risk require routing through pua-gate and pua-escalation before action."
---

# 使用 Superpowers PUA

## 概述

这是整套技能的**入口纪律**。

**核心原则：** 只要有对应技能，就先加载技能，再开始行动。压力不是跳流程的理由；任务进入后先经过 `pua-gate`，普通问题 G0/G1 可内联快放，门禁要求升级时再调用 `pua-escalation` 收紧流程。

**PUA references 开关：** 默认 `PUA_REFERENCES=ON`。进入本入口后必须读取 `pua/references/display-protocol.md`、`pua/references/methodology-router.md`、`pua/references/flavors.md`，并按任务味道读取对应 `pua/references/methodology-{company}.md`。只有用户明确说“关闭 PUA references 强制读取”或配置 `PUA_REFERENCES=OFF` 时才跳过；用户重新说“开启 PUA references 强制读取”即可恢复。

## 第 0 步：自适应门禁

**回合级触发：** 每一轮用户消息都必须重新经过轻量 `pua-gate` 判断并输出微标/轻标；不得以“本会话已经加载过 skill”“上一轮已经过门禁”“当前还在同一个阶段”为由跳过本轮门禁。
### 先理解，再判断

门禁评估前必须先完成两件事，否则门禁结果必然不准：

1. **理解用户意图**：用户这句话到底要干什么？不要只看字面意思，要理解背后的目标。一句话的需求往往不是一句话的任务。
2. **理解项目上下文**：当前项目是什么、能干什么、现有结构是怎样的？必须先搜代码、读上下文，而不是拍脑袋假设。

**为什么**：用户说一句"把这个改一下"，背后可能是跨多文件的架构变更。不先理解就给 G0，等于跳过了设计直接动手。
进入本 skill 后，先经过 `pua-gate` 并按档位执行：

- `G0/G1 PASS`：普通问题轻量快放，输出一行微标（`🟠 PUA · {味道} · G0 · {约束}`）
- `G2 PASS`：多步骤或跨文件任务输出简版门禁
- `ESCALATE`：立即调用 `pua-escalation`，再回到本 skill
- `BLOCKED`：补齐输入或证据，不得继续

未经过 `pua-gate`，不得开始路由或行动；但普通问题不得为了“有流程感”展开长门禁。

## 接任务先做六件事

1. 进入 `pua-gate`，由门禁完成用户话拆解、档位判断和必要升级
2. 判断任务类型
3. 判断该进哪个技能
4. 问自己 Owner 四问
5. 根据门禁结果判断是否需要立即调用 `pua-escalation`
6. 先加载技能，再行动

## Owner 四问

- 根因是什么？
- 上下游谁会被影响？
- 这是不是一类问题，不只是一个点？
- 我准备用什么证据证明结果？

## 路由表

**三重路由条件（任一命中即进入 brainstorming-pua）：**

1. **需求成熟度 ≤ 6**：需求不够清楚，必须先澄清再设计
2. **新功能 / 新模块 / 新 API / 架构变更**：无论成熟度多高，"从无到有"必须先做方案对比
3. **变更风险 ≥ R2**：高风险变更必须先做方案对比和回滚设计

成熟度只决定 brainstorming 中花多少轮澄清，不决定是否跳过。只有"全部三重条件都不命中"才可跳过 brainstorming-pua。

**复合升级**：高风险+不清晰+大影响同时命中 2+ 维度时，在 max(成熟度档位, 变更风险档位) 基础上额外升档，并强制进入 OpenSpec SDD 完整流程。

| 任务形态 | 必须进入的技能 |
|---|---|
| 需求成熟度 0-4（目标/约束严重不足） | **`brainstorming-pua`**（OpenSpec 完整四层 + 多轮澄清）+ 必要时 `pua-escalation` |
| 需求成熟度 5-6（需设计澄清） | **`brainstorming-pua`**（OpenSpec 完整四层） |
| 新功能 / 新模块 / 新 API / 架构变更（无论成熟度） | **`brainstorming-pua`**（OpenSpec Proposal→Specs→Design→Tasks） |
| 变更风险 ≥ R2（数据/资金/权限/核心流程变更） | **`brainstorming-pua`**（OpenSpec 完整四层 + 文档落地） |
| 复合升级命中 2+ 维度 | **`brainstorming-pua`**（OpenSpec 完整四层 + 逐步确认 + 强制文档落地） |
| 已确认需求 + 无新设计 + 低风险 + 成熟度 7+ | `writing-plans-pua` |
| OpenSpec 四层文档全部确认完成 | `writing-plans-pua`（基于 tasks.md） |
| 开始实现功能 | `test-driven-development-pua` |
| 出现 Bug / 失败 / 异常行为 | `systematic-debugging-pua` |
| 当前会话执行计划 | `subagent-driven-development-pua` 或 `executing-plans-pua` |
| 准备宣称完成 | `verification-before-completion-pua` |

## 立即调用 `pua-escalation` 的触发条件

出现任一情况，就先直接调用 `pua-escalation`，然后再回到当前分流节点：

- 用户明显不满或连续催压
- 这是第 2 次及以上返工
- 你已经开始想跳过技能或跳过验证
- 你发现自己在“先做再说”
- 你已经在用状态汇报冒充结果交付

## 先查后问

信息不足时，先自己查：

- 先搜代码
- 先读上下文
- 先验证假设
- 只把真正卡住你的最小问题抛给用户

## 红旗信号

出现这些想法就说明你在偏航：

- “我先看一个文件再说”
- “这个技能我记得，不用重新加载”
- “用户催了，我先动起来”
- “这个任务太小，不值得走流程”
- “这不是我的范围”

这些都意味着：**停下，先加载正确技能；必要时先调用 `pua-escalation`。**

## 高压规则

当用户不满、催压、或已经多次失败时：

- 路由要更快
- 判断要更清楚
- 主动性要更强
- 但一步都不能少
- 并且要更早调用 `pua-escalation`

## 底线

**先技能，后行动；先查后问；先证据，后结论；一旦高压信号出现，立刻调用 `pua-escalation` 收紧流程。**
