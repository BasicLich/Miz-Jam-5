extends Area2D

export var trigger_on_player_tree_enter: bool = true
export var trigger_on_player_tree_exit: bool = true

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var label: Label = $Label


func _ready() -> void:
	label.hide()
	pass
#	animation_player.play("show")
#	yield(animation_player, "animation_finished")
#	animation_player.play("hide")

func _on_body_entered(body: Node) -> void:
	
	if body is Player or (body is PlayerTree and trigger_on_player_tree_enter):
		animation_player.play("show")
		$AudioStreamPlayer.pitch_scale = 0.65 + randf() * 0.3
		$AudioStreamPlayer.play()
	


func _on_body_exited(body: Node) -> void:
	if body is Player or (body is PlayerTree and trigger_on_player_tree_exit):
		animation_player.play("hide")
