extends RichTextLabel

# TODO: Make code generic for multiple custom RichTextEffects

signal custom_effects_finished

var typewriter_effect: TypewriterEffect

var all_custom_effects_finished := false
var check_activity := false

func _ready():
	typewriter_effect = (custom_effects[0] as TypewriterEffect)
	typewriter_effect.connect("fully_typed", self, "on_typewriter_fully_typed")

func _set(k, v):
	if "bbcode_text" == k:
		typewriter_effect.reset()
		all_custom_effects_finished = false

func on_typewriter_fully_typed():
	all_custom_effects_finished = true

func _process(delta):
	if Engine.editor_hint:
		# TODO: Make text display in a loop when in editor
		return

	if _all_custom_effects_inactive():
		all_custom_effects_finished = true
		
	if all_custom_effects_finished:
		all_custom_effects_finished = false
		emit_signal("custom_effects_finished")

# Returns true if all custom effects are inactive.
func _all_custom_effects_inactive() -> bool:
	if check_activity:
		check_activity = false
		return !typewriter_effect.is_typewriter_active()
	else:
		return false


func _on_Check_Activity_timeout():
	check_activity = true
