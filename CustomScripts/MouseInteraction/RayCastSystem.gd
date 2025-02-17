# GLOBAL SCRIPT. ACCESS via RaycastSystem.foo()
# Raycast queries are defined here. All other modules can use it.

extends Node3D
class_name RayCastSystem


const RAY_LENGTH := 1000

"""
Uses default collision_mask. But can be overrided for custom collision
mask/layers.
Output format:
output_dict = {
	"collider": None,  # The colliding object (if any)
	"collider_id": None,  # The colliding object's ID (if any)
	"normal": [0, 0, 0],  # The surface normal at the intersection point
	"position": [0, 0, 0],  # The intersection point
	"face_index": -1,  # The face index at the intersection point
	"rid": None,  # The intersecting object's RID
	"shape": None  # The shape index of the colliding shape
}
"""
# Returns raycast result after it hits an object in the world.
# @return Dictionary or null
func _do_raycast_on_mouse_position(space_state,cam,mousepos,collision_mask: int = 0b00000000_00000000_00000000_00000001):
	# Raycast related code
	var origin = cam.project_ray_origin(mousepos)
	var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	query.collision_mask = collision_mask
	
	var result = space_state.intersect_ray(query) # raycast result
	return result



# # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # #
# API below:


# Gets ray-cast hit position from camera to world.
# @return Vector3 or null
func get_mouse_world_position(space_state,cam,mousepos,collision_mask: int = 0b00000000_00000000_00000000_00000001):
	var raycast_result = _do_raycast_on_mouse_position(space_state,cam,mousepos,collision_mask)
	if raycast_result:
		return raycast_result.position
	return null


# Gets ray-cast hit object from camera to world.
# @return Object or null
func get_raycast_hit_object(space_state,cam,mousepos,collision_mask: int = 0b00000000_00000000_00000000_00000001):
	var raycast_result = _do_raycast_on_mouse_position(space_state,cam,mousepos,collision_mask)
	if raycast_result:
		return raycast_result.collider
	return null
