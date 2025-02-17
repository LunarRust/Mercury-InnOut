extends Node

@export
var normalSong : AudioStreamPlayer
@export
var lyricsAnim : AnimationPlayer
@export
var lyricsParent : Node2D
@export
var normalFace : Node2D
@export
var continueChange : RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	if (PlayerPrefs.get_pref("WonGame", false) == true):
		normalSong.stop()
		lyricsParent.show()
		normalFace.hide()
		lyricsAnim.play("Singing")
		continueChange.show()
	pass # Replace with function body.


