extends Node
class_name playerstatz

var alive = true
var dev_mode = false
var beam = true
var splitshot = true
var multiplayerlocal = false
var rockets = true
var lasers = true
var flak = true
var gun = "lasers"
var power = false setget set_powerup
export(int) var max_hp = 3 setget set_max_health
var hp = max_hp setget set_health
var recent_score: int

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


func set_powerup(new_power):
	power = new_power
	if power:
		var t = get_tree().create_timer(8)
		t.connect("timeout", self, "set_powerup", [false])
