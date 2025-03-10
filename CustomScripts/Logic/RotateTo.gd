extends Node3D
@export var RotatePoint : Node3D
@export var RotateTarget : Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	RotatePoint.rotation.y = lerp(RotatePoint.rotation.y,find_rotation_to(RotatePoint,RotateTarget),delta * 3)


func find_rotation_to(node1 : Node3D,node2 : Node3D,degree = false):
	var pos1 = node1.global_transform.origin
	var pos2 = node2.global_transform.origin
	pos2.y = 2
	# Calculate the direction vector from node1 to node2 and normalize it
	var direction_to_node2 = (pos2 - pos1).normalized()
	var forward_vector = RotatePoint.global_transform.basis.z.normalized()
	# Calculate the angle between the forward vector and the direction vector
	var angle = forward_vector.angle_to(direction_to_node2)
	# Use cross product to determine the angle's sign (relative to the Y-axis)
	var cross_product = forward_vector.cross(direction_to_node2)
	# Adjust angle based on the cross product's Y-component
	if cross_product.y < 0:
			angle = -angle
	# Convert the angle to degrees (if needed)
	var angle_degrees = rad_to_deg(angle)
	if(degree):
		return angle_degrees
	else:
		return angle
