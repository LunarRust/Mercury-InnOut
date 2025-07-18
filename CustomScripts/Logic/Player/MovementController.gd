extends Node3D
@export var soundSource : AudioStreamPlayer3D
var stepSound : AudioStream
var shapeCaster : ShapeCast3D
@export var castBase : ShapeCast3D
@export var areaCast : Area3D
var moveBasis : Node3D
var newPos : Vector3
var newRot : Vector3
var canMove : bool
var canTurn : bool
var UISprite : Sprite2D
var speed : float = 5
static var running : bool
@export var camera : Camera3D
@export var head : Node3D
var camFree : bool
static var camSet : bool
var lookAxis : Vector2
@export var playerAnim : AnimationTree
@export var  playerHealthHandler : Node2D
@export var hudManager : CanvasLayer
var animCurrentSpeed : Vector2
var animTargetSpeed : Vector2
var headTurn : float = 0.02
var headTilt : float = -0.1
var instance = self
var camInstance = Camera3D

func _ready():
	camInstance = camera
	self.position = self.position.snapped(Vector3(0.5,0.5,0.5))
	newPos = self.position
	newRot = self.rotation
	UISprite = self.get_node("%UI")


func _process(delta):
	lookAxis = Vector2(Input.get_joy_axis(0,JOY_AXIS_RIGHT_X),Input.get_joy_axis(0,JOY_AXIS_RIGHT_Y))
	if lookAxis.length() < 0.1:
		lookAxis = Vector2.ZERO
	animCurrentSpeed = animCurrentSpeed.lerp(animTargetSpeed,float(delta) * 10)
	if playerAnim != null:
		playerAnim["parameters/Normal2D/blend_position"] = animCurrentSpeed
	move(float(delta))
	self.position = self.position.lerp(newPos,delta * speed)
	self.rotation = self.rotation.lerp(newRot,delta * 5)
	if self.position.distance_to(newPos) < 0.25 && !canMove:
		if  !Input.is_action_pressed("Up"):
			animTargetSpeed = Vector2(0,0)
		canMove = true
	if self.rotation.distance_to(newRot) < 0.25 && !canTurn:
		animTargetSpeed = Vector2(0,0)
		canTurn = true
	if Input.is_action_pressed("Look") || lookAxis != Vector2.ZERO:
		camFree = true
	if !Input.is_action_pressed("Look") && lookAxis == Vector2.ZERO && camFree:
		camFree = false
		var tween : Tween = create_tween().set_parallel()
		tween.tween_property(camera,"rotation", Vector3.ZERO,0.5).set_trans(Tween.TRANS_QUAD)
		tween.tween_property(head,"rotation", Vector3.ZERO,0.5).set_trans(Tween.TRANS_QUAD)
	if castBase != null:
		castBase.global_position = newPos
		castBase.global_rotation = newRot

func CameraReset():
	camera.make_current()
	camera.get_node("AudioListener3D").make_current()
	hudManager.ShowHUD()


func SetPos():
	pass
	Vector3.AXIS_Y

func _input(event):
	if camFree:
		if event is InputEventMouseMotion:
			head.rotate_y(deg_to_rad(0 - event.relative.x) * 0.25)
			camera.rotate_x(deg_to_rad(0 - event.relative.y) * 0.25)
		elif lookAxis != Vector2.ZERO:
			head.rotation = Vector3(0,0 - lookAxis.x,0)
			camera.rotation = Vector3(0 - lookAxis.y,0,0)

func move(delta : float):
	if Input.is_action_pressed("Run") && playerHealthHandler.mana > 1:
		speed = 6.5
		running = true
	elif running:
		var tween : Tween = create_tween()
		tween.tween_property(camInstance,"rotation",Vector3.ZERO,0.20000000298023224)
		speed = 5
		running = false
	if Input.is_action_pressed("Up") && canMove && canTurn && !playerHealthHandler.dead:
		animTargetSpeed = Vector2(0,1)
		if castBase != null:
			HitTest(1,-castBase.global_basis.z)
		else:
			HitTest(1,-self.transform.basis.z)
		headTilt = -0.1
	if Input.is_action_pressed("Down") && canMove && canTurn && !playerHealthHandler.dead:
		animTargetSpeed = Vector2(0,-1)
		if castBase != null:
			HitTest(1,castBase.global_basis.z,true,2)
		else:
			HitTest(1,self.global_transform.basis.z,true,2)
		headTilt = 0.1
	if Input.is_action_pressed("StrafeLeft") && canMove && canTurn && !playerHealthHandler.dead:
		animTargetSpeed = Vector2(0,1)
		if castBase != null:
			HitTest(1, -castBase.global_basis.x,false)
		else:
			HitTest(1,-self.global_transform.basis.x,false)
	if Input.is_action_pressed("StrafeRight") && canMove && canTurn && !playerHealthHandler.dead:
		animTargetSpeed = Vector2(0,1)
		if castBase != null:
			HitTest(1,castBase.global_basis.x,false)
		else:
			HitTest(1,self.global_transform.basis.x,false)
	if Input.is_action_pressed("Left") && canTurn && !playerHealthHandler.dead:
		animTargetSpeed = Vector2(-1,0)
		Turn(1)
	if Input.is_action_pressed("Right") && canTurn && !playerHealthHandler.dead:
		animTargetSpeed = Vector2(1,0)
		Turn(-1)

func HitTest(amount : float,direction : Vector3,useStamina : bool = true,manaAmount : int = 1):
	var directSpaceState : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var physicsRayQueryParameters3D : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(newPos - self.transform.basis.y * 0.1, newPos + direction * 1.1)
	physicsRayQueryParameters3D.hit_back_faces = false
	var dictionary : Dictionary = directSpaceState.intersect_ray(physicsRayQueryParameters3D)
	if dictionary.size() > 0:
		animTargetSpeed.x = 0
		animCurrentSpeed.y = 0
		return
	directSpaceState = get_world_3d().direct_space_state
	var vector : Vector3 = newPos + direction * amount
	var physicsRayQueryParameters3D2 : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(vector,vector + -self.transform.basis.y * 2)
	var dictionary2 : Dictionary = directSpaceState.intersect_ray(physicsRayQueryParameters3D2)
	if dictionary2.size() > 0:
		soundSource.pitch_scale = randf_range(0.8,1.2)
		soundSource.play()
		canMove = false
		var vector2 : Vector3 = newPos + direction * amount
		newPos = Vector3(vector2.x,(dictionary2["position"] as Vector3).y + 1,vector2.z)
		newPos = newPos.snapped(Vector3(0.5,0.5,0.5))
		if running && useStamina:
			headTurn = 0 - headTurn
			var tween : Tween = create_tween()
			tween.tween_property(camInstance,"rotation",Vector3(headTilt,0,headTurn),0.20000000298023224).set_trans(Tween.TRANS_QUAD)
		var tween2 : Tween = create_tween()
		UISprite.position = Vector2.ZERO
		tween2.tween_property(UISprite,"position",Vector2.DOWN * 10,0.20000000298023224).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween2.tween_property(UISprite,"position",Vector2.ZERO * 10,0.10000000149011612).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	else:
		print("No floor Detected. Will not move.")
		animTargetSpeed = Vector2(0,0)


func Turn(amount : float):
	newRot += Vector3(0,1.5708 * amount,0)
	canTurn = false

func StaticTurn(amount : int):
	instance.newRot += Vector3(0,1.5708 * float(amount),0)
	canTurn = false
