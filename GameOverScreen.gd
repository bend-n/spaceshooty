extends Node

onready var highscoreLabel = $HighscoreLabel
var USE_TOUCH = OS.has_touchscreen_ui_hint()

func _ready():
	set_highscore_label()
	print(USE_TOUCH)
	$TouchScreenButton.visible = USE_TOUCH
	$AnimatedSprite.play("hole")

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://StartMenu.tscn")

func set_highscore_label():
	var save_data = SaveAndLoad.load_data_from_file()
	highscoreLabel.text = "Highscore = " + str(save_data.highscore)
