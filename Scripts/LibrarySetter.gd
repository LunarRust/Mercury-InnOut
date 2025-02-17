extends Node2D


# Called when the node enters the scene tree for the first time.
@export var isTrue: bool = true

func _ready():
	PlayerPrefs.set_pref("Library", isTrue)
	pass # Replace with function body.
