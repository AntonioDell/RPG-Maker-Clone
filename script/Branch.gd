extends Object

class_name Branch

export(String) var text
export(Array, String) var choices

func _init(text: String, choices: Array = []):
	self.text = text
	self.choices = choices

