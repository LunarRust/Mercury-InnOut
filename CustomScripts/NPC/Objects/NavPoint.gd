extends Node
@export var NavNodeTarget : Node
@export var distanceToNext : float = 1.5
@export var ArrivalAction : int = 0
@export var KillNpcOnReach : bool = false
var InnoutBus
var currentNPC
var currentID
var SignalBusKOM
var currentMark

# Called when the node enters the scene tree for the first time.
func _ready():
	InnoutBus = get_tree().get_first_node_in_group("InnOutSignalBus")
	SignalBusKOM = get_tree().get_first_node_in_group("SignalBusKOM")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Reached(id : int):
	print("Reached: " + str(self))
	currentID = id
	#print_rich("[color=red] Reached! [/color] Emiting to Generator#[color=red]" + str(GeneratorID) + "[/color] Recived by #[color=red]" + str(RegisterOrderGen.GenID) + "[/color]")
	await get_tree().create_timer(0.1).timeout
	currentNPC = get_tree().get_first_node_in_group(str(id))
	currentMark = get_tree().get_first_node_in_group("NavMark" + str(currentID))
	if !KillNpcOnReach:
		currentNPC.MaxSpeed = 2
		print_rich("Spawner Current ID: [color=red]" + str(currentID) + "[/color]")
		currentMark.global_position = NavNodeTarget.global_position
		SignalBusKOM.emit_signal("NavToPoint",currentID,false,NavNodeTarget,distanceToNext,ArrivalAction,"player")
		
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
