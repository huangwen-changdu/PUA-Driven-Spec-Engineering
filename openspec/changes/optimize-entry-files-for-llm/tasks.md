# 优化入口文件以更适合LLM解析实现任务

## 前置条件
- [x] Core Clarification 完成
- [x] Proposal 确认
- [x] Specs 确认
- [x] Design 确认

## 任务清单

### 任务 1：设计结构化标记系统（预估：1小时）
- **描述**：设计并定义结构化标记系统，包括 `[REQUIRED]`、`[OPTIONAL]`、`[CRITICAL]`、`[NOTE]` 等标记
- **涉及文件**：
  - 新建 `docs/structured-markers.md`（标记系统说明）
  - 修改 `AGENTS.md`（应用标记）
  - 修改 `CLAUDE.md`（应用标记）
- **验证方式**：
  - 标记系统文档完整
  - 标记在现有文档中正确应用
  - LLM能正确识别标记

### 任务 2：分析并文档化现有skill调用关系（预估：2小时）
- **描述**：分析所有skill之间的调用关系，创建调用关系图和文档
- **涉及文件**：
  - 新建 `docs/skill-call-relations.md`（调用关系文档）
  - 新建 `graphify-out/skill-call-graph.json`（调用关系图）
  - 修改各个 `skills/*/SKILL.md`（添加调用关系章节）
- **验证方式**：
  - 调用关系文档完整
  - 调用关系图准确
  - 每个skill文档都包含调用关系章节

### 任务 3：优化AGENTS.md结构（预估：3小时）
- **描述**：按5点结构重组AGENTS.md，添加结构化标记，明确skill间调用关系
- **涉及文件**：
  - 修改 `AGENTS.md`（重组结构，添加标记，明确调用关系）
- **验证方式**：
  - 文档结构符合5点要求
  - 标记系统正确应用
  - skill间调用关系明确
  - LLM能正确解析并执行规则

### 任务 4：优化CLAUDE.md（预估：2小时）
- **描述**：保持与AGENTS.md同步，针对Claude Code优化，强调`use_skill`机制
- **涉及文件**：
  - 修改 `CLAUDE.md`（同步AGENTS.md，针对Claude Code优化）
- **验证方式**：
  - 与AGENTS.md保持同步
  - 针对Claude Code优化
  - `use_skill`机制明确

### 任务 5：优化.github/copilot-instructions.md（预估：2小时）
- **描述**：针对GitHub Copilot优化，内联完整规则，保持与AGENTS.md同步
- **涉及文件**：
  - 修改 `.github/copilot-instructions.md`（针对GitHub Copilot优化）
- **验证方式**：
  - 针对GitHub Copilot优化
  - 内联完整规则
  - 与AGENTS.md保持同步

### 任务 6：优化.codebuddy/rules/*/RULE.mdc（预估：2小时）
- **描述**：针对CodeBuddy优化，强调`alwaysApply`和完整规范，保持与AGENTS.md同步
- **涉及文件**：
  - 修改 `.codebuddy/rules/*/RULE.mdc`（针对CodeBuddy优化）
- **验证方式**：
  - 针对CodeBuddy优化
  - `alwaysApply`和完整规范明确
  - 与AGENTS.md保持同步

### 任务 7：创建skill调用关系可视化（预估：1小时）
- **描述**：创建skill调用关系的可视化图表，帮助理解调用逻辑
- **涉及文件**：
  - 新建 `docs/skill-call-diagram.md`（调用关系图表）
  - 更新 `graphify-out/GRAPH_REPORT.md`（添加调用关系）
- **验证方式**：
  - 调用关系图表清晰
  - 图表与实际调用关系一致

### 任务 8：测试优化效果（预估：2小时）
- **描述**：测试优化后的文档，验证LLM解析效率和准确性
- **涉及文件**：
  - 新建 `tests/llm-parsing-test.md`（测试用例）
  - 更新 `docs/verification.md`（验证结果）
- **验证方式**：
  - 测试用例完整
  - LLM解析效率提高
  - LLM响应更准确

## 依赖关系
- 任务 1（标记系统）→ 任务 3、4、5、6（应用标记）
- 任务 2（调用关系）→ 任务 3、4、5、6（明确调用关系）
- 任务 3（AGENTS.md）→ 任务 4、5、6（保持同步）
- 任务 7（可视化）→ 任务 8（测试）
- 任务 8（测试）→ 验证完成

## 验证计划
- [ ] 集成验证：所有入口文件结构一致
- [ ] 功能验证：LLM能正确解析并执行优化后的规则
- [ ] 效率验证：LLM解析时间减少
- [ ] 兼容验证：所有平台都能正常加载和使用