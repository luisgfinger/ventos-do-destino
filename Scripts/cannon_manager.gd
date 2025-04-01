extends Node

@export var cannon: int = 1

func add_cannon(amount: int):
	cannon += amount
	update_ui()

func remove_cannon(amount: int):
	if cannon >= amount:
		cannon -= amount
		update_ui()

func update_ui():
	var label = get_node_or_null("/root/Main/UI/CannonLabel")
	if label:
		label.text = "%d" % cannon

func _ready():
	update_ui()
