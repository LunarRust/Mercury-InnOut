extends Node2D


@export var speed : int = 250
@export var upperlimit : int = -100
@export var lowerlimit : int = 600
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.y -= speed * delta
	if (global_position.y < -100):
		global_position.y = 600
	pass
