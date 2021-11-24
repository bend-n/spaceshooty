extends Node

var splitshot = false
var multiplayerlocal = false
var rockets = false
var lasers = true
var gun = "lasers"
export(int) var max_hp = 3 setget set_max_health
var hp = max_hp setget set_health

signal no_hp 
signal hp_changed(value)
signal max_hp_changed(value)

func set_max_health(value):
	max_hp = value
	self.hp = min(hp, max_hp)
	emit_signal("max_hp_changed", value)

func set_health(value):
	hp = value
	emit_signal("hp_changed", hp)
	if hp <= 0:
		emit_signal("no_hp")


func _ready():
	self.hp = max_hp
