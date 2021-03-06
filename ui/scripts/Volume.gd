extends HSlider
export var audio_bus_name := "Master"
onready var _bus := AudioServer.get_bus_index(audio_bus_name)


func _ready() -> void:
	value = db2linear(AudioServer.get_bus_volume_db(_bus))


func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus, linear2db(value))


func _on_VolumeSlider_gui_input(event):
	if event.is_action("ui_left"):
		value -= .009
	elif event.is_action("ui_right"):
		value += .009
