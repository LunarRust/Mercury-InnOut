extends Node
var DebugFile = ConfigFile.new()
var err
signal Activate_Pomp_Target
signal Activate_Player_Target
signal Kill_pomp
signal Item_Grab
signal Light_Toggle
signal Light_Off
signal Light_On
signal NavToPoint(id : int,doLook : bool,NavNodeTarget : Node,distance : float,ActionOnArrive : int,LookTargetFromBus : String)
signal ItemSpef(id : int,NavNodeTargetFromSignalBus : Node,Action : int)
signal CreateNpc(ID : int)
signal TargetCreature(id : int,doLook : bool,TargetEntityFromSignalBus : String,distance : float,LookTargetFromBus : String, isHostile : bool)
signal Dead
@export var AllowDebug : bool = false

@export_category("Data Handles")
@export var PompNpcInstances : Array
# ... add any other signals you may want.


func _ready():
	err = DebugFile.load("user://KOM_Debug.cfg")
	if err != OK || !DebugFile.has_section("PlayerOptions"):
		print("Failed to load file!")
		DebugFile.set_value("PlayerOptions","AllowDebug",false)
		DebugFile.save("user://KOM_Debug.cfg")
	
	if DebugFile.get_value("PlayerOptions","AllowDebug") == true:
		AllowDebug = true
	else:
		AllowDebug = false
