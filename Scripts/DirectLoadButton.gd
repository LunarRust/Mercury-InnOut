extends Button

var mapScene : PackedScene
@export var Destination: String
func _ready():
	pass
func _pressed():
	
	Fade.crossfade_prepare(2,"WeirdWipe",false,false)
	mapScene = load("res://Scenes/" + Destination + ".tscn")
	get_tree().change_scene_to_packed(mapScene)
	Fade.crossfade_execute()
	pass
