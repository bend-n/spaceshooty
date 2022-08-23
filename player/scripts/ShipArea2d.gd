extends Area2D

var target = null setget tar

signal target


func tar(tget):
	emit_signal("target", tget)


func _physics_process(_delta):
	if !target or not is_instance_valid(target):
		find_target()


func find_target():
	var units = get_overlapping_areas()
	if units.size() > 0:
		var closest = units[0]
		for unit in units:
			if (
				position.distance_to(unit.global_position)
				< position.distance_to(closest.global_position)
			):
				closest = unit
		self.target = closest
	else:
		self.target = null
