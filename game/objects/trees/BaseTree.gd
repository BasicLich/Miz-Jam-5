extends Area2D
class_name BaseTree

signal burned(tree)

enum TreeStates {ALIVE, BURNING, BURNED}
export var mini_fire: PackedScene

onready var health_system: HealthSystem = $HealthSystem
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var particles: Particles2D = $FireParticles2D
onready var green_particles: Particles2D = $GreenParticles2D

onready var burn_timer: Timer = $BurnTimer
onready var cooldown_timer: Timer = $CoolDownTimer
onready var player_detection_zone = $PlayerDetectionZone

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
#	green_particles.hide()

func Extinguish() -> void:
	
	if is_burning == false or current_state == TreeStates.BURNED:
		return
	
	burn_level = 0
	
	if burn_level <= 0:
		burn_level = 0
		burn_timer.stop()
		animation_player.play("extinguish")
		is_burning = false
#		green_particles.show()

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
	
	var mini_fire_instance = mini_fire.instance()
	get_parent().add_child(mini_fire_instance)
	mini_fire_instance.global_position = global_position 
	

func _on_CoolDownTimer_timeout() -> void:
	
	if player_detection_zone.CanSeePlayer() and not current_state in [TreeStates.BURNED, TreeStates.BURNING]:
		player_detection_zone.player.RemoveFire()
	


func _on_PlayerDetectionZone_body_entered(body: Node) -> void:
	cooldown_timer.start()
