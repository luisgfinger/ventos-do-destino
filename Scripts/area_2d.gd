extends Area2D

@export var gold_amount: int = 300

func _on_body_entered(body):
	if body.name == "Player":
		var gold_manager = get_node("/root/Main/GoldManager")
		gold_manager.add_gold(gold_amount)
		queue_free()
