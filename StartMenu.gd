extends Node

onready var highscoreLabel = $Label


func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://World.tscn")
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	var save_data = SaveAndLoad.load_data_from_file()
	highscoreLabel.text = "Highscore = " + str(save_data.highscore)

var USE_TOUCH = OS.has_touchscreen_ui_hint()
func _ready() -> void:
	print(USE_TOUCH)
	$MobileControls/Attack.visible = USE_TOUCH
