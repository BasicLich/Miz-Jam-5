extends KinematicBody2D
class_name PlayerTree

enum PlayerTreeState {MOVE, LANDING, LANDED, READY_TO_LAUNCH, LAUNCHING, LAUNCHED, DEAD}

signal tree_landed
signal tree_launched


export var speed = 200
export var max_water_level = 100


export var leaf_bullet: PackedScene
export var water_bullet_scene: PackedScene

onready var leaves_shoot_timer: Timer = $LeavesShootTimer
onready var tree_gun: Node2D = $TreeGun
onready var tree_gun_sprite: Sprite = $TreeGun/Leaves
onready var water_tank: WaterTank = $WaterTank
onready var passange_sprite: Sprite = $Tree/Passenger

onready var tree_gun_animation_player: AnimationPlayer = $TreeGun_AnimationPlayer
onready var player_tree_animation_player: AnimationPlayer = $PlayerTreeAnimationPlayer

var current_water_level: int = 100

var direction: Vector2 = Vector2.ZERO
var input_direction: Vector2 = Vector2.ZERO
var to_pointer_direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var in_control: bool = true
var player_within_board_distance = false

var leaf_shots_remaining: int = 0
var leaf_shots: int = 3

var current_state = PlayerTreeState.MOVE

func _ready() -> void:
	leaves_shoot_timer.start()
	leaf_shots_remaining = leaf_shots
	tree_gun_animation_player.play("shoot")
	change_state(PlayerTreeState.LANDING)

func TakeControl(control: bool) -> void:
	in_control = control
	
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:

	match current_state:
		PlayerTreeState.MOVE:
			move_state(delta)
		PlayerTreeState.LANDING:
			landing_state(delta)
		PlayerTreeState.LANDED:
			landed_state(delta)
		PlayerTreeState.READY_TO_LAUNCH:
			ready_to_launch_state(delta)
		PlayerTreeState.LAUNCHING:
			launching_state(delta)
		PlayerTreeState.LAUNCHED:
			launched_state(delta)

func change_state(new_state: int) -> void:
	current_state = new_state
	print("PlayerTree's state changed to: %s" % PlayerTreeState.keys()[current_state])
	

func move_state(delta: float) -> void:
	if in_control == false:
		direction = Vector2.ZERO
		return
	
	input_direction.x = (Input.is_action_pressed("move_right") as int) - (Input.is_action_pressed("move_left") as int)
	input_direction.y = (Input.is_action_pressed("move_down") as int) - (Input.is_action_pressed("move_up") as int)
	
	direction = input_direction.normalized()
	
	var global_mouse_pos = get_global_mouse_position()
	to_pointer_direction = (global_mouse_pos - tree_gun_sprite.global_position)
	
	tree_gun.rotation = to_pointer_direction.angle()
	
	if Input.is_action_just_pressed("shoot_secondary"):
		if is_zero_approx(leaves_shoot_timer.time_left):
			shoot_leaves()
	elif Input.is_action_just_pressed("shoot_primary"):		
		shoot_water()
	
	var new_velocity = direction * speed
	velocity = velocity.linear_interpolate(new_velocity, 0.35)
	
	move_and_slide(velocity)
	
	if Input.is_action_just_pressed("board"):
		change_state(PlayerTreeState.LANDING)
	
#	rotation = move_toward(rotation, direction.angle(), 0.5) 


func landing_state(delta: float) -> void:
	
#	if land_ray.is_colliding() == false:
#		return
	
	if player_tree_animation_player.assigned_animation != "landing_sequence":
		
		player_tree_animation_player.play("landing_sequence")
	
#	landing_line.show()
#	landing_line.points[1] = land_ray.get_collision_point() - position

#	var collision_point = land_ray.get_collision_point()

#	var distance_to_ground = global_position.distance_to(collision_point)

	
#
#	if distance_to_ground > 10:
	velocity.y += 75
	velocity.x = lerp(velocity.x, 0, 0.05)
	move_and_slide(velocity)
#	else:
#		current_state = PlayerTreeState.LANDED
#	print("Withing landing range, at point: %s" % str(land_ray.get_collision_point()))


func landed_state(delta: float) -> void:
	
	emit_signal("tree_landed")
	velocity = Vector2.ZERO
	passange_sprite.hide()
	
	change_state(PlayerTreeState.READY_TO_LAUNCH)


func ready_to_launch_state(delta: float) -> void:
	if Input.is_action_just_pressed("board") and player_within_board_distance:
		change_state(PlayerTreeState.LAUNCHED)	

func launching_state(delta: float) -> void:
	
	
	if player_tree_animation_player.assigned_animation != "launch_sequence":
		player_tree_animation_player.play("launch_sequence")
	
	velocity.y -= 50
	move_and_slide(velocity)
	
	if velocity.y < -1000:
		change_state(PlayerTreeState.MOVE)


func launched_state(delta: float) -> void:
	
	emit_signal("tree_launched")
	change_state(PlayerTreeState.LAUNCHING)
	passange_sprite.show()


func shoot_leaves() -> void:
	
	leaves_shoot_timer.start()
	
	var bullet: LeafBullet = leaf_bullet.instance() as LeafBullet
	bullet.Setup(tree_gun_sprite.global_position, to_pointer_direction.angle())
	get_parent().add_child(bullet)
	bullet.scale = Vector2.ONE * 2
	tree_gun_animation_player.play("shoot")


func shoot_water() -> void:
	
	if current_water_level < 10:
		return
	
	current_water_level -= 10
	var bullet: WaterBullet = water_bullet_scene.instance() as WaterBullet
	bullet.Setup(tree_gun_sprite.global_position, to_pointer_direction.angle())
	get_parent().add_child(bullet)
	bullet.scale = Vector2.ONE * 2
	
	UpdateWaterLevel()
	
func UpdateWaterLevel() -> void:
	var percent_full = current_water_level / float(max_water_level)
	water_tank.SetWaterLevel(percent_full)

func _on_LeavesShootTimer_timeout() -> void:
	tree_gun_sprite.show()


func _on_WaterRegenTimer_timeout() -> void:
	
	if not current_state in [PlayerTreeState.LANDED, PlayerTreeState.READY_TO_LAUNCH]:
		return
	
	current_water_level = clamp(current_water_level + 10, 0, max_water_level) as int
	UpdateWaterLevel()


func _on_GroundArea2D_body_entered(body: Node) -> void:
	if current_state == PlayerTreeState.LANDING:
		change_state(PlayerTreeState.LANDED)



func _on_BoardArea2D_body_entered(body: Node) -> void:
	if body is Player:
		print("Player entered ship board distance")
		player_within_board_distance = true


func _on_BoardArea2D_body_exited(body: Node) -> void:
	if body is Player:
		print("Player left ship board distance")
		player_within_board_distance = false
