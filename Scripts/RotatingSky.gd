extends WorldEnvironment

var Env : WorldEnvironment
@export var speed : float = 1;
# Called when the node enters the scene tree for the first time.
func _ready():
	Env = self;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	Env.environment.sky_rotation.y += (0.0005 * speed)
	if (Env.environment.sky_rotation.y >= 360 or Env.environment.sky_rotation.y <= -360):
		Env.environment.sky_rotation.y =0
	pass
