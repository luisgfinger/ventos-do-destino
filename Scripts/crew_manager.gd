extends Node

@export var crew: int = 1

func add_crew(amount: int):
	crew += amount
	update_ui()

func remove_crew(amount: int):
	if crew >= amount:
		crew -= amount
		update_ui()

func update_ui():
	var label = get_node_or_null("/root/Main/UI/CrewLabel")
	if label:
		label.text = "%d" % crew

func _ready():
	update_ui()
