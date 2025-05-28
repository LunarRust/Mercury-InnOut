@tool
extends RichTextLabel
var tween
var blink_timer : Timer = Timer.new()
@export var speed : float = 1.0
@export var loops : int = -1
@export var DoBlinking : bool = false
@export var BlinkSpeed : float = 1.0
@export var Update:bool:
	set(value):
		if Engine.is_editor_hint():
			update(speed,loops)
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(blink_timer)
	blink_timer.one_shot = false
	blink_timer.wait_time = BlinkSpeed
	blink_timer.connect("timeout",_on_timer_timeout)
	blink_timer.start()
	tween = create_tween()
	tween.set_loops(loops)
	tween.tween_property(self, "visible_ratio", 0, speed)
	tween.tween_property(self, "visible_ratio", 1, speed)
	tween.tween_property(self, "visible_ratio", 1, speed)
	if  DoBlinking:
		tween.tween_property(self, "visible", 0, speed)
		tween.tween_property(self, "visible", 1, speed)


func update(newSpeed : float = speed,newLoops : int = -1):
	tween.kill()
	speed = newSpeed
	loops = newLoops
	scroll_text()

func Disable():
	DoBlinking = false
	update(1,1)
	self.hide()

func Enable():
	self.show()

func _on_timer_timeout():
	blink_timer.wait_time = BlinkSpeed
	if DoBlinking:
		if visible:
			self.hide()
		else:
			self.show()

func scroll_text():
	tween = create_tween()
	tween.set_loops(loops)
	tween.tween_property(self, "visible_ratio", 0, speed)
	tween.tween_property(self, "visible_ratio", 1, speed)
	tween.tween_property(self, "visible_ratio", 1, speed)
	if  DoBlinking:
		tween.tween_property(self, "visible", 0, speed)
		tween.tween_property(self, "visible", 1, speed)
