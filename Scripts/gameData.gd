extends Node

var gold: int = 0
var cannon: int = 1
var crew: int = 1
var last_scene_path: String = ""

const SAVE_PATH := "user://savegame.save"

func _ready():
	last_scene_path = get_tree().current_scene.scene_file_path

func add_gold(amount: int):
	gold += amount

func remove_gold(amount: int):
	if gold >= amount:
		gold -= amount

func add_cannon(amount: int):
	cannon += amount

func remove_cannon(amount: int):
	if cannon >= amount:
		cannon -= amount

func add_crew(amount: int):
	crew += amount

func remove_crew(amount: int):
	if crew >= amount:
		crew -= amount

func save_game():
	last_scene_path = get_tree().current_scene.scene_file_path

	var save_data = {
		"gold": gold,
		"cannon": cannon,
		"crew": crew,
		"scene_path": last_scene_path
	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()
	print("Jogo salvo!")

func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("Nenhum jogo salvo encontrado.")
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var save_data = JSON.parse_string(content)
	if save_data:
		gold = save_data.get("gold", 0)
		cannon = save_data.get("cannon", 1)
		crew = save_data.get("crew", 1)
		last_scene_path = save_data.get("scene_path", "")

		print("Jogo carregado!")

		if last_scene_path != "":
			get_tree().change_scene_to_file(last_scene_path)
	else:
		print("Erro ao carregar jogo.")
