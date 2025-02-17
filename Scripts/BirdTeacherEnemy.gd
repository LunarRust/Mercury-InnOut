extends CharacterBody3D

var player = null

@export var player_path : NodePath

const SPEED = 2.0

@onready var nav_agent = $NavigationAgent3D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (position.distance_to(player.global_position) > 4):
		movement()
	else :
		look_at(Vector3(global_position.x + velocity.x, global_position.y,global_position.z + velocity.z), Vector3.UP, true)
func movement():
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED

	look_at(Vector3(next_nav_point.x, global_position.y,next_nav_point.z), Vector3.UP, true)

	move_and_slide()
