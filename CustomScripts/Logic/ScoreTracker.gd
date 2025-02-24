extends Node
@export_category("Score Tracker")
var ScoreFile = ConfigFile.new()
@export var ScoreLabel : RichTextLabel
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
	var err = ScoreFile.load("res://KOMData/Score.cfg")
	if err != OK:
		ScoreFile.set_value("Count","Amount",0)
		ScoreFile.set_value("ScoreFile_Data", "Exists", true)
		Count = str(ScoreFile.get_value("Count","Amount"))
	# Store some values.
	if !ScoreFile.has_section("Count"):
		ScoreFile.set_value("Count","Amount",0)
	Count = str(ScoreFile.get_value("Count","Amount") + 1)
	var CountInt = ScoreFile.get_value("Count","Amount")
	if !ScoreFile.has_section("BestScore"):
		ScoreFile.set_value("BestScore","Total",0.0)
	ScoreFile.set_value("Attempt" + Count, "Entry", CountInt)
	ScoreFile.set_value("Attempt" + Count, "Score", InnoutBus.Score)
	ScoreFile.set_value("Attempt" + Count, "Seconds", Clock.date_time.seconds)
	ScoreFile.set_value("Attempt" + Count, "Minutes", Clock.date_time.minutes)
	ScoreFile.set_value("Attempt" + Count, "Hours", Clock.date_time.hours)
	ScoreFile.set_value("Attempt" + Count, "TimeTotal",Clock.formated_time)
	if InnoutBus.Score > ScoreFile.get_value("BestScore","Total"):
		print("New high score!")
		ScoreFile.set_value("BestScore","Total",InnoutBus.Score)
	Count = type_convert(Count,TYPE_INT)
	ScoreFile.set_value("Count","Amount",Count)
	
# Save it to a file (overwrite if already exists).
	ScoreFile.save("res://KOMData/Score.cfg")
