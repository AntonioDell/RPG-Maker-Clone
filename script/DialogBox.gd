tool extends Control

signal skip_typewriter

const CONVERSATION_ENDED = "$end$"

export(Resource) var conversation setget set_conversation_res
func set_conversation_res(value):
	conversation = value
	if not conversation:
		conversation = Conversation.new()
		conversation.resource_name = "<Initial name>"

var current_branch: Branch
var selected_choices := []
var fully_typed := false

onready var text_field: RichTextLabel = get_node("Background/TextField")
onready var button_container: HBoxContainer= get_node("Background/ButtonContainer")
onready var button_theme: Theme = preload("res://DefaultTheme.tres")

func _ready():
	text_field.bbcode_enabled = true
	var typewriter_effect = text_field.custom_effects[0]
	typewriter_effect.connect("fully_typed", $".", "on_text_fully_typed")
	connect("skip_typewriter", typewriter_effect, "on_skip_typewriter")
	pass

func _input(event : InputEvent):
	if event is InputEventKey and !event.pressed:
		if !fully_typed and current_branch:
			emit_signal("skip_typewriter")
		else:
			_next_branch()

func _next_branch() -> void:
	if _is_conversation_over():
		# TODO: Signal conversation ended / close dialog
		return
	# current_branch was updated
	fully_typed = false
	_remove_buttons()
	text_field.bbcode_text = current_branch.text


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
	for choice_untyped in current_branch.choices:
		var choice = (choice_untyped as Choice)
		var button := Button.new()
		button.text = choice.text
		button.theme = button_theme
		button.connect("pressed", $".", "on_choice_clicked", [choice.id])
		button_container.add_child(button)

func on_text_fully_typed() -> void:
	fully_typed = true
	_set_buttons()
	
	
func _remove_buttons() -> void:
	# Remove currently shown buttons
	if button_container.get_child_count() > 0:
		for button in button_container.get_children():
			button_container.remove_child(button)
			button.queue_free()
	
func on_choice_clicked(choice) -> void:
	selected_choices.append(choice)
	_next_branch()
