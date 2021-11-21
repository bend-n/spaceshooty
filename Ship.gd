extends KinematicBody2D

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
onready var sprite = $Sprite
var velocity = Vector2.ZERO
signal player_death
var ACCELERATION = 500
var FRICTION = 400
var recoil = 40
var input_vector = Vector2.ZERO
var USE_TOUCH = OS.has_touchscreen_ui_hint()

func _ready() -> void:
	print(USE_TOUCH)
	$MobileJoystick/TouchScreenButton.visible = USE_TOUCH
	$MobileJoystick/MobileControls/Attack.visible = USE_TOUCH
	$AnimationTree.active = true

func _physics_process(delta):
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
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
	if Input.is_action_just_pressed("ui_end"):
		queue_free()
	if Input.is_action_pressed("ui_accept") or Input.is_action_just_released("ui_accept"):
		firing = true
		position.x -= recoil * delta
	else:
		firing = false
	if Input.is_action_just_pressed("ui_focus_next"):
		match playerstats.gun:
			"lasers":
				splitshot()
			"splitshot":
				rockets()
			"rockets":
				lasers()
	move()
	flipping()
func unrotate():
	$Sprite.rotation_degrees = 0

func flipping():
	pass
#	if firing:
#		$Sprite.flip_h = true
#		unrotate()
#	elif velocity.x != 0 and velocity.y != 0:
#		if velocity.x > 0:
#			$Sprite.flip_h = false
#		elif velocity.x < 0:
#			$Sprite.flip_h = true
#		unrotate()
#	else: 
#		if velocity.y > 0:
#			$Sprite.rotation_degrees = 90
#		elif velocity.y < 0:
#			$Sprite.rotation_degrees = -90

func rockets():
	timer.wait_time = .5
	enemy_damage.min_damage = 10
	enemy_damage.max_damage = 30
	movementpenalty = 60
	recoil = 100
	attack = preload("res://Rocket.tscn")
	playerstats.gun = "rockets"
	print("ROCKETS AHOY")

func lasers():
	timer.wait_time = .1
	enemy_damage.min_damage = 3
	enemy_damage.max_damage = 6
	movementpenalty = 20
	recoil = 40
	attack = preload("res://Laser.tscn")
	playerstats.gun = "lasers"
	print("BONKITY BONK")

func splitshot():
	timer.wait_time = 0.01
	enemy_damage.min_damage = .2
	enemy_damage.max_damage = 1
	recoil = 135
	movementpenalty = 130
	attack = preload("res://SplitShot.tscn")
	playerstats.gun = "splitshot"
	print("BAP BAP BAP")

func move():
	velocity = move_and_slide(velocity)


func _on_Timer_timeout(): #shoot
	if firing:
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
	body.queue_free()
	play()

func play():
	hitSound.play()

func _on_AudioStreamPlayer_finished():
	playerstats.hp -= 1
	if playerstats.hp <= 0:
		queue_free()

func create_hit_effect():
	var main = get_tree().current_scene
	var hitEffect = HitEffect.instance()
	main.add_child(hitEffect)
	hitEffect.global_position = global_position


func _on_TouchScreenButton_force(force):
	move_and_slide(force)
