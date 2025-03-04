extends Node
@export_category("Radio Loader")
var DebugFile = ConfigFile.new()
var err
@export var SoundPlayer : AudioStreamPlayer3D
var UserStream : AudioStream

func _ready():
	err = DebugFile.load("user://KOM_Debug.cfg")
	if err != OK || !DebugFile.has_section("Interactables_Options"):
		DebugFile.set_value("Interactables_Options","RadioPlaying",true)
		DebugFile.save("user://KOM_Debug.cfg")
	UserStream = load_mp3("user://radio.mp3")
	SoundPlayer.stream = UserStream
	if SoundPlayer.stream != null:
		UserStream.loop = true
		if DebugFile.get_value("Interactables_Options","RadioPlaying") == true:
			SoundPlayer.play()
		else:
			SoundPlayer.stream_paused = true

func load_mp3(path):
	var file = FileAccess.open(path, FileAccess.READ)
	if file != null:
		var sound = AudioStreamMP3.new()
		sound.data = file.get_buffer(file.get_length())
		return sound
	else:
		return null
	
	
func Touch():
	if !SoundPlayer.stream_paused:
		SoundPlayer.stream_paused = true
		DebugFile.set_value("Interactables_Options","RadioPlaying",false)
		DebugFile.save("user://KOM_Debug.cfg")
	elif SoundPlayer.stream_paused:
		SoundPlayer.stream_paused = false
		DebugFile.set_value("Interactables_Options","RadioPlaying",true)
		DebugFile.save("user://KOM_Debug.cfg")
	if !SoundPlayer.playing && !SoundPlayer.stream_paused:
		SoundPlayer.stream = UserStream
		SoundPlayer.play()
		DebugFile.set_value("Interactables_Options","RadioPlaying",true)
		DebugFile.save("user://KOM_Debug.cfg")
