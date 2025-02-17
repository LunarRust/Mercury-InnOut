extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../RichTextLabel".set_text(str(PlayerPrefs.get_pref("Keys", 0)) + " Eggs Collected")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_pressed():
	$"../AudioStreamPlayer".play()
	pass # Replace with function body.

func _up():
	GameProgress.keysCollected += 1
	SavePoint.Save()
	print(GameProgress.keysCollected)
	$"../RichTextLabel".set_text(str(GameProgress.keysCollected) + " Eggs Collected")
	pass
	
	
func _down():
	GameProgress.keysCollected -= 1
	SavePoint.Save()
	print(GameProgress.keysCollected)
	$"../RichTextLabel".set_text(str(GameProgress.keysCollected) + " Eggs Collected")
	pass



