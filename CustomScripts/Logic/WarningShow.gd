extends Button
var ScoreFile = ConfigFile.new()
@export var EncryptionKey : String
@export var Warning : ColorRect
@export var ScoreLoader : Node
@export var SoundPlayer : AudioStreamPlayer
var Grow : bool = false

func _pressed():
	var err = ScoreFile.load_encrypted_pass("user://Scores.Mercury",EncryptionKey)
	if ScoreFile.has_section("ScoreFile_Data"):
		SoundPlayer.stream = load("res://Sounds/Pickup.ogg")
		SoundPlayer.play()
		Warning.show()
		Grow = true
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
	Grow = false
	
func _process(delta):
	if Grow && Warning.scale < Vector2(1,1):
		Warning.scale += Vector2(delta * 3,delta * 3)
	elif Grow == false:
		if Warning.scale > Vector2(0.5,0.5):
			Warning.scale -= Vector2(delta,delta)
