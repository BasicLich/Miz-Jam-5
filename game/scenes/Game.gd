extends Node2D

export var player_scene: PackedScene
export var tree: PackedScene

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
	if Input.is_action_just_pressed("ui_cancel"):
		OS.window_fullscreen = not OS.window_fullscreen

func SetupGame() -> void:
	
	
	AudioManager.set_music_bus_volume(0.3)
	AudioManager.set_sound_effect_bus_volume(0.5)
	# Connect signals

#	Globals.connect("bullet_hit", self, "on_bullet_hit")
	Globals.connect("player_burned", self, "on_player_burned")
	playerTree.connect("tree_launched", self, "_on_PlayerTree_tree_launched")
	playerTree.connect("tree_landed", self, "_on_PlayerTree_tree_landed")
	
	
	get_tree().paused = true
	
	camera_follower.SetTarget(player)
	camera_follower.camera.align()
	
	AudioManager.change_music_to(AudioManager.game_one_music)	
	game_animation_player.play("IntroSequence")
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
	
	if Globals.ship_launches == 1:
		AudioManager.change_music_to(AudioManager.game_two_music)
	
	player.queue_free()
	camera_follower.SetTarget(playerTree)

			
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



func _on_PlayerEndArea2D_body_entered(body: Node) -> void:
	
	playerTree.TakeControl(false)
	player.TakeControl(false)
	
	game_animation_player.play("OutroSequence")
	yield(game_animation_player, "animation_finished")
	SceneManager.change_scene_to(SceneManager.Scenes.END)
	

