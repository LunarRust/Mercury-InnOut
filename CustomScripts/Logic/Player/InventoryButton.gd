class_name InventoryButton
extends TextureButton
var open : bool
var Hided : bool
@export var HotBar : Sprite2D
@export var Gear1 : Sprite2D
@export var Gear2 : Sprite2D
@export var soundSource : AudioStreamPlayer
@export_category("Health")
@export var PlayerHealthHandler : Node
@export var label : Label
@export var manalabel : Label
@export_category("Parameters")
@export var Speed : float = 1.0
@export var ItemDropRange : float = 200
var HealthHandler

# Called when the node enters the scene tree for the first time.
func _ready():
	HealthHandler = load("res://Scripts/PlayerHealthHandler.cs")
	HealthHandler = HealthHandler.new()
	open = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("menu_inventory"):
		if !open:
			Open()
		else:
			Close()
	if open:
		#label.text = str(HealthHandler.health)
		#manalabel.text = str(HealthHandler.mana)
		pass
	
	if Input.is_action_pressed("MouseAction") && get_viewport().get_mouse_position().y > ItemDropRange && open && !Hided:
		var tween : Tween = create_tween()
		tween.set_parallel()
		tween.tween_property(HotBar,"position",Vector2(480,475),Speed / 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(Gear1,"rotation",0,Speed / 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(Gear2,"rotation",0,Speed / 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		Hided = true
		
	elif Input.is_action_just_released("MouseAction") && Hided:
		var tween : Tween = create_tween()
		tween.set_parallel()
		tween.tween_property(HotBar,"position",Vector2(480,300),Speed / 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(Gear1,"rotation",5,Speed / 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween.tween_property(Gear2,"rotation",-5,Speed / 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		Hided = false


func _on_pressed():
	if !open:
		Open()
	else:
		Close()
		
		
func Open():
	open = true
	soundSource.stream = load("res://Sounds/InvOpen.ogg")
	soundSource.play()
	var tween : Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(HotBar,"position",Vector2(480,300),Speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(Gear1,"rotation",5,Speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(Gear2,"rotation",-5,Speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
func Close():
	open = false
	soundSource.stream = load("res://Sounds/InvClose.ogg")
	soundSource.play()
	var tween : Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(HotBar,"position",Vector2(480,560),Speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(Gear1,"rotation",0,Speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(Gear2,"rotation",0,Speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
