extends Node
@export var FryBasketAnim : AnimationTree
@export var FryerSound : AudioStreamPlayer3D
@export var progressBar : ProgressBar
@export var GUI : Node3D
var up = false
var ItemInBasket : bool = false
var ItemInBasketName : String
var RecivedItem : String
@export var TargetLoc : Node3D
@export var SpriteObject : Sprite3D
@export var AnimatedSpriteObject : AnimatedSprite3D
@export var Sprites : Array[Resource]
@export var CookedSprites : Array[CompressedTexture2D]
@export var BurnedSprites : Array[CompressedTexture2D]
@export var DebugLabels : Node3D
@export_category("Parameters")
@export var TimeTillBuzzer : float = 0
@export var CookedTime : float = 15
@export var BurnTime : float = 30
var inv : Inventory
var NpcInv : Inventory
var used : bool = false
var Cooking : bool = false
var BellDinged : bool = false
var HasCooked : bool = false
var CookTime : float
var SpriteNum : int
var sb
# Called when the node enters the scene tree for the first time.
func _ready():
	inv = get_tree().get_first_node_in_group("KOMInventoryManager").inv
	if inv == null:
		inv = InventoryManager.inventoryInstance
	animTrigger("Down")
	up = false
	progressBar.max_value = CookedTime
	sb = StyleBoxFlat.new()
	progressBar.add_theme_stylebox_override("fill", sb)
	pass # Replace with function body.
	

func create_item(prototype_id: String) -> InventoryItem:
	var item: InventoryItem = InventoryItem.new()
	item.protoset = NpcInv.item_protoset
	item.prototype_id = prototype_id
	return item

func _process(delta):
	DebugLabels.get_child(0).set_text("Basket up: " + str(up))
	DebugLabels.get_child(1).set_text("Has Item: " + str(ItemInBasket))
	DebugLabels.get_child(2).set_text("Cook Time: " + str(snapped(CookTime,0.01)))
	if Input.is_physical_key_pressed(KEY_SPACE):
		animTrigger("Down")
		if ItemInBasket:
			Cooking = true
		up = false
	if Cooking:
		CookTime += delta
		progressBar.value = CookTime 
		#if CookTime >=  CookedTime * 0.70:
		sb.bg_color = Color.DARK_RED.lerp(Color.DARK_GREEN, CookTime / CookedTime)
		if CookTime >= CookedTime && CookTime <= BurnTime:
			SpriteObject.texture = CookedSprites[SpriteNum]
		elif CookTime >= BurnTime:
			SpriteObject.texture = BurnedSprites[SpriteNum]
		if CookTime >= CookedTime && !HasCooked:
			HasCooked = true
			FryerSound.stop()
		if CookTime >= CookedTime + TimeTillBuzzer && !BellDinged:
			BellDinged = true
			FryerSound.pitch_scale = randf_range(0.8,1.2)
			FryerSound.stream = load("res://KOMSounds/buzzer-short_out.ogg")
			FryerSound.play()
		
