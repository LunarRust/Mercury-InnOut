extends Node
@export_category("Score Loader")
var ScoreFile = ConfigFile.new()
@export var listContainer : VBoxContainer
@export var ScoreEntryPrefabRoot : PackedScene
var InnoutBus
var SignalBusKOM
var Clock
var Total = "0"
var TotalInt = 0
var Attempt : int = 1
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var err = ScoreFile.load("res://KOMData/Score.cfg")
	if err != OK:
		print("Failed to load file!")
	Total = str(ScoreFile.get_value("Count","Amount"))
	TotalInt = ScoreFile.get_value("Count","Amount")
	Attempt = ScoreFile.get_value("Attempt" + str(Attempt), "Entry")
	active = true
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		if TotalInt > Attempt:
			loadScore()
			Attempt += 1
	
func loadScore():
	ScoreFile.get_value("Attempt" + str(Attempt), "Entry")
	var Score = ScoreFile.get_value("Attempt" + str(Attempt), "Score")
	var seconds = ScoreFile.get_value("Attempt" + str(Attempt), "Seconds")
	var minutes = ScoreFile.get_value("Attempt" + str(Attempt), "Minutes")
	var hours = ScoreFile.get_value("Attempt" + str(Attempt), "Hours")
	var formated_time = ScoreFile.get_value("Attempt" + str(Attempt), "TimeTotal")
	var node = ScoreEntryPrefabRoot.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	var ScoreEntry = node.get_child(0)
	var TotalServed = node.get_child(1)
	var TimeTaken = node.get_child(2)
	ScoreEntry.text = "Score #" + str(Attempt)
	TotalServed.text = "Items served: " + str(Score)
	TimeTaken.text = "Time: " + formated_time
	listContainer.add_child(node)
