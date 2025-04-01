extends Control

@export var auto_hide: bool = true

@onready var bar: ProgressBar = $Bar

var cooldown_time: float = 1.0
var elapsed: float = 0.0
var running: bool = false

func _process(delta):
	if running:
		elapsed += delta
		bar.value = elapsed
		if elapsed >= cooldown_time:
			stop()

func start(duration: float):
	cooldown_time = duration
	elapsed = 0.0
	bar.max_value = duration
	bar.value = 0.0
	running = true
	visible = true

func stop():
	running = false
	if auto_hide:
		visible = false
