# Scene with a checkbox to switch settings with boolean values
tool
extends Control

signal toggled(is_button_pressed)

export var title := "" setget set_title

func _on_CheckBox_toggled(button_pressed: bool) -> void:
	emit_signal("toggled", button_pressed)



func set_title(value: String) -> void:
	title = value
	# Wait until the scene is ready if `label` is null.
	if not $CheckBox:
		yield(self, "ready")
	# Update the label's text
	$CheckBox.text = title
