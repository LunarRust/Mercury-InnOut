extends CharacterBody3D

@export var nav_agent : NavigationAgent3D

@export var speed: float = 3

@export var playerObject :Node3D

@export var anim : AnimationPlayer

@export var attackThreshold : float = 1.5
@export var attackPower : int = 1
@export var aggroRange : int = 10
@export var walkName = "Walk"
@export var attackName = "Attack"
@export var meleeAttack : bool = true

var attackTimer : float
var attacking : bool
var active : bool = false

var playerHealth = load("res://Scripts/PlayerHealthHandler.cs")
var playerMover = load("res://Scripts/MoverTest.cs")
var playerHealthInstance = playerHealth.new()

func _ready():
	if (playerObject == null):
		print("Ouchie wawa! There's no defined player object for this enemy to chase! Trying to find one now.")
		playerObject = get_tree().get_first_node_in_group("player")
		active = true
	else:
		active = true
	pass
		

func _physics_process(delta):
	if (active):
		active_handling(delta)

func active_handling(delta):
	if (position.distance_to(playerObject.position) < aggroRange && !attacking):
		if (anim != null):
			anim.play(walkName)
		attacking = true
	if (position.distance_to(playerObject.position) > 1.5 && attacking):
		handle_Move()
	if (position.distance_to(playerObject.position) < 1.5):
		attackTimer += 1 * delta
	if (attackTimer > attackThreshold && attacking && meleeAttack):
		Attack()
		attackTimer = 0


func update_target_location(target_location):
	nav_agent.target_position = target_location
	
func handle_Move():
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * speed
	var lookTarget = Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z)
	if (current_location != next_location && velocity != Vector3.ZERO && lookTarget != global_position):
		look_at(Vector3(lookTarget), Vector3.UP, true)
	
	#look_at(Vector3(playerObject.global_position.x,global_position.y,playerObject.global_position.z), Vector3.UP, true);
	
	velocity = velocity.move_toward(new_velocity, .25)
	move_and_slide()
	update_target_location(playerObject.position)

func Attack():
	if (anim != null):
		anim.play(attackName)
	if (position.distance_to(playerObject.position) < 1.5):
		playerHealthInstance.notsostatichealth(attackPower)
	await get_tree().create_timer(1.0).timeout
	if (anim != null):
		anim.play(walkName)
	pass
