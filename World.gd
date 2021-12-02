extends Node

var deaths = 0
var score = 0 setget set_score
var USE_TOUCH = OS.has_touchscreen_ui_hint()
onready var scoreLabel = $ScoreLabel

func _process(delta):
	if Input.is_action_just_pressed("ui_home"):
		self.score = 20000

func set_score(value):
	score = value
	update_score_label()
	if score >= 30000:
		get_tree().change_scene("res://Win.tscn")

func update_score_label():
	scoreLabel.text = "Score = " + str(score)
	
func update_save_data():
	var save_data = SaveAndLoad.load_data_from_file()
	if score > save_data.highscore:
		save_data.highscore = score
		SaveAndLoad.save_data_to_file(save_data)

func _on_Ship_player_death():
	$CanvasLayer/HpUi.visible = false
	playerstats.hp = playerstats.max_hp
	update_save_data()
	yield(get_tree().create_timer(1), "timeout")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://GameOverScreen.tscn")
