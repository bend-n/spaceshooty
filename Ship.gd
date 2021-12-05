extends KinematicBody2D
class_name playerkinematic

onready var HitEffect = preload("res://HitEffect.tscn")
export var id = 1 setget set_id
signal player_death
signal remove_beam

func set_id(value):
	$Ship.id = value

func _on_Ship_force(force):
# warning-ignore:return_value_discarded
	move_and_slide(force)

func _on_Ship_velocity(velocity):
# warning-ignore:return_value_discarded
	move_and_slide(velocity)

func create_hit_effect():
	var main = get_tree().current_scene
	var hitEffect = HitEffect.instance()
	main.add_child(hitEffect)
	hitEffect.global_position = global_position

func _process(delta):
	if self.is_on_wall():
		$Ship.walled = true

func _on_Ship_player_death():
	emit_signal("player_death")


func _on_Ship_remove_beam(b):
	emit_signal("remove_beam", b)
