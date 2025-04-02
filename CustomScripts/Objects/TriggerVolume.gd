extends Node
signal VolumeBeenEntered
signal VolumeBeenExited

@export var TriggerOnce : bool = false
@export var TriggerResetTime : float = 0.0
@export var TriggerByGroup : Array[String]

var TriggerTime : float = 0.0
var BeenEntered : bool = false
var BeenExited : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	TriggerTime += delta
	if TriggerTime >= TriggerResetTime:
		TriggerTime = 0.0
		BeenEntered = false
		BeenExited = false


func _on_area_entered(area):
	if !BeenEntered:
		if !TriggerByGroup.is_empty():
			for i in TriggerByGroup:
				if area.get_parent().is_in_group(i):
					VolumeBeenEntered.emit()
					if !TriggerOnce:
						BeenEntered = true
		else:
			VolumeBeenEntered.emit()
			if !TriggerOnce:
				BeenEntered = true


func _on_area_exited(area):
	if  !BeenExited:
		if !TriggerByGroup.is_empty():
			for i in TriggerByGroup:
				if area.get_parent().is_in_group(i):
					VolumeBeenExited.emit()
					if !TriggerOnce:
						BeenExited = true
		else:
			VolumeBeenExited.emit()
			if !TriggerOnce:
				BeenExited = true


func _on_body_exited(body):
	pass # Replace with function body.


func _on_body_entered(body):
	pass # Replace with function body.
