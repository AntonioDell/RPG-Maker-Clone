tool extends Control

export(Resource) var conversation setget set_conversation_res
func set_conversation_res(value):
	conversation = value
	if not conversation:
		conversation = Conversation.new()
		conversation.resource_name = "<Initial name>"

var current_branch := 0

onready var text_field: RichTextLabel = get_node("Background/TextField")
onready var button_container: HBoxContainer= get_node("Background/ButtonContainer")
onready var button_theme: Theme = preload("res://DefaultTheme.tres")

func _ready():
	text_field.bbcode_enabled = true
	text_field.custom_effects[0].connect("fully_typed", $".", "on_text_fully_typed")
	pass

func _input(event : InputEvent):
	if event is InputEventKey and !event.pressed:
		_next_branch()

func _next_branch() -> void:
	if current_branch < conversation.branches.size():
		var branch = conversation.branches[current_branch]
		_remove_buttons()
		_set_text(branch)
		current_branch += 1
		

func _set_text(branch: Dictionary) -> void:
	text_field.bbcode_text = branch.get("text")

func _set_buttons(branch: Dictionary) -> void:
	# Skip if there are no choices to show
	if !branch.has("choices"):
		return
	
	# Create button for each choice
	var choices: Array = branch.get("choices")
	
	for choice in choices:
		var button := Button.new()
		button.text = choice
		button.theme = button_theme
		button.connect("pressed", $".", "on_choice_clicked", [choice])
		button_container.add_child(button)

func on_text_fully_typed() -> void:
	_set_buttons(conversation.branches[current_branch-1])
	
func _remove_buttons() -> void:
	# Remove currently shown buttons
	if button_container.get_child_count() > 0:
		for button in button_container.get_children():
			button_container.remove_child(button)
			button.queue_free()
	
func on_choice_clicked(choice) -> void:
	_next_branch()
