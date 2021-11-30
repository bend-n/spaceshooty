extends Control
func _process(_delta) -> void:
	match playerstats.gun:
		"rockets":
			$Flak.visible = false
			$Rocket.visible = true
			$Split.visible = false
			$Laser.visible = false
			$Beam.visible = false
		"lasers":
			$Flak.visible = false
			$Laser.visible = true
			$Rocket.visible = false
			$Split.visible = false
			$Beam.visible = false
		"splitshot":
			$Flak.visible = false
			$Split.visible = true
			$Laser.visible = false
			$Rocket.visible = false
			$Beam.visible = false
		"beam":
			$Flak.visible = false
			$Laser.visible = false
			$Rocket.visible = false
			$Split.visible = false
			$Beam.visible = true
		"flak":
			$Flak.visible = true
			$Laser.visible = false
			$Rocket.visible = false
			$Split.visible = false
			$Beam.visible = false
