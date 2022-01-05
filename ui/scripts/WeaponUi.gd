extends Control


func _process(_delta) -> void:
	$Laser.visible = playerstats.gun == "lasers"
	$Flak.visible = playerstats.gun == "flak"
	$Split.visible = playerstats.gun == "splitshot"
	$Rocket.visible = playerstats.gun == "rockets"
