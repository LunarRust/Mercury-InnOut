extends Node
@export var SoundSource : AudioStreamPlayer3D
@export var Sound : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Touch():
	SoundSource.stream = Sound
	SoundSource.pitch_scale = randf_range(0.8,1.2)
	SoundSource.play()
