extends TextureButton
@export var PlayerInv : Inventory
@export var SoundSource : AudioStreamPlayer
var SoundStream : AudioStream = load("res://KOMSounds/crumple-03-40747.mp3")

func _on_pressed():
	SoundSource.stream = SoundStream
	SoundSource.play()
	PlayerInv.clear()
