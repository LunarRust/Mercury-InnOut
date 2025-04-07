extends Sprite2D
var instance
signal DialogueClosed

# Called when the node enters the scene tree for the first time.
func _ready():
	instance = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE) || Input.is_key_pressed(KEY_SPACE) || Input.is_joy_button_pressed(0,JOY_BUTTON_B) && instance.visible:
		DialogueClosed.emit()
		instance.hide()
