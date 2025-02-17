extends Node3D
@export_category("DialogueSystem")
@export var npcName : String
@export_multiline var Dialogue : String
@export_multiline var LookDescription : String
@export_multiline var TouchDescription : String
@export var soundSource : AudioStreamPlayer3D
@export var DialogueSound : AudioStream
@export var faceSprite : Texture2D
var DialogueBox : Node2D
var isTalking : bool
var PlayerObject : Node
var lookTarget : Vector3
@export var looking : bool = true
@export var Distance : bool = true
var parentnode : Node3D
var ActionButtonMaster : Node

func _ready():
	DialogueBox = get_tree().get_first_node_in_group("DialogueBox")
	PlayerObject = get_tree().get_first_node_in_group("player")
	ActionButtonMaster = get_tree().get_first_node_in_group("InteractionButtonKOMMaster")
	
	parentnode = self.get_parent()
	var vector : Vector3 = parentnode.global_position + parentnode.basis.z * 2
	lookTarget = Vector3(vector.x,self.global_position.y,vector.z)


func _process(delta):
	if looking:
		parentnode.look_at(lookTarget,Vector3.UP,true)
	if self.global_position.distance_to(PlayerObject.global_position) > 4 && isTalking && Distance:
		CloseDialogue()
		
func OpenDialogue():
	DialogueBox.show()
	DialogueBox.modulate = Color.TRANSPARENT
	var tween : Tween = create_tween()
	tween.tween_property(DialogueBox,"modulate",Color.WHITE,1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
func  DialogueProcessing():
	if looking:
		var tween : Tween = create_tween()
		tween.tween_property(self,"lookTarget",Vector3(PlayerObject.position.x,self.global_position.y,PlayerObject.position.z),0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	match ActionButtonMaster.interactionMode:
		1:
			DialogueBox.get_node("NameText").text = "Look"
			DialogueBox.get_node("MainText").text = LookDescription
			DialogueBox.get_node("FaceSprite").texture = load("res://Sprites/Faces/Eye.png")
			OpenDialogue()

		2:
			if soundSource != null && DialogueSound != null:
				soundSource.stream = DialogueSound
				soundSource.play()
			DialogueBox.get_node("NameText").text = npcName
			DialogueBox.get_node("MainText").text = Dialogue
			DialogueBox.get_node("FaceSprite").texture = faceSprite
			OpenDialogue()

		3:
			DialogueBox.get_node("NameText").text = "Touch"
			DialogueBox.get_node("MainText").text = TouchDescription
			DialogueBox.get_node("FaceSprite").texture = load("res://Sprites/Faces/Touch.png")
			OpenDialogue()
	isTalking = true
	
func CloseDialogue():
	DialogueBox.hide()
	isTalking = false
		
