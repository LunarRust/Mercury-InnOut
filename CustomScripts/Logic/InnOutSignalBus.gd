extends Node
var DebugFile = ConfigFile.new()
var err
var SignalBusKOM
@export_category("Numbers")
@export var Score : float = 0.0
@export var ServedCustomers : int = 0
@export var DoTimer : bool = true
@export var OrderWaitLimit : float = 60
@export_category("Game Status")
@export var WavesActive : bool = true
signal ScoreChanged
signal OrderGen(ID : int)
signal ReadyToOrder(ID : int)
signal GameOver
signal WaveDeactivate
signal WaveActivate
signal WaveToggle

func _ready():
	
	WaveToggle.connect(LunchRushToggle)
	WaveActivate.connect(LunchRushActivate)
	WaveDeactivate.connect(LunchRushDeactivate)
	err = DebugFile.load("user://KOM_Debug.cfg")
	if err != OK || !DebugFile.has_section("DebugFile_Data"):
		print("Failed to load file!")
		DebugFile.set_value("DebugFile_Data","Exists",true)
		DebugFile.set_value("DebugOptions","ShowInOutDebug",false)
		DebugFile.set_value("InOutOptions","DoTimer",true)
		DebugFile.save("user://KOM_Debug.cfg")
	
	if DebugFile.get_value("InOutOptions","DoTimer") == true:
		DoTimer = true
	else:
		DoTimer = false
		
	await get_tree().create_timer(0.5).timeout
	SignalBusKOM = get_tree().get_first_node_in_group("player").get_node("KOMSignalBus")
	
func _process(delta):
	if Input.is_physical_key_pressed(KEY_F3):
		GameOver.emit()

func LunchRushToggle():
	if WavesActive:
		WavesActive = false
	else:
		WavesActive = true
		
func LunchRushActivate():
	WavesActive = true
	
func LunchRushDeactivate():
	WavesActive = false


func _on_game_over():
	SignalBusKOM.emit_signal("TargetCreature",true,000,"player",1.5,"default",true)
