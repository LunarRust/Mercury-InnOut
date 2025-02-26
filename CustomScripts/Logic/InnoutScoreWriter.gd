extends Node
# Create new ScoreFileFile object.
var ScoreFile = ConfigFile.new()
@export var KOMVerLabel : RichTextLabel
@export var InnoutVerLabel : RichTextLabel
@export var KOMVer : String
@export var InnoutVer : String



# Called when the node enters the scene tree for the first time.
func _ready():
	var err = ScoreFile.load("res://KOMData/Score.cfg")
	# Store some values.
	if err != OK:
		ScoreFile.set_value("Versions", "KOMVer", KOMVer)
		ScoreFile.set_value("Versions", "InnoutVer", InnoutVer)
		ScoreFile.set_value("ScoreFile_Data", "Exists", true)
	# Save it to a file (overwrite if already exists).
		ScoreFile.save("res://KOMData/Score.cfg")
		
	for Versions in ScoreFile.get_sections():
		var KOMVer = ScoreFile.get_value(Versions, "KOMVer")
		var InnoutVer = ScoreFile.get_value(Versions, "InnoutVer")
		if KOMVer != null:
			if KOMVerLabel != null:
				KOMVerLabel.text = ("[shake rate=20] [" + KOMVer + "]")
		if InnoutVer != null:
			if InnoutVerLabel != null:
				InnoutVerLabel.text = ("[shake rate=20]In'nOut [" + InnoutVer + "]")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
