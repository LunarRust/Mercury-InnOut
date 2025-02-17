extends Node


@export_category("Item")
@export var RequireItem : bool
@export var ItemToMatch : String
@export var SoundEffect : AudioStream
@export_category("Transmission")
@export var Transmit : bool
@export var PartnerDoor : StaticBody3D
@export_category("Movement")
@export var AnimTree : AnimationTree
@export var AnimPlayer : AnimationPlayer
@export var direction : Vector3
@export var Duration : float
signal open
signal closed(bool)

var opened : bool
var moving : bool = false
var ItemUsed: bool = false
signal stopped
	
func Item(item : String):
	print("Trying Key")
	print("Does " + item + " equal " + ItemToMatch)
	if (item == ItemToMatch && !opened):
		ItemUsed = true
		OpenDoor()
		if PartnerDoor:
			PartnerDoor.get_child(7).OpenDoor()
		return true
	else:
		return false
		
		
#TODO: Fix glasswdoor spam bug
func OpenDoor():
	if moving:
		await stopped
	if !opened:
		#print("Door is moving: " + str(TweenClose.is_running()))
		opened = true 
		%SoundSource.stream = SoundEffect
		%SoundSource.play()
		AnimPlayer.speed_scale = Duration
		animTrigger("Open")
		moving = true
		if Transmit:
			open.emit()
			PartnerDoor.get_child(7).OpenDoor()
			
		
	
func Close():
	if moving:
		await stopped
	if opened:
		#print("Door is moving: " + str(TweenOpen.is_running()))
		opened = false 
		%SoundSource.stream = SoundEffect
		%SoundSource.play()
		AnimPlayer.speed_scale = Duration
		animTrigger("Close")
		moving = true
		if Transmit:
			closed.emit()
			PartnerDoor.get_child(7).Close()
		

func RemoteTriggerActivate():
	print("Does door Require Item: " + str(RequireItem) + " and has Item been used: " + str(ItemUsed))
	if RequireItem:
		if ItemUsed:
			OpenDoor()
	else:
		OpenDoor()
	
func RemoteTriggerDeactivate():
	print("Does door Require Item: " + str(RequireItem) + " and has Item been used: " + str(ItemUsed))
	if RequireItem:
		if ItemUsed:
			Close()
	else:
		Close()

func on_tweenclose_finished():
	print("Door finished Moving!")
	stopped.emit()
	moving = false
	
func on_tweenopen_finished():
	stopped.emit()
	print("Door finished Moving!")
	moving = false


func Destroy():
	queue_free()
	
func animTrigger(triggername : String):
	AnimTree["parameters/conditions/" + triggername] = true;
	await get_tree().create_timer(0.1).timeout
	AnimTree["parameters/conditions/" + triggername] = false;
