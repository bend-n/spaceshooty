extends Node
export var hole = false
onready var highscoreLabel = $HighscoreLabel
var USE_TOUCH = OS.has_touchscreen_ui_hint()


func _ready():
	$Score.text = ("Score = " + str(playerstats.recent_score))
	set_highscore_label()
	$TouchScreenButton.visible = USE_TOUCH
	if hole:
		$AnimatedSprite.play("hole")
	var save_data = SaveAndLoad.load_data_from_file()
	if playerstats.recent_score >= save_data.highscore:
		$HighscoreLabel.hide()


func _input(event):
	if event.is_action("ui_cancel"):
		Game.transition("res://ui/scenes/StartMenu.tscn")


func set_highscore_label():
	var save_data = SaveAndLoad.load_data_from_file()
	highscoreLabel.text = "Highscore = " + str(save_data.highscore)
