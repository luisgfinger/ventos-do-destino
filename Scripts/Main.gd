extends Node2D

@onready var crosshair_scene: PackedScene = preload("res://Scenes/crosshair.tscn")
@onready var pirate_scene: PackedScene = preload("res://Scenes/pirate.tscn")
@onready var lostMan_scene: PackedScene = preload("res://Scenes/LostMan.tscn")
@onready var tutorial_scene: PackedScene = preload("res://Scenes/tutorial.tscn")
@onready var tutorial2_scene: PackedScene = preload("res://Scenes/tutorial2.tscn")
@onready var tutorial3_scene: PackedScene = preload("res://Scenes/tutorial3.tscn")
@onready var arrow_pointer_scene: PackedScene = preload("res://Scenes/seta_direcional_2d.tscn")

var arrow_pointer: Node2D
var crosshair: Node2D
var pirate: Node2D
var lostMan = Node2D
var tutorial = Node2D
var tutorial2 = Node2D
var tutorial3 = Node2D
var control: int = 1
var controlPointer = 1
var mission1_completed := false
var mission2_completed := false
var mission3_completed := false
var mission4_completed := false
var mission5_completed := false
var mission6_completed := false
var mission7_completed := false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	tutorial = tutorial_scene.instantiate()
	$UI.add_child(tutorial)
	
	$UI/Objetivos/Mission1.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$UI/Objetivos/Mission2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$UI/Objetivos/Mission3.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$UI/Objetivos/Mission4.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$UI/Objetivos/Mission5.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$UI/Objetivos/Mission6.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$UI/Objetivos/Mission7.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	$UI/Objetivos/MissionAnimate.play("missionsAnimate")
	
	arrow_pointer = arrow_pointer_scene.instantiate()
	add_child(arrow_pointer)
	arrow_pointer.alvo = $MissionArrow
	arrow_pointer.visible = false
	
	$MissionArrow/arrowAnimate.play("arrowAnimation1")
	await $UI/Objetivos/MissionAnimate.animation_finished
	crosshair = crosshair_scene.instantiate()
	add_child(crosshair)
	$Fase1.visible = false
	$Fase1.monitoring = false
	
	$UI/Objetivos/Mission6.visible = false

	var map = $Fase1.get_node_or_null("Map")
	if map:
		map.connect("coletado", Callable(self, "_on_item_coletado"))
		
	$Cutscenes.visible = false

func _process(delta):
	if crosshair:
		crosshair.global_position = get_global_mouse_position()
	check_mission_progress()
	if controlPointer == 1:
		arrow_pointer.visible = true
		controlPointer = 2
	var goldLabel = get_node_or_null("UI/GoldLabel")
	var cannonLabel = get_node_or_null("UI/CannonLabel")
	var crewLabel = get_node_or_null("UI/CrewLabel")
	goldLabel.text = "%d" % GameData.gold
	cannonLabel.text = "%d" % GameData.cannon
	crewLabel.text = "%d" % GameData.crew

