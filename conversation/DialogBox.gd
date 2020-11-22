extends Popup

signal skip_typewriter
signal dialog_closed(original_caller)

const CONVERSATION_ENDED = "$end$"

export(TextFile) var conversation

var current_branch: Branch
var selected_choices := []
var fully_typed := false
var caller: Node
var fade_out_completed := false

onready var text_field: RichTextLabel = get_node("Background/TextField")
onready var button_container: HBoxContainer= get_node("Background/ButtonContainer")
onready var button_theme: Theme = preload("res://DefaultTheme.tres")


func _ready():
	text_field.bbcode_enabled = true
	var typewriter_effect = text_field.custom_effects[0]
	typewriter_effect.connect("fully_typed", $".", "on_text_fully_typed")
	connect("skip_typewriter", typewriter_effect, "on_skip_typewriter")

func _input(event : InputEvent):
	if fade_out_completed:
		return
		
	if Input.is_action_just_released("ui_accept") and visible:
		if !fully_typed and current_branch:
			emit_signal("skip_typewriter")
		elif not current_branch or current_branch.choices.empty():
			_next_branch()

# Starting point for a new conversation.
func on_show_conversation(conversation_to_show: Conversation, caller: Node) -> void:
	if fade_out_completed:
		print_debug("Started conversation before other one faded")
		return
	text_field.bbcode_text = ""
	self.caller = caller
	self.conversation = conversation_to_show
	get_tree().paused = true
	popup_centered(Vector2(360, 100))
	_next_branch()

func on_text_fully_typed() -> void:
	fully_typed = true
	_set_buttons()

func on_choice_clicked(choice) -> void:
	selected_choices.append(choice)
	_next_branch()

func _next_branch() -> void:
	if _is_conversation_over():
		_end_conversation()
		return
	# current_branch was updated
	fully_typed = false
	_remove_buttons()
	text_field.bbcode_text = current_branch.text

func _end_conversation():
	self.conversation = null
	self.current_branch = null
	self.fully_typed = false
	selected_choices = []
	get_tree().paused = false
	$FadeOut.interpolate_property(self, "modulate:a", 1.0, 0.0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$FadeOut.start()
	fade_out_completed = true
	

# Returns true if the conversation ended, set's current_branch if not
func _is_conversation_over() -> bool:
	if !current_branch:
		current_branch = Branch.new(conversation.branches[0])
		return false
	
	var branch_index: int
	for branch_dict in conversation.branches:
		if branch_dict.get("id") == current_branch.id:
			branch_index = conversation.branches.find(branch_dict) + 1
			
	while branch_index < conversation.branches.size():
		var branch := Branch.new(conversation.branches[branch_index])
		if branch.all_conditions_met(selected_choices):
			current_branch = branch
			return false
		branch_index += 1
	return true
	
func _set_buttons() -> void:
	# Skip if there are no choices to show
	if current_branch.choices.empty():
		return
	
	# Create button for each choice
	var first_button := true
	for choice_untyped in current_branch.choices:
		var choice = (choice_untyped as Choice)
		var button := Button.new()
		button.text = choice.text
		button.theme = button_theme
		button.connect("pressed", $".", "on_choice_clicked", [choice.id])
		button_container.add_child(button)
		if first_button:
			first_button = false
			button.grab_focus()

# Remove currently shown buttons
func _remove_buttons() -> void:
	if button_container.get_child_count() > 0:
		for button in button_container.get_children():
			button_container.remove_child(button)
			button.queue_free()

func _on_DialogBox_about_to_show():
	$FadeIn.interpolate_property(self, "modulate:a", 0.0, 1.0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$FadeIn.start()

# Last method to get called before dialog closes
func _on_FadeOut_completed(object, key):
	fade_out_completed = false
	hide()
	emit_signal("dialog_closed", caller)
	
