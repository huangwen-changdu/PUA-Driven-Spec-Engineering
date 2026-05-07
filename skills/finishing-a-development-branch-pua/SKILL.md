---
name: finishing-a-development-branch-pua
description: "当实现已完成且已验证，需要明确收尾而不是让工作停留在半成品或模糊状态时使用"
---

# Finishing a Development Branch PUA

## 概述

验证通过后，明确地结束这个分支。

**核心原则：** 代码写完不等于工作结束；分支结果没落定，就不算真正收尾。出现含糊收尾、没验证就清理、想把状态悬着不管时，直接调用 `pua-escalation`，再回到收尾流程继续完成闭环。

## 第 0 步：自适应门禁

进入本 skill 后，先经过 `pua-gate` 并按档位执行：

- `G0/G1 PASS`：普通问题轻量快放，输出一行微标/轻标（不得完全静默）
- `G2 PASS`：多步骤或跨文件任务输出简版门禁
- `ESCALATE`：立即调用 `pua-escalation`，再回到本 skill
- `BLOCKED`：补齐输入或证据，不得继续

未经过 `pua-gate`，不得进入下面的主流程；但普通问题不得为了“有流程感”展开长门禁。

## 必经流程

0. 确认**本轮用户消息**已完成第 0 步门禁；不能复用上一轮 `pua-gate` 结果
1. 验证测试和必要检查
2. 确认基线分支
3. 若本次变更包含 `Change Metadata`，执行 `Feature Ledger Writeback`：归档 `openspec/changes/{change-name}/` 后，更新 `openspec/features/{feature-name}/README.md` 的当前版本、最近变更、版本历史、关键决策、已知约束和归档路径
4. 清楚地给出收尾选项
5. 判断是否需要调用 `pua-escalation`
6. 若本轮有用户纠正、重复失败或可复用坑点，调用 `pua-learning-loop` 确认学习卡是否已落地
7. 安全执行用户选择
8. 只在合适时清理环境

## 直接调用 `pua-escalation` 的触发条件

出现任一情况，先调用 `pua-escalation`，再回到收尾流程：

- 你想含糊地说“先放这”
- 你准备没验证就做清理
- 你没有明确结束态，却想先结束对话
- 你想把当前状态悬着不管
- 你在拿“差不多收尾了”冒充真正收尾

## 高压下怎么做

不要把结尾搞模糊。

不允许：

- 默默搁置
- 含糊地说“先放这”
- 没验证就做清理
- 出现悬置倾向时不调 `pua-escalation`

## 有效结束态

- 已本地合并
- 已推送并发起 PR
- 明确保留当前状态
- 明确确认后丢弃

## Feature Ledger Writeback 完成条件

当本次变更包含 `Change Metadata` 时，声称完成前必须检查：

- `openspec/changes/{change-name}/` 已按流程归档，或明确说明本轮尚未归档
- `openspec/features/{feature-name}/README.md` 已更新当前版本和最近变更
- `版本历史` 已增加本次变更记录
- `关键决策` 和 `已知约束` 已写入本次新增的重要结论
- `关联文档` 已写入当前 change 或归档路径

没有完成 Feature Ledger Writeback，不允许说“完成/收尾完成”。

## 压力升级（内联保底）

优先调用 `pua-escalation`；无法加载时按以下规则就地执行：

| 失败次数 | 等级 | 强制动作 |
|---------|------|--------|
| 2 | E1 | 换本质不同的方案，不准换参数冒充 |
| 3 | E2 | 搜索 + 读上下文 + 列 3 个假设 |
| 4 | E3 | 7 项检查清单全部填完才继续 |
| 5+ | E4 | 拼命模式：升级搜索、验证、review |

**E3+ 检查清单**：逐字读失败信号？搜索过核心问题？读过原始上下文？假设用工具确认？试过反向假设？最小范围复现？换过工具/方法？

**方法论切换**：优先由 `pua-escalation` 按 `pua/references/methodology-router.md` 切换链执行；无法加载时按内联切换动作表执行。

## 底线

把工作收干净，不要让分支状态悬着；一旦开始想模糊收尾，就先调 `pua-escalation`。
