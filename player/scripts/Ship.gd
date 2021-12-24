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
var FRICTION = 400
var recoil = 40
var input_vector = Vector2.ZERO
var USE_TOUCH = OS.has_touchscreen_ui_hint()
onready var splitshotu
onready var rocketsu
onready var lasersu
onready var flaku
onready var beamu
onready var fire = $Fire
var amount = 1
var target = null
var firing = false
var thrusting_last_frame = false
var shake_intensity = .3
var quant = 30
var shake_duration = .2
var triple_shot


func _ready():
	playerstats.gun = "lasers"
	$MobileJoystick/TouchScreenButton.visible = USE_TOUCH
	$MobileJoystick/MobileControls/Attack.visible = USE_TOUCH
	$"MobileJoystick/MobileControls/Change gun".visible = USE_TOUCH
	$AnimationTree.active = true
	lasersu = playerstats.lasers
	rocketsu = playerstats.rockets
	splitshotu = playerstats.splitshot
	flaku = playerstats.flak
	beamu = playerstats.beam


func create_hit_effect():
	var main = get_tree().current_scene
	var hitEffect = HitEffect.instance()
	main.add_child(hitEffect)
	hitEffect.global_position = global_position


func _physics_process(delta):
	input_vector.x = Input.get_axis("left_%s" % id, "right_%s" % id)
	input_vector.y = Input.get_axis("up_%s" % id, "down_%s" % id)
	if Game.keyboard:
		input_vector = input_vector.normalized()
	if $MobileJoystick/TouchScreenButton.in_use:
		input_vector = $MobileJoystick/TouchScreenButton.force
	#makes a input vector based off of inputs, and supports controllers
	# fire particle code
	var fire_dir = input_vector * -1
	fire.direction = fire_dir

	if input_vector.x > 0 or input_vector.y != 0:
		$Sprite/Particles2D.emitting = true
		fire.emitting = true
	else:
		$Sprite/Particles2D.emitting = false
		fire.emitting = false

	if input_vector != Vector2.ZERO:
		if not thrusting_last_frame:
			$thrustsfxin.playing = true

		if not $thrustsfxloop.playing:
			$thrustsfxloop.playing = true

		if $thrustsfxend.playing:
			pass

		thrusting_last_frame = true
	else:
		if thrusting_last_frame:
			$thrustsfxloop.playing = false
			$thrustsfxend.playing = true

			if $thrustsfxin.playing:
				$thrustsfxin.playing = false

		thrusting_last_frame = false
	if input_vector != Vector2.ZERO:  #moves ya
		velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION * delta)
		$AnimationTree.set("parameters/Turn/blend_position", input_vector)
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
				splitshot()
			"splitshot":
				flak()
			"flak":
				lasers()
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
		triple_shot = false
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
		triple_shot = false
		shake_intensity = .4
		shake_duration = .3
		wait_time = 1
		amount = 1
		quant = 4
		enemy_damage.min_damage = 10
		enemy_damage.max_damage = 30
		movementpenalty = 60
		recoil = 200
		playerstats.gun = "rockets"


func lasers():
	if lasersu:
		triple_shot = false
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
		triple_shot = true
		wait_time = 0.05
		shake_intensity = .2
		amount = .5
		shake_duration = .2
		enemy_damage.min_damage = .1
		enemy_damage.max_damage = .4
		recoil = 17
		movementpenalty = 130
		attack = preload("res://bullets/scenes/SplitShot.tscn")
		playerstats.gun = "splitshot"


func shoot():  #shoot
	_go_into_cooldown()
	if !firing:
		firing = true
	Shake.shake(shake_intensity, shake_duration)
	if playerstats.gun == "rockets":
		if not self.is_on_wall():
			velocity.x -= recoil
		else:
			velocity.x -= recoil / 10
		var missiles = preload("res://bullets/scenes/missile.tscn")
		var m = missiles.instance()
		var main = get_tree().current_scene
		m.global_position = $Trail/LeftWingtip.global_position
		m.start(target)
		if playerstats.power:
			m.powered_up = true
		main.add_child(m)
		var laser2 = missiles.instance()
		laser2.global_position = $Trail2/RightWingtip.global_position
		if playerstats.power:
			laser2.powered_up = true
		main.add_child(laser2)
		laser2.start(target)

	else:
		if not self.is_on_wall():
			velocity.x -= recoil
		else:
			velocity.x -= recoil / 10
		var laser = attack.instance()
		var main = get_tree().current_scene
		laser.global_position = global_position
		if playerstats.power:
			laser.powered_up = true
		main.add_child(laser)
		if triple_shot:
			var laser2 = attack.instance()
			laser2.global_position = $Trail2/RightWingtip.global_position
			if playerstats.power:
				laser2.powered_up = true
			main.add_child(laser2)

			var laser3 = attack.instance()
			laser3.global_position = $Trail/LeftWingtip.global_position
			if playerstats.power:
				laser3.powered_up = true
			main.add_child(laser3)


func _exit_tree():
	playerstats.alive = false
	var main = get_tree().current_scene
	var explosionEffect = ExplosionEffect.instance()
	main.call_deferred("add_child", explosionEffect)
	explosionEffect.global_position = global_position
	emit_signal("player_death")


func _on_target_getter_target(_target):
	target = _target
