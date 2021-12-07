extends Control

func _input(event):
	if event.is_action_pressed("pause"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state

func _on_mainmenu_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://StartMenu.tscn")


# warning-ignore:unused_argument
func _on_mainmenu_area_entered(area):
	pass
