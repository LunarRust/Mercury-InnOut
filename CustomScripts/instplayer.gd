extends Node
var player_object = null
var ui_overlay = null
@export var location : Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	player_object = preload("res://prefabs/player_object.tscn").instantiate(PackedScene.GEN_EDIT_STATE_DISABLED) as Node3D
	if player_object:
		$".".add_child(player_object)
		get_tree().get_first_node_in_group("player").newPos = Vector3(0, 0, 0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
