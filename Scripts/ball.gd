extends Area2D

@export var speed: float = 300.0
var direction: Vector2 = Vector2.ZERO
var damage: int = 10

func _process(delta):
	position += direction * speed * delta

func _on_area_entered(area):
	queue_free()

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
