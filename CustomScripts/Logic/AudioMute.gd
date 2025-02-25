extends AudioStreamPlayer
@export var key : Key
@export var OtherNodes : Array[Node]
var pressed : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_physical_key_pressed(key):
		if !pressed:
			self.stream_paused = true
			if !OtherNodes.is_empty():		
				for i in OtherNodes:
					if i != null:
						i.stream_paused = true
			await get_tree().create_timer(0.4).timeout
			pressed = true
		else:
			self.stream_paused = false
			if !OtherNodes.is_empty():		
				for i in OtherNodes:
					if i != null:
						i.stream_paused = false
			await get_tree().create_timer(0.4).timeout
			pressed = false
