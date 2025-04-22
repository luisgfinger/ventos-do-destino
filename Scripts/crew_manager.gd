extends Node

var crew:= GameData.crew

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
		GameData.crew = crew
		label.text = "%d" % GameData.crew

func _ready():
	update_ui()
