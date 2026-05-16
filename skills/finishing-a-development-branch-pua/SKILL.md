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

## 压力升级

当遇到困难或失败时，读取 `skills/pua-escalation/SKILL.md` 获取具体的解决方案和指导。

## 底线

把工作收干净，不要让分支状态悬着；一旦开始想模糊收尾，就先调 `pua-escalation`。
