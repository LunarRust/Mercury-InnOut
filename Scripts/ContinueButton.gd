extends TextureButton

var mapScene : PackedScene

func _ready():
	pass
func _pressed():

	SavePoint.Load()
	if (GameProgress.MapLayer == 1):
		mapScene = load("res://Scenes/WorldMap.tscn")
	elif (GameProgress.MapLayer == 2):
		mapScene = load("res://Scenes/WorldMap2.tscn")
	elif (GameProgress.MapLayer == 3):
		mapScene = load("res://Scenes/WorldMap3.tscn")

	Fade.crossfade_prepare(2,"WeirdWipe",false,false)
	get_tree().change_scene_to_packed(mapScene)
	Fade.crossfade_execute()
	pass
