extends KinematicBody2D
class_name MiniFire

enum MiniFireStates{IDLE, WANDER, CHASE, LOST_TARGET, BURN, DEATH}

export var move_speed: float = 100.0
export var chase_speed: float = 400.0

onready var player_detection_zone: PlayerDetectionZone = $PlayerDetectionZone
onready var idle_timer: Timer = $IdleTimer
onready var health_system: HealthSystem = $HealthSystem
onready var animation_player: AnimationPlayer = $AnimationPlayer

var velocity: Vector2 = Vector2.ZERO
var current_state: int = MiniFireStates.IDLE
var wander_direction: float = 1.0

func _ready() -> void:
	
	change_state_to(MiniFireStates.IDLE)

func _physics_process(delta: float) -> void:
	
	match current_state:
		MiniFireStates.IDLE:
			velocity.y = 300
			idle_state(delta)
		MiniFireStates.WANDER:
			velocity.y = 300
			wander_state(delta)
		MiniFireStates.CHASE:
			velocity.y = 300
			chase_state(delta)
		MiniFireStates.BURN:
			pass
	
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, PI/3.0)

func change_state_to(new_state: int) -> void:
	current_state = new_state
	
	if new_state == MiniFireStates.IDLE:
		idle_timer.start()
	
	if new_state == MiniFireStates.WANDER:
		wander_direction = 1.0 if randi() % 2 == 0 else -1.0
	
	if new_state == MiniFireStates.LOST_TARGET:
		change_state_to(MiniFireStates.IDLE)
	
func idle_state(delta: float) -> void:
	
	if player_detection_zone.CanSeePlayer():
		print("I see the player")
		change_state_to(MiniFireStates.CHASE)
	
func wander_state(delta: float) -> void:
	
	velocity.x = move_speed * wander_direction
	
	if player_detection_zone.CanSeePlayer():
		print("I see the player")
		change_state_to(MiniFireStates.CHASE)
	


func chase_state(delta: float) -> void:
	
	if player_detection_zone.CanSeePlayer() == false or player_detection_zone.player == null:
		change_state_to(MiniFireStates.LOST_TARGET)
		return
	
	var player_pos = player_detection_zone.player.global_position
	
	var direction = global_position.direction_to(player_pos)
	var acceleration = 100
#	velocity = velocity.move_toward(direction * chase_speed, acceleration * delta)
	velocity.x = direction.x * chase_speed


func _on_IdleTimer_timeout() -> void:
	change_state_to(MiniFireStates.WANDER)


func _on_HealthSystem_health_zero() -> void:
	print("DEATH")
	animation_player.play("death")
	change_state_to(MiniFireStates.DEATH)
	yield(animation_player, "animation_finished")
	queue_free()
