extends Control

signal tutorial_closed

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	$Panel/Close.pressed.connect(_on_fechar)

func _on_fechar():
	queue_free()
	emit_signal("tutorial_closed")
