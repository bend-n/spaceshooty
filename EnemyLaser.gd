extends RigidBody2D

const HitEffect = preload("res://HitEffect.tscn")

func _ready():
	randomize() 
	var animatedSprite = $AnimatedSprite
	animatedSprite.frame = rand_range(0, 13)

func create_hit_effect():
	var main = get_tree().current_scene
	var hitEffect = HitEffect.instance()
	main.add_child(hitEffect)
	hitEffect.global_position = global_position

func _on_VisibilityNotifier2D_screen_exited(): queue_free()

