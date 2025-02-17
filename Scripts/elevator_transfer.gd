extends Area3D


@export var destinationscene : String
@export var anim : AnimationPlayer
var elevatorScene : PackedScene
var used : bool

func transfer():
	get_tree().change_scene_to_packed(elevatorScene);
	pass

func _on_area_entered(_area:Area3D):
	if (used == false):
		used = true
		get_tree().get_first_node_in_group("player").set_script(null)
		var tween = get_tree().create_tween()
		tween.tween_property(get_viewport().get_camera_3d(), "rotation", Vector3(0,3.14159,0), .5)
		#get_viewport().get_camera_3d().rotate_y(3.14159)
		SceneLoader.DestinationScene = "res://Scenes/" + destinationscene + ".tscn"
		elevatorScene = load("res://Scenes/Elevator.tscn")
		anim.play("Elevator_New")
	pass # Replace with function body.
