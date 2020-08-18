extends Node2D

export var player_scene: PackedScene

onready var main_menu_ui: MainMenuUI = $MainMenuUI
onready var playerTree = $PlayerTree
onready var player: Player = $Player
onready var neutral_tile_map: TileMap = $NeutralTileMap
onready var good_tile_map: TileMap = $GoodTileMap

func _ready() -> void:
	
	main_menu_ui.connect("play_button_pressed", self, "on_play_button_pressed")
	
	main_menu_ui.ShowMainScreen()
	get_tree().paused = true
	
func on_play_button_pressed() -> void:
	get_tree().paused = false
	main_menu_ui.HideMainMenu()
	player.TakeControl(true)
	playerTree.TakeControl(true)

func _process(delta: float) -> void:
#	print(str(get_global_mouse_position()) + " : " + str(neutral_tile_map.world_to_map(get_global_mouse_position())))
	if Input.is_action_just_pressed("shoot_primary"):
		var global_mouse_pos: Vector2 = get_global_mouse_position()
		var map_coords = neutral_tile_map.world_to_map(global_mouse_pos / 2.0)
		var cell = neutral_tile_map.get_cell(map_coords.x, map_coords.y)
		var autotile = neutral_tile_map.get_cell_autotile_coord(map_coords.x, map_coords.y)
		print("Cell %d at %s, autotile = %s" % [cell, str(map_coords), str(autotile)])
		if cell != -1:
			neutral_tile_map.set_cell(map_coords.x, map_coords.y, -1)
			good_tile_map.set_cell(map_coords.x, map_coords.y, 0, false, false, false, autotile)
	
	

#		player.TakeControl(!player.in_control)
#		playerTree.TakeControl(!playerTree.in_control)


func _on_PlayerTree_tree_landed() -> void:
	
	if player != null:
		return
	
	var player_instance: Player = player_scene.instance() as Player
	add_child(player_instance)
	player = player_instance
	player.position = playerTree.passange_sprite.global_position
	player.TakeControl(true)

func _on_PlayerTree_tree_launched() -> void:
	player.queue_free()
	pass
