extends BaseBullet
class_name LeafBullet

export var tree: PackedScene

func _on_BaseBullet_body_entered(body: Node) -> void:
	
	
	
	
	queue_free()
	
	
	
