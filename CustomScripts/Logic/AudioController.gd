extends AudioStreamPlayer
@export var key : Key
@export var TrackSelection : Array[AudioStream]
@export var OtherNodesToMute : Array[Node]
var pressed : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	var RandNum : RandomNumberGenerator = RandomNumberGenerator.new()
	var num : int = RandNum.randi_range(0,TrackSelection.size() - 1)
	self.stream = TrackSelection[num]
	self.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_physical_key_pressed(key):
		if !pressed:
			self.stream_paused = true
			if !OtherNodesToMute.is_empty():		
				for i in OtherNodesToMute:
					if i != null:
						i.stream_paused = true
			await get_tree().create_timer(0.4).timeout
			pressed = true
		else:
			self.stream_paused = false
			if !OtherNodesToMute.is_empty():		
				for i in OtherNodesToMute:
					if i != null:
						i.stream_paused = false
			await get_tree().create_timer(0.4).timeout
			pressed = false
