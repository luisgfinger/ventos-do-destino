extends Node2D

@onready var crosshair_scene: PackedScene = preload("res://Scenes/crosshair.tscn")
@onready var arrow_pointer_scene: PackedScene = preload("res://Scenes/seta_direcional_2d.tscn")
@onready var pauseMenu_scene: PackedScene = preload("res://Scenes/pauseMenu.tscn")

var crosshair: Node2D
var arrow_pointer: Node2D
var pauseMenu = Control

var mission1_completed := false
var mission2_completed := false

var control := 1;

var total_ships := 5
var dead_ships := 0

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
	
	$Map.monitoring = false
	$Map.visible = false
	
	$UI/Objetivos/Mission1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$UI/Objetivos/Mission2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$UI/Objetivos/Mission4.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$UI/Objetivos/Mission5.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$UI/Objetivos/Mission6.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		pauseMenu = pauseMenu_scene.instantiate()
		$UI.add_child(pauseMenu)
	if crosshair:
		crosshair.global_position = get_global_mouse_position()
	var goldLabel = get_node_or_null("UI/GoldLabel")
	var cannonLabel = get_node_or_null("UI/CannonLabel")
	var crewLabel = get_node_or_null("UI/CrewLabel")

	if goldLabel: goldLabel.text = "%d" % GameData.gold
	if cannonLabel: cannonLabel.text = "%d" % GameData.cannon
	if crewLabel: crewLabel.text = "%d" % GameData.crew
	
	if not mission1_completed:
		mission_1()
		
	elif mission1_completed and control == 1:
		$UI/Objetivos/Mission1.button_pressed = true
		$UI/Objetivos/Mission1.disabled = true
		$MissionArrow.visible = false
		arrow_pointer.visible = false
		
	if not mission2_completed and mission1_completed:
		if control == 1:
			$MissionArrow.visible = true
			arrow_pointer.visible = true
			$Map.visible = true
			$Map.monitoring = true
			$UI/Objetivos/MissionAnimate.play("missionsAnimate2")
			$MissionArrow/arrowAnimate.play("arrowAnimation2")
			control = 2;
		mission2()
		
	elif mission2_completed:
		$MissionArrow.visible = false
		arrow_pointer.visible = false
		$UI/Objetivos/Mission2.disabled = true
		$UI/Objetivos/Mission2.button_pressed = true
		var loading := preload("res://Scenes/loading.tscn").instantiate()
		loading.next_scene_path = "res://Scenes/cutScene4.tscn"
		get_tree().root.add_child(loading)
		get_tree().current_scene.queue_free()
		
func mission_1():
	$Boss1.attack.connect(_on_boss_attack)
	$Boss1.live.connect(_on_boss_live)
	
	if $Boss1.pode_atacar == true:
		control = 2
		$UI/Objetivos/Mission1.button_pressed = true
		$UI/Objetivos/Mission1.disabled = true
		$MissionArrow.visible = false
		arrow_pointer.visible = false
		mission1_completed = true
		$SpainShip.died.connect(_on_ship_died)
		$SpainShip2.died.connect(_on_ship_died)
		$SpainShip3.died.connect(_on_ship_died)
		$SpainShip4.died.connect(_on_ship_died)
		$Boss1.died.connect(_on_ship_died)
		
func mission2():
	$Map.coletado.connect(_on_map_colect)
			
func _on_boss_attack():
	BgSong.pausar_musica()
	BattleSong.retomar_musica()
	mission1_completed = true
	$UI/Objetivos/Mission1.button_pressed = true
	$UI/Objetivos/Mission1.disabled = true
	$MissionArrow.visible = false
	arrow_pointer.visible = false
	mission1_completed = true
	control = 2
	await get_tree().create_timer(2.0).timeout
	$SpainShip.pode_atacar = true
	$SpainShip2.pode_atacar = true
	$SpainShip3.pode_atacar = true
	$SpainShip4.pode_atacar = true
	
	$SpainShip.died.connect(_on_ship_died)
	$SpainShip2.died.connect(_on_ship_died)
	$SpainShip3.died.connect(_on_ship_died)
	$SpainShip4.died.connect(_on_ship_died)
	$Boss1.died.connect(_on_ship_died)
	
func _on_boss_live():
	$SpainShip.fugir = true
	$SpainShip2.fugir = true
	$SpainShip3.fugir = true
	$SpainShip4.fugir = true
	mission1_completed = true
	
func _on_map_colect():
	mission2_completed = true
	
func _on_ship_died():
	dead_ships += 1
	if dead_ships == total_ships:
		BattleSong.pausar_musica()
		BgSong.retomar_musica()
		control = 1
