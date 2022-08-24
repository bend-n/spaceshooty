extends Control

export var hearts = 5 setget set_hearts
export var max_hearts = 5 setget set_max_hearts
onready var fullHearts = $FullHarts
onready var emptyHearts = $EmptyHarts


func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if fullHearts != null:
		fullHearts.rect_size.x = hearts * 15


func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if emptyHearts != null:
		emptyHearts.rect_size.x = max_hearts * 15


func _ready():
	self.hearts = playerstats.hp
	playerstats.connect("hp_changed", self, "set_hearts")
	playerstats.connect("max_hp_changed", self, "set_max_hearts")
