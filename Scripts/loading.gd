extends Control

var next_scene_path: String = ""

var carregador: Thread
var cena_carregada: PackedScene
var carregando: bool = true

func _ready() -> void:
	carregador = Thread.new()
	carregador.start(_carregar_em_thread.bind(next_scene_path))
	
func _process(_delta: float) -> void:
	if not carregando and cena_carregada != null:
		trocar_para_cena()
		carregando = true  

func _carregar_em_thread(caminho: String) -> void:
	var recurso := ResourceLoader.load(caminho)
	if recurso and recurso is PackedScene:
		cena_carregada = recurso
		carregando = false  

func trocar_para_cena() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_packed(cena_carregada)
	queue_free()
