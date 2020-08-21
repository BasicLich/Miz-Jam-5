extends KinematicBody2D
class_name BaseBullet

export var speed = 1000

var velocity: Vector2 = Vector2.ZERO


func Setup(start_position: Vector2, dir: float) -> void:
	position = start_position
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)


func _physics_process(delta):
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
#		Globals.emit_signal("bullet_hit", self, collision)
		bullet_collided(collision)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

func bullet_collided(collision) -> void:
#	queue_free()
	pass


#func _on_BulletArea2D_area_entered(area: Area2D) -> void:
##	Globals.emit_signal("bullet_hit", self, area)
##	queue_free()
#	pass # Replace with function body.
#
#
#func _on_BulletArea2D_body_entered(body: Node) -> void:
##	Globals.emit_signal("bullet_hit", self, body)
##	queue_free()
#	pass
