extends Control

func _process(delta) -> void:
	match playerstats.gun:
		"rockets":
			$Rocket.visible = true
			$Split.visible = false
		"lasers":
			$Laser.visible = true
			$Rocket.visible = false
		"splitshot":
			$Split.visible = true
			$Laser.visible = false
