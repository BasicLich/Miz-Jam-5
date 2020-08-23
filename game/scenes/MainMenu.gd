extends Node

onready var main_menu_ui: MainMenuUI = $MainMenuUI

func _ready() -> void:
	main_menu_ui.ShowMainScreen()
	AudioManager.change_music_to(AudioManager.title_music)
	AudioManager.set_music_bus_volume(0.3)
	AudioManager.set_sound_effect_bus_volume(0.5)

func _on_MainMenuUI_play_button_pressed() -> void:
	SceneManager.change_scene_to(SceneManager.Scenes.GAME)



func _on_QuitButton_pressed() -> void:
	get_tree().quit()
