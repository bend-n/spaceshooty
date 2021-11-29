extends Node

var deaths = 0
var score = 0 setget set_score

onready var scoreLabel = $ScoreLabel
onready var player = preload("res://Ship2.tscn")

func _ready():
	if playerstats.multiplayerlocal:
		$CanvasLayer2/HpUi.visible = true
		$CanvasLayer2/WeaponUi.visible = true
		var Player = player.instance()
		self.add_child(Player)
		Player.id = 2
# warning-ignore:return_value_discarded
		Player.connect("player_death", self, "_on_Ship_player_death")

func set_score(value):
	score = value
	update_score_label()

func update_score_label():
	scoreLabel.text = "Score = " + str(score)
	
func update_save_data():
	var save_data = SaveAndLoad.load_data_from_file()
	if score > save_data.highscore:
		save_data.highscore = score
		SaveAndLoad.save_data_to_file(save_data)

func _on_Ship_player_death():
	if playerstats.multiplayerlocal:
		deaths += 1
		if deaths >= 2:
			$CanvasLayer/HpUi.visible = false
			$CanvasLayer2/HpUi.visible = false
			playerstats_1.hp = playerstats_1.max_hp
			playerstats_2.hp = playerstats_2.max_hp
			update_save_data()
			load("res://GameOverScreen.tscn")
			yield(get_tree().create_timer(1), "timeout")
		# warning-ignore:return_value_discarded
			get_tree().change_scene("res://GameOverScreen.tscn")
	else:
		$CanvasLayer/HpUi.visible = false
		playerstats_1.hp = playerstats_1.max_hp
		update_save_data()
		yield(get_tree().create_timer(1), "timeout")
	# warning-ignore:return_value_discarded
		get_tree().change_scene("res://GameOverScreen.tscn")
