# 技能文件内容去重与职责明确化提案

## Change Metadata
- Feature: `skill-system`
- Iteration: `v1`
- Change Type: 重构
- Previous Change: 无
- Related Archive: 无
- Feature Ledger: `openspec/features/skill-system/README.md`

## Why
当前 PUA 技能套件中多个文件存在大量重复内容，主要问题：
1. **味道判定协议**在 `pua/SKILL.md`、`pua-gate/SKILL.md`、`using-superpowers-pua/SKILL.md` 中重复定义
2. **方法论路由**在 `pua/SKILL.md` 和 `using-superpowers-pua/SKILL.md` 中重复描述
3. **门禁流程**在 `pua-gate/SKILL.md` 中详细定义，但在其他技能中重复出现"第 0 步：自适应门禁"
4. **路由表**在多个文件中重复出现

这导致：
- 用户阅读时困惑，不清楚哪个文件是权威来源
- 维护困难，修改一处需要同步多处
- 技能职责边界模糊

## What Changes
1. 明确每个技能的核心职责，消除重复内容
2. 建立清晰的引用关系，避免重复定义
3. 优化引导流程，让用户逐步跟随

## Capabilities
### New Capabilities
- `skill-responsibility-matrix`: 技能职责矩阵，明确每个技能的核心职责
- `reference-chain`: 引用链机制，避免重复定义

### Modified Capabilities
- `pua`: 专注于方法论路由和味道文化，移除门禁相关重复内容
- `pua-gate`: 专注于门禁判断，移除味道判定协议重复内容
- `using-superpowers-pua`: 专注于入口纪律和路由，移除方法论路由重复内容
- `brainstorming-pua`: 专注于 OpenSpec 流程，保持现有职责

## Impact
- 所有技能文件：需要调整内容结构
- 用户阅读体验：更清晰，无困惑
- 维护成本：降低，一处定义，多处引用

## Risk Assessment
- 变更风险等级：R1
- 影响文件数：6+（四个指定文件 + PUA-FLOW.md + skill-call-diagram.md）
- 是否命中复合升级：否