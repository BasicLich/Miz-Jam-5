extends Node




enum Scenes {SPLASH, MAIN_MENU, GAME, END}
export(Scenes) var current_scene
export var transition_time: float = 0.5

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var color_rect: ColorRect = $CanvasLayer/ColorRect

const SPLASH_SCENE: String = "res://scenes/Splashscreen.tscn"
const MAIN_MENU_SCENE: String = "res://scenes/MainMenu.tscn"
const GAME_SCENE: String = "res://scenes/Game.tscn"
const END_SCENE: String = "res://scenes/EndScreen.tscn"

var scenes_dictionary = {Scenes.SPLASH:SPLASH_SCENE, Scenes.MAIN_MENU:MAIN_MENU_SCENE,  
						Scenes.GAME:GAME_SCENE, Scenes.END:END_SCENE}

var is_changing_scene = false

# signals
signal scene_changed

func _ready() -> void:
	color_rect.hide()

func change_scene_to(new_scene: int, transition_duration: float = transition_time) -> void:

	var scene_path = scenes_dictionary[new_scene]
	
	if is_changing_scene == true or scene_path == null: return
	
	# 
	print("Changing scene to: " + get_tree().current_scene.name)
	is_changing_scene = true
	animation_player.playback_speed = 1.0 / (transition_time/2.0)
	
	# Fade in transition background
	color_rect.show()
#	animation_player.play("fade_in")
	animation_player.play("fade_to_black")
	yield(animation_player, "animation_finished")
	
	# Change to the new scene
	var result  = get_tree().change_scene(scene_path)
	if result != OK:
		print("ERROR: Could not load the scene!")
	
	# Fade out transition background
#	animation_player.play_backwards("fade_in")
	animation_player.play("fade_to_transparent")
	yield(animation_player, "animation_finished")
	color_rect.hide()
	
	emit_signal("scene_changed", new_scene)
	
	is_changing_scene = false
	current_scene = new_scene
	yield(get_tree().create_timer(0.1), "timeout")

	print("Changed scene to: " + get_tree().current_scene.name)
