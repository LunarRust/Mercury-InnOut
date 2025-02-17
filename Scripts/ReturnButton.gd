extends TextureButton


var loadScene: PackedScene
var destination: String

# Called when the node enters the scene tree for the first time.
func _ready():
	loadScene = load("res://Scenes/TipSceneLoader.tscn")

	if (GameProgress.MapLayer == 1):
		destination = "WorldMap"
	if (GameProgress.MapLayer == 2):
		destination = "WorldMap2"
	if (GameProgress.MapLayer == 3):
		destination = "WorldMap3"
		
	pass # Replace with function body.

func _input(_event):
	if Input.is_joy_button_pressed(0, JOY_BUTTON_START):
		_pressed()


func _pressed():
	SceneLoader.DestinationScene = "res://Scenes/" + destination + ".tscn"
	Fade.crossfade_prepare(2,"WeirdWipe",false,false)
	get_tree().change_scene_to_packed(loadScene)
	Fade.crossfade_execute()
	pass
