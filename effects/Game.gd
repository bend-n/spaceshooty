extends Node2D

signal transition_halfway
var just_called = false
var keyboard = true setget set_keyboard
var USE_TOUCH = OS.has_touchscreen_ui_hint()


func halfway():
	emit_signal("transition_halfway")


func exit():
	get_tree().quit()


func transition(to = null):
	if just_called == false:
		just_called = true
		get_tree().paused = true
		$transitionAnimation.stop(true)
		$transitionAnimation.play("fadeinout")
		if to:
			get_tree().change_scene(to)
			yield(self, "transition_halfway")
			set_input_prompts()
		get_tree().paused = false
		just_called = false


func _ready():
	set_input_prompts()
	set_process_input(not USE_TOUCH)


func turn_off():
	get_tree().call_group("keyboard", "hide")
	get_tree().call_group("gamepad", "hide")
	get_tree().call_group("not_mobile", "hide")


func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion and keyboard == true:
		self.keyboard = false
	elif event is InputEventKey and keyboard == false:
		self.keyboard = true


func set_keyboard(new_keyboard):
	keyboard = new_keyboard
	set_input_prompts()


func set_input_prompts():
	if USE_TOUCH:
		get_tree().call_group("not_mobile", "hide")
		get_tree().call_group("mobile", "show")
		get_tree().call_group("keyboard", "hide")
		get_tree().call_group("gamepad", "hide")
	elif keyboard == true:
		get_tree().call_group("not_mobile", "show")
		get_tree().call_group("gamepad", "hide")
		get_tree().call_group("mobile", "hide")
		get_tree().call_group("keyboard", "show")
	elif keyboard == false:
		get_tree().call_group("not_mobile", "show")
		get_tree().call_group("keyboard", "hide")
		get_tree().call_group("mobile", "hide")
		get_tree().call_group("gamepad", "show")


func instance_scene_on_main(scene, position):
	var main = get_tree().current_scene
	var instance = scene.instance()
	main.call_deferred("add_child", instance)
#	main.add_child(instance)
	instance.global_position = position
	return instance
