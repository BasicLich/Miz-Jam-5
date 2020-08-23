extends KinematicBody2D
class_name BaseEnemyFire

export var register = true

var velocity: Vector2 = Vector2.ZERO
onready var health_system: HealthSystem = $HealthSystem

func _ready() -> void:
	if register:
		Globals.SubscribeFire(self)

func _exit_tree() -> void:
	if register:
		Globals.UnsubscribeFire(self)
