extends Node
@export var GrillsGrilling : int = 0

signal NoGrillsActive

var SignalFired : bool = false

func _process(delta):
	if GrillsGrilling == 0 && !SignalFired:
		NoGrillsActive.emit()
	else:
		SignalFired = false
