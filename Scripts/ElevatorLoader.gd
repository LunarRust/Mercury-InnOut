extends Node

var EndScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	EndScene = load(SceneLoader.DestinationScene) as PackedScene
	pass # Replace with function body.

func _input(event):
	if event.is_pressed():
		Load()

func Load():
	Fade.crossfade_prepare(2,"WeirdWipe",false,false)
	get_tree().change_scene_to_packed(EndScene)
	Fade.crossfade_execute()
	pass
