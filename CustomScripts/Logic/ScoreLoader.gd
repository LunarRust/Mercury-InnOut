extends Node
@export_category("Score Loader")
var ScoreFile = ConfigFile.new()
@export var listContainer : VBoxContainer
@export var ScoresParent : Node2D
@export var ScoreEntryPrefabRoot : PackedScene
@export var NoScoresLabel : RichTextLabel
@export var BestScoreContainer : ColorRect
@export_category("Encryption")
@export var EncryptionKey : String
@export var KeyInput : LineEdit
@export var TextObject : RichTextLabel
var InnoutBus
var SignalBusKOM
var Clock
var Total = "0"
var TotalInt = 0
var Attempt : int = 0
@export var AttemptString : String
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var err = ScoreFile.load_encrypted_pass("user://Scores.Mercury",EncryptionKey)
	if err != OK || !ScoreFile.has_section("ScoreFile_Data"):
		print("Failed to load file!")
		NoScoresLabel.show()
		ScoresParent.hide()
		BestScoreContainer.get_parent().hide()
	else:
		Total = str(ScoreFile.get_value("Count","Amount"))
		TotalInt = ScoreFile.get_value("Count","Amount")
		Attempt = TotalInt
		AttemptString = str(ScoreFile.get_value("Attempt" + str(Attempt), "Entry"))
		if ScoreFile.has_section_key("BestScore","Entry"):
			loadBest()
			BestScoreContainer.get_parent().show()
		else:
			BestScoreContainer.get_parent().hide()
		active = true
		
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active:
		if Attempt >= 1:
			loadScore()
			
	
func loadBest():
	var entry = ScoreFile.get_value("BestScore", "Entry")
	var Score = ScoreFile.get_value("BestScore", "Score")
	var seconds = ScoreFile.get_value("BestScore", "Seconds")
	var minutes = ScoreFile.get_value("BestScore", "Minutes")
	var hours = ScoreFile.get_value("BestScore", "Hours")
	var Ver = ScoreFile.get_value("BestScore", "Ver")
	var formated_time = ScoreFile.get_value("BestScore", "TimeTotal")
	var node = BestScoreContainer
	var ScoreEntry = node.get_child(0)
	var TotalServed = node.get_child(1)
	var TimeTaken = node.get_child(2)
	var VerText = node.get_child(3)
	ScoreEntry.text = "Entry #" + str(entry)
	TotalServed.text = "Items served: " + str(Score)
	TimeTaken.text = "Time: " + formated_time
	if Ver != null || Ver == "":
		VerText.text = "[" + Ver + "]"
	else:
		VerText.text = "NULL"
	
func loadScore():
	
	ScoreFile.get_value("Attempt" + str(AttemptString), "Entry")
	var Score = ScoreFile.get_value("Attempt" + str(Attempt), "Score")
	var seconds = ScoreFile.get_value("Attempt" + str(Attempt), "Seconds")
	var minutes = ScoreFile.get_value("Attempt" + str(Attempt), "Minutes")
	var hours = ScoreFile.get_value("Attempt" + str(Attempt), "Hours")
	var formated_time = ScoreFile.get_value("Attempt" + str(Attempt), "TimeTotal")
	var Ver = ScoreFile.get_value("Attempt" + str(Attempt), "Ver")
	var node = ScoreEntryPrefabRoot.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
	var ScoreEntry = node.get_child(0)
	var TotalServed = node.get_child(1)
	var TimeTaken = node.get_child(2)
	var VerText = node.get_child(3)
	ScoreEntry.text = "Entry #" + str(Attempt)
	TotalServed.text = "Items served: " + str(Score)
	TimeTaken.text = "Time: " + formated_time
	if Ver != null || Ver == "":
		VerText.text = "[" + Ver + "]"
	else:
		VerText.text = "NULL"
	listContainer.add_child(node)
	Attempt -= 1
	
func Delete():
	ScoreFile.clear()
	ScoreFile.save_encrypted_pass("user://Scores.Mercury",EncryptionKey)
	NoScoresLabel.show()
	ScoresParent.hide()
	BestScoreContainer.get_parent().hide()
	
	
func ScoreDecoder():
		var Inputkey = KeyInput.text
		var err = ScoreFile.load_encrypted_pass("user://Scores.Mercury",Inputkey)
		if err != OK || !ScoreFile.has_section("ScoreFile_Data"):
			print("Failed to load file!")
			TextObject.text = "[center][wave]\nIncorrect Key!"
			TextObject.show()
		else:
			ScoreFile.save("user://Scores.ini")
			TextObject.text = "[center][wave]\nScore file decoded!"
			TextObject.show()
	
func ScoreEncoder():
	var Inputkey = KeyInput.text
	var err = ScoreFile.load("user://Scores.ini")
	if err != OK || !ScoreFile.has_section("ScoreFile_Data"):
		print("Failed to load file!")
		TextObject.text = "[center][wave]\nIncorrect Key!"
		TextObject.show()
	else:
		TextObject.text = "[center][wave]\nScore file (re)encoded!"
		TextObject.show()
		ScoreFile.save_encrypted_pass("user://Scores.Mercury",EncryptionKey)
