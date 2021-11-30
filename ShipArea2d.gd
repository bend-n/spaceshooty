extends Area2D
class_name playerarea2d
var b

var Beam
onready var beam = preload("res://LaserBeamTest.tscn")
var beaming = false
export var id = 1
onready var animationState = $AnimationTree.get("parameters/playback")
onready var HitEffect = preload("res://HitEffect.tscn")
onready var hitSound = $AudioStreamPlayer
const ExplosionEffect = preload("res://ExplosionEffect.tscn")
var attack = preload("res://Laser.tscn")
var ARMOR = 3
var firing = null
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
	shoot_beam()
	if !target or not is_instance_valid(target):
		find_target()
	input_vector.x = Input.get_action_strength('right_%s' % id) - Input.get_action_strength('left_%s' % id)
	input_vector.y = Input.get_action_strength('down_%s' % id) - Input.get_action_strength('up_%s' % id)
	input_vector = input_vector.normalized()
	if $MobileJoystick/TouchScreenButton.in_use:
		input_vector = $MobileJoystick/TouchScreenButton.force
	#makes a input vector based off of inputs, and supports controllers
	if input_vector != Vector2.ZERO:#moves ya
		velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION * delta)
		$AnimationTree.set("parameters/Turn/blend_position", input_vector)
		animationState.travel("Turn")
	else:
		#stops you
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	if firing:
		SPEED = movementpenalty
	else:
		SPEED = 100
	if Input.is_action_pressed('shoot_%s' % id):
		firing = true
	else:
		firing = false
	if Input.is_action_just_pressed("change_gun_%s" % id):
		match playerstats.gun:
			"lasers":
				rockets()
				beaming = false
			"rockets":
				splitshot()
				beaming = false
			"splitshot":
				beam()
				beaming = true
			"beam":
				beaming = false
				flak()
			"flak":
				lasers()
		
	move()

func find_target():
	var units = get_overlapping_bodies()
	if units.size() > 0:
		var closest = units[0]
		for unit in units:
			if position.distance_to(unit.global_position) < position.distance_to(closest.global_position):
				closest = unit
		target = closest
	else:
		target = null

func flak():
	if flaku:
		timer.wait_time = .0007
		enemy_damage.min_damage = 15
		enemy_damage.max_damage = 50
		movementpenalty = 0
		recoil = 3
		attack = preload("res://Flak.tscn")
		playerstats.gun = "flak"

func rockets():
	if rocketsu:
		timer.wait_time = .6
		enemy_damage.min_damage = 10
		enemy_damage.max_damage = 30
		movementpenalty = 60
		recoil = 200
		playerstats.gun = "rockets"

func lasers():
	if lasersu:
		timer.wait_time = .1
		enemy_damage.min_damage = 3
		enemy_damage.max_damage = 6
		movementpenalty = 20
		recoil = 40
		attack = preload("res://Laser.tscn")
		playerstats.gun = "lasers"

func splitshot():
	if splitshotu:
		timer.wait_time = 0.01
		enemy_damage.min_damage = .2
		enemy_damage.max_damage = 1
		recoil = 10
		movementpenalty = 130
		attack = preload("res://SplitShot.tscn")
		playerstats.gun = "splitshot"

# warning-ignore:function_conflicts_variable
func beam():
	if beamu:
		enemy_damage.min_damage = 1
		enemy_damage.max_damage = 4
		movementpenalty = 20
		playerstats.gun = "beam"

func shoot_beam():
	if beaming:
		if Beam == null:
			Beam = beam.instance()
			add_child(Beam)
			Beam.show_behind_parent = true
	elif Beam != null:
		Beam.queue_free()
		Beam = null

func move():
	emit_signal("velocity", velocity)


func _on_Timer_timeout(): #shoot
	if firing:
		if playerstats.gun == "rockets":
			velocity.x -= recoil
			var missiles = preload("res://Missile.tscn")
			var m = missiles.instance()
			var main = get_tree().current_scene
			main.add_child(m)
			m.global_position = global_position
			m.start(self.global_transform, target)
		elif playerstats.gun == "beam":
			pass
		else:
			velocity.x -= recoil
			var laser = attack.instance()
			var main = get_tree().current_scene
			main.add_child(laser)
			laser.global_position = global_position


func _exit_tree():
	var main = get_tree().current_scene
	var explosionEffect = ExplosionEffect.instance()
	main.add_child(explosionEffect)
	explosionEffect.global_position = global_position
	emit_signal("player_death")

func _on_Ship_area_entered(area):
	area.queue_free()
	play()

func _on_Ship_body_entered(body):
	if not body.is_in_group("Player") or is_in_group("pbullet"):
		body.queue_free()
		play()

func play():
	hitSound.play()

func _on_AudioStreamPlayer_finished():
	playerstats.hp -= 1
	if playerstats.hp <= 0:
		$AnimationPlayer.play("Die Anim")


func create_hit_effect():
	var main = get_tree().current_scene
	var hitEffect = HitEffect.instance()
	main.add_child(hitEffect)
	hitEffect.global_position = global_position


func _on_TouchScreenButton_force(force):
	emit_signal("force", force)
