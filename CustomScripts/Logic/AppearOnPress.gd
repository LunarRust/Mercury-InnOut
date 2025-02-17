extends Node

@export var key : Key
@export var SoundEffect : AudioStreamPlayer
@export var OtherNodes : Array[Node]
var pressed : bool = false


func _process(delta):
	if Input.is_physical_key_pressed(key):
		if SoundEffect != null:
			if !SoundEffect.playing:
				SoundEffect.play()
		if !pressed:
			if !OtherNodes.is_empty():		
				for i in OtherNodes:
					if i != null:
						print_rich("Showing: [color=red] " + str(i) + "[/color]" )
						i.show()
			await get_tree().create_timer(0.4).timeout
			pressed = true
		else:
			if !OtherNodes.is_empty():		
				for i in OtherNodes:
					if i != null:
						print_rich("Hiding: [color=red] " + str(i) + "[/color]" )
						i.hide()
			await get_tree().create_timer(0.4).timeout
			pressed = false
		
				#if i == null:
				#	print("cannot show: " + str(i) + " it is a null value!")
