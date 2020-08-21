extends Node2D
class_name FireSpawner

signal spawner_killed

export var spawn_scene: PackedScene
export var max_spawn_count: int = 3
export var max_active_spawn_count: int = 3

onready var spawn_timer: Timer = $SpawnTimer
onready var spawner_seen_by_player: bool = false

var spawned_enemies: Array = []
var spawn_count: int = 0
var spawner_dead: bool = false

func _ready() -> void:
#	spawn_timer.start()
	Globals.SubscribeFireSpawner(self)
	pass

func _on_VisibilityNotifier2D_screen_entered() -> void:
	if spawner_seen_by_player == false:
		spawn_timer.start()
		spawner_seen_by_player = true


func Spawn() -> void:
	
	if spawn_count >= max_spawn_count:
		spawner_dead = true
		emit_signal("spawner_killed")
		return
	
	if spawned_enemies.size() >= max_active_spawn_count:
		return
	
	var instance: Node2D = spawn_scene.instance()
	get_parent().add_child(instance)
	instance.connect("tree_exited", self, "enemy_killed", [instance])
	instance.global_position = global_position
	spawned_enemies.append(instance)
	spawn_count += 1
	
	spawn_timer.start()

func _on_SpawnTimer_timeout() -> void:
	Spawn()

func enemy_killed(enemy) -> void:
	if enemy in spawned_enemies:
		spawned_enemies.erase(enemy)
		spawn_timer.start()
	else:
		print(":/")




func _on_HealthSystem_health_zero() -> void:
	emit_signal("spawner_killed")
	Globals.SubscribeFireSpawner(self)
