extends Node2D

@onready var crosshair_scene: PackedScene = preload("res://Scenes/crosshair.tscn")
@onready var arrow_pointer_scene: PackedScene = preload("res://Scenes/seta_direcional_2d.tscn")

var crosshair: Node2D
var arrow_pointer: Node2D

var mission1_completed := false

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
	
	#$Player.global_position = GameData.player_position
	$UI/Objetivos/MissionAnimate.play("missionsAnimate")
	$MissionArrow/arrowAnimate.play("arrowAnimation1")
	arrow_pointer = arrow_pointer_scene.instantiate()
	add_child(arrow_pointer)
	arrow_pointer.alvo = $MissionArrow

func _process(delta: float) -> void:
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
	elif mission1_completed:
		$UI/Objetivos/Mission1.button_pressed = true
		$UI/Objetivos/Mission1.disabled = true
		$MissionArrow.visible = false
		arrow_pointer.visible = false

func mission_1():
	$Boss1.attack.connect(_on_boss_attack)
	$Boss1.live.connect(_on_boss_live)
	
	if $Boss1.pode_atacar == true:
		mission1_completed = true
	
func _on_boss_attack():
	mission1_completed = true
	await get_tree().create_timer(2.0).timeout
	$SpainShip.pode_atacar = true
	$SpainShip2.pode_atacar = true
	$SpainShip3.pode_atacar = true
	$SpainShip4.pode_atacar = true
	
func _on_boss_live():
	$SpainShip.fugir = true
	$SpainShip2.fugir = true
	$SpainShip3.fugir = true
	$SpainShip4.fugir = true
	mission1_completed = true
