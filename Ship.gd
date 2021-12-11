extends KinematicBody2D
class_name playerkinematic

onready var HitEffect = preload("res://HitEffect.tscn")
signal player_death

# warning-ignore:return_value_discarded
func _on_Ship_force(force): move_and_slide(force)

# warning-ignore:return_value_discarded
func _on_Ship_velocity(velocity): 
	move_and_slide(velocity)

func create_hit_effect():
	var main = get_tree().current_scene
	var hitEffect = HitEffect.instance()
	main.add_child(hitEffect)
	hitEffect.global_position = global_position

func _process(_delta):
	if self.is_on_wall(): $Ship.walled = true
	else: $Ship.walled = false

func _on_Ship_player_death(): emit_signal("player_death")

