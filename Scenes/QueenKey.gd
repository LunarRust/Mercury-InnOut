extends Node


var inv : Inventory
signal taken


# Called when the node enters the scene tree for the first time.
func _ready():
	inv = InventoryManager.inventoryInstance
	pass # Replace with function body.


func Touch():
	emit_signal("taken")
	inv.create_and_add_item("QueenKey")
	self.get_parent().queue_free()
	pass
