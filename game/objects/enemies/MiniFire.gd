extends BaseEnemyFire
class_name MiniFire

enum MiniFireStates{IDLE, WANDER, CHASE, LOST_TARGET, BURN, DEATH}

const FLOOR_DETECT_DISTANCE = 32.0

export var move_speed: float = 100.0
export var chase_speed: float = 400.0
export var gravity = 2000.0
export var acceleration = 300

onready var platform_detector: RayCast2D = $PlatformDetector
onready var player_detection_zone: PlayerDetectionZone = $PlayerDetectionZone
onready var tree_detection_zone: TreeDetectionZone = $TreeDetectionZone
onready var idle_timer: Timer = $IdleTimer
onready var animation_player: AnimationPlayer = $AnimationPlayer

onready var burn_tick_timer: Timer = $BurnTickTimer


var current_state: int = MiniFireStates.IDLE
var wander_direction: float = -1.0
var target: BaseTree = null


func _ready() -> void:
	
	change_state_to(MiniFireStates.IDLE)


func _physics_process(delta: float) -> void:
	
#	print("Fire state: %s" % MiniFireStates.keys()[current_state])
	match current_state:
		MiniFireStates.IDLE:
#			velocity.y = 300
			idle_state(delta)
		MiniFireStates.WANDER:
#			velocity.y = 300
			wander_state(delta)
		MiniFireStates.CHASE:
#			velocity.y = 300
			chase_state(delta)
		MiniFireStates.BURN:
			burn_state(delta)

	velocity.y += gravity * delta
	velocity.y = move_and_slide(velocity, Vector2.UP, false, 4, 0.9).y
	
	if is_on_wall():
		wander_direction *= -1


func change_state_to(new_state: int) -> void:
	current_state = new_state
	
	if new_state == MiniFireStates.IDLE:
		idle_timer.start()
	
	if new_state == MiniFireStates.WANDER:
		wander_direction = -1.0
#		wander_direction = 1.0 if randi() % 2 == 0 else -1.0
	
	if new_state == MiniFireStates.LOST_TARGET:
		change_state_to(MiniFireStates.WANDER)
	
	if new_state == MiniFireStates.BURN:
		burn_tick_timer.start()
		target.Burn(1)

	
func idle_state(delta: float) -> void:
	
	if sees_target():
		change_state_to(MiniFireStates.CHASE)
	
	
func wander_state(delta: float) -> void:
	
	velocity.x = move_speed * wander_direction
	velocity.x = move_toward(velocity.x,  move_speed * wander_direction, acceleration * delta) 
	
	if sees_target():
		change_state_to(MiniFireStates.CHASE)
	
	
func chase_state(delta: float) -> void:
	
	if not tree_detection_zone.CanSeeTree():
		change_state_to(MiniFireStates.LOST_TARGET)
	
	sees_target()
		
	if target == null:
		change_state_to(MiniFireStates.WANDER)
		return

	var target_pos = target.global_position
	var direction = global_position.direction_to(target_pos)

	velocity.x = move_toward(velocity.x, direction.x * chase_speed, acceleration * delta) 
	
	# Check if we are close enough to the target to attack
	if global_position.distance_to(target.global_position) < 16:
		target = target
		change_state_to(MiniFireStates.BURN)


func burn_state(delta: float) -> void:
	if target == null or target.IsBurned():
		change_state_to(MiniFireStates.WANDER)
		return
	
	if  burn_tick_timer.time_left == 0:
		burn_tick_timer.start()
		target.Burn(1)
	
	velocity.x = 0


func sees_target() -> bool:
	target = null
	var closest_distance: float = INF
	
	var posible_targets = tree_detection_zone.trees
	for posible_target in posible_targets:
		var pt: BaseTree = posible_target as BaseTree	
		
		if pt.IsBurned():
			continue
			
		var distance: float = global_position.distance_to(pt.global_position)
		if distance < closest_distance:
			closest_distance = distance
			target = posible_target
			
	return target != null


func _on_IdleTimer_timeout() -> void:
	change_state_to(MiniFireStates.WANDER)


func _on_HealthSystem_health_zero() -> void:
	print("DEATH")
	animation_player.play("death")
	change_state_to(MiniFireStates.DEATH)
	yield(animation_player, "animation_finished")
	queue_free()
