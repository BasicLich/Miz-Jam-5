extends Node2D

export var spawn_scene: PackedScene
export var max_spawn_count: int = 3

onready var spawn_timer: Timer = $SpawnTimer
onready var spawner_seen_by_player: bool = false

var spawned_enemies: Array = []

func _on_VisibilityNotifier2D_screen_entered() -> void:
	if spawner_seen_by_player == false:
		spawn_timer.start()
		spawner_seen_by_player = true


func Spawn() -> void:
	
	var instance: Node2D = spawn_scene.instance()
	get_parent().add_child(instance)
	instance.connect("tree_exited", self, "enemy_killed", [instance])
	instance.global_position = global_position
	spawned_enemies.append(instance)
	
	if spawned_enemies.size() < max_spawn_count:
		spawn_timer.start()

func _on_SpawnTimer_timeout() -> void:
	Spawn()

func enemy_killed(enemy) -> void:
	if enemy in spawned_enemies:
		spawned_enemies.erase(enemy)
		spawn_timer.start()
	else:
		print(":/")
