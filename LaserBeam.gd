extends Node2D

const MAX_LENGTH = 500
var Ray
onready var beam = $Beam
onready var end = $End
onready var rayCast = $RayCast2D


func _physics_process(_delta):
	var mouse_position = get_local_mouse_position()
	var max_cast_to = mouse_position.normalized() * MAX_LENGTH
	rayCast.cast_to = max_cast_to
	if rayCast.is_colliding():
		var obj = rayCast.get_collider()
		if obj.is_in_group("ebullet"):
			end.global_position = rayCast.get_collision_point()
			$End/Particles2D.emitting = false
			beam.region_rect.end.x = end.position.length()
		else:
			$End/Particles2D.emitting = true
			end.global_position = rayCast.get_collision_point()
			beam.region_rect.end.x = end.position.length()
	else:
		$End/Particles2D.emitting = false
		end.global_position = rayCast.cast_to
		beam.region_rect.end.x = end.global_position.length()
	beam.rotation = rayCast.cast_to.angle()
	beam.region_rect.end.x = end.position.length()
