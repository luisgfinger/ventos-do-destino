extends Label

@export var text_to_write : String = "Você precisa encontrar a 
lendária Rosa dos Ventos Eterna!
E precisa encontra-la o mais 
rápido possível!"
@export var speed : float = 0.05

var _current_text : String = ""
var _index : int = 0
var _is_typing : bool = false

func _ready():
	set_text("")

func start_typing():
	if _is_typing:
		return 
	_current_text = ""
	_index = 0
	set_text("")
	_is_typing = true
	typing()

func typing():
	if _index < text_to_write.length():
		_current_text += text_to_write[_index]
		set_text(_current_text)
		_index += 1
		await get_tree().create_timer(speed).timeout
		typing()
	else:
		_is_typing = false
