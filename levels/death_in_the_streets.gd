extends Node2D

export(float) var victim_spawn_rate = 1.0
export(bool) var disable_spawn = false
export(bool) var initial_spawn = true

var victim_scene := preload("res://characters/Victim.tscn")
var rng := RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	var timer := Timer.new()
	timer.autostart = true
	timer.wait_time = victim_spawn_rate
	add_child(timer)
	timer.connect("timeout", self, "_spawn_victim")
	if initial_spawn:
		_spawn_victim()

func _process(delta):
	pass


func _spawn_victim():
	if disable_spawn:
		return
	
	var victim_spawn_point := _get_spawn_point()
	var victim_target_point := _get_target_point(victim_spawn_point)
	var new_victim = victim_scene.instance()
	new_victim.init($Navigation2D,victim_spawn_point.position, victim_target_point.position)
	$Navigation2D.add_child(new_victim)

func _get_spawn_point() -> Position2D:
	match rng.randi_range(0, 3):
		0: return $SpawnPointL1 as Position2D
		1: return $SpawnPointL2 as Position2D
		2: return $SpawnPointR1 as Position2D
		3: return $SpawnPointR2 as Position2D
	return null
	
func _get_target_point(spawn_point: Position2D) -> Position2D:
	var point_number = rng.randi_range(0, 1)
	if spawn_point == $SpawnPointL1 or spawn_point == $SpawnPointL2:
		return $SpawnPointR1 as Position2D if point_number == 0 else $SpawnPointR2 as Position2D
	else:
		return $SpawnPointL1 as Position2D if point_number == 0 else $SpawnPointL2 as Position2D
