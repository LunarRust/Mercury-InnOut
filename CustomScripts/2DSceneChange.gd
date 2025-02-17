extends Button
@export var Dest : String

func _pressed():
	Fade.crossfade_prepare(2,"WeirdWipe",false,false)
	get_tree().change_scene_to_packed(load("res://" + Dest + ".tscn"))
	Fade.crossfade_execute()
	pass
