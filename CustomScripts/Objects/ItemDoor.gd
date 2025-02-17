extends Node


@export_category("Item")
@export var RequireItem : bool
@export var ItemToMatch : String
@export var SoundEffect : AudioStream
@export_category("Transmission")
@export var Transmit : bool
@export var PartnerDoor : StaticBody3D
@export_category("Movement")
@export var direction : Vector3
@export var Duration : float
signal open
signal closed(bool)

@onready var TweenOpen = get_tree().create_tween()
@onready var TweenClose = get_tree().create_tween()
var opened : bool
var moving : bool = false
var ItemUsed: bool = false
signal stopped
	
func Item(item : String):
	TweenClose.set_parallel()
	TweenOpen.set_parallel()
	print("Trying Key")
	print("Does " + item + " equal " + ItemToMatch)
	if (item == ItemToMatch && !opened):
		ItemUsed = true
		OpenDoor()
		if PartnerDoor != null:
			PartnerDoor.get_child(7).OpenDoor()
		return true
	else:
		return false
		
		
#TODO: Fix glassdoor spam bug
func OpenDoor():
	if moving:
		await stopped
	if !opened:
		#print("Door is moving: " + str(TweenClose.is_running()))
		opened = true 
		%SoundSource.stream = SoundEffect
		%SoundSource.play()
		TweenOpen = get_tree().create_tween()
		TweenOpen.set_parallel()
		TweenOpen.connect("finished", on_tweenopen_finished)
		#TweenOpen.new()
		TweenOpen.tween_property(get_parent(), "position", direction,Duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).as_relative()
		moving = true
		if Transmit:
			open.emit()
			if PartnerDoor != null:
				PartnerDoor.get_child(7).OpenDoor()
			
		
	
func Close():
	if moving:
		await stopped
	if opened:
		#print("Door is moving: " + str(TweenOpen.is_running()))
		opened = false 
		%SoundSource.stream = SoundEffect
		%SoundSource.play()
		TweenClose = get_tree().create_tween()
		TweenClose.connect("finished", on_tweenclose_finished)
		TweenClose.set_parallel()
		TweenClose.tween_property(get_parent(), "position", -direction,Duration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE).as_relative()
		moving = true
		if Transmit:
			closed.emit()
			if PartnerDoor != null:
				PartnerDoor.get_child(7).Close()
		

func RemoteTriggerActivate():
	#print("Does door Require Item: " + str(RequireItem) + " and has Item been used: " + str(ItemUsed))
	if RequireItem:
		if ItemUsed:
			OpenDoor()
	else:
		OpenDoor()
	
func RemoteTriggerDeactivate():
	#print("Does door Require Item: " + str(RequireItem) + " and has Item been used: " + str(ItemUsed))
	if RequireItem:
		if ItemUsed:
			Close()
	else:
		Close()

func on_tweenclose_finished():
	#print("Door finished Moving!")
	stopped.emit()
	moving = false
	
func on_tweenopen_finished():
	stopped.emit()
	#print("Door finished Moving!")
	moving = false


func Destroy():
	queue_free()
