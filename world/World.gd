extends Node

var count2
var count = 0
var score = 0 setget set_score
var USE_TOUCH = OS.has_touchscreen_ui_hint()
onready var scoreLabel = $CanvasLayer2/Background/ScoreLabel


func _ready():
	if playerstats.dev_mode:
		$CanvasLayer2/HpUi.hide()
		$CanvasLayer2/WeaponUi.hide()
		scoreLabel.hide()


func set_score(value):
	score = value
	update_score_label()
	if score >= 1000:
		if count2 != 1:
			count2 = 1
			var addorno = 1
			if playerstats.hp != playerstats.max_hp:
				addorno += 1
			playerstats.max_hp += 1
			playerstats.hp += addorno
			if addorno == 2:
				announce("congrats on those hearts")
			else:
				announce("congrats on that heart")

	if score >= 10000:
		if count != 1:
			count = 1
			var save_data = SaveAndLoad.load_data_from_file()
			save_data.unlocked2 = true
			SaveAndLoad.save_data_to_file(save_data)
			print("saved?")
	if score >= 30000:
		Game.transition("res://ui/scenes/Win.tscn")


func update_score_label():
	scoreLabel.text = "Score = " + str(score)


func update_save_data():
	var save_data = SaveAndLoad.load_data_from_file()
	if score > save_data.highscore:
		save_data.highscore = score
		SaveAndLoad.save_data_to_file(save_data)


func _on_Ship_player_death():
	playerstats.max_hp = 3
	playerstats.recent_score = score
	$CanvasLayer2/Background/HpUi.visible = false
	playerstats.hp = playerstats.max_hp
	update_save_data()
	yield(get_tree().create_timer(1), "timeout")
	Game.transition("res://ui/scenes/GameOverScreen.tscn")


onready var speaker = $CanvasLayer2/Background/anouncementlabel
onready var confetti = $CanvasLayer2/Background/anouncementlabel/confetti


func announce(text):
	speaker.text = text
	confetti.emitting = true
	yield(get_tree().create_timer(8), "timeout")
	confetti.emitting = false
	speaker.text = " "


func _process(_delta):
	if playerstats.power == true:
		$CanvasLayer2/Background/powerup.show()
	else:
		$CanvasLayer2/Background/powerup.hide()
