extends CharacterBody3D

@export var nav_agent : NavigationAgent3D

@export var speed: float = 3
@export var acceleration: float = 5

@export var playerObject :Node3D

@export var anim : AnimationPlayer
@export var animTree : AnimationTree
@export var modelRoot : Node3D

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
		handle_Move(delta)
	else:
		velocity = velocity.lerp(Vector3.ZERO, delta)

	if (position.distance_to(playerObject.position) < 1.5):
		attackTimer += 1 * delta

	if (attackTimer > attackThreshold && attacking && meleeAttack):
		Attack()
		attackTimer = 0

	if (animTree != null):
		animTree["parameters/Normal/blend_position"] = velocity.length() / speed


func update_target_location(target_location):
	nav_agent.target_position = target_location
	
func handle_Move(delta):

	var direction = Vector3()
	nav_agent.target_position = playerObject.global_position
	direction = nav_agent.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, delta * acceleration)
	#velocity = velocity.move_toward(direction * speed, .25)
	move_and_slide()

	var lookTarget = Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z)

	var targetPos: Vector2 = Vector2(lookTarget.x, lookTarget.z)
	var modelPos : Vector2 = Vector2(modelRoot.global_position.x, modelRoot.global_position.z)

	if(!nav_agent.is_target_reachable() && velocity.length() / speed < .3):
		targetPos = Vector2(playerObject.global_position.x, playerObject.global_position.z)

	var modelDir = -(modelPos - targetPos)
	modelRoot.global_rotation.y = lerp_angle(modelRoot.global_rotation.y, atan2(modelDir.x, modelDir.y), delta * 6)


func Attack():
	if (anim != null):
		anim.play(attackName)
	if (animTree != null):
		animTree.active = false;
		animTree.active = true;
		animTrigger("Attack")
	if (position.distance_to(playerObject.position) < 1.5):
		playerHealthInstance.notsostatichealth(attackPower)
	await get_tree().create_timer(1.0).timeout
	if (anim != null):
		anim.play(walkName)
	pass

func animTrigger(triggername : String):
	animTree["parameters/conditions/" + triggername] = true;
	await get_tree().create_timer(0.1).timeout
	animTree["parameters/conditions/" + triggername] = false;
