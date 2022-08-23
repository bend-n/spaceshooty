extends RigidBody2D

const HitEffect = preload("res://effects/HitEffect.tscn")


func _ready():
	randomize()
	var animatedSprite = $AnimatedSprite
	animatedSprite.frame = rand_range(0, 13)


func create_hit_effect():
	Game.instance_scene_on_main(HitEffect, global_position)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
