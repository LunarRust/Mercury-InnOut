extends Node
@export var Scene : PackedScene
@export var TargetLoc : Node3D
@export var SoundSource : AudioStreamPlayer
@export var distance : float
@export var OrderGen : Node
@export var RegisterCon : TextureButton
@export var NavNodeTarget : Node
var ScenePack
var currentID
var currentMark
var currentNPC
var SignalBusKOM
var inv
var node
@export_category("Parameters")
@export var ObjectScale : Vector3 = Vector3(1,1,1)
@export var NPCNavEnabled = true

signal ItemTaken
var emited : bool = false
var HasItem : bool = false


func _ready():
	SignalBusKOM = get_tree().get_first_node_in_group("player").get_node("KOMSignalBus")
	inv = get_tree().get_first_node_in_group("PlayerInv")

func Item(item : String):
	if NPCNavEnabled:
		if HasItem == false && OrderGen.ReadyToServe == true:
			match item:
				"Fries":
					SetItem("res://KOMPrefabs/Items/Fries_pickup.tscn")
				"Burger":
					SetItem("res://KOMPrefabs/Items/Burger_pickup.tscn")
				"Soft Drink":
					SetItem("res://KOMPrefabs/Items/Full_Cup.tscn")
				_:
					if item == "Raw Patty":
						var newItem = inv.create_and_add_item("RawPatty")
					elif item == "Fresh Fries":
						var newItem = inv.create_and_add_item("FFries")
					elif item == "Drink Cup":
						var newItem = inv.create_and_add_item("emptycup")
					else:
						var newItem = inv.create_and_add_item(item)
					SoundSource.stream = load("res://Sounds/PhoneFail.ogg")
					SoundSource.play()
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
			SoundSource.stream = load("res://Sounds/PhoneFail.ogg")
			SoundSource.play()
			return false
	elif HasItem == false:
			match item:
				"Fries":
					SetItem("res://KOMPrefabs/Items/Fries_pickup.tscn")
				"Burger":
					SetItem("res://KOMPrefabs/Items/Burger_pickup.tscn")
				"Soft Drink":
					SetItem("res://KOMPrefabs/Items/Full_Cup.tscn")
				_:
					if item == "Raw Patty":
						var newItem = inv.create_and_add_item("RawPatty")
					elif item == "Fresh Fries":
						var newItem = inv.create_and_add_item("FFries")
					elif item == "Drink Cup":
						var newItem = inv.create_and_add_item("emptycup")
					else:
						var newItem = inv.create_and_add_item(item)
					SoundSource.stream = load("res://Sounds/PhoneFail.ogg")
					SoundSource.play()
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
		SoundSource.stream = load("res://Sounds/PhoneFail.ogg")
		SoundSource.play()
		return false
	
func SetItem(prefab : String):
	Scene = load(prefab) as PackedScene
	Packload()
	HasItem = true
	emited = false
	return true
			
func _process(delta):
	if node == null:
		if emited == false:
			StatusEmit()
		HasItem = false

func StatusEmit():
	emited = true
	ItemTaken.emit()

func Packload():
		node = Scene.instantiate()
		get_tree().current_scene.add_child(node)
		node.global_position = TargetLoc.global_position
		print(node.get_tree_string_pretty())
		node.scale = ObjectScale
		
		if NPCNavEnabled:
			NavNodeTarget = node
			await get_tree().create_timer(0.1).timeout

			currentNPC = find_closest_or_furthest(self.get_parent(),"PompNPC")
			if currentNPC != null:
				currentID = currentNPC.InstID
			else:
				currentID = 0
			currentMark = get_tree().get_first_node_in_group("NavMark" + str(currentID))
			currentNPC.MaxSpeed = 2
			print_rich("Spawner Current ID: [color=red]" + str(currentID) + "[/color]")
			for i in get_all_children(get_tree().get_root()):
				if i.is_in_group("PompNPC"):
					if i.InstID == currentID:
						SignalBusKOM.emit_signal("ItemSpef",currentID,NavNodeTarget,0)
			
			currentMark.global_position = NavNodeTarget.global_position
			currentMark = null
			currentID = null

func find_closest_or_furthest(node: Object,group_name,get_closest:= true) -> Object:
	@warning_ignore("unassigned_variable")
	var PossibleTargets : Array
	for i in get_all_children(get_tree().get_root()):
		if i.is_class("Node3D"):
			if i.is_in_group(group_name):
				PossibleTargets.append(i)
				print(str(PossibleTargets))
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

