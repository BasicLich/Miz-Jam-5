extends KinematicBody2D
class_name BaseEnemyFire

var velocity: Vector2 = Vector2.ZERO
onready var health_system: HealthSystem = $HealthSystem

func _ready() -> void:
	Globals.SubscribeFire(self)

func _exit_tree() -> void:
	Globals.UnsubscribeFire(self)
