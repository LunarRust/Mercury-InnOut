extends Sprite2D
@export var Gear1 : Sprite2D
@export var Gear2 : Sprite2D
@export var soundSource : AudioStreamPlayer
@export var SourceLabel : RichTextLabel
@export var TargetLabel : RichTextLabel
@export var Register : TextureButton
@export_category("Parameters")
@export var ClosePosition : Vector2
@export var OpenPosition : Vector2
@export var Speed : float = 1.0

var InnoutSignalBus : Node
var open : bool
var Hided : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	InnoutSignalBus = get_tree().get_first_node_in_group("InnOutSignalBus")
	InnoutSignalBus.GameOver.connect(Close)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if TargetLabel != null && SourceLabel != null:
		TargetLabel.text = SourceLabel.text
		if Register != null && Register.OrderClock <= 30 && Register.OrderClock != 0.0:
			TargetLabel.add_theme_color_override("default_color",Color(1, 0.15294100344181, 0.25490200519562))
		else:
			TargetLabel.add_theme_color_override("default_color",Color(0.498, 0.455, 0.235))
	#if Speed < 1:
		#soundSource.pitch_scale = 2 + Speed
	#else:
		#soundSource.pitch_scale = Speed - 1

func Open():
	if InnoutSignalBus.DoTimer == true && open == false:
		open = true
		soundSource.stream = load("res://Sounds/InvOpen.ogg")
		soundSource.play()
		var tween : Tween = create_tween()
		tween.set_parallel()
		tween.tween_property(self,"position",OpenPosition,Speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(Gear1,"rotation",5,Speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(Gear2,"rotation",-5,Speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	
func Close():
	if InnoutSignalBus.DoTimer == true && open == true:
		open = false
		soundSource.stream = load("res://Sounds/InvClose.ogg")
		soundSource.play()
		var tween : Tween = create_tween()
		tween.set_parallel()
		tween.tween_property(self,"position",ClosePosition,Speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(Gear1,"rotation",0,Speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(Gear2,"rotation",0,Speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
