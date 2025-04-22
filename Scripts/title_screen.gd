extends Control

func _ready() -> void:
	$Music1.play()
	$Music2.play()

	if not FileAccess.file_exists("user://savegame.save"):
		$MarginContainer/HBoxContainer/VBoxContainer/continue_button.disabled = true

func _on_continue_button_pressed() -> void:
	GameData.load_game()

func _on_new_game_button_pressed() -> void:
	var loading := preload("res://Scenes/loading.tscn").instantiate()
	loading.next_scene_path = "res://Scenes/intro.tscn"
	get_tree().root.add_child(loading)
	get_tree().current_scene.queue_free()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
