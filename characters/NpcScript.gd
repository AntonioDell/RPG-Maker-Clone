tool extends KinematicBody2D
class_name Npc

# warning-ignore: unused_signal
signal show_conversation(conversation)


# Code to execute, when player collides with npc.
# Override it to customize behaviour.
func execute_player_collision() -> void:
	pass

# Code to execute, when player interacts with npc.
# Override it to customize behaviour.
func execute_player_interaction() -> void:
	pass
	
func _show_conversation():
	pass
