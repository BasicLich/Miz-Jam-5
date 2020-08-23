extends Node
class_name HealthSystem

signal took_damage(amount)
signal healed_damage(amount)
signal health_zero()
signal healed_full()

export var max_health: int = 100
export var current_health: int = 100
export var regen_amount: int = 0
export var regen_frequency: float = 1

onready var invincibilty_timer: Timer = $InvincibilityTimer
onready var regen_timer: Timer = $RegenTimer

var is_invincible: bool = false

func _ready() -> void:
	if regen_frequency <= 0:
		regen_timer.stop()
	else:
		regen_timer.wait_time = regen_frequency
#	regen_timer.start()

func Damage(amount: int, override_invinciblity: bool = false) -> void:
	
	if is_invincible and not override_invinciblity:
		return
	
	current_health -= amount
	emit_signal("took_damage", amount)
	
	if current_health <= 0:
		emit_signal("health_zero")
	elif invincibilty_timer.wait_time > 0.0:
		invincibilty_timer.start()
		is_invincible = true
	
func Heal(amount: int) -> void:
	
	current_health += amount
	emit_signal("healed_damage", amount)
	
	if current_health > max_health:
		current_health = max_health
		emit_signal("healed_full")

func IsAlive() -> bool:
	return current_health > 0

func HealthLost() -> int:
	return max_health - current_health

func FractionRemainingHealth() -> float:
	return (float(current_health) / float(max_health))

func _on_InvincibilityTimer_timeout() -> void:
	is_invincible = false


func _on_RegenTimer_timeout() -> void:
	Heal(regen_amount)
