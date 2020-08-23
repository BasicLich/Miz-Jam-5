extends Node2D
class_name CameraFollower

onready var camera: Camera2D = $Camera2D

var target: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func SetTarget(new_target: Node2D) -> void:
	target = new_target

func _process(delta: float) -> void:	
	if target != null:	
		global_position = target.global_position
