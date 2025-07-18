class_name KOMInventoryManager
extends Node3D
@export var inv : Inventory
static var inventoryInstance : Inventory
@export var invCtrl : CtrlInventoryGrid
static var instance
static var itemArray : Dictionary
@export var itemName : RichTextLabel
@export var itemDescription : RichTextLabel
@export var health_handler : Node2D
@export var MouseCasting : Node3D
var camCast : Camera3D


# Called when the node enters the scene tree for the first time.
#@onready var health_handler = $"../../HealthHandler"
@onready var main_camera = get_viewport().get_camera_3d()

func _ready():
	itemName.text = ""
	itemDescription.text = ""
	camCast = get_viewport().get_camera_3d()
	inventoryInstance = inv;
	instance = self;
	CreateInventory()
	pass

func CreateInventory():
	inv.deserialize(itemArray)
	pass

static func StoreTrigger():
	instance.call("StoreInventory")
	pass

func StoreInventory():
	itemArray = inv.serialize()
	print("Trying")
	print(itemArray)
	pass

func OnItemActivate(item):

	if (item.get_property("health", 0) != 0):
		print(item)
		health_handler.changeHealth(item.get_property("health", 0))

	if (item.get_property("usable", false)):
		inv.remove_item(item)
	else:
		print(item)
		var cast = camCast.call("ItemCast", item.get_title());
		if (cast == true):
			inv.remove_item(item)
		else:
			print("Not true!")

	if (item.get_title() == "Basic Key"):
		print("used key")
	pass # Replace with function body.

func UseButton():
	print("Use button Pressed")
	if (invCtrl.get_selected_inventory_item() != null):
		OnItemActivate(invCtrl.get_selected_inventory_item())

func OnItemDrop(item, offset):
	#allows for dropping syringes on the main character's face. This wasn't originally intended, but a ton of players tried to use the syringes that way.
	###Disabled to stop getting in way of griddle, re-implement later.
	#if item.prototype_id == "Syringe1":
		#if ((offset.x > 64) && (offset.x < 180) && (offset.y < 375) && (offset.y > 250)):
			#OnItemActivate(item.get_ref())
	print(item.get_ref())
	print(offset)
	ItemCast(item)

	pass # Replace with function body.

func ItemCast(item):
	var cast = MouseCasting.ItemCast(item.get_ref().get_title());
	if (cast == true):
		inv.remove_item(item.get_ref())
	else:
		print("Not true!")

func OnItemLook(item:Variant):
	itemName.text = str(item.get_title())
	itemDescription.text = str(item.get_property("description", 0))

func OnItemLeave(_item):
	itemName.text = ""
	itemDescription.text = ""


func _on_flash_light_button_2_pressed():
	pass # Replace with function body.
