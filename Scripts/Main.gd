extends Node2D

@onready var crosshair_scene: PackedScene = preload("res://Scenes/crosshair.tscn")
@onready var pirate_scene: PackedScene = preload("res://Scenes/pirate.tscn")
@onready var lostMan_scene: PackedScene = preload("res://Scenes/LostMan.tscn")
@onready var tutorial_scene: PackedScene = preload("res://Scenes/tutorial.tscn")
@onready var tutorial2_scene: PackedScene = preload("res://Scenes/tutorial2.tscn")
@onready var tutorial3_scene: PackedScene = preload("res://Scenes/tutorial3.tscn")

var crosshair: Node2D
var pirate: Node2D
var lostMan = Node2D
var tutorial = Node2D
var tutorial2 = Node2D
var tutorial3 = Node2D

var control: int = 1

var mission1_completed := false
var mission2_completed := false
var mission3_completed := false
var mission4_completed := false

func _ready():
	crosshair = crosshair_scene.instantiate()
	add_child(crosshair)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	tutorial = tutorial_scene.instantiate()
	add_child(tutorial)

func _process(delta):
	if crosshair:
		crosshair.global_position = get_global_mouse_position()

	check_mission_progress()

func check_mission_progress():
	if not mission1_completed and $GoldManager.gold >= 300:
		$UI/Objetivos/Mission1.button_pressed = true
		$UI/Objetivos/Mission1.disabled = true
		mission1_completed = true

	if not mission2_completed and $CannonManager.cannon > 1:
		$UI/Objetivos/Mission2.button_pressed = true
		$UI/Objetivos/Mission2.disabled = true
		mission2_completed = true

		tutorial2 = tutorial2_scene.instantiate()
		tutorial2.z_index = 1
		add_child(tutorial2)
		tutorial2.connect("tutorial_closed", Callable(self, "_on_tutorial2_closed"))

	if mission2_completed and not mission3_completed and control == 1:
		$UI/Objetivos/Mission3.visible = true
		lostMan = lostMan_scene.instantiate()
		lostMan.z_index = 0
		add_child(lostMan)
		control = 2

	if mission2_completed and not mission3_completed and $CrewManager.crew >= 2:
		$UI/Objetivos/Mission3.button_pressed = true
		$UI/Objetivos/Mission3.disabled = true
		mission3_completed = true
		start_mission4()

func _on_tutorial2_closed():
	tutorial3 = tutorial3_scene.instantiate()
	tutorial3.z_index = 1
	add_child(tutorial3)

func start_mission4() -> void:
	if control == 3:
		return
	$UI/Objetivos/Mission4.visible = true
	await get_tree().create_timer(1.0).timeout
	pirate = pirate_scene.instantiate()
	add_child(pirate)
	pirate.connect("died", Callable(self, "_on_pirate_died"))
	control = 3

func _on_pirate_died():
	if not mission4_completed:
		$UI/Objetivos/Mission4.button_pressed = true
		$UI/Objetivos/Mission4.disabled = true
		mission4_completed = true
