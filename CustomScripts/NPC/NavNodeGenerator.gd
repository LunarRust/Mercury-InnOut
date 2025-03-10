extends Node
@export var Scene : PackedScene
@export var textbox : LineEdit
#@export var LocationRelative : Vector3
@export var TargetLoc : RayCast3D
@export var Property : String
@export var SourceProperty: Node
@export var Value : String
@export var LocOffset : Vector3
var id
var ScenePack
var start : bool = false
var Spawned = false
var textboxDest


func _ready():
	start = true
	pass
	
func _process(delta):
	if start == true:
		if self.get_parent().running == true:
			if !Spawned:
				Spawned = true
				Packload()

	
	
func Packload():
	id = self.get_parent().InstID
	var node : Node = Scene.instantiate()
	node.InstID = id
	get_tree().current_scene.add_child(node)
	node.global_position = TargetLoc.get_collision_point() + LocOffset
	print(node.get_tree_string_pretty())
	TargetLoc.get_collision_point()
