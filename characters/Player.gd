extends KinematicBody2D

export (int) var speed = 100

var velocity = Vector2()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	
	if velocity.y > 0:
		_play_walking_animation("walk_down")
	elif velocity.y < 0:
		_play_walking_animation("walk_up")
	elif velocity.x > 0:
		_play_walking_animation("walk_right")
	elif velocity.x < 0:
		_play_walking_animation("walk_left")
	
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	if velocity.length() == 0:
		_play_walking_animation("idle")
	for i in get_slide_count():
		if not get_slide_collision(i).collider is Npc:
			continue
		var other := get_slide_collision(i).collider as Npc
		var standing_collision = get_slide_collision(i).travel == Vector2.ZERO
		if not standing_collision:
			other.execute_player_collision()
		if Input.is_action_just_released("ui_accept"):
			other.execute_player_interaction()

func _play_walking_animation(animation: String) -> void:
	if $AnimatedSprite.animation != animation or !$AnimatedSprite.is_playing():
		$AnimatedSprite.play(animation)

		
	
