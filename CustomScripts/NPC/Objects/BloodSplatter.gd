extends GPUParticles3D
@export var bloodMark : Node3D
@export var GibRef : RigidBody3D

func _process(delta):
	if GibRef == null:
		self.queue_free()

func bloodCheck():
	await get_tree().process_frame
	if bloodMark == null:
		return
	var spacestate : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var Vpos : Vector3 = self.position
	var queryV : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(Vpos,Vpos + Vector3.DOWN * 2)
	var resultV : Dictionary = spacestate.intersect_ray(queryV)
	if !resultV.is_empty():
		bloodMark.global_position = resultV["position"] + Vector3.UP * 0.01
		var targetRotation : Vector3 = resultV["normal"]
		if !(targetRotation != Vector3.UP):
			pass
	else:
		print("No Point for Blood Found!")
		bloodMark.queue_free()
