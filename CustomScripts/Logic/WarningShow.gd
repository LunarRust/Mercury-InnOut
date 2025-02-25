extends Button
var ScoreFile = ConfigFile.new()
@export var Warning : ColorRect
@export var ScoreLoader : Node
@export var SoundPlayer : AudioStreamPlayer

func _pressed():
	var err = ScoreFile.load("user://Score.cfg")
	if ScoreFile.has_section("ScoreFile_Data"):
		SoundPlayer.stream = load("res://Sounds/Pickup.ogg")
		SoundPlayer.play()
		Warning.show()
	else:
		start()
	pass

func start():
	ScoreLoader.Delete()
	SoundPlayer.stream = load("res://Sounds/Pickup2.ogg")
	SoundPlayer.play()
	Warning.hide()

func Close():
	Warning.hide()
