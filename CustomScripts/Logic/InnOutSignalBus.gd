extends Node
var DebugFile = ConfigFile.new()
var err
@export var Score : float = 0.0
@export var DoTimer : bool = true
@export var OrderWaitLimit : float = 60
signal ScoreChanged
signal OrderGen(ID : int)
signal ReadyToOrder(ID : int)
signal GameOver

func _ready():
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
