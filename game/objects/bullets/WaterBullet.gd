extends BaseBullet
class_name WaterBullet

var damage: int = 1

func bullet_collided(collision) -> void:
	
	print("Water bullet")
	var col = collision.collider
	if col is MiniFire:
		var enemy: MiniFire = col
		enemy.health_system.Damage(1)
#	if col is BaseTree:
#		col.Extinguish()
	
	queue_free()


func _on_BulletArea2D_area_entered(area: Area2D) -> void:
	
	if area is BaseTree:
		area.Extinguish()
	
	queue_free()
