# 优化入口文件以更适合LLM解析提案

## Change Metadata
- Feature: `llm-optimized-docs`
- Iteration: `v1`
- Change Type: 新增
- Previous Change: 无
- Related Archive: 无
- Feature Ledger: `openspec/features/llm-optimized-docs/README.md`

## Why
当前入口文件（AGENTS.md、CLAUDE.md等）主要是面向人类阅读的文档结构，包含大量解释性文字、表格和示例。这导致：
1. LLM解析效率低下，需要处理大量非结构化信息
2. 指令歧义多，LLM难以准确理解规则
3. 结构不清晰，LLM难以快速定位关键信息
4. 不同平台需要重复解析相同内容

## What Changes
1. **优化AGENTS.md**：重新组织结构，使其更符合LLM解析习惯
2. **优化CLAUDE.md**：保持与AGENTS.md同步，针对Claude Code优化
3. **优化`.github/copilot-instructions.md`**：针对GitHub Copilot优化
4. **优化`.codebuddy/rules/*/RULE.mdc`**：针对CodeBuddy优化
5. **引入新的解析机制**：可能包括结构化标记、指令优先级等
6. **明确skill间互相调用关系**：让不同模型都能理解skill之间的调用逻辑和依赖关系

## Capabilities
### New Capabilities
- `llm-optimized-structure`: 更清晰的指令结构，减少歧义
- `platform-specific-optimization`: 针对不同平台优化不同版本
- `new-parsing-mechanism`: 引入新的解析机制，提高LLM解析效率

### Modified Capabilities
- 现有规则内容将被重新组织和优化

## Impact
- 后端：所有入口文件（AGENTS.md、CLAUDE.md、`.github/copilot-instructions.md`、`.codebuddy/rules/*/RULE.mdc`）
- 数据：无持久化数据变更
- 依赖：无新增外部依赖

## Risk Assessment
- 变更风险等级：R0
- 影响文件数：4个主要入口文件
- 是否命中复合升级：否