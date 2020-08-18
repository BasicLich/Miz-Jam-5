extends KinematicBody2D
class_name Player

const FLOOR_NORMAL: = Vector2.UP

enum PlayerState {IDLE, MOVE, ONBOARD_TREE}


export var max_velocity: = Vector2(300.0, 1000.0)
export var jump_force: float = 500.0
export var gravity: = 3000.0

onready var animated_sprite: AnimatedSprite = $AnimatedSprite

var _velocity: = Vector2.ZERO
var in_control: bool = true
var current_state: int = PlayerState.IDLE



# Public
func TakeControl(control: bool):
	in_control = control
	pass
#

func _ready() -> void:
	change_state(PlayerState.MOVE)

func _physics_process(delta: float) -> void:

	match current_state:
		PlayerState.MOVE:
			move_state(delta)	
		PlayerState.ONBOARD_TREE:
			onboard_state(delta)
	
	
		
func change_state(new_state: int) -> void:
	current_state = new_state
	print("Player's state changed to: %s" % PlayerState.keys()[current_state])


func move_state(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("move_jump") and _velocity.y < 0.0 
	is_jump_interrupted = false
	var direction = get_direction()
	
	
	_velocity = calculate_move_velocity(_velocity, direction, max_velocity, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

	if abs(_velocity.y) > 0:
		animated_sprite.play("jump")
	elif abs(direction.x) > 0:
		animated_sprite.play("move")
		animated_sprite.flip_h = true if direction.x < 0 else false
	else:
		animated_sprite.play("idle")


func onboard_state(delta: float) -> void:
	pass

	
func get_direction() -> Vector2:
	
	var horizontal_input: float = 0
	var vertical_input: float = 0
	if in_control:
		horizontal_input = (Input.is_action_pressed("move_right") as int) - (Input.is_action_pressed("move_left") as int)
		vertical_input = -1.0 if Input.is_action_just_pressed("move_jump") and is_on_floor() else 0.0
	
	return Vector2(horizontal_input, vertical_input)


func calculate_move_velocity(linear_velocity: Vector2, direction: Vector2, 
							 speed: Vector2, is_jump_interrupted: bool) -> Vector2:
	
	var new_velocity = linear_velocity
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time() 
	if direction.y == -1.0:
		new_velocity.y = jump_force * direction.y
	if is_jump_interrupted:
		new_velocity.y = 0.0
	return new_velocity
