extends Node
var DebugFile = ConfigFile.new()
var err
@export_category("NPC Rules")
@export var FlashLightsEnabled : bool = true
@export var InventoryVisible : bool = false
@export var AllowPlayerControl : bool = true


func _ready():
	err = DebugFile.load("user://KOM_Debug.cfg")
	if err != OK || !DebugFile.has_section("NPCOptions"):
		print("Failed to load file!")
		DebugFile.set_value("NPCOptions","AllowPlayerControl",false)
		DebugFile.set_value("NPCOptions","InventoryVisible",true)
		DebugFile.set_value("NPCOptions","FlashLightsEnabled",false)
		DebugFile.save("user://KOM_Debug.cfg")

	if DebugFile.get_value("NPCOptions","AllowPlayerControl") == true:
		AllowPlayerControl = true
	else:
		AllowPlayerControl = false
	if DebugFile.get_value("NPCOptions","InventoryVisible") == true:
		InventoryVisible = true
	else:
		InventoryVisible = false
	if DebugFile.get_value("NPCOptions","FlashLightsEnabled") == true:
		FlashLightsEnabled = true
	else:
		FlashLightsEnabled = false
