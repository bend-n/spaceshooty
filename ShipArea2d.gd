extends Area2D

var target = null

func _physics_process(delta):
	if !target or not is_instance_valid(target): find_target()
	
func find_target():
	var units = get_overlapping_areas()
	if units.size() > 0:
		var closest = units[0]
		for unit in units:
			if position.distance_to(unit.global_position) < position.distance_to(closest.global_position): closest = unit
		target = closest
	else:
		target = null
