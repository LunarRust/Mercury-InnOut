extends Node
@export_category("Score Tracker")
var ScoreFile = ConfigFile.new()
@export var ScoreLabel : RichTextLabel
@export var EncryptionKey : String
var InnoutBus
var SignalBusKOM
var Clock
var Count
var Attempt : String

# Called when the node enters the scene tree for the first time.
func _ready():
	Clock = get_tree().get_first_node_in_group("TimeSystem")
	SignalBusKOM = get_tree().get_first_node_in_group("SignalBusKOM")
	SignalBusKOM.Dead.connect(ScoreWrite)
	InnoutBus = get_tree().get_first_node_in_group("InnOutSignalBus")
	InnoutBus.ScoreChanged.connect(ScoreUpdate)
	ScoreUpdate()

func ScoreUpdate():
	ScoreLabel.text = "[shake rate=15][center]" + str(InnoutBus.Score)
	
func ScoreWrite():
	var err = ScoreFile.load_encrypted_pass("user://Scores.Mercury",EncryptionKey)
	if err != OK:
		ScoreFile.set_value("Count","Amount",0)
		ScoreFile.set_value("ScoreFile_Data", "Exists", true)
		Count = str(ScoreFile.get_value("Count","Amount"))
	# Store some values.
	if !ScoreFile.has_section("ScoreFile_Data"):
		ScoreFile.set_value("ScoreFile_Data", "Exists", true)
	if !ScoreFile.has_section("Count"):
		ScoreFile.set_value("Count","Amount",0)
	Count = str(ScoreFile.get_value("Count","Amount") + 1)
	var CountInt = ScoreFile.get_value("Count","Amount") + 1
	if !ScoreFile.has_section("BestScore"):
		ScoreFile.set_value("BestScore", "Entry", CountInt)
		ScoreFile.set_value("BestScore", "Score", InnoutBus.Score)
		ScoreFile.set_value("BestScore", "Seconds", Clock.date_time.seconds)
		ScoreFile.set_value("BestScore", "Minutes", Clock.date_time.minutes)
		ScoreFile.set_value("BestScore", "Hours", Clock.date_time.hours)
		ScoreFile.set_value("BestScore", "TimeTotal",Clock.formated_time)
	ScoreFile.set_value("Attempt" + Count, "Entry", CountInt)
	ScoreFile.set_value("Attempt" + Count, "Score", InnoutBus.Score)
	ScoreFile.set_value("Attempt" + Count, "Seconds", Clock.date_time.seconds)
	ScoreFile.set_value("Attempt" + Count, "Minutes", Clock.date_time.minutes)
	ScoreFile.set_value("Attempt" + Count, "Hours", Clock.date_time.hours)
	ScoreFile.set_value("Attempt" + Count, "TimeTotal",Clock.formated_time)
	
	var time_substring = Clock.formated_time.replace(':','')
	var time = type_convert(time_substring,TYPE_INT)
	var best_time_substring = ScoreFile.get_value("BestScore", "TimeTotal").replace(':','')
	var best_time = type_convert(best_time_substring,TYPE_INT)
	
	if InnoutBus.Score > ScoreFile.get_value("BestScore","Score"):
		print("New high score!")
		ScoreFile.set_value("BestScore", "Entry", CountInt)
		ScoreFile.set_value("BestScore", "Score", InnoutBus.Score)
		ScoreFile.set_value("BestScore", "Seconds", Clock.date_time.seconds)
		ScoreFile.set_value("BestScore", "Minutes", Clock.date_time.minutes)
		ScoreFile.set_value("BestScore", "Hours", Clock.date_time.hours)
		ScoreFile.set_value("BestScore", "TimeTotal",Clock.formated_time)
	elif time < best_time && InnoutBus.Score == ScoreFile.get_value("BestScore","Score"):
		print("New high score!")
		ScoreFile.set_value("BestScore", "Entry", CountInt)
		ScoreFile.set_value("BestScore", "Score", InnoutBus.Score)
		ScoreFile.set_value("BestScore", "Seconds", Clock.date_time.seconds)
		ScoreFile.set_value("BestScore", "Minutes", Clock.date_time.minutes)
		ScoreFile.set_value("BestScore", "Hours", Clock.date_time.hours)
		ScoreFile.set_value("BestScore", "TimeTotal",Clock.formated_time)
	Count = type_convert(Count,TYPE_INT)
	ScoreFile.set_value("Count","Amount",Count)
	
# Save it to a file (overwrite if already exists).
	ScoreFile.save_encrypted_pass("user://Scores.Mercury",EncryptionKey)
