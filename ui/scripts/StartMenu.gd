extends Node
var USE_TOUCH = OS.has_touchscreen_ui_hint()
var on = false

onready var highscoreLabel = $Label


func _input(event):
	if on:
# warning-ignore:return_value_discarded
		if event.is_action("shoot_1"):
			Game.transition("res://world/World.tscn")
		if event.is_action("ui_cancel"):
			Game.exit()
		if event.is_action("options"):
			$pause.show()


func _ready():
	var save_data = SaveAndLoad.load_data_from_file()
	highscoreLabel.text = "Highscore = " + str(save_data.highscore)
	if USE_TOUCH:
		$MobileControls/Attack.visible = true
	$AnimatedSprite.play("default")
	$MobileControls/Attack.visible = USE_TOUCH
	yield(get_tree().create_timer(.3), "timeout")
	on = true
