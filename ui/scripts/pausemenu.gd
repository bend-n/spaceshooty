extends Control

var setting = false
export var trigger = "pause"

onready var main_menu_button = $"%MainMenuButton"
onready var settings = $"%settings"


func _input(event):
	if event.is_action_pressed(trigger):
		var tree = get_tree()
		tree.paused = not tree.paused
		visible = tree.paused
		if tree.paused:
			main_menu_button.grab_focus()
		else:
			settings.hide()


func _exit_tree():
	get_tree().paused = false


func _on_settings_back():
	settings.visible = false
	setting = false
	yield(get_tree(), "idle_frame")
	main_menu_button.grab_focus()


func _on_options_pressed():
	if setting != true:
		setting = true
		settings.called()


func _on_exit_pressed():
	Game.exit()


func _on_MainMenuButton_pressed():
	Game.transition("res://ui/scenes/StartMenu.tscn")
