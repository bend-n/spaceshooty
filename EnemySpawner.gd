extends Node2D

var nexthing = 0
#min, max, level
var onscreenmax = 3
var onscreen = 0
var score_ranges : Array = [
	[50, 200, 1],
	[200, 749, 2],
	[750, 2499, 3],
	[2500, 5000, 4],
	[5001, 7000, 5],
	[7001, 8000, 6],
	[8001, 30000, 7],
	[30001, 40000, 8]
]
onready var timer = $Enemytimer
onready var spawnPoints = $SpawnPoints
var difficulty_levels:Array
var current_difficulty_level
onready var main = get_node("../EnemyHolder")

func _ready():
	difficulty_levels = load("res://Difficulty Scaling.tscn").instance().get_children();
	current_difficulty_level = difficulty_levels[0]

func spawn_enemy_on_current_difficulty():
	onscreen = main.get_child_count()
	if onscreen <= onscreenmax:
		var choices = current_difficulty_level.get_children()
		var to_spawn = choices[randi() % choices.size()]
		var clone = to_spawn.duplicate()
		main = get_node("../EnemyHolder")
		var spawn_position = get_spawn_position()
		main.add_child(clone)
		clone.global_position = spawn_position

func get_spawn_position():
	var points = spawnPoints.get_children()
	points.shuffle()
	return points[0].global_position

func _physics_process(delta):
	spawn_enemy_on_current_difficulty()
	var world = get_tree().current_scene
	for i in score_ranges.size():
		if world.score in range(score_ranges[i][0], score_ranges[i][1], 1):
			#set your dificulty to score_ranges[i][2]
			diff_levels(score_ranges[i][2])
			if score_ranges[i][2] == 3:
				onscreenmax = 1
			elif score_ranges[i][2] == 4:
				onscreenmax = 9
			elif score_ranges[i][2] == 5:
				onscreenmax = 1
			elif score_ranges[i][2] == 6:
				onscreenmax = 9
			elif score_ranges[i][2] == 7:
				onscreenmax = 0
			else:
				onscreenmax = 5


func diff_levels(value):
	current_difficulty_level = difficulty_levels[value]
