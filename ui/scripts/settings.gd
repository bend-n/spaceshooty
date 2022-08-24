extends Control

signal back


func called():
	show()
	$"%BackButton".grab_focus()


func _on_UIResolutionSelector_resolution_changed(new_resolution: Vector2) -> void:
	OS.set_window_size(new_resolution)


func _on_UIFullscreenCheckbox_toggled(button_pressed: bool) -> void:
	OS.window_fullscreen = button_pressed


func _on_UIVsyncCheckbox_toggled(button_pressed: bool) -> void:
	OS.vsync_enabled = button_pressed


func _on_BackButton_pressed():
	emit_signal("back")


func _on_bullet_lights_toggled(button_pressed):
	get_tree().call_group("pbullet", "set_lights", button_pressed)
	ProjectSettings.set_setting("global/bullet_lights", button_pressed)
