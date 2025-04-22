extends Control

signal pay
signal fight

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	self.process_mode = Node.PROCESS_MODE_ALWAYS

	get_tree().paused = true

	$Panel/Close.pressed.connect(_on_fechar)
	$Panel/VBoxContainer/Pay.pressed.connect(_on_pagar)
	$Panel/VBoxContainer2/Fight.pressed.connect(_on_lutar)
	
func _on_fechar():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	queue_free()

func _on_lutar():
	emit_signal("fight")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	queue_free()

func _on_pagar():
	if GameData.gold >= 500:
		emit_signal("pay")
		GameData.remove_gold(500)
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		get_tree().paused = false
		queue_free()
	
		
