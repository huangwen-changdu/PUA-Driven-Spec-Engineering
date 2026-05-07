# 功能迭代追踪机制功能档案

## 当前状态
- 当前版本：v1
- 状态：开发中
- 最近变更：feature-iteration-ledger

## 功能背景
当前 OpenSpec 以 `openspec/changes/{change-name}/` 管理单次变更，但同一个功能多次迭代时，历史修复、版本演进和关键决策容易分散在不同文档中。该功能用于让“功能”成为长期可追踪对象，让“变更”成为功能版本历史中的一次迭代记录。

## 能力范围

### 当前支持
- 通过 `openspec/features/{feature-name}/README.md` 记录功能长期档案。
- 通过 `Change Metadata` 记录单次 change 的功能归属、迭代版本、前置变更和功能档案路径。
- 新需求开始前先发现或创建 Feature Ledger，再进入 Core Clarification。
- 计划阶段继承功能档案中的版本目标、历史约束和历史修复点。
- 收尾归档时回写功能档案，保持版本链连续。

### 非目标
- 不实现自动版本号计算脚本。
- 不迁移历史上不存在的 change。
- 不替代 `.copilot` 项目学习库。
- 不改变 PUA G0-G4 门禁基本含义。

## 版本历史
| 版本 | 变更 | 类型 | 日期 | 状态 | 摘要 |
|---|---|---|---|---|---|
| v1 | `feature-iteration-ledger` | 新增 | 2026-05-07 | 开发中 | 新增功能档案、Change Metadata、历史读取和归档回写机制 |

## 关键决策
- 2026-05-07：采用 `Feature Ledger + Change Metadata + Archive Writeback`，原因：只靠 change 文档会继续分散，只靠功能档案会缺少强关联，来源：`openspec/changes/feature-iteration-ledger/design.md`。
- 2026-05-07：版本号按功能递增，不按全局 change 递增，原因：不同功能迭代节奏不同，功能局部版本更能表达真实演进，来源：`openspec/changes/feature-iteration-ledger/design.md`。
- 2026-05-07：`.copilot` 学习库不替代功能档案，原因：前者记录跨任务踩坑经验，后者记录某个功能的业务与设计演进，来源：`openspec/changes/feature-iteration-ledger/proposal.md`。

## 已知约束
- 新需求如果可能属于已有功能，必须先搜索 `openspec/features/**/README.md`。
- 功能档案与代码事实冲突时，以代码事实为准，并在本次 change 中记录“历史档案需修正”。
- 归档后必须回写功能档案，否则后续需求仍会丢失背景。
- 一个需求影响多个功能时，应拆成多个 change，或在 Proposal 中声明主功能与相关功能。

## 关联文档
- 当前变更：`openspec/changes/feature-iteration-ledger/`
- Proposal：`openspec/changes/feature-iteration-ledger/proposal.md`
- Design：`openspec/changes/feature-iteration-ledger/design.md`
- Tasks：`openspec/changes/feature-iteration-ledger/tasks.md`
