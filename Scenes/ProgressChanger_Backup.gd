extends Button


@export var Setting : String
var Value = (PlayerPrefs.get_pref(Setting, false) == true)
var ValueStr = str(PlayerPrefs.get_pref(Setting, false) == true)
@export var GameProg = GameProgress.SchoolDone
# Called when the node enters the scene tree for the first time.
func _ready():
	Value = (PlayerPrefs.get_pref(Setting, false) == true)
	ValueStr = str(PlayerPrefs.get_pref(Setting, false) == true)
	if Value == true:
		$".".button_pressed = true
	elif Value == false:
		$".".button_pressed = false
	$".".set_text("Toggle " + Setting + " " + str(!Value))
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	$"."/AudioStreamPlayer.play()
	pass # Replace with function body.


func _on_toggled(toggled_on):
	if toggled_on:
		PlayerPrefs.set_pref(Setting, true);
		$".".set_text("Toggle " + Setting + " false")
		Value = (PlayerPrefs.get_pref(Setting, false) == true)
		ValueStr = str(PlayerPrefs.get_pref(Setting, false) == true)
		print(Setting + " " + str(Value))
		SavePoint.Save()
	else:
		PlayerPrefs.set_pref(Setting, false)
		$".".set_text("Toggle " + Setting + " true")
		Value = (PlayerPrefs.get_pref(Setting, false) == true)
		ValueStr = str(PlayerPrefs.get_pref(Setting, false) == true)
		print(Setting + " " + str(Value))
		SavePoint.Save()
	
	pass
