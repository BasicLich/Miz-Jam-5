extends Node

signal bullet_hit(bullet, collision_information)

signal tree_burned(tree)
signal player_burned()

# Statistics
var fires_put_out: int = 0
var play_time: float = 0.0
var trees_planted: int = 0
var trees_burned: int = 0
var ship_launches: int = 0
var ship_landings: int = 0

var active_fires: Array = []
var active_fire_spawners: Array = []

func SubscribeFire(fire: BaseEnemyFire) -> void:
	
	if not fire in active_fires:
		print("+Subscribed: " + fire.name)
		active_fires.append(fire)
	
func UnsubscribeFire(fire: BaseEnemyFire) -> void:
	
	if fire in active_fires:
		print("-Unsubscribed: " + fire.name)
		active_fires.erase(fire)


func SubscribeFireSpawner(fire_spawner: FireSpawner) -> void:
	if not fire_spawner in active_fire_spawners:
		print("+Subscribed: " + fire_spawner.name)
		active_fire_spawners.append(fire_spawner)

func UnsubscribeFireSpawner(fire_spawner: FireSpawner) -> void:
	if fire_spawner in active_fire_spawners:
		print("-Unsubscribed: " + fire_spawner.name)
		active_fire_spawners.erase(fire_spawner)
