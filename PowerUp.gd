extends Area2D

func _on_PowerUp_area_entered(area): 
	if area.is_in_group("Player"): playerstats.power = true
	get_tree().current_scene.score += 100
	$AnimationPlayer.play('death')
	$confetti.emitting = true

const ExplosionEffect = preload("res://effects/ExplosionEffect.tscn")
const HitEffect = preload("res://effects/HitEffect.tscn")

func create_hit_effect():
	var main = get_tree().current_scene
	var hitEffect = HitEffect.instance()
	main.add_child(hitEffect)
	hitEffect.global_position = global_position

func create_explosion():
	var main = get_tree().current_scene
	var explosionEffect = ExplosionEffect.instance()
	main.add_child(explosionEffect)
	explosionEffect.global_position = global_position

func _ready():
	$confetti.emitting = false
	$Sprite.visible = true

func _on_Timer_timeout():
	$AnimationPlayer.play("death")

