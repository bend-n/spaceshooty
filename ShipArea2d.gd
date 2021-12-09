extends Area2D

var i_am_in_cooldown:bool
var wait_time = .1
var walled = false
export var id = 1
onready var animationState = $AnimationTree.get("parameters/playback")
onready var HitEffect = preload("res://HitEffect.tscn")
onready var hitSound = $AudioStreamPlayer
const ExplosionEffect = preload("res://ExplosionEffect.tscn")
var attack = preload("res://Laser.tscn")
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
var target = null
signal velocity
signal force

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

func _physics_process(delta):
	if !target or not is_instance_valid(target): find_target()
	input_vector.x = Input.get_axis('left_%s' % id, 'right_%s' % id)
	input_vector.y = Input.get_axis('up_%s' % id, 'down_%s' % id)
	input_vector = input_vector.normalized()
	if $MobileJoystick/TouchScreenButton.in_use: input_vector = $MobileJoystick/TouchScreenButton.force
	#makes a input vector based off of inputs, and supports controllers
	if input_vector != Vector2.ZERO:#moves ya
		velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION * delta)
		$AnimationTree.set("parameters/Turn/blend_position", input_vector)
		animationState.travel("Turn")
	else:
		#stops you
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	if i_am_in_cooldown: SPEED = movementpenalty
	else: SPEED = 100
	if not i_am_in_cooldown and Input.is_action_pressed('shoot_%s' % id):
		fire()
		_go_into_cooldown()
	if Input.is_action_just_pressed("change_gun_%s" % id):
		match playerstats.gun:
			"lasers": rockets()
			"rockets": splitshot()
			"splitshot": flak()
			"flak": lasers()
	move()

func find_target():
	var units = get_overlapping_areas()
	if units.size() > 0:
		var closest = units[0]
		for unit in units:
			if position.distance_to(unit.global_position) < position.distance_to(closest.global_position): closest = unit
		target = closest
	else:
		target = null

func flak():
	if flaku:
		wait_time = .0007
		enemy_damage.min_damage = 15
		enemy_damage.max_damage = 50
		movementpenalty = 0
		recoil = 3
		attack = preload("res://Flak.tscn")
		playerstats.gun = "flak"

func rockets():
	if rocketsu:
		wait_time = 1
		enemy_damage.min_damage = 10
		enemy_damage.max_damage = 30
		movementpenalty = 60
		recoil = 300
		playerstats.gun = "rockets"
func lasers():
	if lasersu:
		wait_time = .1
		enemy_damage.min_damage = 3
		enemy_damage.max_damage = 6
		movementpenalty = 20
		recoil = 40
		attack = preload("res://Laser.tscn")
		playerstats.gun = "lasers"
func splitshot():
	if splitshotu:
		wait_time = 0.003
		enemy_damage.min_damage = .2
		enemy_damage.max_damage = 1
		recoil = 40
		movementpenalty = 130
		attack = preload("res://SplitShot.tscn")
		playerstats.gun = "splitshot"
func move(): emit_signal("velocity", velocity)

func _exit_tree():
	var main = get_tree().current_scene
	var explosionEffect = ExplosionEffect.instance()
	main.call_deferred("add_child", explosionEffect)
	explosionEffect.global_position = global_position
	emit_signal("player_death")

func _on_Ship_area_entered(area): if not area.is_in_group("pbullet") or is_in_group("Player"): qfreenplay(area)

func qfreenplay(q):
	q.queue_free()
	play()

func _on_Ship_body_entered(body): if not body.is_in_group("Player") or is_in_group("pbullet"): qfreenplay(body)

func play():
	hitSound.play()

func _on_AudioStreamPlayer_finished():
	playerstats.hp -= 1
	if playerstats.hp <= 0: $AnimationPlayer.play("Die Anim")


func create_hit_effect():
	var main = get_tree().current_scene
	var hitEffect = HitEffect.instance()
	main.add_child(hitEffect)
	hitEffect.global_position = global_position

func _on_TouchScreenButton_force(force): emit_signal("force", force)

func _go_into_cooldown():
  i_am_in_cooldown = true
  timer.start(wait_time)   
  yield(timer, "timeout")
  i_am_in_cooldown = false

func fire(): #shoot
	if playerstats.gun == "rockets":
		if walled == false: velocity.x -= recoil
		else: velocity.x -= recoil / 10
		var missiles = preload("res://missile.tscn")
		var m = missiles.instance()
		var main = get_tree().current_scene
		main.add_child(m)
		m.global_position = global_position
		m._start(target)
	else:
		if walled == false: velocity.x -= recoil
		else: velocity.x -= recoil / 10
		var laser = attack.instance()
		var main = get_tree().current_scene
		main.add_child(laser)
		laser.global_position = global_position
