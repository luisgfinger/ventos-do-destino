extends Node2D

@onready var crosshair_scene: PackedScene = preload("res://Scenes/crosshair.tscn")
@onready var arrow_pointer_scene: PackedScene = preload("res://Scenes/seta_direcional_2d.tscn")
@onready var pauseMenu_scene: PackedScene = preload("res://Scenes/pauseMenu.tscn")

var crosshair: Node2D
var arrow_pointer: Node2D
var pauseMenu = Control

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
	
	$UI/Objetivos/Mission1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$UI/Objetivos/Mission2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	$Map.monitoring = false
	$Map.visible = false

	$FinalBoss.died.connect(_on_finalBoss_died)
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		pauseMenu = pauseMenu_scene.instantiate()
		$UI.add_child(pauseMenu)
		
	if crosshair:
		crosshair.global_position = get_global_mouse_position()
		
func _on_finalBoss_died():
	$UI/Objetivos/Mission1.button_pressed = true
	$MissionArrow/arrowAnimate.play("arrowAnimation2")
	$UI/Objetivos/MissionAnimate.play("missionsAnimate2")
	arrow_pointer = arrow_pointer_scene.instantiate()
	add_child(arrow_pointer)
	arrow_pointer.alvo = $MissionArrow
	
	$Map.monitoring = true
	$Map.visible = true
	
	$Map.coletado.connect(_on_mapa_coletado)
	
func _on_mapa_coletado():
	var loading := preload("res://Scenes/loading.tscn").instantiate()
	loading.next_scene_path = "res://Scenes/endingScene.tscn"
	get_tree().root.add_child(loading)
	get_tree().current_scene.queue_free()
	
	
	
	
