extends KinematicBody2D
class_name Player

export var speed = 200
export var max_water_level = 100

export var leaf_bullet: PackedScene
export var water_bullet_scene: PackedScene

onready var leaves_shoot_timer: Timer = $LeavesShootTimer
onready var tree_gun: Node2D = $TreeGun
onready var tree_gun_sprite: Sprite = $TreeGun/Leaves
onready var water_tank: WaterTank = $WaterTank

onready var tree_gun_animation_player: AnimationPlayer = $TreeGun_AnimationPlayer


var current_water_level: int = 100

var direction: Vector2 = Vector2.ZERO
var input_direction: Vector2 = Vector2.ZERO
var to_pointer_direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO


func _process(delta: float) -> void:
	
	input_direction.x = (Input.is_action_pressed("move_right") as int) - (Input.is_action_pressed("move_left") as int)
	input_direction.y = (Input.is_action_pressed("move_down") as int) - (Input.is_action_pressed("move_up") as int)
	
	direction = input_direction.normalized()
	
	var global_mouse_pos = get_global_mouse_position()
	to_pointer_direction = (global_mouse_pos - tree_gun_sprite.global_position)
	
	tree_gun.rotation = to_pointer_direction.angle()
	
	if Input.is_action_just_pressed("shoot_primary"):
		if is_zero_approx(leaves_shoot_timer.time_left):
			shoot_leaves()
	elif Input.is_action_just_pressed("shoot_secondary"):
		
		shoot_water()
	
func _physics_process(delta: float) -> void:
	
	var new_velocity = direction * speed
	velocity = velocity.linear_interpolate(new_velocity, 0.35)
	
	move_and_slide(velocity)
	
#	position += velocity
	

func shoot_leaves() -> void:
	
	leaves_shoot_timer.start()
	
	var bullet: LeafBullet = leaf_bullet.instance() as LeafBullet
	bullet.Setup(tree_gun_sprite.global_position, to_pointer_direction.angle())
	get_parent().add_child(bullet)
	bullet.scale = Vector2.ONE * 3
	tree_gun_animation_player.play("shoot")

func shoot_water() -> void:
	
	if current_water_level < 10:
		return
	
	current_water_level -= 10
	var bullet: WaterBullet = water_bullet_scene.instance() as WaterBullet
	bullet.Setup(tree_gun_sprite.global_position, to_pointer_direction.angle())
	get_parent().add_child(bullet)
	bullet.scale = Vector2.ONE * 3
	
	UpdateWaterLevel()
	
func UpdateWaterLevel() -> void:
	var percent_full = current_water_level / float(max_water_level)
	water_tank.SetWaterLevel(percent_full)

func _on_LeavesShootTimer_timeout() -> void:
	tree_gun_sprite.show()


func _on_WaterRegenTimer_timeout() -> void:
	current_water_level = clamp(current_water_level + 10, 0, max_water_level) as int
	UpdateWaterLevel()
