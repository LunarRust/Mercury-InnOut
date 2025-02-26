extends Sprite2D
@export var faceSprite : Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween : Tween = create_tween().set_loops()
	tween.tween_property(faceSprite,"rotation",0.2,1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(faceSprite,"rotation",-0.2,1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
