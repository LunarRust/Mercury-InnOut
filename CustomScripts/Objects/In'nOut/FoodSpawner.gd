extends Node
var inv : Inventory
var NpcInv : Inventory
@export_category("Assignments")
@export var SoundPlayer : AudioStreamPlayer3D
@export var SoundStream : AudioStream
@export var FoodSprite : Sprite2D
@export_category("Parameters")
@export var FoodSpriteStretchScale : float
@export var ItemID : String
var FoodSpriteBeginingScale : Vector2
var DoNotTarget : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	inv = get_tree().get_first_node_in_group("KOMInventoryManager").inv
	if inv == null:
		inv = InventoryManager.inventoryInstance
	FoodSpriteBeginingScale = FoodSprite.scale


func Touch(AmNpc = false):
	NpcInv = get_tree().get_first_node_in_group("PompNPC").get_node("InventoryGrid")
	if AmNpc && NpcInv != null:
		if NpcInv.can_add_item(create_item(ItemID)):
			var newItem = NpcInv.create_and_add_item(ItemID)
			if (newItem != null):
				SoundPlayer.stream = SoundStream
				SoundPlayer.play()
				ModifySprite()
				return true
		else:
			print("Cannot Add Item, not enough Room")
			SoundPlayer.stream = load("res://Sounds/DNAfail.ogg")
			SoundPlayer.play()
			return false
			
	else:
		var newItem = inv.create_and_add_item(ItemID)
		if (newItem != null):
			SoundPlayer.stream = SoundStream
			SoundPlayer.play()
			ModifySprite()
			return true
		else:
			print("Cannot Add Item, not enough Room")
			SoundPlayer.stream = load("res://Sounds/DNAfail.ogg")
			SoundPlayer.play()
			return false
			
			
func ModifySprite():
	FoodSprite.scale = FoodSprite.scale * FoodSpriteStretchScale
	await get_tree().create_timer(0.1).timeout
	FoodSprite.scale = FoodSpriteBeginingScale
			
			
func create_item(prototype_id: String) -> InventoryItem:
	var item: InventoryItem = InventoryItem.new()
	item.protoset = NpcInv.item_protoset
	item.prototype_id = prototype_id
	return item
