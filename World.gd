extends Node

var count = 0
var score = 0 setget set_score
var USE_TOUCH = OS.has_touchscreen_ui_hint()
onready var scoreLabel = $CanvasLayer2/Background/ScoreLabel

func _ready():
	if playerstats.dev_mode:
		$CanvasLayer2/HpUi.hide()
		$CanvasLayer2/WeaponUi.hide()
		scoreLabel.hide()

func _input(event):
	if event.is_action("ui_home"):
		self.score = 20000

func set_score(value):
	score = value
	update_score_label()
	if score >= 10000:
		if count != 1:
			count = 1
			var save_data = SaveAndLoad.load_data_from_file()
			save_data.unlocked2 = true
			SaveAndLoad.save_data_to_file(save_data)
			print("saved?")
	if score >= 30000:
# warning-ignore:return_value_discarded
		Game.transition("res://Win.tscn")

func update_score_label():
	scoreLabel.text = "Score = " + str(score)

func update_save_data():
	var save_data = SaveAndLoad.load_data_from_file()
	if score > save_data.highscore:
		save_data.highscore = score
		SaveAndLoad.save_data_to_file(save_data)

func _on_Ship_player_death():
	playerstats.recent_score = score
	$CanvasLayer2/Background/HpUi.visible = false
	playerstats.hp = playerstats.max_hp
	update_save_data()
	yield(get_tree().create_timer(1), "timeout")
# warning-ignore:return_value_discarded
	Game.transition("res://GameOverScreen.tscn")
