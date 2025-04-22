extends Area2D

var gold_amount: int = 300

func _on_body_entered(body):
	if body.name == "Player":
		GameData.add_gold(gold_amount)
		queue_free()
	else:
		print("player nao encontrado")
