extends AnimatedSprite2D

var walk_distance: float = 180.0
var walk_speed: float = 50.0
var fade_duration: float = 1.5

@onready var secondDialog = get_parent().get_node("SecondDialog")
@onready var ballonBG2 = get_parent().get_node("BallonBG2")

func _ready() -> void:
	start_sequence()

func start_sequence() -> void:
	
	play("idle")
	await get_tree().create_timer(2.0).timeout
	$FirstDialog.visible = true
	$BallonBG1.visible = true
	$FirstDialog.play("talk")
	await get_tree().create_timer(5.0).timeout
	$FirstDialog.stop()
	$FirstDialog.visible = false
	$BallonBG1.visible = false
	play("walk")
	var distance_moved := 0.0
	while distance_moved < walk_distance:
		var step = walk_speed * get_process_delta_time()
		position.x += step
		distance_moved += step
		await get_tree().process_frame
	play("idle")
	secondDialog.visible = true
	ballonBG2.visible = true
	secondDialog.play("talk")
	await get_tree().create_timer(5.0).timeout
	secondDialog.visible = false
	ballonBG2.visible = false

	var fade_timer := 0.0
	while fade_timer < fade_duration:
		fade_timer += get_process_delta_time()
		modulate.a = 1.0 - (fade_timer / fade_duration)
		await get_tree().process_frame
	queue_free()
