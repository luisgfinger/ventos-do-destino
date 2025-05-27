extends Slider

func _ready():
	value = AudioServer.get_bus_volume_db(0)
	value_changed.connect(_on_value_changed)

func _on_value_changed(new_value: float) -> void:
	AudioServer.set_bus_volume_db(0, new_value)
