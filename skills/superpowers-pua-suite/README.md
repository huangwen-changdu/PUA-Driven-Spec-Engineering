# Superpowers PUA 套件

已创建这整套中文版 PUA 版 superpowers skills：

## 入口
- `superpowers-pua`
- `using-superpowers-pua`
- `pua-gate`（进入每个阶段前默认必经的门禁）
- `pua-escalation`（门禁要求升级时调用的升级器）

## 设计与规划
- `brainstorming-pua`
- `using-git-worktrees-pua`
- `writing-plans-pua`

## 实现与调试
- `test-driven-development-pua`
- `systematic-debugging-pua`
- `subagent-driven-development-pua`
- `dispatching-parallel-agents-pua`
- `executing-plans-pua`

## 质量与收尾
- `requesting-code-review-pua`
- `receiving-code-review-pua`
- `verification-before-completion-pua`
- `finishing-a-development-branch-pua`
## 诊断工具
- `llm-degradation-detector`（推理能力检测 + 幻觉专项 + 跑分基准 `/iq bench`）
## 现在已并入的“深度 PUA”规则
- 三条红线：闭环意识 / 事实驱动 / 穷尽一切
- Owner 四问：根因、影响、预防、证据
- P8 视角：还有什么没想到？还有什么类似问题也要一起解决？
- 压力升级：E1-E4 分级处理
- 通用方法论：闻味道 → 揪头发 → 照镜子 → 执行新方案 → 复盘
- 体面退出：解决不了也必须给结构化阻塞说明
- Sub-agent 也不养闲：子通道同样要带高压质量约束

## 新的三层流程定位

这套现在不是“把 PUA 文案揉进每个 skill”这么简单，而是明确变成了三层：

1. **主流程层**：`superpowers-pua` 套件负责正常的 skill 路由与阶段推进
2. **自适应门禁层**：`pua-gate` 在每个阶段第 0 步默认插入，先拆用户话，再按普通问题 G0/G1 轻量 PASS、高压问题展开 `PASS` / `ESCALATE` / `BLOCKED` 判断；轻量化只优化普通场景，不能削弱 `/pua` 核心流程
3. **条件升级层**：`pua-escalation` 只在门禁要求升级或执行中失控时调用，负责收紧流程、压住摆烂和漂移

原则只有一句：

**先拆用户话，主流程再往前走；`pua-gate` 负责按档位拦一下：普通问题 G0/G1 轻量 PASS，高压问题才可见升级；`pua-escalation` 只在门禁要求升级时收紧并执行事实动作；调完必须回到原节点继续执行。**

这里的新结构已经拆成两份专用 skill：
- `pua-gate`：只给 `superpowers-pua` 套件做第 0 步强制门禁；遇到 `/pua`、不满、返工、事实错误时必须输出可见 PUA 旁白
- `pua-escalation`：只在门禁要求升级或执行失控时调用；必须指定唯一事实动作并推动搜索、读取或验证
- 二者都不替代主流程，只负责门禁、升级约束、压住漂移、指定唯一下一步

## 大任务推荐调用顺序

普通问答、解释、单文件小改可在 G0/G1 内部拆解后直接处理，不强制进入完整生命周期。

0. 每个阶段先经过 `pua-gate`：普通问题 G0/G1 轻量 PASS；多步骤任务 G2 简版门禁；`ESCALATE` 才调 `pua-escalation`；`BLOCKED` 停止补证据
1. `using-superpowers-pua`
2. 如门禁发现高压 / 返工 / 不满信号，立即调用 `pua-escalation`
3. `brainstorming-pua`（新需求 / 需求不清时；如想跳设计，再调 `pua-escalation`）
4. `using-git-worktrees-pua`
5. `writing-plans-pua`（如计划发虚、验证缺失、影响分析不全，再调 `pua-escalation`）
6. 选择执行技能：
   - `subagent-driven-development-pua`（子通道裸奔、跳评审、带病推进时调 `pua-escalation`）
   - `dispatching-parallel-agents-pua`（边界不清、责任不清、并行制造混乱时调 `pua-escalation`）
   - `executing-plans-pua`（擅改计划、跳验证、带阻塞硬推时调 `pua-escalation`）
   - `systematic-debugging-pua`（连续失败、乱补丁、靠猜时调 `pua-escalation`）
7. `requesting-code-review-pua`（想跳 review 或淡化风险时调 `pua-escalation`）
8. `receiving-code-review-pua`（有反馈时；若开始表演式认同，再调 `pua-escalation`）
9. `verification-before-completion-pua`（准备报完成但证据不够时，再调 `pua-escalation`）
10. `finishing-a-development-branch-pua`（想模糊收尾、悬置状态时再调 `pua-escalation`）

## 十个固定 `pua-escalation` 插点

### 1. 刚接任务时
- 用户明显不满
- 已经返工 2 次以上
- 带着失败历史进入当前轮次

### 2. 设计阶段
- 想跳过设计直接实现
- 想用计划冒充设计
- 因催压减少关键澄清

### 3. 写完计划后
- 计划有空话
- 没验证路径
- 没影响分析
- 想“先做再说”

### 4. 子通道执行时
- 子通道上下文不清就开写
- 想跳评审
- 有重要问题却想先推进下一任务

### 5. 并行调度时
- 任务其实不独立
- 多通道改同一批文件没人协调
- 用并行掩盖范围不明

### 6. 单通道执行计划时
- 想擅改计划意图
- 想跳过验证
- 带着阻塞硬推进

### 7. 调试连续失败时
- 两次相似尝试失败
- 开始乱补丁
- 开始靠猜
- 想提前甩锅

### 8. 发起 review 前
- 想说“这点东西不用审”
- 想带着已知问题继续推进
- 在淡化风险

### 9. 收到 review 反馈后
- 开始表演式认同
- 机械照改
- 只想尽快过 review

### 10. 准备宣称完成或收尾前
- 想说“应该好了”
- 没有新鲜证据
- 想先报完成再补验证
- 想模糊收尾或把状态悬着

## 套件定位
这不是一个 skill，而是一整套带深度 PUA 加压层的 superpowers 流程技能。

核心区别是：
- 保留原 superpowers 的流程门禁
- `pua-escalation` 不再只是隐含文案，而是中途可直接调用的升级 skill
- 现在几乎每个关键阶段都有明确的 `pua-escalation` 插点
- 在催压、连续失败、质量下滑时，不允许跳步骤
- 压力越大，review / verification / evidence / owner 要求越高
