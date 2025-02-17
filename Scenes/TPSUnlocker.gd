extends Node2D


@export var checker : bool


func _ready():
	if (!checker):
	#	PlayerPrefs.set_pref("TPSUnlocked", true)
	#else:
	#	if (PlayerPrefs.get_pref("TPSUnlocked", false) == false):
			hide()
			pass
	pass # Replace with function body.
