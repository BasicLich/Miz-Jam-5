extends Area2D
class_name FireSpawner

signal spawner_killed

export var spawn_scene: PackedScene
export var max_spawn_count: int = 3
export var max_active_spawn_count: int = 3
export var spawner_health: int = 3

export var fire_health: int = 2
export var fire_size: Vector2 = Vector2.ONE

onready var spawn_timer: Timer = $SpawnTimer
onready var spawner_seen_by_player: bool = false
onready var health_system: HealthSystem = $HealthSystem
onready var animation_player: AnimationPlayer = $AnimationPlayer

var spawned_enemies: Array = []
var spawn_count: int = 0
var spawner_dead: bool = false

func _ready() -> void:
#	spawn_timer.start()
	health_system.max_health = spawner_health
	health_system.current_health = spawner_health
	Globals.SubscribeFireSpawner(self)
	pass

func _on_VisibilityNotifier2D_screen_entered() -> void:
	if spawner_seen_by_player == false:
		Spawn()
		spawner_seen_by_player = true
	animation_player.play("form")

func Spawn() -> void:
	
	if spawner_dead == true:
		return
	
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
	instance.Setup(fire_health, fire_size)
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
	spawner_dead = true
	spawn_timer.stop()
	emit_signal("spawner_killed")
	Globals.UnsubscribeFireSpawner(self)
	animation_player.play("die")
	yield(animation_player, "animation_finished")
	queue_free()


func _on_HealthSystem_took_damage(amount) -> void:
	if spawner_dead == false:
		animation_player.play("hit")
		$AudioStreamPlayer.pitch_scale = 0.8 + randf() * 0.4
		$AudioStreamPlayer.play()
		$Particles2D.modulate.a = health_system.FractionRemainingHealth()
		
	
