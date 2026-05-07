# 功能迭代追踪机制任务清单

## 执行前提

- 已确认 Proposal：`openspec/changes/feature-iteration-ledger/proposal.md`
- 已确认 Design：`openspec/changes/feature-iteration-ledger/design.md`
- 本任务只修改 Markdown 流程文档与 OpenSpec 示例档案，不涉及代码运行时、数据库、外部服务或自动化脚本。

## 成功标准

- `pua-gate` 能在真实业务需求或继续迭代场景中识别“可能属于已有功能”。
- `brainstorming-pua` 在 Core Clarification 前要求发现或创建 Feature Ledger。
- `writing-plans-pua` 生成计划时要求引用功能版本、历史约束和回归验证点。
- `finishing-a-development-branch-pua` 收尾时要求归档后回写 Feature Ledger。
- 用户文档能说明如何表达“继续迭代某功能 / 基于 vN 更新”。
- 示例档案 `openspec/features/feature-iteration-ledger/README.md` 能展示当前流程自身的版本链。

## 任务 1：更新 `brainstorming-pua` 的功能档案发现流程

- 文件：`skills/brainstorming-pua/SKILL.md`
- 改什么：
  - 在 Core Clarification 前新增 `Feature Ledger Discovery` 步骤。
  - 要求先搜索 `openspec/features/**/README.md`，判断需求是新功能还是已有功能迭代。
  - 明确功能档案不存在时创建草案，并将首个 change 标记为 `Iteration: v1`。
  - 明确功能档案存在时，新 change 的 `Iteration` 在当前版本基础上递增。
  - 在 Proposal 生成规则中加入 `Change Metadata` 模板。
- 上下游影响：
  - 上游依赖 `pua-gate` 的“已有功能迭代”判断。
  - 下游影响 `design.md`、`tasks.md` 是否引用历史约束。
- 同类位置：
  - 检查该文件中所有 `Core Clarification`、`Proposal`、`OpenSpec` 相关段落，避免只改一处导致规则冲突。
- 验证方式：
  - 搜索 `Feature Ledger Discovery`、`Change Metadata`、`openspec/features`，确认三者都出现在 `brainstorming-pua` 中。
  - 搜索 `Core Clarification` 附近，确认 Feature Ledger Discovery 位于其前置流程。
- 成功判断：
  - 新需求启动时，技能文本明确要求先查功能档案，再进入澄清和 Proposal。

## 任务 2：更新 `pua-gate` 的已有功能迭代识别规则

- 文件：`skills/pua-gate/SKILL.md`
- 改什么：
  - 在用户话拆解协议中增加“功能迭代信号”：继续改、基于某功能、某功能 vN、历史修复、之前版本、同一功能再次调整。
  - 在 G2+ 理解确认要求中加入历史引用格式。
  - 要求真实业务需求进入设计前，先判断是否需要读取 `openspec/features/**/README.md`。
- 上下游影响：
  - 影响所有真实业务需求的前置识别，不改变 G0-G4 档位含义。
  - 给 `brainstorming-pua` 提供 feature 归属线索。
- 同类位置：
  - 检查“用户话拆解协议”“G2+ 标准门禁”“设计前置强制路由”三处，保持规则一致。
- 验证方式：
  - 搜索 `已有功能迭代`、`openspec/features`、`Feature Ledger` 是否出现在门禁相关段落。
  - 确认没有把所有 G0/G1 普通问答强制升级为完整 OpenSpec。
- 成功判断：
  - 当用户说“继续迭代某功能”时，门禁规则会要求先查历史档案，而不是从零开始。

## 任务 3：更新 `writing-plans-pua` 的计划约束

- 文件：`skills/writing-plans-pua/SKILL.md`
- 改什么：
  - 在计划生成前增加检查项：Feature Ledger 是否存在、Iteration 是否明确、历史约束是否进入任务、历史修复点是否进入回归验证。
  - 要求每个任务说明是否受功能档案中的已知约束影响。
  - 要求计划引用本次 `Feature` 与 `Iteration`，避免执行阶段丢失版本上下文。
- 上下游影响：
  - 上游来自 `brainstorming-pua` 的 Proposal / Design。
  - 下游影响执行技能是否能按历史约束闭环。
- 同类位置：
  - 检查“计划标准”“必经流程”“红旗信号”三处，补齐历史上下文要求。
- 验证方式：
  - 搜索 `Feature Ledger`、`Iteration`、`历史修复` 是否出现在计划标准中。
- 成功判断：
  - 计划不再只列本次任务，还会显式继承功能档案中的版本目标和历史约束。

