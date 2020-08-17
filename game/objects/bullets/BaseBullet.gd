extends Area2D
class_name BaseBullet

export var speed = 1000

var velocity: Vector2 = Vector2.ZERO

func Setup(start_position: Vector2, dir: float) -> void:
	position = start_position
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)


func _physics_process(delta):
	position += velocity * delta

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()



func _on_BaseBullet_body_entered(body: Node) -> void:
	queue_free()
