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
			yield(Game, "transition_halfway")
			# warning-ignore:return_value_discarded
			get_tree().change_scene(to)
			set_keyboard(keyboard)
			if OS.has_touchscreen_ui_hint():
				turn_off()
		get_tree().paused = false
		just_called = false


func _ready():
	if OS.has_touchscreen_ui_hint():
		turn_off()


var title = "spaceshooty"


func _process(_delta):
	if Engine.get_physics_frames() % 30 == 0:
		OS.set_window_title(title + " | fps: " + str(Engine.get_frames_per_second()))


func turn_off():
	yield(get_tree().create_timer(.3), "timeout")
	get_tree().call_group("keyboard", "hide")
	get_tree().call_group("gamepad", "hide")
	get_tree().call_group("not_mobile", "hide")


func _input(event: InputEvent) -> void:
	if not USE_TOUCH:
		if event is InputEventJoypadButton or event is InputEventJoypadMotion and keyboard == true:
			self.keyboard = false
		elif event is InputEventKey and keyboard == false:
			self.keyboard = true


func set_keyboard(new_keyboard):
	keyboard = new_keyboard
	if new_keyboard == true:
		get_tree().call_group("gamepad", "hide")
		get_tree().call_group("keyboard", "show")
	elif new_keyboard == false:
		get_tree().call_group("keyboard", "hide")
		get_tree().call_group("gamepad", "show")


func instance_scene_on_main(scene, position):
	var main = get_tree().current_scene
	var instance = scene.instance()
	main.call_deferred("add_child", instance)
#	main.add_child(instance)
	instance.global_position = position
	return instance
