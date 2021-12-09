extends Control

onready var _action_list = get_node("ColorRect/Column/ScrollContainer/ActionList")

func _ready():
# warning-ignore:return_value_discarded
	$InputMapper.connect('profile_changed', self, 'rebuild')
	$ColorRect/Column/ProfilesMenu.initialize($InputMapper)
	$InputMapper.change_profile($ColorRect/Column/ProfilesMenu.selected)

func rebuild(input_profile, is_customizable=false):
	_action_list.clear()
	for input_action in input_profile.keys():
		var line = _action_list.add_input_line(input_action, \
			input_profile[input_action], is_customizable)
		if is_customizable:
			line.connect('change_button_pressed', self, \
				'_on_InputLine_change_button_pressed', [input_action, line])

func _on_InputLine_change_button_pressed(action_name, line):
	set_process_input(false)
	
	$ColorRect/KeySelectMenu.open()
	var key_scancode = yield($ColorRect/KeySelectMenu, "key_selected")
	$InputMapper.change_action_key(action_name, key_scancode)
	line.update_key(key_scancode)
	
	set_process_input(true)

func _on_controls_gui_input(event):
	if event.is_action("ui_accept"):
		yield(get_tree().create_timer(.3), "timeout")
		self.show()
		$ColorRect/Column/ScrollContainer/ActionList.grab_focus()
