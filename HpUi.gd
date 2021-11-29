extends Control

export var using_id_2 = false
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
	if using_id_2:
		self.hearts = playerstats_2.hp
	# warning-ignore:return_value_discarded
		playerstats_2.connect("hp_changed", self, "set_hearts")
	# warning-ignore:return_value_discarded
		playerstats_2.connect("max_hp_changed", self,"set_max_hearts")
	else:
		self.hearts = playerstats_1.hp
	# warning-ignore:return_value_discarded
		playerstats_1.connect("hp_changed", self, "set_hearts")
	# warning-ignore:return_value_discarded
		playerstats_1.connect("max_hp_changed", self,"set_max_hearts")
