extends Node2D

export var player_scene: PackedScene
export var tree: PackedScene

onready var main_menu_ui: MainMenuUI = $MainMenuUI
onready var playerTree = $PlayerTree
onready var player: Player = $Player
onready var camera_follower: CameraFollower = $CameraFollower
onready var camera_shake: ShakeCamera2D = $CameraFollower/Camera2D
onready var game_ui: GameUI = $GameUI
onready var game_animation_player: AnimationPlayer = $GameAnimationPlayer

func _ready() -> void:
	SetupGame()

func _process(delta: float) -> void:
	Globals.play_time += delta


func SetupGame() -> void:
	
	AudioManager.change_music_to(AudioManager.title_music)
	AudioManager.set_music_bus_volume(0.3)
	AudioManager.set_sound_effect_bus_volume(0.5)
	# Connect signals
	main_menu_ui.connect("play_button_pressed", self, "on_play_button_pressed")
	Globals.connect("bullet_hit", self, "on_bullet_hit")
	Globals.connect("player_burned", self, "on_player_burned")
	playerTree.connect("tree_launched", self, "_on_PlayerTree_tree_launched")
	playerTree.connect("tree_landed", self, "_on_PlayerTree_tree_landed")
	
	#
	main_menu_ui.ShowMainScreen()
	get_tree().paused = true
	
	camera_follower.SetTarget(player)

func on_play_button_pressed() -> void:
	
	

#	game_ui.ShowCoverPanel(0.5)
#	yield(game_ui, "cover_shown")
#	game_ui.ShowMessage("This is a test message", 0.5, 2)
#	yield(game_ui, "message_displayed")
#	game_ui.HideCoverPanel(0.5)
	main_menu_ui.HideMainMenu()
	game_animation_player.play("IntroSequence")
	AudioManager.change_music_to(AudioManager.game_one_music)
	
	yield(game_animation_player, "animation_finished")
	get_tree().paused = false
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
	camera_shake.add_trauma(0.3)

func _on_PlayerTree_tree_launched() -> void:
	player.queue_free()
	camera_follower.SetTarget(playerTree)
	
func on_bullet_hit(bullet, collision) -> void:
	pass
#		var tree_instance: BaseTree = tree.instance() as BaseTree
#		add_child(tree_instance)
#		tree_instance.global_position = collision.global_position
#		print(collision.name)
#	if bullet is WaterBullet:
#		var col = collision
#		if col is MiniFire:
#			var enemy: MiniFire = col
#			enemy.health_system.Damage(1)
#		if col is BaseTree:
#			col.Extinguish()
			
func on_player_burned() -> void:
	
	player.set_collision_layer_bit(1, false)
	$GameNodes/Tween.interpolate_property(player, "global_position", player.global_position, 
		playerTree.global_position, 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0)
#	player.global_position = playerTree.global_position
	$GameNodes/Tween.start()
#	player.TakeControl(false)
	yield($GameNodes/Tween, "tween_completed")
	player.set_collision_layer_bit(1, true)
	player.change_state(player.PlayerState.MOVE)
#	player.TakeControl(true)
