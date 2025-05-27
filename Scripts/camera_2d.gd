extends Camera2D

@export var target_path: NodePath  

var target: Node2D = null
var waiting_for_animation = false

@onready var ship = get_parent().get_node("Ship/shipSize")

func _ready():
	if target_path != null and has_node(target_path):
		target = get_node(target_path)

	make_current()
	
func _process(delta):
	if is_instance_valid(target):
		global_position = target.global_position
	elif not waiting_for_animation:
		waiting_for_animation = true
		$ControlZoom.play("ballons")
		ship.play("shipSize")
		$ControlZoom.animation_finished.connect(_on_animation_finished)
	
	if Input.is_action_just_pressed("skip"):
		var loading := preload("res://Scenes/loading.tscn").instantiate()
		loading.next_scene_path = "res://Scenes/scene1.tscn"
		get_tree().root.add_child(loading)
		get_tree().current_scene.queue_free()

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "ballons":
		get_tree().change_scene_to_file("res://Scenes/scene1.tscn")
