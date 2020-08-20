extends Area2D
class_name TreeDetectionZone

var trees: Array = []


func CanSeeTree() -> bool:
	return trees.size() != 0

func ClosestTree() -> BaseTree:
	
	var closest_tree = trees[0]
	var closest_distance = INF
	for tree in trees:
		
		var tre: BaseTree = tree as BaseTree
		
		if tre.IsBurned():
			continue
		
		var distance: float = global_position.distance_to(tree.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_tree = tree
	
	return closest_tree


func _on_area_entered(area: Area2D) -> void:
	if area is BaseTree:
		if not area in trees:
			trees.append(area)


func _on_area_exited(area: Area2D) -> void:
	if area is BaseTree:
		if not area in trees:
			trees.append(area)
