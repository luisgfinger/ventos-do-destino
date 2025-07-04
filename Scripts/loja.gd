extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	self.process_mode = Node.PROCESS_MODE_ALWAYS

	get_tree().paused = true

	$Panel/Close.pressed.connect(_on_fechar)
	$Panel/VBoxContainer/Buy.pressed.connect(_on_comprar)
	
func _on_fechar():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	queue_free()

func _on_comprar():
	if GameData.gold >= 300:
		GameData.remove_gold(300)
		GameData.add_cannon(1)
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		get_tree().paused = false
		queue_free()
	
		
