extends Node3D

@export var Innocent = false
@export var CoreHealthHandler : Node3D
@export var gibRoot = preload("res://prefabs/blood_splatter.tscn")
@export var gibRoot2 = preload("res://prefabs/blood_splatter2.tscn")

var gib = PackedScene
var gib2 = PackedScene

var dead : bool

func _ready():
	CoreHealthHandler = get_parent().get_node("HealthHandler")

func _process(delta):
	if CoreHealthHandler.HP < 1 && !dead:
		Death()
		dead = true


	

func Hurt(amount : int):
	if CoreHealthHandler.HP > 1:
		var node : Node = gibRoot2.instantiate()
		#var node = gib2.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
		get_node("/root").add_child(node)
		node.global_position = self.global_position
	print("Hurt for " + str(amount))
	CoreHealthHandler.HP -= amount
	print(CoreHealthHandler.HP)



func Death():
	var node : Node = gibRoot.instantiate()
	get_node("/root").add_child(node)
	node.global_position = self.global_position
	get_parent().queue_free()
