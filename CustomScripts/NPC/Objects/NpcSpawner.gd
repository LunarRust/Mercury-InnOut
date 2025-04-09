extends Node
@export var Scene : PackedScene
@export var TargetLoc : RayCast3D
@export var TargetRegister : TextureButton
@export var distance : float
@export var ArrivalAction : int = 0
@export var AcknowledgeNVT : bool = true
@export var SpawnOnLoad : bool = false 
@export var SpawnDelay : float = 0.0
@export var InitalDelay : float = 0.0
var firstSpawnDone : bool = false
var ScenePack
var currentID
var currentMark
var currentNPC
var SignalBusKOM
var SignalBusInnout
@export var SpawnerID : int
@export var NavNodeTarget : Node
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBusKOM = get_tree().get_first_node_in_group("player").get_node("KOMSignalBus")
	SignalBusInnout = get_tree().get_first_node_in_group("InnOutSignalBus")
	await SignalBusKOM.is_node_ready()
	SignalBusKOM.CreateNpc.connect(Spawn)
	await get_tree().create_timer(0.3).timeout
	if SpawnOnLoad:
		await get_tree().create_timer(InitalDelay).timeout
		Packload()
	

func Spawn(ID):
	if ID == SpawnerID && SignalBusInnout.WavesActive:
		Packload()

func Packload():
	if firstSpawnDone:
		await get_tree().create_timer(SpawnDelay).timeout
	firstSpawnDone = true
	var node : Node = Scene.instantiate()
	get_tree().current_scene.add_child(node)
	node.global_position = TargetLoc.get_collision_point()
	#print(node.get_tree_string_pretty())
	TargetLoc.get_collision_point()
	node.SpawnerID = SpawnerID
	node.AcknowledgeNVT = AcknowledgeNVT
	TargetRegister.currentNPC = node

	await get_tree().create_timer(0.1).timeout

	currentNPC = find_closest_or_furthest(self,"PompNPC")
	currentID = currentNPC.InstID
	currentMark = get_tree().get_first_node_in_group("NavMark" + str(currentID))
	currentNPC.MaxSpeed = 2
	print_rich("Spawner Current ID: [color=red]" + str(currentID) + "[/color]")
	SignalBusKOM.emit_signal("NavToPoint",currentID,true,NavNodeTarget,distance,ArrivalAction,"player")
	
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
