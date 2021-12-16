extends Node
class_name playerstatz

var dev_mode = false
var beam = true
var splitshot = true
var multiplayerlocal = false
var rockets = true
var lasers = true
var flak = true
var gun = "lasers"
export(int) var max_hp = 3 setget set_max_health
var hp = max_hp setget set_health
var recent_score :int
var keyboard = true setget set_keyboard
var USE_TOUCH = OS.has_touchscreen_ui_hint()

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
	if hp <= 0: emit_signal("no_hp")

func _ready(): 
	self.hp = max_hp
	if USE_TOUCH: self.keyboard = 0


func _input(event: InputEvent) -> void:
	if not USE_TOUCH:
		if event is InputEventJoypadButton or event is InputEventJoypadMotion and keyboard == true: self.keyboard = false
		elif event is InputEventKey and keyboard == false: self.keyboard = true

func set_keyboard(new_keyboard):
	keyboard = new_keyboard
	if USE_TOUCH:
		get_tree().call_group("keyboard", "hide")
		get_tree().call_group("gamepad", "hide")
	elif new_keyboard == true: 
		get_tree().call_group("gamepad", "hide")
		get_tree().call_group("keyboard", "show")
	elif new_keyboard == false: 
		get_tree().call_group("keyboard", "hide")
		get_tree().call_group("gamepad", "show")

