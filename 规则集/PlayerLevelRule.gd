@tool
class_name PlayerLevelRule extends Rule

## @brief 要求的最低等级。
@export var min_level: int = 1
## @brief 要求的最高等级。
@export var max_level: int = 99


## @brief 检查玩家等级是否在指定范围内。
## @param context (Dictionary): 需要包含 'player_level' (int) 键。
## @return bool: 如果玩家等级在 [min_level, max_level] 范围内，则返回 true。
func Evaluate(context: Dictionary) -> bool:
	if not context.has("player_level"):
		push_error("PlayerLevelRule requires 'player_level' in the context.")
		return false
	
	var player_level = context["player_level"] as int
	return player_level >= min_level and player_level <= max_level 
