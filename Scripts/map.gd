extends Area2D

signal coletado

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		emit_signal("coletado")
		queue_free()
