extends Node

onready var highscoreLabel = $Label

func _process(_delta):
	if Input.is_action_just_pressed("shoot_1"):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://World.tscn")
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	var save_data = SaveAndLoad.load_data_from_file()
	highscoreLabel.text = "Highscore = " + str(save_data.highscore)

var USE_TOUCH = OS.has_touchscreen_ui_hint()
func _ready() -> void:
	$AnimatedSprite.play("default")
	$MobileControls/Attack.visible = USE_TOUCH


func _on_TextureButton_toggled(button_pressed):
	playerstats.multiplayerlocal = button_pressed
