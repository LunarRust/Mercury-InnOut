extends Node
var InstID
var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	if InstID != null:
		self.add_to_group("NavMark" + str(InstID))
		print(str(self.get_groups()))
	else:
		await get_tree().create_timer(0.1).timeout
		_ready()
