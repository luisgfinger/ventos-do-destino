extends Slider

func _ready():
	value = -40.0
	AudioServer.set_bus_volume_db(0, value)
	value_changed.connect(_on_value_changed)

func _on_value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(0, new_value)
