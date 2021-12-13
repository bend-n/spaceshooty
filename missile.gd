extends RigidBody2D


export(float) var TERMINAL_VELOCITY := 300.0
export(float) var CONSTANT_THRUST := 200.0
export(float) var TURN_STRENGTH := 15
onready var target_last_position
var TARGET 

func start(_target):
	TARGET = _target
	target_last_position = TARGET.global_position

func _physics_process(delta: float) -> void:
	if is_instance_valid(TARGET):
		var target_position = TARGET.global_position + (TARGET.global_position - target_last_position)/delta
		target_last_position = TARGET.global_position
		var direction: Vector2 = global_position.direction_to(target_position - linear_velocity)
		var attenuate_turning: float = global_transform.y.dot(direction.rotated(angular_velocity*delta))
		apply_torque_impulse(TURN_STRENGTH * attenuate_turning)
		var apply_thrust := Vector2()
		if linear_velocity.length() < TERMINAL_VELOCITY:
			var attenuate_thrust: float = clamp(global_transform.x.dot(direction), 0, 1)
			apply_thrust = global_transform.x * CONSTANT_THRUST * attenuate_thrust
			apply_central_impulse(apply_thrust)

const HitEffect = preload("res://HitEffect.tscn")
func create_hit_effect():
	var main = get_tree().current_scene
	var hitEffect = HitEffect.instance()
	main.add_child(hitEffect)
	hitEffect.global_position = global_position
