extends Node

@onready var player := $Player
@onready var tween := create_tween()

const VOLUME_NORMAL := 0.0
const VOLUME_SILENCIO := -80.0
const DURACAO_FADE := 5.0

func tocar_musica():
	tween.kill()  
	player.stop()
	player.volume_db = VOLUME_SILENCIO
	player.play()
	tween = create_tween()
	tween.tween_property(player, "volume_db", VOLUME_NORMAL, DURACAO_FADE)

func pausar_musica():
	tween.kill()
	tween = create_tween()
	tween.tween_property(player, "volume_db", VOLUME_SILENCIO, DURACAO_FADE)
	tween.tween_callback(Callable(self, "_on_pausa_concluida"))

func _on_pausa_concluida():
	player.stream_paused = true

func retomar_musica():
	player.stream_paused = false
	tween.kill()
	tween = create_tween()
	tween.tween_property(player, "volume_db", VOLUME_NORMAL, DURACAO_FADE)

func parar_musica():
	tween.kill()
	tween = create_tween()
	tween.tween_property(player, "volume_db", VOLUME_SILENCIO, DURACAO_FADE)
	tween.tween_callback(Callable(self, "_on_parada_concluida"))

func _on_parada_concluida():
	player.stop()
