extends Node
@export_category("Score Tracker")
@export var ScoreLabel : RichTextLabel
var InnoutBus

# Called when the node enters the scene tree for the first time.
func _ready():
	InnoutBus = get_tree().get_first_node_in_group("InnOutSignalBus")
	InnoutBus.ScoreChanged.connect(ScoreUpdate)
	ScoreUpdate()

func ScoreUpdate():
	ScoreLabel.text = "[shake rate=15][center]" + str(InnoutBus.Score)
