extends Node3D

@export_category("Parameters")
@export var Innocent = false
@export var HP : int = 9
@export_category("Assignments")
@export var CoreHealthHandler : Node3D
@export var DialogueSystem : Node3D
var shake
@export var gibRoot = preload("res://prefabs/blood_splatter.tscn")
@export var gibRoot2 = preload("res://prefabs/blood_splatter2.tscn")
@export_category("Skins")
@export var Body : MeshInstance3D
@export var Skin0 : StandardMaterial3D
@export var Skin1 : StandardMaterial3D
@export var Skin2 : StandardMaterial3D

var gib = PackedScene
var gib2 = PackedScene

var dead : bool

func _ready():
	shake = get_tree().get_first_node_in_group("CameraShake")
	CoreHealthHandler = get_parent().get_node("HealthHandler")
func _process(delta):
	if HP < 1 && !dead:
		Death()
		dead = true


	

func Hurt(amount : int,doShake : bool = false):
	if HP > 1:
		var node : Node = gibRoot2.instantiate()
		#var node = gib2.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
		get_node("/root").add_child(node)
		node.global_position = self.global_position
	print("Hurt for " + str(amount))
	HP -= amount
	print(HP)
	if doShake == true:
		shake.Shake(0.08)
	#SkinCheck()

###
###TODO: This function changes the material for all instances of the NPC.
###
func SkinCheck():
	if HP > 7:
		if Body != null:
			Skin0 = Skin0.duplicate()
			Body.mesh.surface_set_material(0,Skin0)
	elif HP > 5:
		if Body != null:
			Skin1 = Skin1.duplicate()
			Body.mesh.surface_set_material(0,Skin1)
	else:
		if Body != null:
			Skin2 = Skin2.duplicate()
			Body.mesh.surface_set_material(0,Skin2)

func Death():
	var node : Node = gibRoot.instantiate()
	DialogueSystem.CloseDialogue()
	get_node("/root").add_child(node)
	node.global_position = self.global_position
	get_parent().queue_free()
