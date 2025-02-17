extends TextureButton

@export var destination: String
var loadScene: PackedScene
@export var sceneLoader: String = "res://Scenes/TipSceneLoader.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	loadScene = load(sceneLoader)
	pass # Replace with function body.


func _pressed():
	
	SceneLoader.DestinationScene = "res://Scenes/" + destination + ".tscn"
	Fade.crossfade_prepare(2,"WeirdWipe",false,false)
	get_tree().change_scene_to_packed(loadScene)
	Fade.crossfade_execute()
	pass
