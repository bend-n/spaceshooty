class_name Enemy
extends Area2D

var count = 0
var target
export var drop_power_up = false
export var missile = false
export var ARMOR = 20
export var score_on_kill = 10
const ExplosionEffect = preload("res://effects/ExplosionEffect.tscn")
export var Laser = preload("res://bullets/scenes/EnemyLaser.tscn")
export var SPEED = 25
onready var timer = $Timer
export var shootspeed = 1.5
var target_destination = Vector2.ZERO
var damagetobesubtracted
export var stop_pos = Vector2(200, 0)
onready var tween = $Tween


func _ready():
	target = get_parent().target
	timer.wait_time = shootspeed
	target_destination = global_position


func _process(delta):
	if global_position.x > stop_pos.x:
		global_position.x -= SPEED * delta


func _exit_tree():
	if drop_power_up and randi() % 10 == 2:
		var powerUp = preload("res://PowerUp.tscn")
		Game.instance_scene_on_main(powerUp, global_position)


func damage():
	damagetobesubtracted = rand_range(enemy_damage.min_damage, enemy_damage.max_damage)
	damagetobesubtracted = round(damagetobesubtracted)
	ARMOR -= damagetobesubtracted
	if ARMOR <= 0:
		add_to_score()
		create_explosion()
		queue_free()


func _on_Enemy_body_entered(body):
	if not body.is_in_group("laser"):
		body.create_hit_effect()
		if not body.is_in_group("Player"):
			body.queue_free()
			damage()


func _on_Enemy_area_entered(area):
	if not area.is_in_group("laser"):
		if not area.is_in_group("Player"):
			area.create_hit_effect()
			area.queue_free()
			damage()

	elif area.is_in_group("laser"):
		self.visible = true
		var beam = get_overlapping_bodies()
		if beam != null:
			yield(get_tree().create_timer(.4), "timeout")
			damage()


func add_to_score():
	var main = get_tree().current_scene
	if main.is_in_group("World"):
		main.score += score_on_kill


func create_explosion():
	Game.instance_scene_on_main(ExplosionEffect, global_position)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Timer_timeout():
	if not missile:
		var laser = Game.instance_scene_on_main(Laser, global_position)
		laser.apply_impulse(Vector2.ZERO, Vector2(-50, 0))
	elif missile == true:
		var missiles = preload("res://bullets/scenes/missile.tscn")
		var m = Game.instance_scene_on_main(missiles, global_position)
		m.start(target)


func _on_sidestep_timeout():
	var choosing = randi() % 2
	var choice = [30, -30]
	target_destination = global_position + Vector2(0, choice[choosing])
	if target_destination.y > 160:
		target_destination.y = 160
	elif target_destination.y < 10:
		target_destination.y = 10
	tween.interpolate_property(
		self,
		"position",
		global_position,
		target_destination,
		1,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()
