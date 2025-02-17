extends Node

var STEAM_APP_ID: int = 3243190


# Called when the node enters the scene tree for the first time.
func _ready():
	_initialize_Steam()
	pass # Replace with function body.

func _process(_delta : float):
	Steam.run_callbacks()
	pass

func _initialize_Steam():
	OS.set_environment("SteamAppId", str(STEAM_APP_ID))
	OS.set_environment("SteamGameId", str(STEAM_APP_ID))
	
	var INIT: Dictionary = Steam.steamInit(false)
	print("Steam Status is " +str(INIT))
	if (Steam.isSteamRunning() == false):
		pass
	else:
		if (Steam.isSubscribed() == true):
			print("Stmchk is fine")
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			get_tree().change_scene_to_packed(load("res://Scenes/bsod.tscn") as PackedScene)