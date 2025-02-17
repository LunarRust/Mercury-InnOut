class_name CamShakeGD
extends Node3D
@export var shakeDuration : float = 0.1
@export var shakeAmount : float = 0.2
@export var cam : Camera3D
var shakeStrength : float = 0
var shakeDecay : float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	shakeStrength = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shakeStrength > 0:
		cam.rotation = Vector3(RandomOffset().y,RandomOffset().x,0)
		shakeStrength -= delta * shakeDecay
		
func RandomOffset():
	return Vector2(randf_range(0 - shakeStrength,shakeStrength),randf_range(0 - shakeStrength,shakeStrength))

func Shake(power : float,decay : float = 1):
	Input.start_joy_vibration(0,0.5,0.5,0.25)
	shakeDecay = decay
	shakeStrength = power
	
func shakeNew(delta,power : float = 1,length : float = 1):
	var camera3D = cam
	var rotation : Vector3 = camera3D.rotation
	var num : float = length
	var num2 : float = power
	while(num > 0):
		num -= delta * 1
		num2 -= delta * 1
		var vector : Vector2 = Vector2(randf_range(0 - num2,num2),randf_range(0 - num2,num2))
		camera3D.rotation = rotation + Vector3(vector.y,vector.x,0)
	camera3D.rotation = rotation
