@icon("res://Sprites/iconsmile128Gold.png")

extends Node

@export var anim : AnimationTree
@export var PompAI : Node3D
@export var dialogue : Node3D
@export_category("Parameters")
@export var follow : bool
#@export var PlayerObject : MeshInstance3D

var InteractionButton = load("res://Scripts/InteractionButton.cs")
@onready var DialogueBox = get_tree().get_first_node_in_group("player").get_node("UI Overlay/CanvasLayer/DialogueParent/DialogueBox")

func StartAttack(name : StringName):
	print(name)
	if name == "Angry":
		PompAI.set("Attacking", true)
		
func Look():
	AnimTrigger("Shrug")

func Touch(AmNpc = false):
	AnimTrigger("Touch")

func Talk():
	AnimTrigger("Talk")
	self.get_parent().DialogueSystem.DialogueProcessing()
	
func Hurt():
	AnimTrigger("Hurt")
	if follow:
		#PompAI.set("hurt", true)
		DialogueBox.hide()
		AnimTrigger("Hurt")
		await get_tree().create_timer(1).timeout
		#PompAI.set("hurt", false)
	

func AnimTrigger(triggerName : String):
	anim["parameters/conditions/" + triggerName] = true;
	await get_tree().create_timer(0.1).timeout
	anim["parameters/conditions/" + triggerName] = false;


#func _process(delta):
	#if InteractionButton.get_propertylist("interactionMode") != 1:
		#pass
