extends Node2D

@export var alvo: Node2D
@onready var seta: Node2D = $Seta

const MARGEM_TELA: float = 64.0

func _ready():
	_animar_seta()

func _process(delta: float) -> void:
	if alvo == null or not is_instance_valid(alvo):
		seta.visible = false
		return

	var camera := get_viewport().get_camera_2d()
	if camera == null:
		seta.visible = false
		return

	var viewport_size := get_viewport().get_visible_rect().size
	var centro_tela := viewport_size / 2.0

	# Alvo em coordenadas relativas à câmera
	var pos_alvo_na_tela := (alvo.global_position - camera.global_position) + centro_tela

	var dentro_da_tela := Rect2(Vector2.ZERO, viewport_size).has_point(pos_alvo_na_tela)
	seta.visible = not dentro_da_tela

	if seta.visible:
		var direcao := (alvo.global_position - camera.global_position).normalized()
		var distancia_segura := centro_tela.length() - MARGEM_TELA
		var posicao_seta := centro_tela + direcao * distancia_segura

		var posicao_final := posicao_seta.clamp(
			Vector2(MARGEM_TELA, MARGEM_TELA),
			viewport_size - Vector2(MARGEM_TELA, MARGEM_TELA)
		)

		global_position = camera.global_position + posicao_final - centro_tela
		seta.rotation = direcao.angle()

func _animar_seta():
	var t = create_tween()
	t.set_loops()
	t.tween_property(seta, "scale", Vector2(1.15, 1.15), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	t.tween_property(seta, "scale", Vector2(1.0, 1.0), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
