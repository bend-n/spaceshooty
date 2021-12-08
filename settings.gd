extends Control
var volume setget set_volume

signal back

func called():
	visible = true
	$ColorRect/Back.grab_focus()

func set_volume(value):
	pass

func _on_Back_gui_input(event):
	if event.is_action("ui_accept"):
		visible = false
		emit_signal("back")

func _on_Volume_value_changed(value):
	volume = value
