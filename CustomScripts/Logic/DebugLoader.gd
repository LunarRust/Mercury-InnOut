extends Node
@export_category("Debug Loader")
var DebugFile = ConfigFile.new()
@export var ItemsToShow : Array[Node]
@export var TimerButton : CheckButton
var DisableTimer : bool
var err


func _ready():
	err = DebugFile.load("user://KOM_Debug.cfg")
	if err != OK || !DebugFile.has_section("DebugFile_Data"):
		print("Failed to load file!")
		DebugFile.set_value("DebugFile_Data","Exists",true)
		DebugFile.set_value("DebugOptions","ShowInOutDebug",false)
		DebugFile.set_value("InOutOptions","DoTimer",true)
		DebugFile.save("user://KOM_Debug.cfg")
	if DebugFile.get_value("DebugOptions","ShowInOutDebug") == true:
		if !ItemsToShow.is_empty():
			for i in ItemsToShow:
				if i != null:
					i.show()
		TimerButton.button_pressed = true
		if DebugFile.get_value("InOutOptions","DoTimer") == true:
			DisableTimer = false
			TimerButton.button_pressed = false
		else:
			DisableTimer = true
			TimerButton.button_pressed = true


func _on_timer_disable_pressed():
	if DisableTimer == true:
		DisableTimer = false
		TimerButton.button_pressed = false
		DebugFile.set_value("InOutOptions","DoTimer",true)
		DebugFile.save("user://KOM_Debug.cfg")
	else:
		DisableTimer = true
		TimerButton.button_pressed = true
		DebugFile.set_value("InOutOptions","DoTimer",false)
		DebugFile.save("user://KOM_Debug.cfg")
