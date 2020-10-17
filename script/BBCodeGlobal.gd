extends Node


var typewriter_timing = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func typewriter_register_timing(absolute_index):
	if !typewriter_timing.has(absolute_index):
		typewriter_timing[absolute_index] = false

func typewriter_is_go(absolute_index):
	var current_index = 0	
	var all_finished = true
	while current_index < absolute_index and all_finished:
		all_finished = typewriter_timing[current_index] == null \
		or typewriter_timing[current_index]
		current_index += 1
	
	return all_finished

func typewriter_set_finish(absolute_index):
	typewriter_timing[absolute_index] = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
