extends Button

onready var toggle_graphic: CanvasItem = $ToggleGraphic

var toggle_state: bool = false


func _ready() -> void:
	connect("toggled", self, "SetToggle")
	SetToggle(false)
	pass
	
	
func SetToggle(state: bool) -> void:
	toggle_state = state
	toggle_graphic.visible = toggle_state

func Toggle() -> void:
	toggle_state = not toggle_state
	toggle_graphic.visible = toggle_state
