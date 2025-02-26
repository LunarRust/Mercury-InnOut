extends Button
@export var SoundPlayer : AudioStreamPlayer
@export var Sound : AudioStream

func _ready():
	self.pressed.connect(_on_pressed)

func _on_pressed():
	SoundPlayer.stream = Sound
	SoundPlayer.play()
