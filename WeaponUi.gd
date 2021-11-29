extends Control
export var using_id_2 = false
func _process(_delta) -> void:
	if using_id_2:
		match playerstats_2.gun:
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
	else:
		match playerstats_1.gun:
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
