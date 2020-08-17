extends Node

onready var main_menu_ui: MainMenuUI = $MainMenuUI
onready var player: Player = $Player

func _ready() -> void:
	
	main_menu_ui.connect("play_button_pressed", self, "on_play_button_pressed")
	
	main_menu_ui.ShowMainScreen()
	get_tree().paused = true
	
func on_play_button_pressed() -> void:
	get_tree().paused = false
	main_menu_ui.HideMainMenu()
