extends Control
var focused

func _input(event):
	if event.is_action_pressed("pause"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state
		if new_pause_state:
			$ColorRect/VBoxContainer/mainmenu.grab_focus()

func _process(delta):
	focused = get_focus_owner()
	if Input.is_action_just_pressed("ui_accept"):
		if focused == $ColorRect/VBoxContainer/mainmenu:
			get_tree().change_scene("res://StartMenu.tscn")
		elif $ColorRect/VBoxContainer/options:
			pass
