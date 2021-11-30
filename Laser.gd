extends RigidBody2D

export var homing = false
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
var target = null 
var rotation_pos
var rotation_neg
var to_rotate
var dir = Vector2.ZERO
var velocity

const HitEffect = preload("res://HitEffect.tscn")
var choosing = 0

func _ready():
	randomize() 
	if scalingrand:
		var rand = rand_range(minscalingrand, maxscalingrand)
		$Laser.scale.x = rand
		$Laser.scale.y = rand
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
	if spread or homing:
		dir = Vector2.RIGHT.rotated(rotation)
		velocity = dir * speed * delta
		add_central_force(velocity)


func _on_Timer_timeout():
	if spread:
		linear_velocity.x = 0

