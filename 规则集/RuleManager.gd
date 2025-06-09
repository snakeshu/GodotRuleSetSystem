extends Node

## @brief 检查一个规则集资源。
## @param rule_set (RuleSet): 要评估的规则集资源。
## @param context (Dictionary): 评估规则时需要用到的上下文数据。
## @return bool: 返回评估结果。
func CheckRuleSet(rule_set: RuleSet, context: Dictionary) -> bool:
	if not rule_set:
		push_error("Provided RuleSet is null.")
		return false
	return rule_set.Evaluate(context)


## @brief 通过路径加载并检查一个规则集资源。
## @param path (String): 规则集资源的文件路径 (e.g., "res://rules/my_rule.tres")。
## @param context (Dictionary): 评估规则时需要用到的上下文数据。
## @return bool: 返回评估结果。
func CheckRuleSetByPath(path: String, context: Dictionary) -> bool:
	var rule_set = load(path) as RuleSet
	if not rule_set:
		push_error("Failed to load RuleSet from path: " + path)
		return false
	return rule_set.Evaluate(context) 
