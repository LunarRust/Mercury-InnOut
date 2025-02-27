extends Node3D

@export var Innocent = false
@export var CoreHealthHandler : Node3D
@export var DialogueSystem : Node3D
var shake
@export var gibRoot = preload("res://prefabs/blood_splatter.tscn")
@export var gibRoot2 = preload("res://prefabs/blood_splatter2.tscn")
@export_category("Skins")
@export var Body : MeshInstance3D
@export var Skins : Array[StandardMaterial3D]

var gib = PackedScene
var gib2 = PackedScene

var dead : bool

func _ready():
	shake = get_tree().get_first_node_in_group("CameraShake")
	CoreHealthHandler = get_parent().get_node("HealthHandler")
func _process(delta):
	if CoreHealthHandler.HP < 1 && !dead:
		Death()
		dead = true


	

func Hurt(amount : int,doShake : bool = false):
	if CoreHealthHandler.HP > 1:
		var node : Node = gibRoot2.instantiate()
		#var node = gib2.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
		get_node("/root").add_child(node)
		node.global_position = self.global_position
	print("Hurt for " + str(amount))
	CoreHealthHandler.HP -= amount
	print(CoreHealthHandler.HP)
	if doShake == true:
		shake.Shake(0.08)
	SkinCheck()

func SkinCheck():
	if CoreHealthHandler.health > 7:
		if Body != null:
			Body.mesh.surface_set_material(0,Skins[0])
	elif CoreHealthHandler.health > 5:
		if Body != null:
			Body.mesh.surface_set_material(0,Skins[1])
	else:
		if Body != null:
			Body.mesh.surface_set_material(0,Skins[1])

func Death():
	var node : Node = gibRoot.instantiate()
	DialogueSystem.CloseDialogue()
	get_node("/root").add_child(node)
	node.global_position = self.global_position
	get_parent().queue_free()
