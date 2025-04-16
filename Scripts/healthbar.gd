extends Control

@export var max_health: int = 100
var current_health: int = max_health

@onready var bar: ProgressBar = $Bar

func _ready():
	update_bar()

func set_health(value: int):
	current_health = clamp(value, 0, max_health)
	update_bar()

func update_bar():
	bar.max_value = max_health
	bar.value = current_health

	var percent := float(current_health) / float(max_health)

	var color := Color.WHITE
	if percent > 0.66:
		color = Color(0.2, 1.0, 0.2) 
	elif percent > 0.33:
		color = Color(1.0, 1.0, 0.2) 
	else:
		color = Color(1.0, 0.2, 0.2)  

	var fill_style := StyleBoxFlat.new()
	fill_style.bg_color = color
	bar.add_theme_stylebox_override("fill", fill_style)
