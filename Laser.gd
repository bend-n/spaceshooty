extends RigidBody2D

export var steer_force = 50.0
export var speed = 400
export var spreadminpos:int
export var spreadmaxpos:int
export var spreadmaxneg:int
export var spreadminneg:int
export var spread = true
export var scalingrand = false
export var minscalingrand = 1
export var maxscalingrand = 3
export var FRICTION = 300
var target = null 
var rotation_pos
var rotation_neg
var to_rotate
var dir = Vector2.ZERO
var velocity = Vector2.ZERO
export var initial_velocity = 0
export var particles = false

const HitEffect = preload("res://HitEffect.tscn")
var choosing = 0

func _ready():
	velocity.x += initial_velocity
	if particles: $CPUParticles2D.emitting = true
	randomize() 
	if scalingrand:
		var rand = rand_range(minscalingrand, maxscalingrand)
		$Laser.scale.x = rand
		$Laser.scale.y = rand
		$Collision.scale.x = rand
		$Collision.scale.y = rand
	var animatedSprite = $Laser
	animatedSprite.frame = rand_range(0, 13)
	if spread:
		rotation_pos = rand_range(spreadminpos, spreadmaxpos)
		rotation_neg = rand_range(spreadminneg, spreadmaxneg)
		var rotations = [rotation_pos, rotation_neg]
		choosing = randi() %2
		rotation_degrees = rotations[choosing]

func create_hit_effect():
	var main = get_tree().current_scene
	var hitEffect = HitEffect.instance()
	main.add_child(hitEffect)
	hitEffect.global_position = global_position

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _physics_process(delta):
	if spread:
		dir = Vector2.RIGHT.rotated(rotation)
		velocity = dir * speed * delta
		add_central_force(velocity)
