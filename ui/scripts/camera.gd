extends Camera2D

onready var top_left_limit = $"../walls/CollisionShape2D/left"

func _process(_delta):
	if current:
		limit_left = top_left_limit.position.x

func _ready():
	var bottom = $"../walls/CollisionShape2D/bottom"
	limit_bottom = bottom.position.y
	limit_top = top_left_limit.position.y
