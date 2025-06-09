@tool
class_name Rule extends Resource

## @brief 规则评估的基类
## @param context (Dictionary): 评估规则时需要用到的上下文数据。
## @return bool: 返回评估结果，true为通过，false为不通过。
func Evaluate(context: Dictionary) -> bool:
	push_error("Evaluate() function not implemented in a derived Rule script.")
	return false 
