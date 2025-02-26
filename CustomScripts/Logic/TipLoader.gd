extends RichTextLabel
@export_multiline var tips : Array[String]


# Called when the node enters the scene tree for the first time.
func _ready():
	var RandNum : RandomNumberGenerator = RandomNumberGenerator.new()
	var num : int = RandNum.randi_range(0,tips.size() - 1)
	self.text = "[wave][center]" + "\n" + tips[num]
