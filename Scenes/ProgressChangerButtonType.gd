extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	if (PlayerPrefs.get_pref("WonGame", false) == true):
		#CheckBox.button_pressed = true
		pass
	else:
		#CheckBox.button_pressed = false
		pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	GameProgress._reset()
	PlayerPrefs.set_pref("Library", false);
	PlayerPrefs.set_pref("WonGame", false)
	$"../ProgressClearButton/AudioStreamPlayer".play()
	pass # Replace with function body.
