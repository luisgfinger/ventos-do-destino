extends Control

func _ready() -> void:
	$AnimationPlayer.play("fade")
	await $AnimationPlayer.animation_finished
	var loading := preload("res://Scenes/loading.tscn").instantiate()
	loading.next_scene_path = "res://Scenes/title_screen.tscn"
	get_tree().root.add_child(loading)
	get_tree().current_scene.queue_free()
