extends Control

func _ready() -> void:
	$Music1.play()
	$Music2.play()
	
func _process(delta: float) -> void:
	pass

func _on_continue_button_pressed() -> void:
	pass

func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/intro.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
