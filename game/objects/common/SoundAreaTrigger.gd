extends Area2D


export var trigger_once: bool = true
export var audio_stream: AudioStream

var triggered: bool = false









func _on_body_entered(body: Node) -> void:
	PlaySound()


func PlaySound() -> void:
	if triggered and trigger_once:
		return
	print("soufda")
	$AudioStreamPlayer.stream = audio_stream
	$AudioStreamPlayer.play()
	triggered = true
