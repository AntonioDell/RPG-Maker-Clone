tool extends SpriteFrames
class_name SpriteSheet

const DEFAULT_ANIMATION_SPEED := 3.0

const WALK_RIGHT := "walk_right"
const WALK_LEFT := "walk_left"
const WALK_UP := "walk_up"
const WALK_DOWN := "walk_down"
const IDLE := "idle"

const NECESSARY_ANIMATIONS := [WALK_DOWN, WALK_LEFT, WALK_RIGHT, WALK_UP, IDLE]


func _init():
	if not Engine.editor_hint:
		return
		
	for animation_name in NECESSARY_ANIMATIONS:
		if not has_animation(animation_name):
			push_warning("Missing necessary animation '%s'! Adding it as empty animation." % animation_name)
			call_deferred("add_animation", animation_name)
			call_deferred("set_animation_speed", animation_name, DEFAULT_ANIMATION_SPEED)
	pass

