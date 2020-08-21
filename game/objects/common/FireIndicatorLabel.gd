extends Node2D
class_name FireIndicatorLabel

export var fire_indicator_color: Color = Color.red


onready var fire_label: Label = $FireLabel
onready var fire_animation_player: AnimationPlayer = $FireAnimationPlayer




func UpdateValue(new_value: int, max_value: int) -> void:

	var fraction: float = float(new_value) / float(max_value)
	
	if new_value > 0:
		fire_label.show()
		fire_animation_player.play("add_fire")
		fire_label.modulate = Color.white.linear_interpolate(fire_indicator_color, fraction )
		fire_label.text = str(new_value)
	else:
		fire_label.modulate = Color.white.linear_interpolate(fire_indicator_color, fraction )
		fire_label.hide()
	
