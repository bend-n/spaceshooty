extends Node
var USE_TOUCH = OS.has_touchscreen_ui_hint()

onready var highscoreLabel = $Label

func _process(_delta):
	if Input.is_action_just_pressed("shoot_1"):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://World.tscn")
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	var save_data = SaveAndLoad.load_data_from_file()
	highscoreLabel.text = "Highscore = " + str(save_data.highscore)


func _ready() -> void:
	if USE_TOUCH:
		$TextureButton.visible = false
	$AnimatedSprite.play("default")
	$MobileControls/Attack.visible = USE_TOUCH

