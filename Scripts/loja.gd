extends Control

func _ready():
	$Panel/Close.pressed.connect(_on_fechar)
	$Panel/VBoxContainer/Buy.pressed.connect(_on_comprar)

func _on_fechar():
	queue_free()
	
func _on_comprar():
	var gold_manager = get_node("/root/Main/GoldManager")
	var cannon_manager = get_node("/root/Main/CannonManager")
	if gold_manager.gold >= 300:
		gold_manager.remove_gold(300)
		cannon_manager.add_cannon(1)
