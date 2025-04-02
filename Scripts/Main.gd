extends Node2D

@onready var crosshair_scene: PackedScene = preload("res://Scenes/crosshair.tscn")
var crosshair: Node2D

func _ready():
	crosshair = crosshair_scene.instantiate()
	add_child(crosshair)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	if crosshair:
		crosshair.global_position = get_global_mouse_position()
