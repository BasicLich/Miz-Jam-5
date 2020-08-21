extends BaseBullet
class_name LeafBullet

export var tree: PackedScene

func _on_BaseBullet_body_entered(body: Node) -> void:
	
	pass
	
	
#	queue_free()
	
	
func bullet_collided(collision) -> void:
	
	print("Leaf bullet")
	var tree_instance: BaseTree = tree.instance() as BaseTree
	get_parent().add_child(tree_instance)
	tree_instance.global_position = collision.position
	queue_free()
	pass
