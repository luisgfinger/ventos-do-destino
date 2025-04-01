extends Node

@export var gold: int = 0

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
		label.text = "%d" % gold

func _ready():
	update_ui()
