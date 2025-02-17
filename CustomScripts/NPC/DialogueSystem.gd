extends Node3D

@export var npcName : String
@export var Dialogue : String
@export var LookDescription : String
@export var TouchDescription : String
@export var soundSource : AudioStreamPlayer3D
@export var DialogueSound : AudioStream
@export var faceSprite : Texture2D
@onready var DialogueBox = get_tree().get_root().get_node("DialogueBox")
var isTalking : bool
@export var PlayerObject : MeshInstance3D
var lookTarget : Vector3
var looking : bool = true
var Distance : bool = true
var parentnode : Node3D
var InteractionButton = preload("res://Scripts/InteractionButton.cs")

func _ready():
	parentnode = get_parent()
	print("DialogueBox is: " + str(DialogueBox))

	var vector : Vector3 = parentnode.global_transform.origin + parentnode.global_transform.basis.z * 2
	lookTarget = Vector3(vector.x, global_transform.origin.y, vector.z)

func _process(delta: float) -> void:
	if looking:
		parentnode.look_at(lookTarget, Vector3.UP)
	if global_transform.origin.distance_to(PlayerObject.global_transform.origin) > 4 && isTalking && Distance:
		close_dialogue()

func open_dialogue() -> void:
	DialogueBox.show()
	DialogueBox.modulate = Color(1, 1, 1, 0)
	var tween : Tween = create_tween()
	tween.interpolate_property(DialogueBox, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)

func dialogue_processing() -> void:
	if looking:
		var tween : Tween = create_tween()
		tween.interpolate_property(self, "lookTarget", Vector3(PlayerObject.position.x, global_transform.origin.y, PlayerObject.position.z), 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	
	if InteractionButton.interaction_mode == 1:
		DialogueBox.get_node("NameText").text = "Look"
		DialogueBox.get_node("MainText").text = LookDescription
		DialogueBox.get_node("FaceSprite").texture = preload("res://Sprites/Faces/Eye.png")
		open_dialogue()
	
	if InteractionButton.interaction_mode == 2:
		if soundSource != null and DialogueSound != null:
			soundSource.stream = DialogueSound
			soundSource.play()
		DialogueBox.get_node("NameText").text = npcName
		DialogueBox.get_node("MainText").text = Dialogue
		DialogueBox.get_node("FaceSprite").texture = faceSprite
		open_dialogue()

	if InteractionButton.interaction_mode == 3:
		DialogueBox.get_node("NameText").text = "Touch"
		DialogueBox.get_node("MainText").text = TouchDescription
		DialogueBox.get_node("FaceSprite").texture = preload("res://Sprites/Faces/Touch.png")
		open_dialogue()

	isTalking = true

func close_dialogue() -> void:
	DialogueBox.hide()
	isTalking = false
