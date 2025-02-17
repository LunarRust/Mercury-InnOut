extends Node
var SignalBusKOM

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBusKOM = get_tree().get_first_node_in_group("player").get_node("KOMSignalBus")
	SignalBusKOM.CreateNpc.connect(Spawn)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func Spawn():
	self.get_node("AutoSpawner").Packload()
