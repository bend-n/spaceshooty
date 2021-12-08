extends RigidBody2D
const HitEffect = preload("res://HitEffect.tscn")
onready var player = get_tree().get_nodes_in_group("Player").front()
export var speed = 500.0
export var accelaration = 5.0
export var turn_speed = 5.0
export var turn_accelaration = 0.5

func _physics_process(_delta):
	if is_instance_valid(player):
		angular_velocity = move_toward(
			angular_velocity, 
			get_angle_to(player.global_position) * turn_speed, 
			turn_accelaration)
		linear_velocity = linear_velocity.move_toward(
			Vector2.RIGHT.rotated(global_rotation) * speed, 
			accelaration)

func create_hit_effect():
	var main = get_tree().current_scene
	var hitEffect = HitEffect.instance()
	main.add_child(hitEffect)
	hitEffect.global_position = global_position
