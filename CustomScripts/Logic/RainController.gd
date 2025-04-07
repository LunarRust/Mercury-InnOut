extends Node3D
var DebugFile = ConfigFile.new()
var err
@export_category("Assignments")
@export var WorldEnv : WorldEnvironment
@export var RainSounds : Array[AudioStreamPlayer3D]
@export var ThunderPlayer : AudioStreamPlayer3D
@export var ThunderSounds : Array[AudioStream]
@export var RainParticles : Array[GPUParticles3D]
@export var OtherNodes : Array[Node3D]
@export var ThunderFlashesParent : Node3D
@export_category("Variables")
@export var RainSystemActive : bool = true
@export var ActiveChance : int
@export var MinimumThunderDelay : float

var ThunderClock : float = 0.0
var RandNum : RandomNumberGenerator
var num : int

func _ready():
	RandNum = RandomNumberGenerator.new()
	err = DebugFile.load("user://KOM_Debug.cfg")
	if err != OK || !DebugFile.has_section_key("InOutOptions","ForceRain"):
		DebugFile.set_value("InOutOptions","ForceRain",false)
		DebugFile.save("user://KOM_Debug.cfg")
	if DebugFile.get_value("InOutOptions","ForceRain") == false:
		num = RandNum.randi_range(0,ActiveChance)
		if num == 1:
			RainSystemActive = true
		else:
			RainSystemActive = false
		ActiveCheck()
	else:
		RainSystemActive = true
		ActiveCheck()

func _process(delta):
	if RainSystemActive:
		ThunderClock += delta
		if ThunderClock >= num:
			ThunderClock = 0.0
			num = RandNum.randi_range(0,20) + MinimumThunderDelay
			ThunderPlayer.stream = ThunderSounds.pick_random()
			ThunderPlayer.play()
			await get_tree().create_timer(0.2).timeout
			ThunderFlashesParent.visible = true
		if ThunderClock > 1:
			ThunderFlashesParent.visible = false

func ActiveCheck():
	num = RandNum.randi_range(0,20) + MinimumThunderDelay
	if RainSystemActive:
		WorldEnv.environment.fog_enabled = true
		for i in RainSounds:
			i.play()
		for i in RainParticles:
			i.emitting = true
		for i in OtherNodes:
			i.show()
	else:
		WorldEnv.environment.fog_enabled = false
		for i in RainSounds:
			i.stop()
		for i in RainParticles:
			i.emitting = false
		for i in OtherNodes:
			i.hide()
