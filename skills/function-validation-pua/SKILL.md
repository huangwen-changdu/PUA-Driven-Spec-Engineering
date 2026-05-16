---
name: function-validation-pua
description: "当需要验证代码功能是否正确实现时使用，检查是否符合最佳实践、评估代码质量"
---

# Function Validation PUA

## 概述

验证代码功能是否正确实现，检查是否符合最佳实践、评估代码质量。

**核心原则：** 功能验证应该在开发过程中进行，不要等到最后才测试。出现想跳过验证、忽视问题、或只想赶进度时，直接调用 `pua-escalation`，再回到验证流程继续推进。

## 第 0 步：自适应门禁

进入本 skill 后，先经过 `pua-gate` 并按档位执行：

- `G0/G1 PASS`：普通问题轻量快放，输出一行微标/轻标（不得完全静默）
- `G2 PASS`：多步骤或跨文件任务输出简版门禁
- `ESCALATE`：立即调用 `pua-escalation`，再回到本 skill
- `BLOCKED`：补齐输入或证据，不得继续

未经过 `pua-gate`，不得进入下面的主流程；但普通问题不得为了"有流程感"展开长门禁。

## 必经流程

0. 确认**本轮用户消息**已完成第 0 步门禁；不能复用上一轮 `pua-gate` 结果
1. 确定验证范围
2. 验证功能正确性
3. 检查最佳实践
4. 评估代码质量
5. 生成验证报告
6. 判断是否需要调用 `pua-escalation`
7. 真实问题先修完，再往下走

## 检查内容

### 功能正确性
- 需求符合性：是否符合需求规格
- 边界条件：是否处理边界条件
- 异常处理：是否正确处理异常

### 最佳实践
- 设计原则：是否遵循SOLID原则
- 设计模式：是否使用合适的设计模式
- 代码规范：是否遵循编码规范

### 代码质量
- 可测试性：是否易于测试
- 可维护性：是否易于维护
- 可扩展性：是否易于扩展

## 验证方法

### 1. 单元测试验证
```csharp
// 测试方法功能
[Test]
public void CalculateTotal_WithValidItems_ReturnsCorrectTotal()
{
    // Arrange
    var items = new List<Item>
    {
        new Item { Price = 10, Quantity = 2 },
        new Item { Price = 20, Quantity = 1 }
    };
    var calculator = new OrderCalculator();

    // Act
    var total = calculator.CalculateTotal(items);

    // Assert
    Assert.AreEqual(40, total);
}

// 测试边界条件
[Test]
public void CalculateTotal_WithEmptyList_ReturnsZero()
{
    // Arrange
    var items = new List<Item>();
    var calculator = new OrderCalculator();

    // Act
    var total = calculator.CalculateTotal(items);

    // Assert
    Assert.AreEqual(0, total);
}

// 测试异常处理
[Test]
public void CalculateTotal_WithNullItems_ThrowsArgumentNullException()
{
    // Arrange
    var calculator = new OrderCalculator();

    // Act & Assert
    Assert.Throws<ArgumentNullException>(() => calculator.CalculateTotal(null));
}
```

### 2. 集成测试验证
```csharp
// 测试组件集成
[Test]
public void OrderService_WithValidOrder_CreatesOrderSuccessfully()
{
    // Arrange
    var orderService = new OrderService();
    var order = new Order
    {
        CustomerId = 1,
        Items = new List<Item>
        {
            new Item { ProductId = 1, Quantity = 2 }
        }
    };

    // Act
    var result = orderService.CreateOrder(order);

    // Assert
    Assert.IsTrue(result.Success);
    Assert.IsNotNull(result.OrderId);
}
```

### 3. 功能测试验证
```csharp
// 测试业务功能
[Test]
public void Checkout_WithValidOrder_CompletesSuccessfully()
{
    // Arrange
    var checkoutService = new CheckoutService();
    var order = new Order
    {
        CustomerId = 1,
        Items = new List<Item>
        {
            new Item { ProductId = 1, Quantity = 2 }
        }
    };

    // Act
    var result = checkoutService.Checkout(order);

    // Assert
    Assert.IsTrue(result.Success);
    Assert.IsNotNull(result.TransactionId);
}
```

## 输出格式

验证完成后，输出以下格式的验证报告：

```text
## 功能验证报告

### 验证范围
- 文件：{文件列表}
- 模块：{模块名称}
- 功能：{功能描述}

### 验证结果
1. **功能正确性**：{评分}
   - 需求符合性：{评分}
   - 边界条件：{评分}
   - 异常处理：{评分}

2. **最佳实践**：{评分}
   - 设计原则：{评分}
   - 设计模式：{评分}
   - 代码规范：{评分}

3. **代码质量**：{评分}
   - 可测试性：{评分}
   - 可维护性：{评分}
   - 可扩展性：{评分}

### 测试覆盖率
- 单元测试覆盖率：{覆盖率}
- 集成测试覆盖率：{覆盖率}
- 功能测试覆盖率：{覆盖率}

### 问题汇总
- 严重问题：{严重问题列表}
- 重要问题：{重要问题列表}
- 次要问题：{次要问题列表}

### 建议行动
- 立即修复：{立即修复的问题}
- 计划修复：{计划修复的问题}
- 优化建议：{优化建议}
```

## 直接调用 `pua-escalation` 的触发条件

出现任一情况，先调用 `pua-escalation`，再回到验证流程：

- 你想跳过功能验证
- 你准备忽视验证问题
- 你在淡化验证发现的风险
- 你只想赶进度，不想修复问题
- 你打算用"后面再补"推迟关键问题

## 高压下怎么做

时间越紧，越不能缩功能验证。

正确做法是：

- 验证范围更聚焦
- 重要问题立即处理
- 一旦出现跳验证倾向，立即调 `pua-escalation`

## 红旗信号

- "这点东西不用验证"
- "这个后面再补"
- "先这样吧，差不多了"
- "这个太小，不值得验证"

## 压力升级

当遇到困难或失败时，读取 `skills/pua-escalation/SKILL.md` 获取具体的解决方案和指导。

## 底线

功能验证的成本，永远低于问题滚大后的成本；一旦开始想跳验证，就先调 `pua-escalation`。
