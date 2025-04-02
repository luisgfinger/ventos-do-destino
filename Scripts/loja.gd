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
	var gold_manager = get_node("/root/Main/GoldManager")
	var cannon_manager = get_node("/root/Main/CannonManager")
	
	if gold_manager.gold >= 300:
		gold_manager.remove_gold(300)
		cannon_manager.add_cannon(1)
