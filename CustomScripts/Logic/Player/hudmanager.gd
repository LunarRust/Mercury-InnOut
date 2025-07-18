extends CanvasLayer
@export var backupFilter : ColorRect
var instance
# Called when the node enters the scene tree for the first time.
func _ready():
	instance = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if Input.is_action_just_pressed("HideHud"):
		if instance.visible:
			HideHUD()
		else:
			ShowHUD()



func HideHUD():
	instance.hide()
	if instance.backupFilter != null:
		instance.backupFilter.show()


func ShowHUD():
	instance.show()
	if instance.backupFilter != null:
		instance.backupFIlter.hide()
