extends Control

func _ready():
	$Panel/Button.pressed.connect(_on_fechar)
func _on_fechar():
	queue_free() 
