extends Area2D

@onready var pirate_scene: PackedScene = preload("res://Scenes/pirate.tscn")

var piratas: Array = []
var ja_spawnou := false
var todos_mortos := false

func _on_body_entered(body):
	if body.name == "Player" and not ja_spawnou:
		ja_spawnou = true
		spawnar_piratas(body)

func spawnar_piratas(player: Node2D):
	var centro = Vector2(18, -500)
	var espacamento = 300

	for i in range(2):
		var pirate = pirate_scene.instantiate()

		var offset = Vector2((i - 1) * espacamento, 0)
		pirate.global_position = centro + offset

		pirate.pode_atacar = false
		pirate.formacao_index = i - 1
		pirate.formacao_centro = player

		# Conectamos o sinal died e passamos o pirata como argumento
		pirate.connect("died", Callable(self, "_on_pirate_died").bind(pirate))

		add_child(pirate)
		piratas.append(pirate)

	await get_tree().create_timer(3.0).timeout

	for pirate in piratas:
		pirate.pode_atacar = true

func _on_pirate_died(pirate):
	if pirate in piratas:
		piratas.erase(pirate)

	if piratas.size() == 0:
		todos_mortos = true
