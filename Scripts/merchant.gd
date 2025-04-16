extends CharacterBody2D

@export var distancia_maxima: float = 100.0

var player: Node2D
var sprite: AnimatedSprite2D
var loja_scene: PackedScene = preload("res://Scenes/loja.tscn")

func _ready():
	sprite = $baloon
	player = get_parent().get_node_or_null("Player")
	sprite.play("shopIcon")

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
			
			var ui_node = get_tree().get_root().find_child("UI", true, false)
			
			if ui_node:
				ui_node.add_child(loja)
			else:
				push_warning("UI node não encontrado. Adicionando ao próprio Merchant.")
				add_child(loja) 
	else:
		if sprite.animation != "shopIcon":
			sprite.play("shopIcon")
