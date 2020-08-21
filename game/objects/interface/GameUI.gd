extends CanvasLayer
class_name GameUI

signal message_displayed
signal cover_shown
signal cover_hide

onready var cover_animation_player: AnimationPlayer = $CoverAnimationPlayer
onready var message_animation_player: AnimationPlayer = $MessageAnimationPlayer
onready var message_label: Label = $MessageLabel

func _ready() -> void:
	message_label.text = ""
	message_label.hide()

# Public 
func ShowMessage(text: String, transition: float = 0.5, duration: float = 1.0) -> void:
	
	message_label.text = text
	message_animation_player.playback_speed = 1.0 / transition
	
	message_animation_player.play("show_message")
	yield(message_animation_player, "animation_finished")
	yield(get_tree().create_timer(duration), "timeout")
	message_animation_player.play("hide_message")	
	yield(message_animation_player, "animation_finished")
	
	message_label.text = ""
	emit_signal("message_displayed")
	
func ShowCoverPanel(duration: float = 1.0) -> void:
	cover_animation_player.playback_speed = 1.0 / duration
	cover_animation_player.play("show_cover_panel")
	yield(cover_animation_player, "animation_finished")
	emit_signal("cover_shown")

func HideCoverPanel(duration: float = 1.0) -> void:
	cover_animation_player.playback_speed = 1.0 / duration
	cover_animation_player.play("hide_cover_panel")
	yield(cover_animation_player, "animation_finished")
	emit_signal("cover_hide")
