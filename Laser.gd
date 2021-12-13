extends RigidBody2D

export var steer_force = 50.0
export var speed = 400
export var max_speed = 500
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
export var trail = false
export var trail_rare = true
export var rarity_min = 1
export var rarity_max = 5

const HitEffect = preload("res://HitEffect.tscn")
const Trail = preload("res://Trail.tscn")
var choosing = 0

func _ready():
	$LaserSound.pitch_scale = randf() + 0.4
	$LaserSound.play()
	$Laser.playing = true
	if trail:
		if trail_rare:
			var chance = rand_range(rarity_min, rarity_max)
			chance = round(chance)
			if chance == 1:
				var trailinstance = Trail.instance()
				self.add_child(trailinstance)
		else:
			var trailinstance = Trail.instance()
			self.add_child(trailinstance)
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

func _on_VisibilityNotifier2D_screen_exited(): queue_free()

func _physics_process(delta):
	if spread:
		dir = Vector2.RIGHT.rotated(rotation)
		velocity = dir * speed * delta
		velocity = velocity.clamped(max_speed)
		if particles:
			$CPUParticles2D.direction = velocity * -1
		add_central_force(velocity)
