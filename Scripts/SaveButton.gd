extends Button

var soundSource : AudioStreamPlayer

@export var MapLayer : int = 1;

func _ready():
	GameProgress.MapLayer = MapLayer;
	SavePoint.Save()

func _pressed():
	SavePoint.Save()
	soundSource = get_node("%SoundSource")
	soundSource.stream = load("res://Sounds/tick3.ogg")
	soundSource.play()
	pass
