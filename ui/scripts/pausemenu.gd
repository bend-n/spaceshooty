extends Control

var setting = false
export var trigger = "pause"
export var pausing = true


func _ready():
	$ColorRect/settings/ColorRect/pause.visible = pausing
	$ColorRect/settings/ColorRect/pause2.visible = pausing
	$ColorRect/pause1.visible = pausing
	$ColorRect/pause2.visible = pausing
	$ColorRect/pause_icon.visible = pausing
	$ColorRect/settings/ColorRect/pause_icon.visible = pausing


func _input(event):
	if event.is_action_pressed(trigger):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state
		if new_pause_state:
			$ColorRect/VBoxContainer/mainmenu.grab_focus()
			$ColorRect/settings/ColorRect/Stars.emitting = true
		elif new_pause_state == false:
			$ColorRect/settings.hide()
			$ColorRect/settings/ColorRect/Stars.emitting = false


func _exit_tree():
	get_tree().paused = false


func _on_settings_back():
	$ColorRect/settings.visible = false
	yield(get_tree().create_timer(.3), "timeout")
	$ColorRect/VBoxContainer/mainmenu.grab_focus()
	setting = false


func update_settings(settings: Dictionary) -> void:
	OS.window_fullscreen = settings.fullscreen
	OS.set_window_size(settings.resolution)
	OS.vsync_enabled = settings.vsync


func _on_settings_apply_button_pressed(settings) -> void:
	update_settings(settings)


# warning-ignore:return_value_discarded
func _on_mainmenu_gui_input(event):
	if event.is_action("ui_accept"):
		Game.transition("res://ui/scenes/StartMenu.tscn")


func _on_options_gui_input(event):
	if event.is_action("ui_accept"):
		if setting != true:
			setting = true
			$ColorRect/settings.called()


func _on_exit_gui_input(event):
	if event.is_action("ui_accept"):
		Game.exit()
