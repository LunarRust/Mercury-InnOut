extends Node
var loadScene: PackedScene

func _ready():
	print("King of Mercury initialized!")
	loadScene = load(res://Scenes/title_screen.tscn)
	get_tree().change_scene_to_packed(loadScene)
	pass
