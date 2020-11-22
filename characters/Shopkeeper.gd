tool extends Npc

export(TextFile) var open_shop_conversation


func execute_player_interaction():
	_open_shop()

func execute_player_collision():
	_open_shop()

func on_shop_closed(original_caller: Node):
	if original_caller == self:
		$AnimatedSprite.play("idle")

func _open_shop():
	$AnimatedSprite.play("open_shop")
	emit_signal("show_conversation", open_shop_conversation, self)
