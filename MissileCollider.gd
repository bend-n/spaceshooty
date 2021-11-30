extends RigidBody2D
const HitEffect = preload("res://HitEffect.tscn")

func create_hit_effect():
	var main = get_tree().current_scene
	var hitEffect = HitEffect.instance()
	main.add_child(hitEffect)
	hitEffect.global_position = global_position
