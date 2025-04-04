extends Node
@export_category("Assignments")
@export var inv : Inventory
static var inventoryInstance : Inventory
@export var invCtrl : CtrlInventoryGrid

@export var Labels : Node2D
static var instance
static var itemArray : Dictionary
var camCast : Camera3D
@export_category("Inventory Parameters")
const DEFAULT_SIZE: Vector2i = Vector2i(10, 10)
@export var GenID : int
@export_category("Item Info")
@export var Protoset : ItemProtoset
@export var ItemCounts : Dictionary
var InvItemsList : Dictionary
var RelevantItems : Dictionary
#####EXTERNAL VARS#####
var InvSize : Vector2i
var InvFreeSpace
var RandList : Array
var ReadyToServe : bool = false
signal ReadyToServeSignal
signal NotReadyToServe
var ItemsInInv : Array
var ItemsInInvDictionary : Dictionary

#####
#TODO Script Makes game stutter every time Inventory is generated. Can this be improved?
#####

func _ready():
	get_tree().get_first_node_in_group("InnOutSignalBus").OrderGen.connect(Generate)
	get_tree().get_first_node_in_group("InnOutSignalBus").ReadyToOrder.connect(ReadyForOrder)
	InvSize = inv._constraint_manager.get_grid_constraint().size
	InvFreeSpace = InvSize.x * InvSize.y
	InvItemsList = Protoset._prototypes
	
func ReadyForOrder(ID):
	if ID == GenID:
		ReadyToServe = true
		ReadyToServeSignal.emit()
	
	
func Clear():
	inv.clear()
	ItemsInInv.clear()
	ItemsInInvDictionary.clear()
	ReadyToServe = false
	NotReadyToServe.emit()
	
func Generate(ID):
	if ID == GenID:
		ReadyForOrder(GenID)
		inv.clear()
		ItemListGen()
		ItemsInInvDictionary.keys().shuffle()
		RelevantItems.keys().shuffle()
		var items
		while items == 0:
			for i in RelevantItems.values():
				items += i
			if items == 0:
				ItemListGen()
		
		#var keys = RelevantItems.keys()
		## shuffle the keys
		#keys.shuffle()
		## index the dictionary with shuffled keys
		#while not keys.is_empty():
			#print(RelevantItems[keys.pop_back()])
		for i in RelevantItems:
			var count = 1
			var InvFull = false
			while count <= RelevantItems[i] && InvFull == false:
				count += 1
				if inv.can_add_item(create_item(i)):
					var Item = create_item(i)
					print("adding: " + str(i))
					inv.add_item(Item)
					if ItemsInInvDictionary.has(Item.prototype_id):
						ItemsInInvDictionary[Item.prototype_id] += 1
					else:
						ItemsInInvDictionary[Item.prototype_id] = 1
				else:
					InvFull = true
					
		for i in ItemCounts:
			ItemCounts[i] = 0
			print(str(ItemCounts))
		ItemsInInv = inv.get_items()
		print(str(ItemsInInv))
		print(str(RelevantItems))
		for i in ItemsInInv:
			#var id = str(ItemsInInv[i].prototype_id)
			if  RelevantItems[i.prototype_id]:
				print(str(i.prototype_id) + " " + str(RelevantItems[i.prototype_id]))
				ItemCounts[i.prototype_id] += 1
func ItemListGen():
	#print_rich("InvItemsList:[color=red] " + str(InvItemsList) + "[/color]")
	RandList = generate_sum_array(InvFreeSpace,1,3)
	var iterant = -1
	for i in ItemCounts:
		iterant += 1
		ItemCounts[i] = randi_range(0,3)
	ItemCounts.keys().shuffle()
	#print_rich("InvCounts:[color=red] " + str(ItemCounts) + "[/color]")
	InvItemsList.keys().shuffle()
	for i in InvItemsList:
		for ii in ItemCounts.size():
			if i == ItemCounts.keys()[ii]:
				print(str(i) + " matches " + str(ItemCounts.keys()[ii]))
				RelevantItems[i] = ItemCounts.values()[ii]
	RelevantItems.keys().sort()
			
	
	Labels.get_child(2).set_text("Items:[color=red] " + str(RelevantItems) + "[/color]")
	#print_rich("Items:[color=red] " + str(RelevantItems) + "[/color]")
	pass

func generate_sum_array(maxSum, factor, maxNumber):
	var sum = 0
	var generationRange = int(maxNumber/factor)          #this one for non 0 values
	var array = []
	var cont = true
	while cont:
		var n = randi() % generationRange + 1
		n *= factor
		sum += n
		if sum > maxSum:
			n -= sum - maxSum
			cont = false
		if n != 0:                           
			array.append(n)

	return array

func create_item(prototype_id: String) -> InventoryItem:
	var item: InventoryItem = InventoryItem.new()
	item.protoset = inv.item_protoset
	item.prototype_id = prototype_id
	return item
