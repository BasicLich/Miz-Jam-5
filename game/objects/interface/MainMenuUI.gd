extends CanvasLayer
class_name MainMenuUI

signal play_button_pressed()

onready var main_screen: Control = $MainScreen

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var play_button: Button = $MainScreen/CenterContainer/VBoxContainer/PlayButton

func _ready() -> void:
	play_button.connect("pressed", self, "on_play_button_pressed")
	
	
func ShowMainScreen() -> void:
	animation_player.play("show_main_screen")

func HideMainMenu() -> void:
	main_screen.hide()


func on_play_button_pressed() -> void:
	emit_signal("play_button_pressed")
