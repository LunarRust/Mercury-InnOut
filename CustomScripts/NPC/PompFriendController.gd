extends Node
signal AttackEnimeies
signal FollowPlayer


func _on_attack_button_pressed():
	get_tree().get_first_node_in_group("player").get_node("KOMSignalBus").emit_signal("Activate_Pomp_Target")


func _on_player_button_pressed():
	get_tree().get_first_node_in_group("player").get_node("KOMSignalBus").emit_signal("Activate_Player_Target")


func _on_kill_button_pressed():
	get_tree().get_first_node_in_group("player").get_node("KOMSignalBus").emit_signal("Kill_pomp")


func _on_item_grab_pressed():
	get_tree().get_first_node_in_group("player").get_node("KOMSignalBus").emit_signal("Item_Grab")


func _on_flash_light_button_pressed():
	get_tree().get_first_node_in_group("player").get_node("KOMSignalBus").emit_signal("Light_Toggle")
