# 功能迭代追踪机制技术设计

## 方案对比

### 方案 A：只在 Change 文档增加元数据
- 描述：继续只使用 `openspec/changes/{change-name}/`，在 `proposal.md` 顶部增加 `Feature`、`Iteration`、`Previous Change` 等字段。
- 优点：改动最小；不新增目录；对现有 OpenSpec 结构干扰低。
- 缺点：历史仍然分散；想看某个功能全貌时需要反向搜索多个 change；归档后长期视图仍不稳定。
- 影响面：主要修改 `brainstorming-pua` 的 Proposal 模板。

### 方案 B：只新增功能档案
- 描述：新增 `openspec/features/{feature-name}/README.md`，但不强制每个 change 写元数据。
- 优点：用户能看到功能长期背景和版本历史。
- 缺点：change 与 feature 的关联依赖人工维护；AI 无法稳定判断新需求属于哪个功能版本；容易出现档案和 change 脱节。
- 影响面：修改 `brainstorming-pua`、收尾归档流程和用户文档。

### 方案 C：功能档案 + Change 元数据 + 归档回写
- 描述：功能长期档案记录版本链；每个 change 声明功能归属与迭代版本；归档时强制回写功能档案。
- 优点：既保留单次变更文档，又有功能级连续历史；新需求能先读取历史；归档不会成为断点。
- 缺点：流程规则更严格；需要同步修改多个技能和文档。
- 影响面：`brainstorming-pua`、`pua-gate`、`writing-plans-pua`、`finishing-a-development-branch-pua`、`README.md`、`docs/DECISION-TREE.md`、`docs/SCENARIOS.md`。

### 推荐：方案 C
推荐方案 C，因为本次问题的根因不是“单个文档缺字段”，而是缺少**功能级长期上下文治理机制**。只改 change 文档会继续分散；只加功能档案会缺少强关联。方案 C 同时解决版本、历史、关联、归档回写四个闭环点。

## 架构

### 文档层级

```text
openspec/
├── features/
│   └── {feature-name}/
│       └── README.md              # 功能长期档案
└── changes/
    ├── {change-name}/
    │   ├── proposal.md            # 单次变更提案，含 Change Metadata
    │   ├── design.md
    │   └── tasks.md
    └── archive/
        └── {date}-{change-name}/
```

### 责任划分

| 层级 | 责任 | 生命周期 |
|---|---|---|
| `openspec/features/{feature-name}/README.md` | 记录功能背景、当前版本、版本历史、关键决策、已知约束 | 长期存在，随每次迭代更新 |
| `openspec/changes/{change-name}/` | 记录一次需求变更的 Proposal / Design / Tasks | 开发中存在，完成后归档 |
| `openspec/changes/archive/{date}-{change-name}/` | 保存已完成变更的完整证据链 | 长期只读 |

### 数据流向

```text
用户提出需求
  ↓
pua-gate 判断：全新功能 / 已有功能迭代 / 不确定
  ↓
brainstorming-pua 搜索 openspec/features 与历史 changes
  ↓
创建或更新 openspec/changes/{change-name}/proposal.md 的 Change Metadata
  ↓
Design / Tasks 引用 Feature Ledger 的历史约束
  ↓
实现与验证
  ↓
finishing-a-development-branch-pua 归档 change
  ↓
回写 openspec/features/{feature-name}/README.md
```

## 关键决策

1. **功能档案是长期入口，Change 是单次执行记录**
   - 原因：用户关心的是“这个功能演进到哪里了”，不是孤立的某次需求。

2. **版本号按功能递增，不按 change 全局递增**
   - 原因：不同功能的迭代节奏不同，全局版本号无法表达功能局部演进。

3. **Change Metadata 放在 `proposal.md` 顶部**
   - 原因：Proposal 是变更入口；越早声明关联，后续 Design 和 Tasks 才不会跑偏。

4. **归档必须回写功能档案**
   - 原因：只归档 change 不回写 feature，会重新造成“文档孤岛”。

5. **`.copilot` 学习库不替代功能档案**
   - 原因：`.copilot` 记录跨项目/跨任务踩坑经验；`openspec/features` 记录某个功能的业务与设计演进。

## 文档契约

### Feature Ledger 模板

路径：`openspec/features/{feature-name}/README.md`

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

### Change Metadata 模板

位置：`openspec/changes/{change-name}/proposal.md` 顶部，位于标题后、`Why` 前。

```markdown
## Change Metadata
- Feature: `{feature-name}`
- Iteration: `v{N}`
- Change Type: 新增 / 增强 / 修复 / 重构 / 回滚 / 废弃
- Previous Change: `{previous-change-name}` 或 `无`
- Related Archive: `openspec/changes/archive/{date}-{previous-change-name}/` 或 `无`
- Feature Ledger: `openspec/features/{feature-name}/README.md`
```

## 流程改造点

### `pua-gate`

新增判断：当用户提出真实业务需求、用户故事、功能体验调整或“继续改某功能”时，G2+ 门禁必须额外判断：

1. 是否可能属于已有功能迭代
2. 是否需要搜索 `openspec/features/**/README.md`
3. 是否需要读取最近归档 change
4. 是否存在功能档案与代码事实冲突

