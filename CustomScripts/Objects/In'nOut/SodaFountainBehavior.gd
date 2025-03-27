extends Node
@export_category("Soda Machine Behavior")
@export var Cup3D : Node3D
@export var SodaStream : Node3D
@export var SodaPlane : MeshInstance3D
@export var GUI : Node3D
@export var PourSoundPlayer : AudioStreamPlayer3D

var progressBar : ProgressBar
var inv : Inventory
var NpcInv : Inventory
var SodaStreamMesh : MeshInstance3D
var SodaStreamMat : StandardMaterial3D

var TimeToFull : float = 7
var isFilling : bool = false
var FillTime : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	SodaStream.hide()
	SodaPlane.hide()
	Cup3D.hide()
	GUI.hide()
	
	SodaStreamMesh = SodaStream.get_node("Cylinder")
	SodaStreamMat = SodaStreamMesh.get_surface_override_material(0)
	progressBar = GUI.get_node("SubViewport/ProgressBar")
	progressBar.max_value = TimeToFull
	inv = get_tree().get_first_node_in_group("KOMInventoryManager").inv
	if inv == null:
		inv = InventoryManager.inventoryInstance


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isFilling:
		WhileFilling(delta)


func Item(item : String):
	if !isFilling:
		match  item:
			"emptycup": StartFilling()
			"Drink Cup": StartFilling()
			_: pass

func Touch(AmNpc : bool = false):
	if get_tree().get_first_node_in_group("PompNPC") != null:
				NpcInv = get_tree().get_first_node_in_group("PompNPC").get_node("InventoryGrid")
	if AmNpc && NpcInv != null:
		if NpcInv.can_add_item(create_item("Drink")):
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
	if !PourSoundPlayer.playing:
		PourSoundPlayer.play()
	progressBar.max_value = TimeToFull
	isFilling = true

func WhileFilling(delta : float):
	SodaStreamMat.uv1_offset.y += delta * 1
	FillTime += delta
	progressBar.value = FillTime
	if FillTime >= TimeToFull:
		isFilling = false
		PourSoundPlayer.stop()
		
	
	
func Reset():
	SodaStream.hide()
	SodaPlane.hide()
	Cup3D.hide()
	GUI.hide()
	PourSoundPlayer.stop()
	FillTime = 0.0



func create_item(prototype_id: String) -> InventoryItem:
	var item: InventoryItem = InventoryItem.new()
	item.protoset = NpcInv.item_protoset
	item.prototype_id = prototype_id
	return item
