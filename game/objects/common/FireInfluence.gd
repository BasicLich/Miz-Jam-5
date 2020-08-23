extends Node2D

export var player_ship_path: NodePath

onready var player_ship: PlayerTree = get_node(player_ship_path)

var is_alive: bool = true


func _ready() -> void:
	$AnimationPlayer.play("create")


func _process(delta: float) -> void:
	
#	var fires: Array = Globals.active_fires
#
#	if fires.size() == 0:
#		global_position.x += 150 * delta
#		return
#
#	var left_most_fire = fires[0]
#
#	for fire in fires:
#		if fire.global_position.x < left_most_fire.global_position.x:
#			left_most_fire = fire
	
	if not is_alive:
		return
	
	var fire_spawners: Array = Globals.active_fire_spawners
	
	if fire_spawners.size() == 0:
		global_position.x += 200 * delta
		is_alive = false
		$AnimationPlayer.play("die")
		return
	
	var left_most_fire_spawner = fire_spawners[0]
	for fire_spawner in fire_spawners:
		if fire_spawner.global_position.x < left_most_fire_spawner.global_position.x:
			left_most_fire_spawner = fire_spawner
	
	
	var target_pos: float  = left_most_fire_spawner.global_position.x
	if player_ship.current_state in [player_ship.PlayerTreeState.LANDED, player_ship.PlayerTreeState.READY_TO_LAUNCH]:
		target_pos = max( left_most_fire_spawner.global_position.x + 50, player_ship.global_position.x + 10)
	else:
		target_pos = left_most_fire_spawner.global_position.x + 50
	
	
	global_position.x = move_toward(global_position.x, target_pos, 300 * delta)
#	global_position.x = lerp(global_position.x, target_pos, 0.6 * delta)
	
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "die":
		queue_free()
	
