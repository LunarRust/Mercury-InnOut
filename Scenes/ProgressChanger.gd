extends Button

@export var Setting : String
var Value = (PlayerPrefs.get_pref(Setting, false) == true)
var ValueStr = str(PlayerPrefs.get_pref(Setting, false) == true)
#@export var GameProg : String
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
#
#Creating Toggle functions for each level explicitly because I cannot 
#figure out a more elegent way to do this within the confines of a mod
#
func _on_toggled_school(toggled_on):
	if toggled_on:
		GameProgress.SchoolDone = true
		$".".set_text("Toggle " + Setting + " false")
		Value = (PlayerPrefs.get_pref(Setting, false) == true)
		ValueStr = str(PlayerPrefs.get_pref(Setting, false) == true)
		print(Setting + " " + str(Value))
		SavePoint.Save()
	else:
		GameProgress.SchoolDone = false
		$".".set_text("Toggle " + Setting + " true")
		Value = (PlayerPrefs.get_pref(Setting, false) == true)
		ValueStr = str(PlayerPrefs.get_pref(Setting, false) == true)
		print(Setting + " " + str(Value))
		SavePoint.Save()
	
	pass


func _on_toggled_sewer(toggled_on):
	if toggled_on:
		GameProgress.SewerDone = true
		$".".set_text("Toggle " + Setting + " false")
		Value = (PlayerPrefs.get_pref(Setting, false) == true)
		ValueStr = str(PlayerPrefs.get_pref(Setting, false) == true)
		print(Setting + " " + str(Value))
		SavePoint.Save()
	else:
		GameProgress.SewerDone = false
		$".".set_text("Toggle " + Setting + " true")
		Value = (PlayerPrefs.get_pref(Setting, false) == true)
		ValueStr = str(PlayerPrefs.get_pref(Setting, false) == true)
		print(Setting + " " + str(Value))
		SavePoint.Save()
	
	pass


func _on_toggled_hospital(toggled_on):
	if toggled_on:
		GameProgress.HospitalDone = true
		$".".set_text("Toggle " + Setting + " false")
		Value = (PlayerPrefs.get_pref(Setting, false) == true)
		ValueStr = str(PlayerPrefs.get_pref(Setting, false) == true)
		print(Setting + " " + str(Value))
		SavePoint.Save()
	else:
		GameProgress.HospitalDone = false
		$".".set_text("Toggle " + Setting + " true")
		Value = (PlayerPrefs.get_pref(Setting, false) == true)
		ValueStr = str(PlayerPrefs.get_pref(Setting, false) == true)
		print(Setting + " " + str(Value))
		SavePoint.Save()
	
	pass


func _on_toggled_building(toggled_on):
	if toggled_on:
		GameProgress.BuildingDone = true
		$".".set_text("Toggle " + Setting + " false")
		Value = (PlayerPrefs.get_pref(Setting, false) == true)
		ValueStr = str(PlayerPrefs.get_pref(Setting, false) == true)
		print(Setting + " " + str(Value))
		SavePoint.Save()
	else:
		GameProgress.BuildingDone = false
		$".".set_text("Toggle " + Setting + " true")
		Value = (PlayerPrefs.get_pref(Setting, false) == true)
		ValueStr = str(PlayerPrefs.get_pref(Setting, false) == true)
		print(Setting + " " + str(Value))
		SavePoint.Save()
	
	pass


func _on_toggled_dna(toggled_on):
	if toggled_on:
		GameProgress.DnaDone = true
		$".".set_text("Toggle " + Setting + " false")
		Value = (PlayerPrefs.get_pref(Setting, false) == true)
		ValueStr = str(PlayerPrefs.get_pref(Setting, false) == true)
		print(Setting + " " + str(Value))
		SavePoint.Save()
	else:
		GameProgress.DnaDone = false
		$".".set_text("Toggle " + Setting + " true")
		Value = (PlayerPrefs.get_pref(Setting, false) == true)
		ValueStr = str(PlayerPrefs.get_pref(Setting, false) == true)
		print(Setting + " " + str(Value))
		SavePoint.Save()
	
	pass


func _on_toggled_symbol(toggled_on):
	if toggled_on:
		GameProgress.SymbolDone = true
		$".".set_text("Toggle " + Setting + " false")
		Value = (PlayerPrefs.get_pref(Setting, false) == true)
		ValueStr = str(PlayerPrefs.get_pref(Setting, false) == true)
		print(Setting + " " + str(Value))
		SavePoint.Save()
	else:
		GameProgress.SymbolDone = false
		$".".set_text("Toggle " + Setting + " true")
		Value = (PlayerPrefs.get_pref(Setting, false) == true)
		ValueStr = str(PlayerPrefs.get_pref(Setting, false) == true)
		print(Setting + " " + str(Value))
		SavePoint.Save()
	
	pass
