class_name Choice

var id := ""
var text := ""

func _init(dict: Dictionary):
	self.id = dict.get("id")
	self.text = dict.get("text")
