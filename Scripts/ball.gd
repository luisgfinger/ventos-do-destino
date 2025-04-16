extends Area2D

var speed: float = 300.0
var direction: Vector2 = Vector2.ZERO
var damage: int = 10
var start_position: Vector2
var max_distance: float = 1000.0

func _ready():
	start_position = position

func _process(delta):
	position += direction * speed * delta
	
	if position.distance_to(start_position) >= max_distance:
		queue_free()

func _on_area_entered(area):
	queue_free()

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()
