extends Node


var inv : Inventory
var NpcInv : Inventory
var used : bool = false
@export var ItemID : String
# Called when the node enters the scene tree for the first time.
func _ready():
	inv = get_tree().get_first_node_in_group("KOMInventoryManager").inv
	if inv == null:
		inv = InventoryManager.inventoryInstance
	pass # Replace with function body.


func Touch(AmNpc = false):
	NpcInv = find_closest_or_furthest(self.get_parent(),"PompNPC").get_node("InventoryGrid")
	if AmNpc && NpcInv != null:
		if (!used):
			if NpcInv.can_add_item(create_item(ItemID)):
				var newItem = NpcInv.create_and_add_item(ItemID)
				if (newItem != null):
					used = true
					self.get_parent().queue_free()
					return true
			else:
				print("Cannot Add Item, not enough Room")
				return false
			
	elif (!used):
		var newItem = inv.create_and_add_item(ItemID)
		if (newItem != null):
			used = true
			self.get_parent().queue_free()
			return true
		else:
			print("Cannot Add Item, not enough Room")
			return false

func create_item(prototype_id: String) -> InventoryItem:
	var item: InventoryItem = InventoryItem.new()
	item.protoset = NpcInv.item_protoset
	item.prototype_id = prototype_id
	return item
	
	
func find_closest_or_furthest(node: Object,group_name,get_closest:= true) -> Object:
	@warning_ignore("unassigned_variable")
	var PossibleTargets : Array
	for i in get_all_children(get_tree().get_root()):
		if i.is_class("Node3D"):
			if i.is_in_group(group_name):
				PossibleTargets.append(i)
	if !PossibleTargets.is_empty():
		var target_group = PossibleTargets
		var distance_away = node.global_transform.origin.distance_to(target_group[0].global_transform.origin)
		var return_node = target_group[0]
		for index in target_group.size():
			var distance = node.global_transform.origin.distance_to(target_group[index].global_transform.origin)
			if get_closest == true && distance < distance_away:
				distance_away = distance
				return_node = target_group[index]
			elif get_closest == false && distance > distance_away:
				distance_away = distance
				return_node = target_group[index]
		return return_node
	else:
		return null
			
func get_all_children(in_node, array := []):
	array.push_back(in_node)
	for child in in_node.get_children():
		array = get_all_children(child, array)
	return array
