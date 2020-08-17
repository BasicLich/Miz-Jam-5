extends Node2D
class_name WaterTank

onready var water_level: ColorRect = $WaterLevel


# Public
func SetWaterLevel(percent_full: float) -> void:
	
	water_level.material.set_shader_param("cut_off", (1.0-percent_full))
	