func check_mission_progress():
	if not mission1_completed and GameData.gold >= 300:
		$UI/Objetivos/Mission1.button_pressed = true
		$UI/Objetivos/Mission1.disabled = true
		$MissionArrow/arrowAnimate.stop()
		$MissionArrow/arrowAnimate.play("arrowAnimation2")
		mission1_completed = true

	if not mission2_completed and GameData.cannon > 1:
		$UI/Objetivos/Mission2.button_pressed = true
		$UI/Objetivos/Mission2.disabled = true
		$MissionArrow/arrowAnimate.stop()
		$MissionArrow/arrowAnimate.play("arrowAnimation3")
		mission2_completed = true

		tutorial2 = tutorial2_scene.instantiate()
		tutorial2.z_index = 1
		$UI.add_child(tutorial2)
		tutorial2.connect("tutorial_closed", Callable(self, "_on_tutorial2_closed"))

	if mission2_completed and not mission3_completed and control == 1:
		$UI/Objetivos/Mission3.visible = true
		$UI/Objetivos/MissionAnimate.play("missionsAnimate2")
		lostMan = lostMan_scene.instantiate()
		lostMan.z_index = 0
		add_child(lostMan)
		control = 2

	if mission2_completed and not mission3_completed and GameData.crew >= 2:
		$UI/Objetivos/Mission3.button_pressed = true
		$UI/Objetivos/Mission3.disabled = true
		$MissionArrow/arrowAnimate.stop()
		$MissionArrow.visible = false
		mission3_completed = true
		start_mission4()
		
	if mission4_completed and not mission5_completed and control == 3:
		$Fase1.visible = true
		$Fase1.monitoring = true
		arrow_pointer.visible = true
		$MissionArrow/arrowAnimate.play("arrowAnimation4")
		$UI/Objetivos/MissionAnimate.play("missionsAnimate4")
		control = 4
		
	if mission4_completed and not mission5_completed and $Fase1.ja_spawnou:
		$UI/Objetivos/Mission5.disabled = true
		$UI/Objetivos/Mission5.button_pressed = true
		$Fase1/Map.monitoring = false
		$MissionArrow/arrowAnimate.stop()
		$MissionArrow.visible = false
		arrow_pointer.visible = false
		mission5_completed = true
		BgSong.pausar_musica()
		BattleSong.retomar_musica()
		
	if mission5_completed and not mission6_completed and control == 4:
		$UI/Objetivos/Mission6.visible = true
		$UI/Objetivos/MissionAnimate.play("missionsAnimate5")
		control = 5
		mostrar_cutscene()
		await get_tree().create_timer(10.0).timeout
		$Cutscenes.visible = false
		get_tree().paused = false
		
		
	if not mission6_completed and $Fase1.todos_mortos:
		$UI/Objetivos/Mission6.button_pressed = true
		$UI/Objetivos/Mission6.disabled = true
		$UI/Objetivos/Mission7.visible = true
		$UI/Objetivos/MissionAnimate.play("missionsAnimate6")
		mission6_completed = true
		$Fase1/Map.monitoring = true
		$MissionArrow/arrowAnimate.play("arrowAnimation4")
		arrow_pointer.visible = true
		BattleSong.pausar_musica()
		BgSong.retomar_musica()

func _on_item_coletado():
	if mission6_completed and not mission7_completed:
		var loading := preload("res://Scenes/loading.tscn").instantiate()
		loading.next_scene_path = "res://Scenes/scene2.tscn"
		get_tree().root.add_child(loading)
		get_tree().current_scene.queue_free()
	
func _on_tutorial2_closed():
	tutorial3 = tutorial3_scene.instantiate()
	tutorial3.z_index = 1
	$UI.add_child(tutorial3)

func start_mission4() -> void:
	if control == 3:
		return
	arrow_pointer.visible = false
	$UI/Objetivos/Mission4.visible = true
	$UI/Objetivos/MissionAnimate.play("missionsAnimate3")
	await get_tree().create_timer(1.0).timeout
	pirate = pirate_scene.instantiate()
	pirate.player = $Player
	add_child(pirate)
	pirate.pode_atacar = true
	BgSong.pausar_musica()
	BattleSong.tocar_musica()
	pirate.connect("died", Callable(self, "_on_pirate_died"))
	control = 3

func _on_pirate_died():
	BattleSong.pausar_musica()
	BgSong.retomar_musica()
	if not mission4_completed:
		$UI/Objetivos/Mission4.button_pressed = true
		$UI/Objetivos/Mission4.disabled = true
		mission4_completed = true
		
func mostrar_cutscene():
	get_tree().paused = true
	
	var cutscene_scene = preload("res://Scenes/cutScene2.tscn")
	var cutscene = cutscene_scene.instantiate()
	
	$Cutscenes.visible = true
	$Cutscenes/Control.add_child(cutscene)
