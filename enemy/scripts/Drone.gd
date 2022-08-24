extends RigidBody2D

var alive = true
var asleep = false
var health = 15
var COOLDOWN = 1

var hovering

export var MAX_SPEED = 50
export var MAX_THRUST = 25


func _integrate_forces(state):
	if not alive:
		return

	if asleep:
		return

	var delta = state.get_step()

	# Check nearby objects with raycast
	var closest_collision = null
	$rays.rotation += delta * 11 * PI
	for ray in $rays.get_children():
		if ray.is_colliding():
			var collision_point = ray.get_collision_point() - global_position
			if closest_collision == null:
				closest_collision = collision_point
			if collision_point.length() < closest_collision.length():
				closest_collision = collision_point

	# Dodge
	if closest_collision:
		var normal = -closest_collision.normalized()
		var dodge_direction = 1
		if randf() < 0.5:
			dodge_direction = -1
		linear_velocity += normal * MAX_THRUST * 2 * delta
		linear_velocity += normal.rotated(PI / 2 * dodge_direction) * MAX_THRUST * delta

	# Steer towards player
	var distance_to_player = global_position.distance_to($"../../Ship".global_position)
	var vector_to_player = ($"../../Ship".global_position - global_position).normalized()

	# Rotate turret
	var start = $turret.rotation
	var angle_to_target = Vector2(1, 0).rotated(start).angle_to(vector_to_player)
	var end = start + angle_to_target
	$Tween.interpolate_property($turret, "rotation", start, end, 0.1, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()

	if distance_to_player > 40:
		# Move towards player
		linear_velocity += vector_to_player * MAX_THRUST * delta
		hovering = false
	else:
		# Move away from player
		hovering = false
		linear_velocity += -vector_to_player * MAX_THRUST * delta

	# Clamp max speed
	if linear_velocity.length() > MAX_SPEED:
		linear_velocity = linear_velocity.normalized() * MAX_SPEED


func shoot():
	$shootCooldown.wait_time = COOLDOWN * (1 + rand_range(-0.25, 0.25))
	$shootCooldown.start()

	if not alive:
		return

	if asleep:
		return

	# Start firing animation
	$AnimationPlayer.play("firing")


const Laser = preload("res://bullets/scenes/EnemyLaser.tscn")


func spawn_bullet():
	var laser = Game.instance_scene_on_main(Laser, global_position)
	laser.apply_impulse(Vector2.ZERO, Vector2(-50, 0))


const ExplosionEffect = preload("res://effects/ExplosionEffect.tscn")
const HitEffect = preload("res://effects/HitEffect.tscn")


func create_hit_effect():
	Game.instance_scene_on_main(HitEffect, global_position)


func create_explosion():
	Game.instance_scene_on_main(ExplosionEffect, global_position)


func _exit_tree():
	create_explosion()


func _on_Drone_body_entered(body):
	if body.is_in_group("pbullet"):
		health -= 1
		if health <= 0:
			queue_free()
