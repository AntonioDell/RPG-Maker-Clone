tool extends Path2D

func _ready():
	$Tween.interpolate_property($PathFollow2D, "unit_offset", 0, 1, 5, Tween.TRANS_LINEAR)
	$Tween.start()
	pass
