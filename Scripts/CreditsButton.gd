extends TextureButton


@export var creditsParent : ColorRect
# Called when the node enters the scene tree for the first time.

func _pressed():
	#creditsParent.show()
	$".".show()
	pass


func _on_texture_button_pressed():
	$Credits.hide()
	
	pass # Replace with function body.


func _on_pressed():
	$Credits.show()
	pass # Replace with function body.
