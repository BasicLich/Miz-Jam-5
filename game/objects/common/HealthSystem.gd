extends Node
class_name HealthSystem

signal took_damage(amount)
signal healed_damage(amount)
signal health_zero()
signal healed_full()

export var max_health: int = 100
export var current_health: int = 100

onready var invincibilty_timer: Timer = $InvincibilityTimer

var is_invincible: bool = false

func Damage(amount: int) -> void:
	
	if is_invincible:
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



func _on_InvincibilityTimer_timeout() -> void:
	is_invincible = false
