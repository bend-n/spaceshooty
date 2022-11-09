extends Node2D

var count1 = 0
var count2 = 0
var count3 = 0
var count4 = 0
var count5 = 0
var count6 = 0
var count7 = 0
var count8 = 0

onready var label = $"Sprite Holders/Label"
var nexthing = 0
#min, max, level
var onscreenmax = 3
var onscreen = 0
var announcing = true
var dev_mode = playerstats.dev_mode
var score_ranges: Array = [
	[50, 200, 1],
	[200, 749, 2],
	[750, 2499, 3],
	[2500, 5000, 4],
	[5001, 7000, 5],
	[5001, 7000, 5],
	[7001, 8000, 6],
	[8001, 30000, 7],
	[30001, 40000, 8]
]
onready var spawnPoints = $SpawnPoints
var difficulty_levels: Array
var current_difficulty_level
onready var main = get_node("../../../EnemyHolder")
onready var world = get_tree().current_scene
var last_score: int = -1


func _ready():
	visible_then_not($"Sprite Holders/octopus")
	difficulty_levels = load("res://enemy/scenes/Difficulty Scaling.tscn").instance().get_children()
	current_difficulty_level = difficulty_levels[0]


func spawn_enemy_on_current_difficulty():
	if not announcing:
		if not dev_mode:
			onscreen = main.get_child_count()
			if onscreen <= onscreenmax:
				var choices = current_difficulty_level.get_children()
				var to_spawn = choices[randi() % choices.size()]
				if to_spawn.name == "Drone":
					if randi() % 6 == 5:
						var clone = to_spawn.duplicate()
						var spawn_position = get_spawn_position()
						main.add_child(clone)
						clone.global_position = spawn_position
				else:
					var clone = to_spawn.duplicate()
					var spawn_position = get_spawn_position()
					main.add_child(clone)
					clone.global_position = spawn_position


func get_spawn_position():
	var points = spawnPoints.get_children()
	points.shuffle()
	return points[0].global_position


func _physics_process(_delta):
	if world.score == last_score:
		last_score = world.score
		return
	for i in score_ranges.size():
		if world.score in range(score_ranges[i][0], score_ranges[i][1], 1):
			#set your dificulty to score_ranges[i][2]
			diff_levels(score_ranges[i][2])
			match score_ranges[i][2]:
				1:
					if not count1 >= 1:
						count1 += 1
						visible_then_not($"Sprite Holders/basicenemy")
				2:
					if not count2 >= 1:
						count2 += 1
						visible_then_not($"Sprite Holders/hardy")
						visible_then_not($"Sprite Holders/ufo")
				3:
					if not count3 >= 1:
						count3 += 1
						onscreenmax = 1
						label.text = "First boss = "
						visible_then_not($"Sprite Holders/squid")
						yield(get_tree().create_timer(6), "timeout")
						label.text = "Next up ="
				4:
					if not count4 >= 1:
						count4 += 1
						onscreenmax = 4
						label.text = "Hats off to ye!"
						label.visible = true
						yield(get_tree().create_timer(6), "timeout")
						label.visible = false
				5:
					if not count5 >= 1:
						count5 += 1
						onscreenmax = 1
						label.text = "Second boss = "
						visible_then_not($"Sprite Holders/boss")
						yield(get_tree().create_timer(6), "timeout")
				6:
					if not count6 >= 1:
						count6 += 1
						onscreenmax = 9
						label.text = "Random bullshit go!"
						label.visible = true
						yield(get_tree().create_timer(6), "timeout")
						label.visible = false
				7:
					if not count7 >= 1:
						count7 += 1
						onscreenmax = 0
						label.text = "Last boss = "
						visible_then_not($"Sprite Holders/finale")
						label.text = "Y r u alive!!!"
				8:
					if not count8 >= 1:
						count8 += 1
						onscreenmax = 5
						label.visible = true
						yield(get_tree().create_timer(6), "timeout")
						label.visible = false


func diff_levels(value):
	current_difficulty_level = difficulty_levels[value]


func visible_then_not(sprite):
	announcing = true
	label.visible = true
	sprite.visible = true
	yield(get_tree().create_timer(5), "timeout")
	sprite.visible = false
	label.visible = false
	announcing = false
