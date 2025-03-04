extends Node
@export var RegisterOrderGen : Node
@export var GeneratorID : int
var InnoutBus

# Called when the node enters the scene tree for the first time.
func _ready():
	InnoutBus = get_tree().get_first_node_in_group("InnOutSignalBus")


	
func Reached(id : int):
	RegisterOrderGen.Generate(GeneratorID)
	if InnoutBus != null:
		InnoutBus.emit_signal("ReadyToOrder",GeneratorID)
	else:
		print("SignalBus does not exist!")
	print_rich("[color=red] Reached! [/color] Emiting to Generator#[color=red]" + str(GeneratorID) + "[/color] Recived by #[color=red]" + str(RegisterOrderGen.GenID) + "[/color]")
