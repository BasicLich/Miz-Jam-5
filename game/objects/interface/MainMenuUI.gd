extends CanvasLayer
class_name MainMenuUI

signal play_button_pressed()

onready var main_screen: Control = $MainScreen

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var play_button: Button = $MainScreen/CenterContainer/VBoxContainer/PlayButton
onready var credits_button: Button = $MainScreen/CenterContainer/VBoxContainer/CreditsButton
onready var resume_button: Button = $PauseScreen/CenterContainer/VBoxContainer/ResumeButton

func _ready() -> void:
	play_button.connect("pressed", self, "on_play_button_pressed")
	credits_button.connect("pressed", self, "ShowCreditsScreen")
	resume_button.connect("pressed", self, "HidePauseScreen")
	
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


func on_play_button_pressed() -> void:
	emit_signal("play_button_pressed")


func _on_BackButton_pressed() -> void:
	animation_player.play("show_main_screen")


func _process(delta: float) -> void:
		
	if Input.is_action_just_pressed("ui_cancel"):
#		
		if get_tree().paused == false:	
			ShowPauseScreen()
		else:	
			HidePauseScreen()
