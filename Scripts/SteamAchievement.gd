extends Node

@export var achievementName : String
@export var AutoGive : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	if (AutoGive):
		_grant()
	pass # Replace with function body.

func _grant():
	var INIT: Dictionary = Steam.steamInit(false)
	if (INIT.get("status") == 1):
		print("Granting Achievement " + achievementName)
		Steam.setAchievement(achievementName)
		Steam.storeStats()
 
static func _static_grant(ach : String):
	var INIT: Dictionary = Steam.steamInit(false)
	if (INIT.get("status") == 1):
		print("Granting Achievement " + ach)
		Steam.setAchievement(ach)
		Steam.storeStats()

func _on_area_entered(_area):
	_grant()
	pass # Replace with function body.
