extends Control

onready var laser := $Laser
onready var rocket := $Rocket
onready var split := $Split
onready var flak := $Flak


func _process(_delta) -> void:
	laser.visible = playerstats.gun == "lasers"
	flak.visible = playerstats.gun == "flak"
	split.visible = playerstats.gun == "splitshot"
	rocket.visible = playerstats.gun == "rockets"
