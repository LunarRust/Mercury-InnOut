extends AnimationPlayer

@export var destination : String


func _on_animation_finished(anim_name:StringName):
	print(anim_name)
	get_tree().change_scene_to_packed(load("res://Scenes/" + destination + ".tscn") as PackedScene)
	pass # Replace with function body.
