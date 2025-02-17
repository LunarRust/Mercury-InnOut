extends Node
class_name SceneLoader

static var DestinationScene : String
var loadStatus = 0
var progress = []
var loadReady = false;
var newScene
@export var LoadText : RichTextLabel


func _ready():
	loadReady = false
	ResourceLoader.load_threaded_request(DestinationScene)
	print("Destination is: " + DestinationScene)
	$"../ConsoleParent/RichTextLabel4".set_text("Destination is: " + DestinationScene)

func _process(_delta):
	if (!loadReady):
		loadStatus = ResourceLoader.load_threaded_get_status(DestinationScene,progress)
		if (loadStatus == ResourceLoader.THREAD_LOAD_LOADED):
			newScene = ResourceLoader.load_threaded_get(DestinationScene) as PackedScene
			if LoadText != null:
				await get_tree().create_timer(0.3).timeout
				LoadText.text = "[wave]Press any key to continue"
			loadReady = true
	
func _input(event):
	if event is InputEventKey && event.is_pressed() && loadReady:
		if not event.keycode == KEY_F4:
			sceneLoad()
	elif event is InputEventMouseButton:
		sceneLoad()

func sceneLoad():
	if (loadReady):
		Fade.crossfade_prepare(2,"WeirdWipe",false,false)
		get_tree().change_scene_to_packed(newScene)
		Fade.crossfade_execute()
		print("Cool")
