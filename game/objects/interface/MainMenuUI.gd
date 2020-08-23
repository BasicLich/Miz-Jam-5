extends CanvasLayer
class_name MainMenuUI

signal play_button_pressed()

onready var main_screen: Control = $MainScreen

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var play_button: Button = $MainScreen/CenterContainer/VBoxContainer/PlayButton
onready var credits_button: Button = $MainScreen/CenterContainer/VBoxContainer/CreditsButton
onready var resume_button: Button = $PauseScreen/CenterContainer/VBoxContainer/ResumeButton
onready var options_button: Button = $MainScreen/CenterContainer/VBoxContainer/OptionsButton


onready var master_volume_slider = $OptionsScreen/CenterContainer/VBoxContainer/HBoxContainer/MasterVolumeSlider
onready var music_volume_slider = $OptionsScreen/CenterContainer/VBoxContainer/HBoxContainer2/MusicVolumeSlider
onready var sound_effect_volume_slider = $OptionsScreen/CenterContainer/VBoxContainer/HBoxContainer3/SoundEffectVolumeSlider 
onready var fullscreen_toggle: Button = $OptionsScreen/CenterContainer/VBoxContainer/HBoxContainer4/FullscreenToggle



func _ready() -> void:
#	$ColorRect.show()
	play_button.connect("pressed", self, "on_play_button_pressed")
	credits_button.connect("pressed", self, "ShowCreditsScreen")
	resume_button.connect("pressed", self, "HidePauseScreen")
	options_button.connect("pressed", self, "on_options_button_pressed")
	
	master_volume_slider.value = 0.5
	music_volume_slider.value = 0.5
	sound_effect_volume_slider.value = 0.5
	fullscreen_toggle.pressed = OS.window_fullscreen
	
	
func ShowMainScreen() -> void:
	animation_player.play("show_main_screen")

func ShowCreditsScreen() -> void:
	animation_player.play("show_credits_screen")

func ShowPauseScreen() -> void:
	get_tree().paused = true
	animation_player.play("show_pause_screen")

func HidePauseScreen() -> void:
	get_tree().paused = false
	animation_player.play_backwards("show_pause_screen")

func HideMainMenu() -> void:
	main_screen.hide()
#	$ColorRect.hide()

func on_play_button_pressed() -> void:
	emit_signal("play_button_pressed")

func on_options_button_pressed() -> void:
	animation_player.play("show_options_screen")



func _on_BackButton_pressed() -> void:
	animation_player.play("show_main_screen")


func _process(delta: float) -> void:
		
	if Input.is_action_just_pressed("ui_cancel"):
#		
		if get_tree().paused == false:	
			ShowPauseScreen()
		else:	
			HidePauseScreen()


func _on_MasterVolumeSlider_value_changed(value: float) -> void:
	AudioManager.set_master_bus_volume(value)


func _on_MusicVolumeSlider_value_changed(value: float) -> void:
	AudioManager.set_music_bus_volume(value)


func _on_SoundEffectVolumeSlider_value_changed(value: float) -> void:
	AudioManager.set_sound_effect_bus_volume(value)


func _on_FullscreenToggle_toggled(button_pressed: bool) -> void:
	OS.window_fullscreen = button_pressed
