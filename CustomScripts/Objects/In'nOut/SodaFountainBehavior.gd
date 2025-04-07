extends Node
@export_category("Soda Machine Behavior")
@export var Cup3D : Node3D
@export var SodaStream : Node3D
@export var SodaPlane : MeshInstance3D
@export var GUI : Node3D
@export var PourSoundPlayer : AudioStreamPlayer3D
@export var SoundArray : Array[AudioStream]
@export_category("Parameters")
@export var TimeToFull : float = 7

var progressBar : ProgressBar
var inv : Inventory
var NpcInv : Inventory
var SodaStreamMesh : ArrayMesh
var SodaStreamMat : StandardMaterial3D
var sb


var isFilling : bool = false
var HasCup : bool = false
var FillTime : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	SodaStream.hide()
	SodaPlane.hide()
	Cup3D.hide()
	GUI.hide()
	
	SodaStreamMesh = SodaStream.get_node("Cylinder").get_mesh()
	SodaStreamMat = SodaStreamMesh.surface_get_material(0)
	progressBar = GUI.get_node("SubViewport/ProgressBar")
	progressBar.max_value = TimeToFull
	inv = get_tree().get_first_node_in_group("KOMInventoryManager").inv
	if inv == null:
		inv = InventoryManager.inventoryInstance
	sb = StyleBoxFlat.new()
	progressBar.add_theme_stylebox_override("fill", sb)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isFilling:
		WhileFilling(delta)


func Item(item : String):
	if !isFilling && !HasCup:
		match  item:
			"emptycup": 
				StartFilling()
				return true
			"Drink Cup": 
				StartFilling()
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
		return false
	

func Touch(AmNpc : bool = false):
	if HasCup && !isFilling:
		if get_tree().get_first_node_in_group("PompNPC") != null:
					NpcInv = get_tree().get_first_node_in_group("PompNPC").get_node("InventoryGrid")
		if AmNpc && NpcInv != null:
			if NpcInv.can_add_item(create_item("drink")):
				var newItem = NpcInv.create_and_add_item("drink")
				Reset()
				
		else :
			if inv.can_add_item(create_item("drink")):
				var newItem = inv.create_and_add_item("drink")
				Reset()


func StartFilling():
	if !Cup3D.visible:
		Cup3D.show()
	if !GUI.visible:
		GUI.show()
	if !SodaStream.visible:
		SodaStream.show()
	PourSoundPlayer.stream = SoundArray[1]
	if !PourSoundPlayer.playing:
		PourSoundPlayer.play()
	progressBar.max_value = TimeToFull
	HasCup = true
	isFilling = true

func WhileFilling(delta : float):
	SodaStreamMat.uv1_offset.y += delta * 1
	sb.bg_color = Color.DARK_RED.lerp(Color.DARK_GREEN, FillTime / TimeToFull)
	FillTime += delta
	progressBar.value = FillTime
	if FillTime >= TimeToFull:
		isFilling = false
		PourSoundPlayer.stop()
		SodaPlane.show()
		SodaStream.hide()
		
	
	
func Reset():
	SodaStream.hide()
	SodaPlane.hide()
	Cup3D.hide()
	GUI.hide()
	PourSoundPlayer.stream = SoundArray[0]
	PourSoundPlayer.play()
	FillTime = 0.0
	HasCup = false



func create_item(prototype_id: String) -> InventoryItem:
	var item: InventoryItem = InventoryItem.new()
	item.protoset = NpcInv.item_protoset
	item.prototype_id = prototype_id
	return item
