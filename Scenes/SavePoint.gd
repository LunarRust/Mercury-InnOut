extends Node
class_name SavePoint



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

static func Save():
	#var playerHealth = load("res://Scripts/PlayerHealthHandler.cs")
	#var playerHealthInstance = playerHealth.new()
	PlayerPrefs.set_pref("InventoryDict", InventoryManager.itemArray)
	#PlayerPrefs.set_pref("PlayerHealth", playerHealthInstance.get("health"))
	#PlayerPrefs.set_pref("PlayerMana", playerHealthInstance.get("mana"))
	PlayerPrefs.set_pref("SaveExist", true);
	PlayerPrefs.set_pref("Keys", GameProgress.keysCollected)
	PlayerPrefs.set_pref("MapLayer", GameProgress.MapLayer)
	PlayerPrefs.set_pref("School", GameProgress.SchoolDone)
	PlayerPrefs.set_pref("Sewer", GameProgress.SewerDone)
	PlayerPrefs.set_pref("Hospital", GameProgress.HospitalDone)
	PlayerPrefs.set_pref("DNA", GameProgress.DnaDone)
	PlayerPrefs.set_pref("Building", GameProgress.BuildingDone)
	PlayerPrefs.set_pref("Symbol", GameProgress.SymbolDone)
	PlayerPrefs.set_pref("EmeraldKeys", GameProgress.EmeraldKeys)
	
	
	pass 

static func Load():
	if (PlayerPrefs.get_pref("SaveExist", false) == true):
		var playerHealth = load("res://Scripts/PlayerHealthHandler.cs")
		#var playerHealthInstance = playerHealth.new()
		#playerHealthInstance.setHealth();
		#playerHealth.health = PlayerPrefs.get_pref("PlayerHealth", 9)
		#playerHealth.mana = PlayerPrefs.get_pref("PlayerMana", 9)
		InventoryManager.itemArray = PlayerPrefs.get_pref("InventoryDict", null)
		GameProgress.keysCollected = PlayerPrefs.get_pref("Keys", 0)
		GameProgress.MapLayer = PlayerPrefs.get_pref("MapLayer", 1)
		GameProgress.SchoolDone = PlayerPrefs.get_pref("School", false)
		GameProgress.SewerDone = PlayerPrefs.get_pref("Sewer", false)
		GameProgress.HospitalDone = PlayerPrefs.get_pref("Hospital", false)
		GameProgress.DnaDone = PlayerPrefs.get_pref("DNA", false)
		GameProgress.BuildingDone = PlayerPrefs.get_pref("Building", false)
		GameProgress.SymbolDone = PlayerPrefs.get_pref("Symbol", false)
		GameProgress.EmeraldKeys = PlayerPrefs.get_pref("EmeraldKeys", 0)
	pass
