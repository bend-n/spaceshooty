extends Node2D

onready var ray = $RayCast2D
onready var line = $Line2D
var on
var max_bounces = 5

func _ready():
	on = true

func _process(_delta):
	line.clear_points()
	if on:
		ray.clear_exceptions()
		line.add_point(Vector2.ZERO)
		$End.global_position = ray.get_collision_point()
		ray.global_position = line.global_position
		ray.cast_to = (get_global_mouse_position()- line.global_position).normalized() * 500
		ray.force_raycast_update()
		
		var bounces = 0
		
		while true:
			ray.clear_exceptions()
			if not ray.is_colliding():
				ray.clear_exceptions()
				var pt = ray.global_position + ray.cast_to
				line.add_point(line.to_local(pt))
				$End/CPUParticles2D.emitting = false
				break 
			$End.global_position = ray.get_collision_point()
			$End/CPUParticles2D.emitting = true
			var coll = ray.get_collider()
			var pt = ray.get_collision_point()
			
			line.add_point(line.to_local(pt))
			
			if not coll.is_in_group("ebullet"):
				break
			
			var normal = ray.get_collision_normal()
			
			if normal == Vector2.ZERO:
				break
			ray.add_exception(coll)
#			if prev != null:
#				prev.collision_mask = 9
#				prev.collision_layer = 9
#			prev = coll
#			prev.collision_mask = 0
#			prev.collision_layer = 0
			
			ray.global_position = pt
			ray.cast_to = ray.cast_to.bounce(normal)
			ray.force_raycast_update()
			
			bounces += 1
			if bounces >= max_bounces:
				break
#
#		if prev != null:
#			prev.collision_mask = 9
#			prev.collision_layer = 9
