extends RigidBody2D
class_name Bullet

export var spreadmaxneg: int
export var spreadmaxpos: int
export var scalingrand = false
export var minscalingrand = 1
export var maxscalingrand = 1
export var initial_velocity = 150
export var particles = false
export var trail = false
export var trail_rare = true
export var rarity_min = 1
export var rarity_max = 5
export var scale_glow = true
export var modulate_amount = .2
export var modulate_glow = false

var powered_up = false

const HitEffect = preload("res://effects/HitEffect.tscn")
const Trail = preload("res://effects/Trail.tscn")
var choosing = 0


func _ready():
	yield(get_tree().create_timer(.1), "timeout")
	visible = true
	var direction = Vector2(initial_velocity, rand_range(spreadmaxneg, spreadmaxpos))
	apply_impulse(Vector2.ZERO, direction)
	rotation = direction.angle()
	$LaserSound.pitch_scale = randf() + 0.4
	$LaserSound.play()
	$Laser.playing = true

	randomize()
	var rand = rand_range(minscalingrand, maxscalingrand)

	if powered_up:
		scalingrand = true

	if scalingrand:
		var to_scale = Vector2(rand, rand)
		if powered_up:
			to_scale += Vector2(1.5, 1.5)
		$Laser.scale = to_scale
		$Collision.scale = to_scale
		if scale_glow:
			$Light.texture_scale += to_scale.x / 3
	var animatedSprite = $Laser
	animatedSprite.frame = rand_range(0, 13)
	if trail:
		if trail_rare:
			var chance = rand_range(rarity_min, rarity_max)
			chance = round(chance)
			if chance == 1:
				var trailinstance = Trail.instance()
				self.add_child(trailinstance)
				if powered_up:
					trailinstance.THICKNESS = rand * 2
		else:
			var trailinstance = Trail.instance()
			self.add_child(trailinstance)
			if powered_up:
				trailinstance.THICKNESS = rand * 2


func create_hit_effect():
	Game.instance_scene_on_main(HitEffect, global_position)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _physics_process(delta):
	if modulate_glow:
		$Light.colors.a -= modulate_amount * delta
