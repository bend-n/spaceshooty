extends Node
var USE_TOUCH = OS.has_touchscreen_ui_hint()
var on = false

onready var highscoreLabel = $Label

func _process(_delta):
	if on:
		if Input.is_action_just_pressed("shoot_1"): get_tree().change_scene("res://World.tscn")
		if Input.is_action_just_pressed("ui_cancel"): get_tree().quit()
	var save_data = SaveAndLoad.load_data_from_file()
	highscoreLabel.text = "Highscore = " + str(save_data.highscore)

func _ready():
	if USE_TOUCH: $TextureButton.visible = false
	$AnimatedSprite.play("default")
	$MobileControls/Attack.visible = USE_TOUCH
	yield(get_tree().create_timer(.3), "timeout")
	on = true
	

