extends RigidBody2D
const HitEffect = preload("res://HitEffect.tscn")
#onready var player = get_tree().get_nodes_in_group("Player").front()
var player
export var speed = 500.0
export var accelaration = 5.0
export var turn_speed = 4
export var turn_accelaration = 0.5
export var initial_velocity = 200
var count = 0
var dir = Vector2.ZERO
var velocity = Vector2.ZERO

func _start(_target):
	player = _target

func _physics_process(delta):
	dir = Vector2.RIGHT.rotated(rotation)
	velocity = dir * speed * delta
	add_central_force(velocity)

func create_hit_effect():
	var main = get_tree().current_scene
	var hitEffect = HitEffect.instance()
	main.add_child(hitEffect)
	hitEffect.global_position = global_position
