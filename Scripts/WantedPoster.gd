extends Sprite3D


func _ready():
	if(GameProgress.keysCollected > 1):
		show()
	else:
		hide()
