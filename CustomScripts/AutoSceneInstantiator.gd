extends Node
@export var Scene : PackedScene
@export var textbox : LineEdit
#@export var LocationRelative : Vector3
@export var TargetLoc : Node3D
@export var LocOffset : Vector3
var ScenePack
var active = false
var Spawned = false
var textboxDest


func _ready():
	active = true
	
func _process(delta):
		if active && !Spawned:
			Spawned = true
			Packload()

	
func create():
	var node : Node = ScenePack.instantiate()
	get_tree().current_scene.add_child(node)
	if TargetLoc is RayCast3D:
		node.global_position = TargetLoc.get_collision_point()
	else:
		node.global_position = TargetLoc.global_position
	node.position += LocOffset
	print(node.get_tree_string_pretty())
	#TargetLoc.get_collision_point()
	
func Packload():
	if (textbox != null && textbox.text != "Enter prefab"):
			textboxDest = "res://prefabs/" + textbox.text + ".tscn"
			ResourceLoader.load_threaded_request(textboxDest)
			ScenePack = ResourceLoader.load_threaded_get(textboxDest) as PackedScene
			create()
	else:
		var node : Node = Scene.instantiate()
		get_tree().current_scene.add_child(node)
		if TargetLoc is RayCast3D:
			node.global_position = TargetLoc.get_collision_point()
		else:
			node.global_position = TargetLoc.global_position
		node.position += LocOffset
		print(node.get_tree_string_pretty())
