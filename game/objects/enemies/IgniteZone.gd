extends Area2D
class_name IgniteZone


var player: Player = null

func _on_body_entered(body: Node) -> void:
	if body is Player:
		player = body
		$BurnFrequency.start()

func _on_body_exited(body: Node) -> void:
	if body is Player:
		player = null
		$BurnFrequency.stop()


func _on_BurnFrequency_timeout() -> void:
	
	if not player == null:
		player.AddFire()
	
	
