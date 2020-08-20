extends Area2D
class_name BaseTree

signal burned(tree)

enum TreeStates {ALIVE, BURNING, BURNED}

onready var health_system: HealthSystem = $HealthSystem
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var particles: Particles2D = $Particles2D

onready var burn_timer: Timer = $BurnTimer

var is_burning = false
var burn_level = 0
var current_state: int = TreeStates.ALIVE

func _ready() -> void:
	is_burning = false
	animation_player.play("grow")
	current_state = TreeStates.ALIVE

func IsBurning() -> bool:
	return current_state == TreeStates.BURNING

func IsBurned() -> bool:
	return current_state == TreeStates.BURNED

func Burn(power: int) -> void:
	
	burn_level += power
	
	if is_burning == true:
		return
	
#	particles.amount = health_system.HealthLost()
	animation_player.play("burning")
	is_burning = true
	current_state = TreeStates.BURNING
	burn_timer.start()

func Extinguish() -> void:
	burn_timer.stop()
	animation_player.play("extinguish")

func _on_BurnTimer_timeout() -> void:
	health_system.Damage(burn_level, true)
#	particles.amount = health_system.HealthLost()
	print("Health: %s / %s" % [str(health_system.current_health), str(health_system.max_health)])
	
	if health_system.IsAlive():
		burn_timer.start()

		


func _on_HealthSystem_health_zero() -> void:
	
	animation_player.play("burned")
	current_state = TreeStates.BURNED
	emit_signal("burned", self)
	Globals.trees_burned += 1
