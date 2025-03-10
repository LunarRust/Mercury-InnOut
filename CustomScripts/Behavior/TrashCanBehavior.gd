extends Node
@export var SoundSource : AudioStreamPlayer3D

func Item(item : String):
	SoundSource.pitch_scale = randf_range(0.8,1.2)
	SoundSource.play()
	return true
