class_name Enemy
extends Area2D


export var ARMOR = 20
export var score_on_kill = 10
const ExplosionEffect = preload("res://ExplosionEffect.tscn")
export var Laser = preload("res://EnemyLaser.tscn")
export var SPEED = 25
onready var timer = $Timer
export var shootspeed = 1.5

var damagetobesubtracted 
func _ready():
	timer.wait_time = shootspeed

func _process(delta):
	position.x -= SPEED * delta

func _on_Enemy_body_entered(body):
	body.create_hit_effect()
	body.queue_free()
	damagetobesubtracted = rand_range(enemy_damage.min_damage, enemy_damage.max_damage)
	damagetobesubtracted = round(damagetobesubtracted)
	ARMOR -= damagetobesubtracted
	if ARMOR <= 0:
		add_to_score()
		create_explosion()
		queue_free()

func add_to_score():
	var main = get_tree().current_scene
	if main.is_in_group("World"):
		main.score += score_on_kill

func create_explosion():
	var main = get_tree().current_scene
	var explosionEffect = ExplosionEffect.instance()
	main.add_child(explosionEffect)
	explosionEffect.global_position = global_position

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	

func _on_Timer_timeout():
	var laser = Laser.instance()
	var main = get_tree().current_scene
	main.add_child(laser)
	laser.global_position = global_position