G2+ 理解确认中应增加历史引用：

```text
我查到：该需求关联 `{feature-name}`，当前功能档案版本为 v{N}，最近变更为 `{change-name}`。
```

### `brainstorming-pua`

在 Core Clarification 前新增“Feature Ledger Discovery”步骤：

1. 搜索 `openspec/features/` 是否已有相关功能档案
2. 如果存在，读取功能档案并提取背景、当前版本、关键约束、最近变更
3. 如果不存在，判断是否创建新功能档案草案
4. 新建 `proposal.md` 时必须写入 Change Metadata
5. Core Clarification 必须引用历史约束和版本目标

### `writing-plans-pua`

计划生成前必须检查：

- 是否存在 Feature Ledger
- `tasks.md` 是否引用了本次 `Iteration`
- 每个任务是否考虑功能档案中的已知约束
- 验证计划是否覆盖历史修复点，避免回归

### `finishing-a-development-branch-pua`

收尾流程新增“Feature Ledger Writeback”：

1. 确认变更已验证
2. 归档 `openspec/changes/{change-name}/`
3. 更新 `openspec/features/{feature-name}/README.md`
4. 写入版本历史、关键决策、已知约束、归档路径
5. 再声明工作完成

### 用户文档

需要在以下文档增加用户入口说明：

- `README.md`：解释功能迭代追踪机制的价值和目录结构
- `docs/DECISION-TREE.md`：增加“已有功能迭代”决策路径
- `docs/SCENARIOS.md`：增加“继续迭代某功能”的输入模板

## 变更清单

- [ ] 更新 `skills/brainstorming-pua/SKILL.md`：加入 Feature Ledger Discovery、模板、启动规则、归档回写说明
- [ ] 更新 `skills/pua-gate/SKILL.md`：G2+ 真实业务需求识别已有功能迭代
- [ ] 更新 `skills/writing-plans-pua/SKILL.md`：计划阶段引用功能档案约束和版本目标
- [ ] 更新 `skills/finishing-a-development-branch-pua/SKILL.md`：收尾阶段强制回写功能档案
- [ ] 更新 `README.md`：增加功能迭代追踪机制说明
- [ ] 更新 `docs/DECISION-TREE.md`：增加已有功能迭代路径
- [ ] 更新 `docs/SCENARIOS.md`：增加功能连续迭代场景模板
- [ ] 创建示例功能档案 `openspec/features/feature-iteration-ledger/README.md`，作为本次流程变更自身的首个功能档案

## 回滚方案

### 回滚步骤

1. 删除 `openspec/features/feature-iteration-ledger/README.md` 示例档案
2. 从 `skills/brainstorming-pua/SKILL.md` 移除 Feature Ledger Discovery 相关段落
3. 从 `skills/pua-gate/SKILL.md` 移除已有功能迭代判断规则
4. 从 `skills/writing-plans-pua/SKILL.md` 移除功能档案引用要求
5. 从 `skills/finishing-a-development-branch-pua/SKILL.md` 移除归档回写要求
6. 从 `README.md`、`docs/DECISION-TREE.md`、`docs/SCENARIOS.md` 移除用户说明
7. 保留现有 `openspec/changes/{change-name}/` 单次变更机制

### 不可逆操作

- 无不可逆操作。本变更只修改 Markdown 流程文档，不涉及数据库、外部系统或生产数据。

### 回滚验证清单

- [ ] 搜索 `Feature Ledger` 无残留强制规则
- [ ] 搜索 `openspec/features` 无残留强制规则
- [ ] `brainstorming-pua` 仍可按原 `Core Clarification → Proposal → Design → Tasks` 路径工作
- [ ] README / docs 不再出现功能档案使用入口

## 影响面分析

### 上下游依赖

- 上游：`pua-gate` 负责识别需求是否为已有功能迭代
- 中游：`brainstorming-pua` 负责创建/读取功能档案并生成 Change Metadata
- 下游：`writing-plans-pua` 负责把历史约束转成可执行任务约束
- 收尾：`finishing-a-development-branch-pua` 负责归档后回写功能档案

### 受影响模块清单

| 模块 | 变更类型 | 影响说明 |
|---|---|---|
| `skills/brainstorming-pua/SKILL.md` | 修改 | 增加功能档案发现、模板、启动和归档规则 |
| `skills/pua-gate/SKILL.md` | 修改 | 增加已有功能迭代识别和历史读取要求 |
| `skills/writing-plans-pua/SKILL.md` | 修改 | 要求计划引用功能档案的版本目标和历史约束 |
| `skills/finishing-a-development-branch-pua/SKILL.md` | 修改 | 收尾时回写功能档案，防止归档断链 |
| `README.md` | 修改 | 用户级说明功能迭代追踪机制 |
| `docs/DECISION-TREE.md` | 修改 | 决策树加入已有功能迭代路径 |
| `docs/SCENARIOS.md` | 修改 | 增加连续迭代场景模板 |
| `openspec/features/feature-iteration-ledger/README.md` | 新增 | 本流程自身的功能档案示例 |
