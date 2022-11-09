extends KinematicBody2D
class_name playerkinematic

var counter
var i_am_in_cooldown: bool
var wait_time = .1
var walled = false
export var id = 1
export var fireoffset = 2
onready var animationState = $AnimationTree.get("parameters/playback")
onready var HitEffect = preload("res://effects/HitEffect.tscn")
onready var hitSound = $AudioStreamPlayer
const ExplosionEffect = preload("res://effects/ExplosionEffect.tscn")
var attack = preload("res://bullets/scenes/Laser.tscn")
export(int) var SPEED = 100
onready var timer = $Timer
var movementpenalty = 20
var velocity = Vector2.ZERO
signal player_death
var ACCELERATION = 500
var FRICTION = 20
var recoil = 40
var input_vector = Vector2.ZERO
var USE_TOUCH = OS.has_touchscreen_ui_hint()
onready var splitshotu
onready var rocketsu
onready var lasersu
onready var flaku
onready var beamu
onready var fire = $Fire
onready var joystick = $MobileControls/MobileJoystick
onready var thrustsfxin = $thrustsfxin
onready var thrustsfxend = $thrustsfxend
onready var thrustsfxloop = $thrustsfxloop
onready var animation_tree = $AnimationTree

var amount = 1
var target = null
var firing = false
var thrusting_last_frame = false
var shake_intensity = .3
var quant = 30
var shake_duration = .2


func _ready():
	playerstats.gun = "lasers"
	animation_tree.active = true
	lasersu = playerstats.lasers
	rocketsu = playerstats.rockets
	splitshotu = playerstats.splitshot
	flaku = playerstats.flak
	beamu = playerstats.beam


func create_hit_effect():
	Game.instance_scene_on_main(HitEffect, global_position)


func _physics_process(delta):
	input_vector.x = Input.get_axis("left_%s" % id, "right_%s" % id)
	input_vector.y = Input.get_axis("up_%s" % id, "down_%s" % id)
	if Game.keyboard:
		input_vector = input_vector.normalized()
	if joystick.in_use:
		input_vector = joystick.force
	#makes a input vector based off of inputs, and supports controllers
	# fire particle code
	var fire_dir = input_vector * -1
	fire.direction = fire_dir

	if input_vector.x > 0 or input_vector.y != 0:
		fire.emitting = true
		fire.initial_velocity = input_vector.x * 40
	else:
		fire.emitting = false

	if input_vector != Vector2.ZERO:
		if not thrusting_last_frame:
			thrustsfxin.playing = true

		if not thrustsfxloop.playing:
			thrustsfxloop.playing = true

		thrusting_last_frame = true
	else:
		if thrusting_last_frame:
			thrustsfxloop.playing = false
			thrustsfxend.playing = true

			if thrustsfxin.playing:
				thrustsfxin.playing = false

		thrusting_last_frame = false
	if input_vector != Vector2.ZERO:  #moves ya
		velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION * delta)
		animation_tree.set("parameters/Turn/blend_position", input_vector)
		animationState.travel("Turn")
	else:
		#stops you
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	if firing:
		SPEED = movementpenalty
		if not i_am_in_cooldown:
			if randi() % quant == quant - 1:
				Glitch.apply(.1, amount)
	else:
		SPEED = 100
	if not i_am_in_cooldown and Input.is_action_pressed("shoot_%s" % id):
		shoot()
	elif not Input.is_action_pressed("shoot_%s" % id):
		firing = false
	if Input.is_action_just_pressed("change_gun_%s" % id):
		match playerstats.gun:
			"lasers":
				rockets()
			"rockets":
				lasers()
#			"splitshot":
#				lasers()
#			"flak":
#				lasers()
	velocity = move_and_slide(velocity)


func _on_TouchScreenButton_force(force):
	input_vector = force


func _on_Ship_area_entered(area):
	if not area.is_in_group("pbullet") and not area.is_in_group("Player"):
		qfreenplay(area)


func qfreenplay(q):
	q.queue_free()
	play()


func _on_Ship_body_entered(body):
	if not body.is_in_group("Player") and not body.is_in_group("pbullet"):
		qfreenplay(body)


func play():
	hitSound.play()


func _on_AudioStreamPlayer_finished():
	playerstats.hp -= 1
	if playerstats.hp <= 0:
		$AnimationPlayer.play("Die Anim")


func _go_into_cooldown():
	i_am_in_cooldown = true
	timer.start(wait_time)
	yield(timer, "timeout")
	i_am_in_cooldown = false


func flak():
	if flaku:
		wait_time = .001
		shake_intensity = .03
		shake_duration = .04
		enemy_damage.min_damage = 15
		enemy_damage.max_damage = 30
		movementpenalty = 0
		quant = 20
		amount = .5
		recoil = 1
		attack = preload("res://bullets/scenes/Flak.tscn")
		playerstats.gun = "flak"


func rockets():
	if rocketsu:
		shake_intensity = .4
		shake_duration = .3
		wait_time = 1
		amount = 1
		quant = 4
		enemy_damage.min_damage = 10
		enemy_damage.max_damage = 30
		movementpenalty = 60
		recoil = 200
		attack = preload("res://bullets/scenes/missile.tscn")
		playerstats.gun = "rockets"


func lasers():
	if lasersu:
		amount = 1
		shake_intensity = .3
		shake_duration = .2
		wait_time = .1
		quant = 20
		enemy_damage.min_damage = 4
		enemy_damage.max_damage = 9
		movementpenalty = 20
		recoil = 20
		attack = preload("res://bullets/scenes/Laser.tscn")
		playerstats.gun = "lasers"


func splitshot():
	if splitshotu:
		quant = 40
		wait_time = 0.05
		shake_intensity = .2
		amount = .5
		shake_duration = .2
		enemy_damage.min_damage = .5
		enemy_damage.max_damage = 1
		recoil = 12
		movementpenalty = 130
		attack = preload("res://bullets/scenes/SplitShot.tscn")
		playerstats.gun = "splitshot"


onready var rocket_muzzles = $Muzzles/RocketMuzzle.get_children()
onready var laser_muzzles = $Muzzles/LaserMuzzle.get_children()


func shoot():  #shoot
	_go_into_cooldown()
	if !firing:
		firing = true
	Shake.shake(shake_intensity, shake_duration)
	match playerstats.gun:
		"rockets":
			for muzzle in rocket_muzzles:
				var bullet = fire(muzzle.global_position, attack)
				bullet.start(target)
		"lasers":
			for muzzle in laser_muzzles:
				fire(muzzle.global_position, attack)


# warning-ignore:function_conflicts_variable
func fire(global_pos, Bullet):
	var bullet = Game.instance_scene_on_main(Bullet, global_pos)
	if playerstats.power:
		bullet.powered_up = true
	if not self.is_on_wall():
		velocity.x -= recoil
	else:
		velocity.x -= recoil / 10
	return bullet


func _exit_tree():
	playerstats.alive = false
	Game.instance_scene_on_main(ExplosionEffect, global_position)
	emit_signal("player_death")


func _on_target_getter_target(_target):
	target = _target
