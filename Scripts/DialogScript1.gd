extends Label

@export var text_to_write : String = "Meu filho! Estou muito doente! Antes de partir, preciso te fazer um último pedido!"
@export var speed : float = 0.05

var _current_text : String = ""
var _index : int = 0
var _is_typing : bool = false
var _processed_text : String = ""

func _ready():
	set_text("")

func start_typing():
	if _is_typing:
		return 
	_current_text = ""
	_index = 0
	set_text("")
	_processed_text = insert_line_breaks(text_to_write, 33)
	_is_typing = true
	typing()

func typing():
	if _index < _processed_text.length():
		_current_text += _processed_text[_index]
		set_text(_current_text)
		_index += 1
		await get_tree().create_timer(speed).timeout
		typing()
	else:
		_is_typing = false

func insert_line_breaks(text: String, line_length: int) -> String:
	var result := ""
	var current_line := ""
	for word in text.split(" "):
		if current_line.length() + word.length() + 1 > line_length:
			result += current_line.strip_edges() + "\n"
			current_line = ""
		current_line += word + " "
	result += current_line.strip_edges()
	return result
