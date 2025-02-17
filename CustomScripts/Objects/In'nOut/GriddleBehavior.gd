extends Node
@export var Spatula : Node3D
@export var GriddleSound : AudioStreamPlayer
var up = false
var ItemOnSpatula : bool = false
var ItemOnSpatulaName : String
var RecivedItem : String
@export var TargetLoc : Node3D
@export var SpriteObject : Sprite3D
@export var AnimatedSpriteObject : AnimatedSprite3D
@export var Sprites : Array[Resource]
@export var AltSprites : Array[Texture2D]
@export var DebugLabels : Node3D
var inv : Inventory
var NpcInv : Inventory
var used : bool = false
var Cooking : bool = false
var CookTime : float
# Called when the node enters the scene tree for the first time.
func _ready():
	CookTime = 0
	ItemOnSpatula = false
	inv = get_tree().get_first_node_in_group("KOMInventoryManager").inv
	if inv == null:
		inv = InventoryManager.inventoryInstance
	animTrigger("Down")
	up = false
	

func create_item(prototype_id: String) -> InventoryItem:
	var item: InventoryItem = InventoryItem.new()
	item.protoset = NpcInv.item_protoset
	item.prototype_id = prototype_id
	return item

func _process(delta):
	if DebugLabels:
		DebugLabels.get_child(0).set_text("Spatula up: " + str(up))
		DebugLabels.get_child(1).set_text("Has Item: " + str(ItemOnSpatula))
		DebugLabels.get_child(2).set_text("Cook Time: " + str(snapped(CookTime,0.01)))
	if Input.is_physical_key_pressed(KEY_SPACE):
		animTrigger("Down")
		if ItemOnSpatula:
			Cooking = true
		up = false
	if !up:
		if ItemOnSpatula:
			Cooking = true
	if Cooking:
		CookTime += delta
		if CookTime >= 15 && ItemOnSpatula:
			if RecivedItem == "RawPatty":
				SpriteObject.texture = AltSprites[3]
		
func Item(item : String):
	if  !ItemOnSpatula:
		match item:
			"RawPatty":
				SpriteObject.texture = Sprites[3]
				print_rich("Showing: [color=red]" + str(SpriteObject.name) + "[/color]")
				ItemOnSpatula = true
				RecivedItem = "RawPatty"
				ItemOnSpatulaName = "RawPatty"
				Spatula.get_parent().show()
				SpriteObject.show()
				return true
			"Raw Patty":
				SpriteObject.texture = Sprites[3]
				print_rich("Showing: [color=red]" + str(SpriteObject.name) + "[/color]")
				ItemOnSpatula = true
				RecivedItem = "RawPatty"
				ItemOnSpatulaName = "Burger"
				Spatula.get_parent().show()
				SpriteObject.show()
				return true
			_:
				if item == "Raw Patty":
					var newItem = inv.create_and_add_item("RawPatty")
				elif item == "Fresh Fries":
					var newItem = inv.create_and_add_item("FFries")
				else:
					var newItem = inv.create_and_add_item(item)
				return false
	else:
		if item == "Raw Patty":
			var newItem = inv.create_and_add_item("RawPatty")
		elif item == "Fresh Fries":
			var newItem = inv.create_and_add_item("FFries")
		else:
			var newItem = inv.create_and_add_item(item)
		return false

func Touch(AmNpc = false):
	if !ItemOnSpatula || up:
		GriddleSound.play()
		if up:
			animTrigger("Down")
			if ItemOnSpatula:
				Cooking = true
			up = false
		
	else:
		if CookTime >= 15:
			if get_tree().get_first_node_in_group("PompNPC") != null:
				NpcInv = get_tree().get_first_node_in_group("PompNPC").get_node("InventoryGrid")
				if AmNpc && NpcInv != null:
					if NpcInv.can_add_item(create_item(ItemOnSpatulaName)):
						var newItem = NpcInv.create_and_add_item(ItemOnSpatulaName)
						if (newItem != null):
							newItem.set_property("CookTime", CookTime)
							if newItem.get_property("name","FFries") && CookTime >= 50:
								newItem.set_property("image","res://KOMSprites/innout/friesBurnt.png")
								newItem.set_property("name",str("burnt " + name))
							SpriteObject.hide()
							Spatula.get_parent().hide()
							ItemOnSpatula = false
							Cooking = false
							CookTime = 0
						else:
							print("Cannot Add Item, not enough Room")
				else :
					if inv.can_add_item(create_item(ItemOnSpatulaName)):
						var newItem = inv.create_and_add_item(ItemOnSpatulaName)
						if (newItem != null):
							newItem.set_property("CookTime", CookTime)
						SpriteObject.hide()
						Spatula.get_parent().hide()
						ItemOnSpatula = false
						Cooking = false
						CookTime = 0
		else:
			animTrigger("Flip")   

func animTrigger(triggername : String):
	Spatula.get_node("AnimationTree")["parameters/conditions/" + triggername] = true;
	await get_tree().create_timer(0.1).timeout
	Spatula.get_node("AnimationTree")["parameters/conditions/" + triggername] = false;
