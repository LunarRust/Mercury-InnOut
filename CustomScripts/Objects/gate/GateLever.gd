extends Node
@export var gate : StaticBody3D
@export var LeverAnim : AnimationPlayer
@export var GateAnim : AnimationPlayer
@export var SoundSource : AudioStreamPlayer
@export var delay : float
var used : bool = false
var playerObject : Node3D

	
func Touch():
	print("Lever Touched!")
	if(!used):
		_OpenGate()
	pass
	
func _OpenGate():
	print("Lever flipped!")
	used = true
	SoundSource.play()
	LeverAnim.play("TurnOn")
	GateAnim.play("Open")
	await get_tree().create_timer(delay).timeout
	gate.queue_free()
	
	pass
