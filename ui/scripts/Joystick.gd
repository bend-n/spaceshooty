extends TouchScreenButton


func angle_to_vec(angle: float) -> Vector2:
	return Vector2(cos(angle), sin(angle))


func weighted_average(a: Vector2, b: Vector2, weight: float) -> Vector2:
	return a * weight + b * (1.0 - weight)


var radius: float
var center: Vector2
var event_index = -1
var in_use: bool = false
var force: Vector2 = Vector2()
const FRICTION = 400
onready var handle = $"%Handle"


func _ready():
	radius = normal.get_width() * global_scale.x / 2
	center = global_position + Vector2(radius, radius)
	handle.global_position = center


func _input(event):
	if event is InputEventScreenDrag || (event is InputEventScreenTouch && event.is_pressed()):
		var dist = event.position.distance_to(center)

		if dist <= radius or event.get_index() == event_index:
			event_index = event.get_index()
			in_use = true

			var clamped_dist = min(dist, radius)
			var angle = event.position.angle_to_point(center)

			force = angle_to_vec(angle) * clamped_dist / radius

			handle.global_position = center + force.normalized() * clamped_dist

	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == event_index:
		event_index = -1
		in_use = false


func _process(delta):
	# Return the button to the center of the joystick
	if !in_use:
		handle.global_position = weighted_average(handle.global_position, center, 0.8)
		force = force.move_toward(Vector2.ZERO, FRICTION * delta)
