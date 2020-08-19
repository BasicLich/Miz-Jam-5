extends Node2D

export var player_scene: PackedScene
export var tree: PackedScene

onready var main_menu_ui: MainMenuUI = $MainMenuUI
onready var playerTree = $PlayerTree
onready var player: Player = $Player
onready var tile_map: TileMap = $TileMap
onready var camera_follower: CameraFollower = $CameraFollower

func _ready() -> void:
	SetupGame()

func _process(delta: float) -> void:
	Globals.play_time += delta


func SetupGame() -> void:
	
	# Connect signals
	main_menu_ui.connect("play_button_pressed", self, "on_play_button_pressed")
	Globals.connect("bullet_hit", self, "on_bullet_hit")
	
	#
	main_menu_ui.ShowMainScreen()
	get_tree().paused = true
	
	camera_follower.SetTarget(player)

func on_play_button_pressed() -> void:
	get_tree().paused = false
	main_menu_ui.HideMainMenu()
	player.TakeControl(true)
	playerTree.TakeControl(true)


func _on_PlayerTree_tree_landed() -> void:
	
	if player != null:
		return
	
	var player_instance: Player = player_scene.instance() as Player
	add_child(player_instance)
	player = player_instance
	player.position = playerTree.passange_sprite.global_position
	player.TakeControl(true)
	
	camera_follower.SetTarget(player)

func _on_PlayerTree_tree_launched() -> void:
	player.queue_free()
	camera_follower.SetTarget(playerTree)
	
func on_bullet_hit(bullet, collision) -> void:
	if bullet is LeafBullet:
		var tree_instance: BaseTree = tree.instance() as BaseTree
		add_child(tree_instance)
		tree_instance.global_position = collision.position
		print(collision.collider)
	if bullet is WaterBullet:
		if collision.collider is MiniFire:
			var enemy: MiniFire = collision.collider
			enemy.health_system.Damage(1)
