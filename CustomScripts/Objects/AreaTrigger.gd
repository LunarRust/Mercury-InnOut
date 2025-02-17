extends Node


@export var Target : StaticBody3D
@export var DoorBehavior : Node
@export var ChildNumber : int
@export var Entrance : bool
@export var Exit : bool
@export var OnVolumeExit : bool
@export var OnVolumeEntered : bool
var opened : bool


#TODO Item gets door stuck while player is in AreaTrigger
func _on_area_entered(area):
	if OnVolumeEntered:
		#print("area entered")
		#print_rich("is Entrance: [color=red]" + str(Entrance) + "[/color] and is opened: [color=red]" + str(opened) + "[/color] and is moving: [color=red]" + str(Target.get_child(ChildNumber).moving) + "[/color]")
		if !DoorBehavior.moving:
			match opened:
				true:
					if Exit:
						close()
				false:
					if Entrance:
						open()
		else:
			await get_tree().create_timer((Target.get_child(ChildNumber).Duration) + 0.1).timeout
			_on_area_entered(area)
			
		
func open():
	Target.get_child(ChildNumber).RemoteTriggerActivate()

func close():
	Target.get_child(ChildNumber).RemoteTriggerDeactivate()



func _on_behavior_open():
	#print("Door opened")
	opened = true
	

func _on_behavior_closed():
	#print("door closed")
	opened = false


func _on_area_exited(area):
		if OnVolumeExit:
			#print("area exited")
			#print_rich("is Entrance: [color=red]" + str(Entrance) + "[/color] and is opened: [color=red]" + str(opened) + "[/color] and is moving: [color=red]" + str(Target.get_child(ChildNumber).moving) + "[/color]")
			if !DoorBehavior.moving:
				match opened:
					true:
						if Exit:
							close()
					false:
						if Entrance:
							open()
			else:
				await get_tree().create_timer((Target.get_child(ChildNumber).Duration) + 0.1).timeout
				_on_area_exited(area)
