extends Node

var gold := GameData.gold

func add_gold(amount: int):
	gold += amount
	update_ui()

func remove_gold(amount: int):
	if gold >= amount:
		gold -= amount
		update_ui()

func update_ui():
	var label = get_node_or_null("/root/Main/UI/GoldLabel")
	if label:
		GameData.gold = gold
		label.text = "%d" % GameData.gold

func _ready():
	update_ui()
