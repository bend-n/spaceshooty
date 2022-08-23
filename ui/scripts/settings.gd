extends Control

signal back


func called():
	self.show()
	yield(get_tree().create_timer(.3), "timeout")
	$ColorRect/VBoxContainer/Back.grab_focus()


func _on_Back_gui_input(event):
	if event.is_action("ui_accept"):
		emit_signal("back")


func controls():
	$"../pause2".hide()
	$"../pause1".hide()


func uncontrols():
	$"../pause2".show()
	$"../pause1".show()


signal apply_button_pressed(settings)

var _settings := {resolution = Vector2(1280, 720), fullscreen = false, vsync = false}


func _on_UIResolutionSelector_resolution_changed(new_resolution: Vector2) -> void:
	_settings.resolution = new_resolution
	emit_signal("apply_button_pressed", _settings)


func _on_UIFullscreenCheckbox_toggled(is_button_pressed: bool) -> void:
	_settings.fullscreen = is_button_pressed
	emit_signal("apply_button_pressed", _settings)


func _on_UIVsyncCheckbox_toggled(is_button_pressed: bool) -> void:
	_settings.vsync = is_button_pressed
	emit_signal("apply_button_pressed", _settings)


func _on_InputMenu_controls():
	controls()


func _on_InputMenu_uncontrolled():
	uncontrols()
