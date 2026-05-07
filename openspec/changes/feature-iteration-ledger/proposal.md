# 功能迭代追踪机制提案

## Why
当前 OpenSpec 变更文档以 `openspec/changes/{change-name}/` 为中心组织，每次需求会产生一组独立的 `proposal.md`、`specs/spec.md`、`design.md`、`tasks.md`。这能管理单次变更，但不能稳定表达“同一个功能经历了哪些版本、修复过什么、为什么这么演进”。

因此，当一个功能持续迭代时，用户需要反复重新说明背景，AI 也难以主动复用历史上下文，导致：

- 新需求与历史修复、历史决策脱节
- 多个变更文档之间缺少可导航关系
- 不知道当前功能已经迭代到第几版
- 无法快速判断某次调整是新增、修复、回滚还是重构
- 归档后的变更难以回写到功能长期知识中

本变更的目标是让“功能”成为长期可追踪对象，让“变更”成为功能版本历史中的一次迭代记录。

## What Changes

新增一套功能级迭代追踪规则：

1. 新增功能档案目录：`openspec/features/{feature-name}/README.md`
2. 每个功能档案维护：功能背景、当前版本、能力范围、历史版本、关联变更、关键决策、已知约束
3. 每个 `openspec/changes/{change-name}/` 必须声明归属功能与迭代版本
4. 新变更开始前，AI 必须先查对应功能档案和历史变更摘要
5. 变更完成归档时，必须回写功能档案，形成连续版本链
6. 若功能档案不存在，则首个变更必须创建该功能档案

## Capabilities

### New Capabilities

- `feature-ledger`: 功能级长期档案，记录同一功能的背景、版本、历史迭代与关键决策
- `change-lineage`: 变更链路追踪，记录当前变更属于哪个功能、是第几版、前置版本是什么
- `iteration-context-recall`: 新需求开始前自动读取功能历史，减少用户重复说明背景
- `archive-writeback`: 变更完成后回写功能档案，保证归档不是断点

### Modified Capabilities

- `brainstorming-pua`: Core Clarification 前增加“功能档案查找/创建”步骤
- `pua-gate`: G2+ 真实业务需求需识别是否属于已有功能迭代
- `writing-plans-pua`: 计划生成需引用功能档案中的历史约束和版本目标
- `finishing-a-development-branch-pua`: 收尾归档时增加功能档案回写要求
- `README.md` / `docs/DECISION-TREE.md` / `docs/SCENARIOS.md`: 增加功能迭代追踪说明和使用入口

## Impact

- 流程文档：需要更新 OpenSpec SDD 规则，增加功能档案与版本链机制
- 技能文件：主要影响 `skills/brainstorming-pua/SKILL.md`，可能同步影响 `skills/pua-gate/SKILL.md`、`skills/finishing-a-development-branch-pua/SKILL.md`、`skills/writing-plans-pua/SKILL.md`
- 用户使用方式：用户后续可用“继续迭代某功能”“基于某功能 vN 更新”触发历史读取
- 数据持久化：不涉及数据库或生产数据，仅涉及仓库文档结构
- 兼容性：保留现有 `openspec/changes/{change-name}/`，不破坏已有变更文档结构

## Risk Assessment

- 变更风险等级：R2
- 风险原因：这是流程架构变更，影响多个技能如何组织和回忆需求文档
- 影响文件数：预计 4-7 个文档/技能文件
- 是否命中复合升级：是（流程架构变更 + 多文件影响）
- 回滚方式：撤销新增的功能档案规则段落，保留原 `openspec/changes/{change-name}/` 机制

## 需求边界（合并 Specs）

### 功能档案结构

建议每个功能档案使用以下结构：

```text
openspec/features/{feature-name}/README.md
```

内容模板：

```markdown
# {功能名}功能档案

## 当前状态
- 当前版本：v{N}
- 状态：规划中 / 开发中 / 已发布 / 暂停 / 废弃
- 最近变更：{change-name}

## 功能背景
[这个功能为什么存在，解决什么问题]

## 能力范围
### 当前支持
- [能力点]

### 非目标
- [明确不做]

## 版本历史
| 版本 | 变更 | 类型 | 日期 | 状态 | 摘要 |
|---|---|---|---|---|---|
| v1 | `{change-name}` | 新增 | YYYY-MM-DD | 已归档 | 初始能力 |

## 关键决策
- YYYY-MM-DD：{决策}，原因：{原因}，来源：`openspec/changes/.../design.md`

## 已知约束
- [历史遗留约束、兼容性要求、不能踩的坑]

## 关联文档
- 当前变更：`openspec/changes/{change-name}/`
- 历史归档：`openspec/changes/archive/{date}-{change-name}/`
```

### Change 元数据结构

每个 `proposal.md` 顶部必须增加：

```markdown
## Change Metadata
- Feature: `{feature-name}`
- Iteration: `v{N}`
- Change Type: 新增 / 增强 / 修复 / 重构 / 回滚 / 废弃
- Previous Change: `{previous-change-name}` 或 `无`
- Related Archive: `openspec/changes/archive/{date}-{previous-change-name}/` 或 `无`
- Feature Ledger: `openspec/features/{feature-name}/README.md`
```

### 新需求启动规则

当用户提出需求时，AI 必须判断：

1. 这是全新功能，还是已有功能的一次迭代？
2. 如果是已有功能，先读取 `openspec/features/{feature-name}/README.md`
3. 如果功能档案不存在，先创建档案草案，并在首个 change 中声明 `Iteration: v1`
4. 如果功能档案存在，新 change 的 `Iteration` 必须在当前版本基础上递增
5. Core Clarification 必须引用功能档案中的历史背景、约束、关键决策

### 归档回写规则

当变更完成并归档后，AI 必须更新功能档案：

- 更新 `当前版本`
- 更新 `最近变更`
- 在 `版本历史` 增加一行
- 把本次重要技术决策写入 `关键决策`
- 把新增约束或踩坑写入 `已知约束`
- 把归档路径写入 `关联文档`

## 验收标准

- [ ] 新流程明确区分“功能档案”和“单次变更文档”
- [ ] 新需求开始前有规则要求先查历史功能档案
- [ ] 每次变更有 `Feature`、`Iteration`、`Previous Change` 元数据
- [ ] 归档时有规则要求回写功能档案
- [ ] README 或 docs 中有用户可理解的使用方式
- [ ] 不破坏现有 `openspec/changes/{change-name}/proposal.md / design.md / tasks.md` 结构

## 非目标

- 不引入数据库、脚本或外部系统
- 不实现自动版本号计算程序
- 不迁移历史上不存在的 OpenSpec 实例
- 不改变 PUA 门禁 G0-G4 的基本含义
- 不把 `.copilot` 学习库替换为功能档案；二者职责不同：`.copilot` 记录项目踩坑经验，`openspec/features` 记录功能演进历史

## 边界条件

- 如果一个需求影响多个功能：必须拆成多个 change，或在 Proposal 中声明主功能与相关功能
- 如果功能被废弃：功能档案状态标记为 `废弃`，但不删除历史
- 如果用户不知道功能名：AI 先搜索现有功能档案和代码上下文，再建议功能名
- 如果历史档案与当前代码事实冲突：以代码事实为准，并在本次 change 中记录“历史档案需修正”
