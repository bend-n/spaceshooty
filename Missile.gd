extends Area2D

export var speed = 700
export var steer_force = 50.0
var velocity = Vector2.ZERO
var acceleration = Vector2.RIGHT
export var enemy = false
var target = null
const HitEffect = preload("res://HitEffect.tscn")
export var initial_velocity = 200

func _ready():
	if enemy:
		velocity = Vector2(-initial_velocity, 0)
		acceleration = Vector2.LEFT
	else:
		velocity = Vector2(initial_velocity, 0)
		acceleration = Vector2.RIGHT

func start(_transform, _target):
	global_transform = _transform
	rotation += rand_range(-0.09, 0.09)
	velocity = transform.x * speed
	target = _target

func seek():
	var steer = Vector2.ZERO
	if target:
		if is_instance_valid(target):
			var desired = (target.position - position).normalized() * speed
			steer = (desired - velocity).normalized() * steer_force
	return steer

func _physics_process(delta):
	acceleration += seek()
	velocity += acceleration * delta
	rotation = velocity.angle()
	position += velocity * delta

func create_hit_effect():
	var main = get_tree().current_scene
	var hitEffect = HitEffect.instance()
	main.add_child(hitEffect)
	hitEffect.global_position = global_position

