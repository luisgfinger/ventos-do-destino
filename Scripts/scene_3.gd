extends Node2D

@onready var crosshair_scene: PackedScene = preload("res://Scenes/crosshair.tscn")
@onready var arrow_pointer_scene: PackedScene = preload("res://Scenes/seta_direcional_2d.tscn")

var crosshair: Node2D
var arrow_pointer: Node2D

func _ready() -> void:
	GameData.save_game()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	crosshair = crosshair_scene.instantiate()
	add_child(crosshair)
	
	var goldLabel = get_node_or_null("UI/GoldLabel")
	var cannonLabel = get_node_or_null("UI/CannonLabel")
	var crewLabel = get_node_or_null("UI/CrewLabel")
	goldLabel.text = "%d" % GameData.gold
	cannonLabel.text = "%d" % GameData.cannon
	crewLabel.text = "%d" % GameData.crew
	
	$UI/Objetivos/MissionAnimate.play("missionsAnimate")
	$MissionArrow/arrowAnimate.play("arrowAnimation1")
	
	arrow_pointer = arrow_pointer_scene.instantiate()
	add_child(arrow_pointer)
	arrow_pointer.alvo = $MissionArrow

func _process(delta: float) -> void:
	if crosshair:
		crosshair.global_position = get_global_mouse_position()
