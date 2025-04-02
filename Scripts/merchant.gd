extends CharacterBody2D

@export var distancia_maxima: float = 100.0
@export var max_health: int = 100
var current_health: int = max_health

var player: Node2D
var sprite: AnimatedSprite2D
var loja_scene: PackedScene = preload("res://Scenes/loja.tscn")
@onready var health_bar = $HealthBar

func _ready():
	sprite = $baloon
	player = get_parent().get_node_or_null("Player")
	sprite.play("shopIcon")

	health_bar.max_health = max_health
	health_bar.set_health(current_health)

func _process(delta):
	if not player:
		return

	var distancia = global_position.distance_to(player.global_position)
	
	if distancia <= distancia_maxima:
		if sprite.animation != "pressE":
			sprite.play("pressE")

		if Input.is_action_just_pressed("interact") and not get_tree().get_root().has_node("Loja"):
			var loja = loja_scene.instantiate()
			loja.name = "Loja"
			get_tree().get_root().add_child(loja)
	else:
		if sprite.animation != "shopIcon":
			sprite.play("shopIcon")

func take_damage(amount: int):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	health_bar.set_health(current_health)

	if current_health <= 0:
		die()

func die():
	queue_free()
