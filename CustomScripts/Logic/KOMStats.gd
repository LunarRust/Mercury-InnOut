extends Node
# Create new ConfigFile object.
var config = ConfigFile.new()
@export var KOMVerLabel : RichTextLabel
@export var InnoutVerLabel : RichTextLabel
@export var KOMVer : String
@export var InnoutVer : String



# Called when the node enters the scene tree for the first time.
func _ready():
	var err = config.load("res://KOMData/system.cfg")
	# Store some values.
	if err != OK:
		config.set_value("Versions", "KOMVer", KOMVer)
		config.set_value("Versions", "InnoutVer", InnoutVer)
		config.set_value("Config_Data", "Exists", true)
	# Save it to a file (overwrite if already exists).
		config.save("res://system.cfg")
		
	for Versions in config.get_sections():
		var KOMVer = config.get_value(Versions, "KOMVer")
		var InnoutVer = config.get_value(Versions, "InnoutVer")
		if KOMVer != null:
			if KOMVerLabel != null:
				KOMVerLabel.text = ("[shake rate=20] [" + KOMVer + "]")
		if InnoutVer != null:
			if InnoutVerLabel != null:
				InnoutVerLabel.text = ("[shake rate=20]In'nOut [" + InnoutVer + "]")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
