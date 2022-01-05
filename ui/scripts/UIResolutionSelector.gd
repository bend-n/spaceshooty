# Scene with an OptionButton to select the resolution from a list of options
extends OptionButton
var focused_now
# Emitted when the selected resolution changes.
signal resolution_changed(new_resolution)


func _update_selected_item(text: String) -> void:
	# The resolution options are written in the form "XRESxYRES".
	# Using `split_floats` we get an array with both values as floats.
	var values := text.split_floats("x")
	# Emit a signal for informing the newly selected resolution
	emit_signal("resolution_changed", Vector2(values[0], values[1]))


func _on_OptionButton_item_selected(_index: int) -> void:
	_update_selected_item(self.text)


func _on_OptionButton_item_focused(index):
	focused_now = index


func _on_OptionButton_gui_input(event):
	if event.is_action("ui_accept") and focused_now != null:
		_on_OptionButton_item_selected(focused_now)
