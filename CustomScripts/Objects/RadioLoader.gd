extends Node3D
@export var SoundPlayer : AudioStreamPlayer3D
var UserStream : AudioStream

func _ready():
	UserStream = load("user://radio.ogg")
	SoundPlayer.stream = UserStream
	SoundPlayer.play()
