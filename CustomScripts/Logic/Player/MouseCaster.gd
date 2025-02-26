class_name MouseCaster
extends Node3D
@export var RCS : Node3D
@export var PlayerAnim : AnimationTree
@export var HammerAnim : AnimationPlayer
@export var HurtFor : int
@export var SoundSource : AudioStreamPlayer
var active : bool = false
var space_state
var cam
var mousepos
var CurrentIntersectedObject
var interactionButtonKOM
var TouchedObject
var ViewButton = preload("res://Scripts/ViewButton.cs")
var WooshSound = preload("res://Sounds/Woosh.ogg") as AudioStream
var ImpactSound = preload("res://Sounds/Impact.ogg") as AudioStream

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.2).timeout
	interactionButtonKOM = get_tree().get_first_node_in_group("InteractionButtonKOMMaster")
	active = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if active:
		space_state = get_world_3d().direct_space_state
		cam = get_viewport().get_camera_3d()
		mousepos = get_viewport().get_mouse_position()
		if mousepos == null:
			mousepos = Vector2(0,0)
		if RCS.get_mouse_world_position(space_state,cam,mousepos) != null:
			self.global_position = RCS.get_mouse_world_position(space_state,cam,mousepos)
		CurrentIntersectedObject = RCS.get_raycast_hit_object(space_state,cam,mousepos)
	
func Cast():
	var node : Node
	var zDepth : float
	zDepth = 2
	var from : Vector3 = cam.project_ray_origin(mousepos)
	var to = cam.project_position(mousepos,zDepth)
	var physicsRayQueryParameters3D : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from,to)
	physicsRayQueryParameters3D.hit_back_faces = false
	var dictionary : Dictionary = space_state.intersect_ray(physicsRayQueryParameters3D)
	print_rich("[color=red]" + str(dictionary) + "[/color]")
	if !dictionary.is_empty() && (dictionary["collider"] as CollisionObject3D).has_node("DialogueSystem"):
		(dictionary["collider"] as CollisionObject3D).get_node("DialogueSystem").DialogueProcessing()
	if !dictionary.is_empty() && (dictionary["collider"] as CollisionObject3D).has_node("Behavior"):
		node = (dictionary["collider"] as CollisionObject3D).get_node("Behavior")
	match  interactionButtonKOM.interactionMode:
		3: 
			if !dictionary.is_empty():
				if node != null:
					if node.has_method("Touch"):
						animTrigger("Touch")
						node.Touch()
						print_rich("Touched object is: [color=red]" + str(node) + "[/color]")
		4: 
			animTrigger("Attack")
			HammerAnim.stop()
			HammerAnim.play("Attack")
			SoundSource.stream = WooshSound
			SoundSource.play()
			await get_tree().create_timer(0.15000000596046448).timeout
			if !dictionary.is_empty():
				if (dictionary["collider"] as CollisionObject3D).has_node("HealthHandler"):
					var health : Node = (dictionary["collider"] as CollisionObject3D).get_node("HealthHandler")
					health.Hurt(HurtFor)
					print("Hitting creature")
				else:
					SoundSource.stream = ImpactSound
					SoundSource.play()
					print("Hitting object")
				if node != null:
					if node.has_method("Hurt"):
						node.Hurt()
						print_rich("Attacked object is: [color=red]" + str(node) + "[/color]")
		2:
			if !dictionary.is_empty():
				if node != null:
					if node.has_method("Talk"):
						animTrigger("Talk")
						node.Talk()
		1:
			if !dictionary.is_empty():
				if node != null:
					if node.has_method("Look"):
						node.Look()
	TouchedObject = CurrentIntersectedObject
	
	
func ItemCast(item : String):
	var zDepth : float
	zDepth = 2
	var from : Vector3 = cam.project_ray_origin(mousepos)
	var to = cam.project_position(mousepos,zDepth)
	var physicsRayQueryParameters3D : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from,to)
	physicsRayQueryParameters3D.hit_back_faces = false
	var dictionary : Dictionary = space_state.intersect_ray(physicsRayQueryParameters3D)
	print_rich("[color=red]" + str(dictionary) + "[/color]")
	print_rich("Casting with:[color=red] " + item + "[/color]")
	if !dictionary.is_empty() && (dictionary["collider"] as CollisionObject3D).has_node("Behavior"):
		var node : Node = (dictionary["collider"] as CollisionObject3D).get_node("Behavior")
		if node.has_method("Item"):
			node.Item(item)
			return true
	else:
		return false
		
func _unhandled_input(event):
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
		mousepos = event.position
		Cast()

func get_all_children(in_node, array := []):
	array.push_back(in_node)
	for child in in_node.get_children():
		array = get_all_children(child, array)
	return array
	
func animTrigger(triggername : String):
	PlayerAnim["parameters/conditions/" + triggername] = true;
	await get_tree().create_timer(0.1).timeout
	PlayerAnim["parameters/conditions/" + triggername] = false;
