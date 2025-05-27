extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	
func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	queue_free()
	
func _on_new_game_button_pressed() -> void:
	get_tree().paused = false
	var loading := preload("res://Scenes/loading.tscn").instantiate()
	loading.next_scene_path = "res://Scenes/cutScene1.tscn"
	get_tree().root.add_child(loading)
	get_tree().current_scene.queue_free()

func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	var loading := preload("res://Scenes/loading.tscn").instantiate()
	loading.next_scene_path = "res://Scenes/title_screen.tscn"
	get_tree().root.add_child(loading)
	get_tree().current_scene.queue_free()
