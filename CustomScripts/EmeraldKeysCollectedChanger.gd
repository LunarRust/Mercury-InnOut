extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../RichTextLabel".set_text(str(PlayerPrefs.get_pref("EmeraldKeys", 0)) + " Emerald Keys")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_pressed():
	$"../AudioStreamPlayer".play()
	pass # Replace with function body.

func _up():
	GameProgress.EmeraldKeys += 1
	SavePoint.Save()
	print(GameProgress.EmeraldKeys)
	$"../RichTextLabel".set_text(str(GameProgress.EmeraldKeys) + " Emerald Keys")
	pass
	
	
func _down():
	GameProgress.EmeraldKeys -= 1
	SavePoint.Save()
	print(GameProgress.EmeraldKeys)
	$"../RichTextLabel".set_text(str(GameProgress.EmeraldKeys) + " Emerald Keys")
	pass



