# Godot 通用规则集系统 (Godot Universal RuleSet System)

这是一个为 Godot Engine 设计的通用、可扩展的规则集系统。它允许开发者和设计师在 Godot 编辑器中以资源（Resource）的形式直观地创建、组合和配置复杂的逻辑规则，而无需编写额外的代码。

本系统严格遵循**开闭原则**，您可以轻松添加新的规则类型来扩展系统，而无需修改任何现有核心代码。

## ✨ 系统特性

- **可视化配置**: 直接在 Godot 编辑器中创建和管理规则及规则集，像操作任何其他资源一样简单。
- **高度可扩展**: 只需继承 `Rule` 基类并实现 `Evaluate` 方法，即可创建任意复杂的新规则。
- **灵活组合**: 支持 `AND` (所有规则满足) 和 `OR` (任意规则满足) 两种逻辑模式。
- **嵌套结构**: 规则集可以包含其他规则集，轻松构建复杂的判定树。
- **全局访问**: 通过 `RuleManager` 单例，在项目的任何地方方便地调用和评估规则。
- **代码整洁**: 将游戏逻辑（如何判定）与游戏行为（判定后做什么）完全解耦。

## 📂 文件结构

```
/规则集
  ├── Rule.gd              # (核心) 所有规则的抽象基类
  ├── RuleSet.gd           # (核心) 规则集，用于容纳和评估一组规则
  ├── RuleManager.gd       # (核心) 全局单例，用于检查规则集
  ├── PlayerLevelRule.gd   # (示例) 检查玩家等级的规则
  └── HasItemRule.gd       # (示例) 检查玩家是否拥有特定物品的规则
```

## 🚀 如何使用

### 1. 安装

1.  将 `规则集` 文件夹完整复制到您的 Godot 项目中。
2.  **设置 `RuleManager` 为自动加载 (Singleton)**:
    *   打开 Godot 编辑器，进入 **项目 (Project) > 项目设置 (Project Settings...)**。
    *   切换到 **Autoload** 标签页。
    *   点击 **路径 (Path)** 右侧的文件夹图标，选择 `规则集/RuleManager.gd`。
    *   **节点名称 (Node Name)** 会自动填充为 `RuleManager`，保持默认即可。
    *   点击 **添加 (Add)**。

### 2. 在编辑器中创建规则

这是本系统最强大的功能。

1.  在 **文件系统 (FileSystem)** 面板中，右键点击您想存放规则的文件夹。
2.  选择 **新建 (New...) > 资源 (Resource)...**。
3.  在弹出的窗口中，选择您需要的规则类型，例如 `PlayerLevelRule` 或 `HasItemRule`。
4.  将资源保存为 `.tres` 文件（如 `level_gt_10_rule.tres`）。
5.  点击您创建的 `.tres` 文件，在 **检查器 (Inspector)** 中配置其属性（如 `min_level`）。

### 3. 创建并配置规则集

1.  同样地，新建一个 `RuleSet` 类型的资源（如 `can_open_chest.tres`）。
2.  在检查器中，您可以：
    *   设置 **Mode**: `ALL` (所有规则满足) 或 `ANY` (任意一个满足)。
    *   配置 **Rules** 数组：将您创建的 `.tres` 规则文件从文件系统面板拖拽到数组的插槽中。您甚至可以拖入另一个 `RuleSet` 资源实现嵌套。

### 4. 在代码中评估规则

现在，您可以在任何脚本中通过全局的 `RuleManager` 来检查一个规则集是否满足。

```gdscript
# 示例：在一个宝箱的脚本中检查是否可以被打开

func _on_player_interaction():
    # 1. 定义评估所需的上下文信息
    #    这个字典的键必须与您的规则所期望的一致
    var eval_context = {
        "player_level": get_player().level,
        "player_inventory": get_player().inventory # 假设格式为 {"item_name": quantity}
    }

    # 2. 加载您在编辑器中创建的规则集资源
    var can_open_rules = load("res://rules/can_open_chest.tres")

    # 3. 使用 RuleManager 进行评估
    if RuleManager.CheckRuleSet(can_open_rules, eval_context):
        print("条件满足：打开宝箱！")
        open_chest()
    else:
        print("条件不满足：宝箱仍然锁定。")
        show_locked_message()

    # 也可以直接通过路径评估，无需预加载
    # if RuleManager.CheckRuleSetByPath("res://rules/can_open_chest.tres", eval_context):
    #     ...
```

## 🛠️ 如何扩展（创建新规则）

当您需要一个新的规则类型（例如，“检查玩家声望”）时，只需：

1.  **创建新脚本**: 例如 `PlayerReputationRule.gd`。
2.  **继承 `Rule`**:
    ```gdscript
    @tool
    class_name PlayerReputationRule extends Rule
    ```
3.  **添加 `@export` 变量**:
    ```gdscript
    ## @brief 要求的最低声望值
    @export var required_reputation: int = 100
    ```
4.  **实现 `Evaluate` 方法**:
    ```gdscript
    func Evaluate(context: Dictionary) -> bool:
        if not context.has("player_reputation"):
            push_error("PlayerReputationRule 需要在 context 中提供 'player_reputation'。")
            return false

        var current_reputation = context["player_reputation"] as int
        return current_reputation >= required_reputation
    ```

完成！现在您就可以在编辑器中创建 `PlayerReputationRule` 类型的资源了，无需修改任何核心代码。

## 💡 应用场景

- **任务接取条件**: 玩家等级、前置任务完成状态、特定物品持有情况。
- **对话分支**: 根据玩家的选择、属性或阵营来决定 NPC 的反应。
- **技能学习/装备穿戴**: 角色属性、职业、前置技能是否满足要求。
- **场景交互**: 开门、激活机关等，需要满足多个条件。
- **AI 行为决策**: 根据环境和自身状态（生命值、敌人距离）决定 AI 的行动策略。
