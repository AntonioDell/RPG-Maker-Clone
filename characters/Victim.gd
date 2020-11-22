extends Npc

export(float) var update_path_interval
export(float) var walk_speed := 100

var nav: Navigation2D
var start: Vector2
var end: Vector2
var path: PoolVector2Array
var timer: Timer

var current_point

onready var animated_sprite := $AnimatedSprite 

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func init(nav: Navigation2D, start: Vector2, end: Vector2, update_path_interval := 1.0, walk_speed := 100):
	self.nav = nav
	self.start = start
	self.end = end
	self.update_path_interval = update_path_interval
	self.walk_speed = walk_speed
	position = start

func _ready():
	_update_path()
	timer = Timer.new()
	timer.wait_time = update_path_interval
	timer.autostart = true
	self.add_child(timer)
	# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "_update_path")
	
func _physics_process(delta):
	if path and current_point == null:
		current_point = path[0]
		path.remove(0)
		
	if current_point:
		if current_point.distance_to(position) > 2:
			var target_direction = (current_point - position).normalized()

			var velocity = target_direction * walk_speed
			move_and_slide(velocity, Vector2.ZERO, false, 100)
		else:
			current_point = null
	
	# TODO: Check why position doesn't go to 0
	if position.distance_to(end) <= 16:
		_end_reached()
		
	for i in get_slide_count():
		var collision: KinematicCollision2D = get_slide_collision(i)

#	if get_slide_collision()

func _end_reached() -> void:
	print("Reached the end.")
	queue_free()
		

func _play_walking_animation(distance: Vector2):
	var current_animation = animated_sprite.animation
	if distance.y < 0 and current_animation != "walk_up":
		animated_sprite.play("walk_up")
	elif distance.y > 0 and current_animation != "walk_down":
		animated_sprite.play("walk_down")
	elif distance.x > 0 and current_animation != "walk_right":
		animated_sprite.play("walk_right")
	elif distance.x < 0 and current_animation != "walk_left":
		animated_sprite.play("walk_left")
	


func _update_path():
	if not nav:
		return
	var last_path_point = path[0] if path and not path.empty() else position
	path = nav.get_simple_path(last_path_point, end, false)

	
func execute_player_interaction() -> void:
	queue_free()
