extends Node
var currentID
var currentMark
var currentNPC
var SignalBusKOM
var SignalBusInnOut
var NpcInventory
@export var NavNodeTarget : Node
@export var SoundSource : AudioStreamPlayer
@export var SoundPositive : AudioStream
@export var SoundNegative : AudioStream
@export var PosRefrence : Node3D
@export var ItemGen : Node
var NeededTotal : int
var TotalItems = 0
var OrderClock : float = 0.0
@export var ClockDisplay : RichTextLabel
var WaitingForOrder : bool = false
var FallBackSpawnClock : float = 0.0
var NpcHasExisted : bool = false
var HasComplained : bool = false
### Vars for lunch rush segment ###

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBusKOM = get_tree().get_first_node_in_group("player").get_node("KOMSignalBus")
	SignalBusInnOut = get_tree().get_first_node_in_group("InnOutSignalBus")
	await SignalBusInnOut.is_node_ready()
	ItemGen.ReadyToServeSignal.connect(BeginTimer)
	if SignalBusInnOut.DoTimer == true:
		ClockDisplay.text = "[shake rate=20][center]0"
	else:
		ClockDisplay.hide()



func NpcInvCheck():
	var NeededTotal = 0
	currentNPC = find_closest_or_furthest(PosRefrence,"PompNPC")
	currentID = currentNPC.InstID
	currentMark = get_tree().get_first_node_in_group("NavMark" + str(currentID))
	print_rich("Register Current ID: [color=red]" + str(currentID) + "[/color]")
	for i in get_all_children(get_tree().get_root()):
		if i.is_in_group("PompNPC"):
			if i.InstID == currentID:
				for ii in i.get_children():
					if ii.name == "InventoryGrid":
						NpcInventory = ii
	for i in ItemGen.RelevantItems:
		ItemGen.RelevantItems[i] = 0
	print(str(ItemGen.RelevantItems))

	var ItemsInInv = NpcInventory.get_items()
	for i in ItemsInInv:
		var iterant = -1
		if "prototype_id" in i:
			for ii in ItemGen.RelevantItems.size():
				iterant += 1
				print("ItemID is: " + str(i.prototype_id) + " " + "ItemGen.RelevantItems Key is: " + str(ItemGen.RelevantItems.keys()[iterant]))
				if i.prototype_id == ItemGen.RelevantItems.keys()[iterant]:
					print("Match!")
					ItemGen.RelevantItems[ItemGen.RelevantItems.keys()[iterant]] += 1
					print(str(ItemGen.RelevantItems.values()))
	TotalItems = 0
	for i in ItemGen.RelevantItems:
		TotalItems += ItemGen.RelevantItems[i]
		#if ItemGen.RelevantItems[i] != 0:
			#print(str(ItemGen.ItemCounts))
			#if ItemGen.RelevantItems[i] <= ItemGen.ItemCounts[i]:
				#TotalItems += ItemGen.RelevantItems[i]
			#else:
				#print(str("not enough " + str(ItemGen.RelevantItems[i])))
	for i in ItemGen.ItemsInInvDictionary:
		NeededTotal += ItemGen.ItemsInInvDictionary[i]

	print(str(ItemGen.RelevantItems))
	print(str(TotalItems) + " " + str(NeededTotal))
	if TotalItems >= NeededTotal:
		return true
	else:
		return false

func Task():
	currentNPC = find_closest_or_furthest(PosRefrence,"PompNPC")
	currentID = currentNPC.InstID
	currentMark = get_tree().get_first_node_in_group("NavMark" + str(currentID))
	print_rich("Register Current ID: [color=red]" + str(currentID) + "[/color]")
	for i in get_all_children(get_tree().get_root()):
		if i.is_in_group("PompNPC"):
			if i.InstID == currentID:
				SignalBusKOM.emit_signal("NavToPoint",currentID,false,NavNodeTarget,1,0,"default")

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

func BeginTimer():
	SoundSource.stream = load("res://Sounds/tick3.ogg")
	SoundSource.play()
	if SignalBusInnOut.DoTimer == true:
		ClockDisplay.show()
	else:
		ClockDisplay.hide()
	OrderClock = SignalBusInnOut.OrderWaitLimit + randf_range(-10,20)
	WaitingForOrder = true
	FallBackSpawnClock = 0.0
	currentNPC = find_closest_or_furthest(PosRefrence,"PompNPC")
	NpcHasExisted = true

func NpcLost():
	SignalBusInnOut.Score += TotalItems
	SignalBusInnOut.emit_signal("ScoreChanged")
	OrderClock = SignalBusInnOut.OrderWaitLimit + randf_range(-10,20)
	WaitingForOrder = false
	ItemGen.Clear()

func _process(delta):
	if WaitingForOrder:
		FallBackSpawnClock = 0.0
		if currentNPC == null:
			NpcLost()
		if SignalBusInnOut.DoTimer:
			OrderClock -= delta
		ClockDisplay.text = "[shake rate=20][center]" + str(snapped(OrderClock,1))
		if OrderClock <= 0.0:
			ClockDisplay.add_theme_color_override("default_color",Color(1, 0.15294100344181, 0.25490200519562))
			SignalBusKOM.emit_signal("TargetCreature",true,000,"player",1.5,"default",true)
			SignalBusInnOut.emit_signal("GameOver")
			WaitingForOrder = false
		if OrderClock <= 30.0 && !HasComplained:
			currentNPC.Speak(1,"res://KOMSounds/VO/Venus/WhereIsMyDamnFood.wav")
			HasComplained = true;
	else:
		if NpcHasExisted:
			if currentNPC == null:
				FallBackSpawnClock += delta
				if FallBackSpawnClock >= 30:
					FallBackSpawnClock = 0.0
					SignalBusKOM.emit_signal("CreateNpc",ItemGen.GenID)

func _on_pressed():
	if ItemGen.ReadyToServe == true:
		if NpcInvCheck() == true:
			SoundSource.stream = SoundPositive
			SoundSource.play()
			SignalBusInnOut.Score += TotalItems
			SignalBusInnOut.emit_signal("ScoreChanged")
			SignalBusInnOut.ServedCustomers += 1
			HasComplained = false
			OrderClock = 0.0
			WaitingForOrder = false

			ItemGen.Clear()
			Task()
		else:
			currentNPC.get_node("InventoryGrid").clear()
			currentNPC.animTrigger("Shrug")
			SoundSource.stream = SoundNegative
			SignalBusInnOut.Score -= TotalItems
			SignalBusInnOut.emit_signal("ScoreChanged")
			SignalBusInnOut.emit_signal("GameOver")
			OrderClock = 0.0
			WaitingForOrder = false
			SoundSource.play()
	else:
		SoundSource.stream = SoundNegative
		SoundSource.play()


func _on_behavior_item_taken():
	OrderClock += 15
