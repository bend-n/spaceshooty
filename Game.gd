extends Node2D

signal transition_halfway
var just_called = false

func halfway():
	emit_signal("transition_halfway")

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
		get_tree().paused = false
		just_called = false
