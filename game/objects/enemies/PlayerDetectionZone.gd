extends Area2D
class_name PlayerDetectionZone

var player: Player

func CanSeePlayer() -> bool:
	return player != null



func _on_PlayerDetectionZone_body_entered(body: Node) -> void:
	if body is Player:
		player = body


func _on_PlayerDetectionZone_body_exited(body: Node) -> void:
	if body is Player:
		player = null
