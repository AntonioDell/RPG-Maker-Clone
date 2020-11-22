class_name Branch

var id: String
var text: String
var choices: Array
var conditions: Array

func _init(dict: Dictionary):
	self.id = dict.get("id")
	self.text = dict.get("text")
	self.conditions = dict.get("conditions", [])
	self.choices = []
	for choice_dict in dict.get("choices", []):
		self.choices.append(Choice.new(choice_dict))
	
func all_conditions_met(selected_choices) -> bool:
	var condition_met := true
	for condition in conditions:
		if !selected_choices.has(condition):
			condition_met = false
			break
	return condition_met
