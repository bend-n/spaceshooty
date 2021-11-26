extends KinematicBody2D
onready var HitEffect = preload("res://HitEffect.tscn")

func _on_Ship_force(force):
	move_and_slide(force)

func _on_Ship_velocity(velocity):
	move_and_slide(velocity)

func create_hit_effect():
	var main = get_tree().current_scene
	var hitEffect = HitEffect.instance()
	main.add_child(hitEffect)
	hitEffect.global_position = global_position
