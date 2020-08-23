extends KinematicBody2D
class_name Player

const FLOOR_NORMAL: = Vector2.UP
enum PlayerState {IDLE, MOVE, ONBOARD_TREE, BURNED}

signal burned_up

export var max_velocity: = Vector2(300.0, 1000.0)
export var jump_force: float = 500.0
export var gravity: = 3000.0
export var max_burn_level = 10

onready var animated_sprite: AnimatedSprite = $AnimatedSprite
onready var health_system: HealthSystem = $HealthSystem
onready var weapon_animation_player: AnimationPlayer = $WeaponAnimationPlayer
onready var footsteps_stream_player: AudioStreamPlayer = $FootstepsStreamPlayer
onready var weapon_stream_player: AudioStreamPlayer = $WeaponStreamPlayer
onready var sword_center: Node2D = $SwordCenter
onready var fire_indicator_label: FireIndicatorLabel = $FireIndicatorLabel
#onready var tree_detection_zone: TreeDetectionZone = $TreeDetectionZone
onready var weapon_water_particles: Particles2D = $SwordCenter/SwordPivot/Sword/WaterParticles2D

var _velocity: = Vector2.ZERO
var in_control: bool = true
var current_state: int = PlayerState.IDLE

var fire_level: int = 0
var can_extinguish_tree: bool = true
var can_hit_fire: bool = true

# Public
func TakeControl(control: bool):
	in_control = control
	
	if in_control == false:
		fire_indicator_label.hide()
	else:
		fire_indicator_label.show()


func _ready() -> void:
	fire_level = 0
	fire_indicator_label.UpdateValue(fire_level, max_burn_level)
	can_extinguish_tree = true
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
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL, true)
	
#	if abs(_velocity.y) > 0:
#		animated_sprite.play("jump")
	if abs(direction.x) > 0:
		if footsteps_stream_player.playing == false:
			footsteps_stream_player.play()
		animated_sprite.play("move")
		animated_sprite.flip_h = true if direction.x < 0 else false
		sword_center.scale = Vector2(1,1) if direction.x > 0 else Vector2(-1, 1)
	else:
		if footsteps_stream_player.playing == true or is_on_floor() == false:
			footsteps_stream_player.stop()
		else:
			animated_sprite.play("idle")
	
	if Input.is_action_just_pressed("shoot_primary"):
		if weapon_animation_player.is_playing() == false:
			weapon_animation_player.play("attack2")
			var rand: float = randf() * 0.15
			weapon_stream_player.pitch_scale = (1.0 - 0.15 / 2.0) + rand 
			weapon_stream_player.play()
	
	if global_position.y > 725:
		_burned()
#	if tree_detection_zone.CanSeeTree():
#		var closest_tree = tree_detection_zone.ClosestTree()
#		if closest_tree.is_burning and can_extinguish_tree:
#			closest_tree.Extinguish()

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


func _on_Sword_body_entered(body: Node) -> void:
	if body is BaseEnemyFire and weapon_animation_player.is_playing() and can_hit_fire:
		var enemy: BaseEnemyFire = body as BaseEnemyFire
		var vector: Vector2 = global_position.direction_to(enemy.global_position)
		enemy.velocity += Vector2(0, -250)
		enemy.velocity.x += 400 * sword_center.scale.x
		enemy.health_system.Damage(1)
		weapon_water_particles.emitting = true
		AddFire()
		can_hit_fire = false
	if body is FireSpawner and weapon_animation_player.is_playing():
		body.health_system

func AddFire() -> void:
	
	fire_level += 1
	$CoolOffTimer.start()
	fire_indicator_label.UpdateValue(fire_level, max_burn_level)
	if fire_level >= max_burn_level:
		_burned()
		

func RemoveFire() -> void:
	if fire_level > 0:
		fire_level -= 1
		fire_indicator_label.UpdateValue(fire_level, max_burn_level)


func _on_CoolOffTimer_timeout() -> void:
	RemoveFire()


func _burned() -> void:
	fire_level = 0
	fire_indicator_label.UpdateValue(fire_level, max_burn_level)
	$DeathStreamPlayer.play()
	change_state(PlayerState.BURNED)
	Globals.emit_signal("player_burned")


func _on_WeaponAnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "attack2":
		
		if $TreeDetectionZone.CanSeeTree():
			var closest_tree = $TreeDetectionZone.ClosestTree()
			if closest_tree.is_burning and can_extinguish_tree:
				closest_tree.Extinguish()
				can_extinguish_tree = false
				weapon_water_particles.emitting = true
		pass


func _on_WeaponAnimationPlayer_animation_started(anim_name: String) -> void:
	if anim_name == "attack2":
		can_extinguish_tree = true
		can_hit_fire = true
		pass


func _on_Sword_area_entered(area: Area2D) -> void:
	if area is FireSpawner:
		area.health_system.Damage(1, true)
		weapon_water_particles.emitting = true

