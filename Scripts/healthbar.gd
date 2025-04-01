extends Control

@export var max_health: int = 100
var current_health: int = max_health

@onready var bar = $Bar

func _ready():
	update_bar()

func set_health(value: int):
	current_health = clamp(value, 0, max_health)
	update_bar()

func update_bar():
	bar.max_value = max_health
	bar.value = current_health
