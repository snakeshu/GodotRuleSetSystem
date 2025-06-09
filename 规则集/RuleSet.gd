@tool
class_name RuleSet extends Resource

enum EvaluationMode {
	ALL, # 所有规则都必须为 true
	ANY  # 任意一个规则为 true 即可
}

## @brief 一组规则的集合。
@export var rules: Array[Rule]

## @brief 规则集的评估模式。
@export var mode: EvaluationMode = EvaluationMode.ALL


## @brief 评估整个规则集。
## @param context (Dictionary): 评估规则时需要用到的上下文数据。
## @return bool: 返回规则集的最终评估结果。
func Evaluate(context: Dictionary) -> bool:
	if rules.is_empty():
		return true

	match mode:
		EvaluationMode.ALL:
			for rule in rules:
				if not rule:
					printerr("RuleSet 中发现了一个空规则。")
					continue
				if not rule.Evaluate(context):
					return false
			return true
		EvaluationMode.ANY:
			for rule in rules:
				if not rule:
					printerr("RuleSet 中发现了一个空规则。")
					continue
				if rule.Evaluate(context):
					return true
			return false
			
	return false 
