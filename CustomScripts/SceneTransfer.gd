extends Area3D


var loadScene: PackedScene
@export var destination: String

# Called when the node enters the scene tree for the first time.
func _ready():
	loadScene = load("res://CustomMercScenes/CustomScenes/WMMD.tscn")
	pass # Replace with function body.




func _load():
	Fade.crossfade_prepare(2,"WeirdWipe",false,false)
	get_tree().change_scene_to_packed(loadScene)
	Fade.crossfade_execute()
	pass


func _on_area_entered(area):
	_load()
	pass # Replace with function body.
