extends Node2D

signal cs
signal transition_halfway
var just_called = false

func halfway(): emit_signal("transition_halfway")
func exit(): get_tree().quit()

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
			if OS.has_touchscreen_ui_hint(): turn_off()
		get_tree().paused = false
		just_called = false

func _ready(): if OS.has_touchscreen_ui_hint(): turn_off()

var title = "spaceshooty"

func _process(_delta): OS.set_window_title(title + " | fps: " + str(Engine.get_frames_per_second()))

func turn_off(): # refer to playerstats
	yield(get_tree().create_timer(.3),"timeout")
	get_tree().call_group("keyboard", "hide")
	get_tree().call_group("gamepad", "hide")
	get_tree().call_group("not_mobile", "hide")
