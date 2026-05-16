# 优化入口文件以更适合LLM解析执行计划

## 计划概览
- **Feature**: `llm-optimized-docs`
- **Iteration**: `v1`
- **Feature Ledger**: `openspec/features/llm-optimized-docs/README.md`
- **风险等级**: R0
- **执行路径**: `executing-plans-pua`（顺序执行）

## 任务 1：设计结构化标记系统

### 目标
设计并定义结构化标记系统，帮助LLM快速识别关键信息。

### 步骤
1. **分析现有文档**（30分钟）
   - 读取 `AGENTS.md`、`CLAUDE.md`、`.github/copilot-instructions.md`
   - 识别需要标记的关键信息类型
   - 记录现有文档结构

2. **设计标记系统**（20分钟）
   - 定义标记类型：`[REQUIRED]`、`[OPTIONAL]`、`[CRITICAL]`、`[NOTE]`
   - 定义标记语义和使用场景
   - 设计标记格式和位置规则

3. **创建标记系统文档**（10分钟）
   - 创建 `docs/structured-markers.md`
   - 包含标记定义、使用示例、最佳实践

### 验证方式
- 标记系统文档完整
- 标记语义清晰无歧义
- LLM能正确识别标记

### 影响面
- 新建文件：`docs/structured-markers.md`
- 无现有文件修改

---

## 任务 2：分析并文档化现有skill调用关系

### 目标
分析所有skill之间的调用关系，创建调用关系图和文档。

### 步骤
1. **分析现有skill**（60分钟）
   - 读取所有 `skills/*/SKILL.md` 文件
   - 识别调用关系：入口→门禁→具体skill→升级→返回
   - 记录调用条件和路由逻辑

2. **创建调用关系文档**（30分钟）
   - 创建 `docs/skill-call-relations.md`
   - 包含调用关系图、路由逻辑、返回机制
   - 明确每个skill的调用条件和依赖关系

3. **创建调用关系图**（20分钟）
   - 创建 `graphify-out/skill-call-graph.json`
   - 使用JSON格式表示调用关系
   - 包含节点（skill）和边（调用关系）

4. **更新skill文档**（10分钟）
   - 在每个 `skills/*/SKILL.md` 中添加"调用关系"章节
   - 明确该skill的调用者和被调用者

### 验证方式
- 调用关系文档完整
- 调用关系图准确
- 每个skill文档都包含调用关系章节

### 影响面
- 新建文件：`docs/skill-call-relations.md`、`graphify-out/skill-call-graph.json`
- 修改文件：所有 `skills/*/SKILL.md`

---

## 任务 3：优化AGENTS.md结构

### 目标
按5点结构重组AGENTS.md，添加结构化标记，明确skill间调用关系。

### 步骤
1. **备份现有文件**（5分钟）
   - 创建 `AGENTS.md.backup`
   - 记录现有文件结构

2. **重组文档结构**（90分钟）
   - 按5点结构重组：
     1. 角色和项目背景（20-30行）
     2. 配置中枢索引
     3. 七项核心职责
     4. 十阶段工作流调度指令
     5. 沟通原则和硬性约束
   - 保持核心规则不变
   - 优化语言表达，减少歧义

3. **添加结构化标记**（30分钟）
   - 应用 `[REQUIRED]`、`[OPTIONAL]`、`[CRITICAL]`、`[NOTE]` 标记
   - 标记关键规则和约束
   - 确保标记不影响人类阅读

4. **明确skill间调用关系**（30分钟）
   - 添加skill调用关系章节
   - 包含调用关系图
   - 明确路由逻辑和返回机制

5. **验证优化效果**（30分钟）
   - 测试LLM解析效率
   - 验证规则执行准确性
   - 收集反馈并优化

### 验证方式
- 文档结构符合5点要求
- 标记系统正确应用
- skill间调用关系明确
- LLM能正确解析并执行规则

### 影响面
- 修改文件：`AGENTS.md`
- 依赖文件：所有使用AGENTS.md的LLM平台

---

## 任务 4：优化CLAUDE.md

### 目标
保持与AGENTS.md同步，针对Claude Code优化，强调`use_skill`机制。

### 步骤
1. **同步AGENTS.md内容**（60分钟）
   - 读取优化后的AGENTS.md
   - 同步核心规则和结构
   - 保持Claude Code特有内容

2. **针对Claude Code优化**（30分钟）
   - 强调`use_skill`机制
   - 优化Claude Code特有功能
   - 确保与Claude Code兼容

3. **添加结构化标记**（20分钟）
   - 应用与AGENTS.md相同的标记系统
   - 确保标记一致性

4. **验证优化效果**（10分钟）
   - 测试Claude Code解析
   - 验证规则执行

### 验证方式
- 与AGENTS.md保持同步
- 针对Claude Code优化
- `use_skill`机制明确

### 影响面
- 修改文件：`CLAUDE.md`
- 依赖文件：Claude Code平台

---

## 任务 5：优化.github/copilot-instructions.md

### 目标
针对GitHub Copilot优化，内联完整规则，保持与AGENTS.md同步。

