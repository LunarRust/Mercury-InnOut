extends Node


@export var trns1 : Node2D
@export var trns2 : Node2D
@export var trns3 : Node2D
@export var trns4 : Node2D
@export var forb1 : Node2D
@export var forb2 : Node2D
@export var finalbutton : Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	trns1.hide()
	trns2.hide()
	trns3.hide()
	trns4.hide()
	if (forb1 != null):
		forb1.hide()
	if (forb2 != null):
		forb2.hide()
	if (GameProgress.keysCollected > 0):
		var rng = RandomNumberGenerator.new()
		var rand = rng.randi_range(1,6)
		if (rand == 4):
			trns1.show()
		if (rand == 5):
			trns2.show()
		if (rand == 3):
			trns3.show()
		if (rand == 2 && GameProgress.keysCollected > 1):
			trns4.show()
	if (PlayerPrefs.get_pref("WonGame", false) == true && forb1 != null):
		forb1.show()
	if (PlayerPrefs.get_pref("Library", false) == true && forb2 != null):
		forb2.show()
		if (finalbutton != null):
			finalbutton.hide()
	pass # Replace with function body.

