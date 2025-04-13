extends Area2D

@export var crew_amount: int = 1

func _on_body_entered(body):
	if body.name == "Player":
		print("Player encontrado")
		var crew_manager = get_node("/root/Main/CrewManager")
		crew_manager.add_crew(crew_amount)
		queue_free()
	else:
		print("player nao encontrado")