### 步骤
1. **同步AGENTS.md内容**（60分钟）
   - 读取优化后的AGENTS.md
   - 同步核心规则和结构
   - 保持GitHub Copilot特有内容

2. **针对GitHub Copilot优化**（30分钟）
   - 内联完整规则
   - 优化GitHub Copilot特有功能
   - 确保与GitHub Copilot兼容

3. **添加结构化标记**（20分钟）
   - 应用与AGENTS.md相同的标记系统
   - 确保标记一致性

4. **验证优化效果**（10分钟）
   - 测试GitHub Copilot解析
   - 验证规则执行

### 验证方式
- 针对GitHub Copilot优化
- 内联完整规则
- 与AGENTS.md保持同步

### 影响面
- 修改文件：`.github/copilot-instructions.md`
- 依赖文件：GitHub Copilot平台

---

## 任务 6：优化.codebuddy/rules/*/RULE.mdc

### 目标
针对CodeBuddy优化，强调`alwaysApply`和完整规范，保持与AGENTS.md同步。

### 步骤
1. **同步AGENTS.md内容**（60分钟）
   - 读取优化后的AGENTS.md
   - 同步核心规则和结构
   - 保持CodeBuddy特有内容

2. **针对CodeBuddy优化**（30分钟）
   - 强调`alwaysApply`和完整规范
   - 优化CodeBuddy特有功能
   - 确保与CodeBuddy兼容

3. **添加结构化标记**（20分钟）
   - 应用与AGENTS.md相同的标记系统
   - 确保标记一致性

4. **验证优化效果**（10分钟）
   - 测试CodeBuddy解析
   - 验证规则执行

### 验证方式
- 针对CodeBuddy优化
- `alwaysApply`和完整规范明确
- 与AGENTS.md保持同步

### 影响面
- 修改文件：`.codebuddy/rules/*/RULE.mdc`
- 依赖文件：CodeBuddy平台

---

## 任务 7：创建skill调用关系可视化

### 目标
创建skill调用关系的可视化图表，帮助理解调用逻辑。

### 步骤
1. **设计图表格式**（20分钟）
   - 选择可视化格式（Mermaid、PlantUML等）
   - 设计图表结构
   - 确定关键节点和边

2. **创建调用关系图表**（30分钟）
   - 创建 `docs/skill-call-diagram.md`
   - 包含Mermaid或PlantUML图表
   - 明确调用流程和分支

3. **更新Graphify报告**（10分钟）
   - 更新 `graphify-out/GRAPH_REPORT.md`
   - 添加调用关系章节
   - 包含图表引用

### 验证方式
- 调用关系图表清晰
- 图表与实际调用关系一致
- 图表易于理解

### 影响面
- 新建文件：`docs/skill-call-diagram.md`
- 修改文件：`graphify-out/GRAPH_REPORT.md`

---

## 任务 8：测试优化效果

### 目标
测试优化后的文档，验证LLM解析效率和准确性。

### 步骤
1. **设计测试用例**（30分钟）
   - 创建 `tests/llm-parsing-test.md`
   - 设计测试场景和用例
   - 定义成功标准

2. **执行测试**（60分钟）
   - 测试LLM解析效率
   - 测试LLM响应准确性
   - 测试跨平台兼容性

3. **分析测试结果**（20分钟）
   - 记录测试结果
   - 分析优化效果
   - 识别改进点

4. **创建验证报告**（10分钟）
   - 更新 `docs/verification.md`
   - 包含测试结果和优化效果
   - 提供改进建议

### 验证方式
- 测试用例完整
- LLM解析效率提高
- LLM响应更准确

### 影响面
- 新建文件：`tests/llm-parsing-test.md`
- 修改文件：`docs/verification.md`

---

## 执行顺序

### 阶段 1：准备（任务 1、2）
- 设计结构化标记系统
- 分析并文档化现有skill调用关系

### 阶段 2：核心优化（任务 3）
- 优化AGENTS.md结构

### 阶段 3：平台优化（任务 4、5、6）
- 优化CLAUDE.md
- 优化.github/copilot-instructions.md
- 优化.codebuddy/rules/*/RULE.mdc

### 阶段 4：可视化（任务 7）
- 创建skill调用关系可视化

### 阶段 5：验证（任务 8）
- 测试优化效果

## 风险与缓解

### 风险 1：破坏现有功能
- **缓解**：备份现有文件，逐步优化，充分测试

### 风险 2：LLM解析效率未提高
- **缓解**：设计测试用例，持续优化，收集反馈

### 风险 3：跨平台兼容性问题
- **缓解**：针对不同平台优化，充分测试兼容性

## 成功标准

### 功能成功
- LLM能正确解析优化后的规则，无歧义理解
- LLM能正确执行skill间调用逻辑
- 所有平台都能正常加载和使用优化后的文件

### 效率成功
- LLM解析时间减少
- LLM响应更准确
- 减少LLM需要处理的冗余信息

### 维护成功
- 优化后的文件易于维护和更新
- 文档结构清晰，便于理解
- 标记系统有效，便于识别关键信息