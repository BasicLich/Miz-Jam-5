extends Node2D


func _process(delta: float) -> void:
	
	var fires: Array = Globals.active_fires
	
	if fires.size() == 0:
		global_position.x += 50 * delta
		return
	
	var left_most_fire = fires[0]
	
	for fire in fires:
		if fire.global_position.x < left_most_fire.global_position.x:
			left_most_fire = fire
	
	global_position.x = lerp(global_position.x, left_most_fire.global_position.x, 0.9*delta)