## 任务 4：更新 `finishing-a-development-branch-pua` 的归档回写规则

- 文件：`skills/finishing-a-development-branch-pua/SKILL.md`
- 改什么：
  - 新增 `Feature Ledger Writeback` 收尾步骤。
  - 归档 `openspec/changes/{change-name}/` 后，必须更新 `openspec/features/{feature-name}/README.md`。
  - 回写内容包括当前版本、最近变更、版本历史、关键决策、已知约束、归档路径。
  - 声称完成前必须检查 Feature Ledger 已回写。
- 上下游影响：
  - 上游依赖本次 change 的 `Change Metadata`。
  - 下游保证后续需求能通过功能档案读取历史。
- 同类位置：
  - 检查“完成前验证”“归档”“收尾”相关段落，避免出现“归档完成但未回写也可完成”的规则冲突。
- 验证方式：
  - 搜索 `Feature Ledger Writeback`、`版本历史`、`最近变更`、`归档路径` 是否出现在收尾流程。
- 成功判断：
  - 没有回写功能档案时，收尾流程不允许声明完成。

## 任务 5：更新用户入口文档

- 文件：
  - `README.md`
  - `docs/DECISION-TREE.md`
  - `docs/SCENARIOS.md`
- 改什么：
  - `README.md`：新增功能迭代追踪机制说明，解释 `openspec/features/{feature-name}/README.md` 与 `openspec/changes/{change-name}/` 的关系。
  - `docs/DECISION-TREE.md`：增加“已有功能迭代”路径：先查 Feature Ledger，再决定创建新 change 或新 feature。
  - `docs/SCENARIOS.md`：增加用户输入模板，例如“继续迭代 X 功能”“基于 X v2 增加 Y”“修复 X 功能历史问题”。
- 上下游影响：
  - 影响用户如何触发这套机制。
  - 不改变已有 OpenSpec 基础流程，只增加功能级入口。
- 同类位置：
  - 检查三个文档中已有 OpenSpec / PUA / changes 说明，避免重复或互相矛盾。
- 验证方式：
  - 搜索 `openspec/features`、`继续迭代`、`Feature Ledger` 是否出现在用户文档中。
- 成功判断：
  - 用户能从 README 或场景文档看懂如何表达“同一功能继续迭代”。

## 任务 6：创建示例功能档案

- 文件：`openspec/features/feature-iteration-ledger/README.md`
- 改什么：
  - 创建本流程自身的功能档案。
  - 当前版本设为 `v1`。
  - 最近变更设为 `feature-iteration-ledger`。
  - 版本历史记录本次变更。
  - 关联当前 `proposal.md`、`design.md`、`tasks.md`。
- 上下游影响：
  - 作为后续功能档案模板示例。
  - 不替代 `openspec/changes/feature-iteration-ledger/`，只提供长期入口。
- 同类位置：
  - 检查 `openspec/features/` 下是否已有同名档案，避免覆盖历史。
- 验证方式：
  - 读取该文件，确认包含“当前状态 / 功能背景 / 能力范围 / 版本历史 / 关键决策 / 已知约束 / 关联文档”。
- 成功判断：
  - 示例档案本身能解释这次流程改造的版本链。

## 任务 7：一致性验证

- 范围：全仓 Markdown 文档。
- 验证命令：
  - `rg "Feature Ledger|openspec/features|Change Metadata|Feature Ledger Writeback|已有功能迭代|继续迭代" -n .`
- 检查点：
  - 新规则覆盖门禁、澄清、计划、收尾、用户入口文档。
  - 没有出现与设计相反的规则，例如“只需要 changes 文档即可完成历史追踪”。
  - 没有把 `.copilot` 学习库描述成功能档案的替代品。
- 成功判断：
  - 搜索结果能串起完整链路：用户输入 → 门禁识别 → 功能档案发现 → Change Metadata → 计划引用 → 归档回写 → 下次迭代读取。

## 执行顺序

1. 先改 `brainstorming-pua`，建立 Feature Ledger 主流程。
2. 再改 `pua-gate`，补齐入口识别。
3. 再改 `writing-plans-pua`，确保计划继承历史约束。
4. 再改 `finishing-a-development-branch-pua`，确保归档回写。
5. 再改用户文档，补充使用入口。
6. 最后创建示例功能档案。
7. 运行一致性搜索验证。

## 非目标

- 不实现自动版本号计算脚本。
- 不迁移历史上不存在的 change。
- 不修改 `.copilot` 学习库结构。
- 不改变 PUA G0-G4 门禁基本含义。
- 不引入数据库、外部服务或运行时依赖。
