extends Node2D

signal transition_halfway

func halfway():
	emit_signal("transition_halfway")

func transition(to = null):
	get_tree().paused = true
	$transitionAnimation.stop(true)
	$transitionAnimation.play("fadeinout")
	if to:
		yield(Game, "transition_halfway")
		get_tree().change_scene(to)
	get_tree().paused = false
