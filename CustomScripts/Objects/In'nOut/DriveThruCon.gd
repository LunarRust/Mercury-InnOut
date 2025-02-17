extends Node
@export var DriveThruDoorBehavior : Node
var opened : bool = false
var pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	if !DriveThruDoorBehavior.moving:
		match opened:
			false:
				opened = true
				open()
			true:
				opened = false
				close()
	else:
		await get_tree().create_timer((DriveThruDoorBehavior.Duration) + 0.1).timeout
		_on_pressed()
		
func open():
	DriveThruDoorBehavior.RemoteTriggerActivate()

func close():
	DriveThruDoorBehavior.RemoteTriggerDeactivate()


func _on_toggled(toggled_on):
	pass # Replace with function body.
