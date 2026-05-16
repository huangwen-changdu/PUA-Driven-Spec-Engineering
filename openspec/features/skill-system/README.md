# Skill System 功能档案

## 概述
PUA 技能套件的技能系统，包括技能职责划分、引用关系、引导流程等。

## 当前版本
v1

## 版本历史
| 版本 | 变更名称 | 变更日期 | 变更类型 | 归档路径 |
|------|---------|---------|---------|---------|
| v1 | skill-content-deduplication | 2026-05-17 | 重构 | `openspec/changes/archive/2026-05-17-skill-content-deduplication/` |

## 能力范围
- 技能职责划分：明确每个技能的核心职责
- 引用关系：建立清晰的引用链机制，避免重复定义
- 引导流程：优化用户引导流程，让用户逐步跟随
- 味道方法论声明：强调味道方法论必须声明的要求

## 关键决策
1. **权威来源**：每个技能有明确的核心职责，其他文件引用
   - `pua`：方法论路由引擎 + 味道文化（权威来源）
   - `pua-gate`：自适应门禁（权威来源）
   - `using-superpowers-pua`：入口纪律 + 路由表（引用 pua 和 pua-gate）
   - `brainstorming-pua`：OpenSpec 流程（保持现有职责）

2. **重复内容处理**：详细定义保留在权威来源文件，其他文件引用
   - 味道判定协议：详细定义保留在 `pua/SKILL.md`，其他文件引用
   - 门禁流程：详细定义保留在 `pua-gate/SKILL.md`，其他文件引用
   - 方法论路由：详细定义保留在 `pua/SKILL.md`，其他文件引用

3. **向后兼容**：保持现有调用关系、门禁逻辑、OpenSpec 流程不变

## 已知约束
- 保持向后兼容，现有调用关系不变
- 不改变现有的门禁逻辑和风险评估
- 不改变现有的 OpenSpec 流程

## 相关变更
- `skill-content-deduplication`：技能文件内容去重与职责明确化

## 功能档案路径
`openspec/features/skill-system/README.md`