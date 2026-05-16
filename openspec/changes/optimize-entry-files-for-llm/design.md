# 优化入口文件以更适合LLM解析技术设计

## 方案对比

### 方案 A：渐进式优化（推荐）
- **描述**：保持现有文件结构，逐步优化内容，引入结构化标记
- **优点**：
  - 风险最低，向后兼容
  - 可以分阶段实施
  - 保持现有技能系统不变
- **缺点**：
  - 优化效果可能不如彻底重构
  - 需要多次迭代
- **影响面**：所有入口文件，但改动可控

### 方案 B：彻底重构
- **描述**：完全重新设计文件结构，引入新的解析机制
- **优点**：
  - 优化效果最好
  - 可以设计全新的解析机制
- **缺点**：
  - 风险高，可能破坏现有功能
  - 需要大量测试
  - 实施周期长
- **影响面**：所有入口文件及依赖它们的技能系统

### 推荐：方案 A 及原因
选择渐进式优化，因为：
1. 风险最低，可以快速迭代
2. 保持向后兼容，不会破坏现有功能
3. 可以分阶段实施，逐步验证效果

## 架构

### 优化后的文档结构
```
入口文件优化架构：
├── AGENTS.md（跨平台中枢）
│   ├── 1. 角色和项目背景（20-30行）
│   ├── 2. 配置中枢索引
│   ├── 3. 七项核心职责
│   ├── 4. 十阶段工作流调度指令
│   └── 5. 沟通原则和硬性约束
├── CLAUDE.md（Claude Code入口）
│   └── 针对Claude Code优化的版本
├── .github/copilot-instructions.md（GitHub Copilot入口）
│   └── 针对GitHub Copilot优化的版本
└── .codebuddy/rules/*/RULE.mdc（CodeBuddy入口）
    └── 针对CodeBuddy优化的版本
```

### Skill间调用关系架构
```
调用关系图：
using-superpowers-pua（入口）
├── pua-gate（门禁）
├── brainstorming-pua（设计）
├── writing-plans-pua（计划）
├── executing-plans-pua（执行）
├── verification-before-completion-pua（验证）
├── pua-escalation（升级）
└── llm-degradation-detector（诊断）
```

## 关键决策

### 1. 引入结构化标记系统
- **决策**：在Markdown中引入结构化标记，如 `[REQUIRED]`、`[OPTIONAL]`、`[CRITICAL]`
- **原因**：帮助LLM快速识别关键信息，减少解析歧义
- **实现**：在现有Markdown内容中添加标记，不影响人类阅读

### 2. 明确skill间调用关系
- **决策**：在文档中明确skill之间的调用逻辑和依赖关系
- **原因**：用户特别强调要让不同模型都能理解skill间的调用关系
- **实现**：
  - 在每个skill文档中添加"调用关系"章节
  - 创建skill调用关系图
  - 明确路由逻辑和返回机制

### 3. 平台特定优化
- **决策**：针对不同平台优化不同版本
- **原因**：不同平台有不同的解析机制和要求
- **实现**：
  - AGENTS.md：保持通用性，作为跨平台中枢
  - CLAUDE.md：针对Claude Code优化，强调`use_skill`机制
  - `.github/copilot-instructions.md`：针对GitHub Copilot优化，内联完整规则
  - `.codebuddy/rules/*/RULE.mdc`：针对CodeBuddy优化，强调`alwaysApply`和完整规范

### 4. 减少冗余内容
- **决策**：删除重复内容，合并相似规则
- **原因**：减少LLM需要处理的冗余信息，提高解析效率
- **实现**：
  - 识别并删除重复内容
  - 合并相似规则
  - 保持核心规则不变

## 接口定义

### 结构化标记接口
```markdown
[REQUIRED] 必须遵守的规则
[OPTIONAL] 可选遵守的规则
[CRITICAL] 关键规则，违反会导致严重后果
[NOTE] 注意事项，帮助理解
```

### Skill调用接口
```markdown
## 调用关系
- 入口：`using-superpowers-pua`
- 调用：`pua-gate` → `brainstorming-pua` → `writing-plans-pua` → ...
- 返回：执行完成后返回调用者
- 升级：需要时调用 `pua-escalation`
```

## 变更清单

### AGENTS.md 优化
- [ ] 重组为5点结构
- [ ] 添加结构化标记
- [ ] 明确skill间调用关系
- [ ] 减少冗余内容

### CLAUDE.md 优化
- [ ] 保持与AGENTS.md同步
- [ ] 针对Claude Code优化
- [ ] 强调`use_skill`机制

### .github/copilot-instructions.md 优化
- [ ] 针对GitHub Copilot优化
- [ ] 内联完整规则
- [ ] 保持与AGENTS.md同步

### .codebuddy/rules/*/RULE.mdc 优化
- [ ] 针对CodeBuddy优化
- [ ] 强调`alwaysApply`和完整规范
- [ ] 保持与AGENTS.md同步

## 影响面分析

### 上下游依赖
- **上游**：所有使用入口文件的LLM平台
- **下游**：所有依赖入口文件的技能系统

### 受影响模块清单
| 模块 | 变更类型 | 影响说明 |
|---|---|---|
| AGENTS.md | 优化 | 重组结构，添加标记，明确调用关系 |
| CLAUDE.md | 优化 | 针对Claude Code优化 |
| .github/copilot-instructions.md | 优化 | 针对GitHub Copilot优化 |
| .codebuddy/rules/*/RULE.mdc | 优化 | 针对CodeBuddy优化 |
| 所有技能系统 | 无变更 | 保持现有功能不变 |