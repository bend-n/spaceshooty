extends Control

func _process(delta) -> void:
	match playerstats.gun:
		"rockets":
			$Rocket.visible = true
			$Split.visible = false
			$Laser.visible = false
			$Beam.visible = false
		"lasers":
			$Laser.visible = true
			$Rocket.visible = false
			$Split.visible = false
			$Beam.visible = false
		"splitshot":
			$Split.visible = true
			$Laser.visible = false
			$Rocket.visible = false
			$Beam.visible = false
		"beam":
			$Laser.visible = false
			$Rocket.visible = false
			$Split.visible = false
			$Beam.visible = true
