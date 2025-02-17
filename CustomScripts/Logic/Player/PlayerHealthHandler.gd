class_name PlayerHealthHandler
extends Node
var health : int = 9
var mana : int = 16
var dead : bool = false
@export var manaTimer : Timer
@export var playerAnim : AnimationTree
@export var playerBody : MeshInstance3D
@export var playerObject : MeshInstance3D
@export var CameraShaker : Node3D
@export var skin1 : BaseMaterial3D
@export var skin2 : BaseMaterial3D
@export var skin3 : BaseMaterial3D
var instance : PlayerHealthHandler
@export var InvButton : TextureButton
@export var healthBar : Sprite2D
@export var manaBar : Sprite2D
@export var lowHealthOverlay : Sprite2D
@export var faceSprite : Sprite2D
@export var label : Label
@export var manaLabel : Label
@export var deathAnim : AnimationPlayer
@export var soundSource : AudioStreamPlayer

var Fader = load("res://addons/UniversalFade/Fade.gd")
var MoverTestC = load("res://Scripts/MoverTest.cs") as Script
var MoverTest = MoverTestC.new()
#var CameraShaker = preload("res://Scripts/CameraShake.cs") as Script
#var camshake = CameraShaker.new()
var HudManage = load("res://prefabs/hudmanager.cs")
var CamCastC = load("res://Scripts/CameraCast.cs")
var CamCast = CamCastC.new()
var usedHeal : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	usedHeal = false
	InvButton.open = false
	instance = self
	health = 9
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if InvButton.open:
		label.text = str(health)
		manaLabel.text = str(mana)
	manaBar.frame = (9 - mana / 2)
	mana = clamp(mana,1,16)
	
func AddMana():
	if !Input.is_action_pressed("Run") && mana < 16:
		mana += 1
	manaTimer.start(0.3499999940395355)
	
func changeHealth(amount : int):
	if dead:
		return
	var num : int = health
	if amount < 0:
		if playerAnim != null:
			AnimTrigger("Hurt")
		CameraShaker.Shake(0.1)
		soundSource.stream = load("res://Sounds/Hurt1.ogg")
		soundSource.play()
	elif amount > 0:
		soundSource.stream = load("res://Sounds/Pickup.ogg")
		soundSource.play()
		usedHeal = true
	health += amount
	health = clampf(health,0,9)
	healthBar.frame = 9 - health
	healthCheck()
	FaceCheck()
	
func FaceCheck():
	if playerAnim != null:
		playerAnim["parameters/Normal2D/4/blend_position"] = health
	if health > 6:
		if playerBody != null:
			playerBody.material_override = skin1
		faceSprite.frame = 0
	elif health > 5:
		if playerBody != null:
			playerBody.material_override = skin2
		faceSprite.frame = 1
	elif health > 3:
		faceSprite.frame = 2
	else:
		if playerBody != null:
			playerBody.material_override = skin3
		faceSprite.frame = 3
		
func staticHealth():
	instance.changeHealth(-1)
			
func notsostatichealth(amount : int):
	instance.changeHealth(amount * -1)
	
func setHealth():
	health = 9
	
func healthCheck():
	if health < 1 || (mana < 1 && !dead):
		Death()
		dead = true
	if health == 1:
		var tween : Tween = create_tween()
		tween.tween_property(lowHealthOverlay,"modulate",Color(1,1,1,0.75),2)
	else:
		var tween2 : Tween = create_tween()
		tween2.tween_property(lowHealthOverlay,"modulate",Color(1,1,1,0),2)

func Death():
	if playerAnim != null:
		AnimTrigger("Death")
	deathAnim.play("Death")
	dead = true
	HudManage.HideHUD()
	get_viewport().get_camera_3d().position -= Vector3.UP
	CamCast.rotation = Vector3(0,0,1.5)
	await get_tree().create_timer(4.199999809265137).timeout
	Fade.crossfade_prepare(3,"WeirdWipe",false,false)
	get_tree().change_scene_to_packed(load("res://Scenes/GameOver.tscn") as PackedScene)
	Fade.crossfade_execute()
	dead = false
	print("You died, womp womp!")
	
			
func AnimTrigger(triggername : String):
	playerAnim["parameters/conditions/" + triggername] = true;
	await get_tree().create_timer(0.1).timeout
	playerAnim["parameters/conditions/" + triggername] = false;
