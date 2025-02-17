extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func item(cool : String):
	if (cool == "Empty Syringe"):
		print("So Cool!")
		return false
	else:
		print("Not Cool Bro!")
