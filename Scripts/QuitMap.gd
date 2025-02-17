extends Button


func _pressed():
	Fade.crossfade_prepare(2,"WeirdWipe",false,false)
	get_tree().change_scene_to_packed(load("res://Scenes/title_screen.tscn"))
	Fade.crossfade_execute()
	pass
