@tool
class_name HasItemRule extends Rule

## @brief 要求的物品名称。
@export var item_name: String
## @brief 要求的物品数量。
@export var quantity: int = 1


## @brief 检查玩家是否拥有指定数量的特定物品。
## @param context (Dictionary): 需要包含 'player_inventory' (Dictionary) 键。
##      库存字典的格式应为 { "物品名称": 数量 }。
## @return bool: 如果玩家拥有足够数量的物品，则返回 true。
func Evaluate(context: Dictionary) -> bool:
	if not context.has("player_inventory"):
		push_error("HasItemRule requires 'player_inventory' in the context.")
		return false

	var inventory = context["player_inventory"] as Dictionary
	if inventory.has(item_name) and inventory[item_name] >= quantity:
		return true
	
	return false 
