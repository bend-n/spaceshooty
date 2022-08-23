extends RigidBody2D

export(float) var TERMINAL_VELOCITY := 300.0
export(float) var CONSTANT_THRUST := 200.0
export(float) var TURN_STRENGTH := 15.0
var off_screen = false
onready var target_last_position
var TARGET
var powered_up


func start(_target):
	TARGET = _target
	if is_instance_valid(TARGET):
		target_last_position = TARGET.global_position
	else:
		linear_velocity.x = CONSTANT_THRUST


func _physics_process(delta: float) -> void:
	if is_instance_valid(TARGET):
		var target_position = (
			TARGET.global_position
			+ (TARGET.global_position - target_last_position) / delta
		)
		target_last_position = TARGET.global_position
		var direction: Vector2 = global_position.direction_to(target_position - linear_velocity)
		var attenuate_turning: float = global_transform.y.dot(
			direction.rotated(angular_velocity * delta)
		)
		apply_torque_impulse(TURN_STRENGTH * attenuate_turning)
		var apply_thrust := Vector2()
		if linear_velocity.length() < TERMINAL_VELOCITY:
			var attenuate_thrust: float = clamp(global_transform.x.dot(direction), 0, 1)
			apply_thrust = global_transform.x * CONSTANT_THRUST * attenuate_thrust
			apply_central_impulse(apply_thrust)


const ExplosionEffect = preload("res://effects/ExplosionEffect.tscn")
const HitEffect = preload("res://effects/HitEffect.tscn")


func create_hit_effect():
	Game.instance_scene_on_main(HitEffect, global_position)


func create_explosion():
	Game.instance_scene_on_main(ExplosionEffect, global_position)


func _exit_tree():
	if not off_screen:
		create_explosion()


func _on_VisibilityNotifier2D_screen_exited():
	if randi() % 6 != 5:
		off_screen = true
		queue_free()


func _ready():
	$LaserSound.pitch_scale = randf() + 0.4
	var minscalingrand = 1
	var maxscalingrand = 1
	if powered_up:
		CONSTANT_THRUST -= 20
		TURN_STRENGTH += 20
		minscalingrand += 1
		maxscalingrand += 2
	var rand = rand_range(minscalingrand, maxscalingrand)
	var to_scale = Vector2(rand, rand)
	$Sprite.scale = to_scale
	$Light.texture_scale = to_scale.x
	$CollisionPolygon2D.scale = to_scale
	if powered_up:
		$Trail.THICKNESS += rand * 2
