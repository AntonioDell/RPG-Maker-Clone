tool extends RichTextEffect
class_name TypewriterEffect

var bbcode = "typewriter"
var typewriter_timing = {}
var is_fully_typed = false
var is_skipped = false

signal fully_typed

func typewriter_register_timing(index) -> Dictionary:
	if !typewriter_timing.has(index):
		typewriter_timing[index] = {"finish": false, "go_time": -1}
	return typewriter_timing[index]

func typewriter_is_go(index):
	var current_index = 0
	var all_finished = true
	while current_index < index and all_finished:
		all_finished = !typewriter_timing.has(current_index) \
		or typewriter_timing[current_index]["finish"]
		current_index += 1
	
	return all_finished


func _process_custom_fx(char_fx: CharFXTransform):
	if _check_is_skipped(char_fx):
		return true
	
	var index = char_fx.absolute_index
	var timing = typewriter_register_timing(index)
	if timing["finish"]:
		if index + 1 == typewriter_timing.size() \
		and !is_fully_typed:
			is_fully_typed = true
			emit_signal("fully_typed")
		return true
	
	var time = char_fx.elapsed_time
	var speed = char_fx.env.get("speed", 0.2) # in seconds

	if timing["go_time"] == -1 \
	and typewriter_is_go(index):
		timing["go_time"] = time
		
	
	if timing["go_time"] >= 0 \
	and time > timing["go_time"] + speed:
		timing["finish"] = true
		char_fx.visible = true
	else:
		char_fx.visible = false
	
	return true

func _check_is_skipped(char_fx: CharFXTransform):
	if is_skipped:
		char_fx.visible = true
		if !is_fully_typed:
			emit_signal("fully_typed")	
		is_fully_typed = true
		return true
	else:
		return false

func reset():
	typewriter_timing = {}
	is_fully_typed = false
	is_skipped = false

func on_skip_typewriter():
	is_skipped = true
