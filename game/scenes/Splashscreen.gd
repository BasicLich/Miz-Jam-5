extends Node

export var game_scene: PackedScene


func SplashComplete() -> void:
	
	SceneManager.change_scene_to(SceneManager.Scenes.MAIN_MENU)
	
	
