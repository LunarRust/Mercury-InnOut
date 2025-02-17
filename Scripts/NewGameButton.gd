extends TextureButton

@export var Warning : ColorRect


func _pressed():
	if (PlayerPrefs.get_pref("Keys", 0) > 0):
		$Warning.set_visible(true)
	else:
		start()
	pass

func start():
	GameProgress._reset()

	Fade.crossfade_prepare(2,"WeirdWipe",false,false)
	get_tree().change_scene_to_packed(load("res://Scenes/GameIntro.tscn"))
	Fade.crossfade_execute()
	InventoryManager.itemArray.clear()