func Item(item : String):
	if !ItemInBasket:
		match item:
			"Fresh Fries":
				SpriteObject.texture = Sprites[2]
				SpriteNum = 2
				print_rich("Showing: [color=red]" + str(SpriteObject.name) + "[/color]")
				ItemInBasket = true
				BellDinged = false
				HasCooked = false
				RecivedItem = "FFries"
				ItemInBasketName = "Fries"
				SpriteObject.show()
				if up:
					animTrigger("Down")
				if ItemInBasket:
					Cooking = true
				FryerSound.stream = load("res://Sounds/SizzleLoop.ogg")
				FryerSound.volume_db = -10
				FryerSound.play()
				GUI.show()
				up = false
				return true
			"Fries":
				SpriteObject.texture = Sprites[0]
				SpriteNum = 0
				print_rich("Showing: [color=red]" + str(SpriteObject.name) + "[/color]")
				ItemInBasket = true
				BellDinged = false
				HasCooked = false
				RecivedItem = "Fries"
				ItemInBasketName = "Fries"
				SpriteObject.show()
				if up:
					animTrigger("Down")
				if ItemInBasket:
					Cooking = true
				FryerSound.volume_db = -10
				FryerSound.stream = load("res://Sounds/SizzleLoop.ogg")
				FryerSound.play()
				GUI.show()
				up = false
				return true
			_:
				if item == "Raw Patty":
					var newItem = inv.create_and_add_item("RawPatty")
				elif item == "Fresh Fries":
					var newItem = inv.create_and_add_item("FFries")
				elif item == "Drink Cup":
					var newItem = inv.create_and_add_item("emptycup")
				else:
					var newItem = inv.create_and_add_item(item)
				FryerSound.stream = load("res://Sounds/PhoneFail.ogg")
				FryerSound.play()
				return false
	else:
		if item == "Raw Patty":
			var newItem = inv.create_and_add_item("RawPatty")
		elif item == "Fresh Fries":
			var newItem = inv.create_and_add_item("FFries")
		elif item == "Drink Cup":
			var newItem = inv.create_and_add_item("emptycup")
		else:
			var newItem = inv.create_and_add_item(item)
		FryerSound.stream = load("res://Sounds/PhoneFail.ogg")
		FryerSound.play()
		return false

func Touch(AmNpc = false):
	if !ItemInBasket || up:
		if up:
			animTrigger("Down")
			if ItemInBasket:
				Cooking = true
			up = false
		else:
			animTrigger("Up")
			Cooking = false
			up = true
	else:
		NpcInv = get_tree().get_first_node_in_group("PompNPC").get_node("InventoryGrid")
		if AmNpc && NpcInv != null:
			if CookTime >= BurnTime:
				if NpcInv.can_add_item(create_item(ItemInBasketName)):
					var newItem = NpcInv.create_and_add_item(ItemInBasketName)
					if (newItem != null):
						newItem.set_property("CookTime", CookTime)
						if newItem.get_property("name","FFries") && CookTime >= 50:
							newItem.set_property("image","res://KOMSprites/innout/friesBurnt.png")
							newItem.set_property("name",str("burnt " + name))
						SpriteObject.hide()
						animTrigger("Up")
						up = true
						ItemInBasket = false
						FryerSound.stop()
						HasCooked = false
						Cooking = false
						GUI.hide()
						progressBar.value = 0
						CookTime = 0.0
					else:
						print("Cannot Add Item, not enough Room")
			else:
				if CookTime >= CookedTime:
					if NpcInv.can_add_item(create_item(ItemInBasketName)):
						var newItem = NpcInv.create_and_add_item(ItemInBasketName)
						if (newItem != null):
							newItem.set_property("CookTime", CookTime)
						SpriteObject.hide()
						animTrigger("Up")
						up = true
						ItemInBasket = false
						HasCooked = false
						GUI.hide()
						FryerSound.stop()
						progressBar.value = 0
						Cooking = false
		else :
			if CookTime >= BurnTime:
				if inv.can_add_item(create_item("Burned Fries")):
					var newItem = inv.create_and_add_item("Burned Fries")
					if (newItem != null):
						newItem.set_property("CookTime", CookTime)
					SpriteObject.hide()
					animTrigger("Up")
					up = true
					HasCooked = false
					ItemInBasket = false
					Cooking = false
					FryerSound.stop()
					GUI.hide()
					progressBar.value = 0
					CookTime = 0.0
				else:
					print("Cannot Add Item, not enough Room")
			else:
				if CookTime >= CookedTime:
					if inv.can_add_item(create_item(ItemInBasketName)):
						var newItem = inv.create_and_add_item(ItemInBasketName)
						if (newItem != null):
							newItem.set_property("CookTime", CookTime)
						SpriteObject.hide()
						animTrigger("Up")
						up = true
						ItemInBasket = false
						HasCooked = false
						Cooking = false
						FryerSound.stop()
						GUI.hide()
						progressBar.value = 0
						CookTime = 0.0
				

func animTrigger(triggername : String):
	FryBasketAnim["parameters/conditions/" + triggername] = true;
	await get_tree().create_timer(0.1).timeout
	FryBasketAnim["parameters/conditions/" + triggername] = false;
