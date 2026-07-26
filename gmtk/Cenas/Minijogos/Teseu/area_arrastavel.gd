extends StaticBody2D

var ocupado: bool = false
@export var id_esperado: String = "triangulo"

func _ready() -> void:
	modulate = Color(Color.MEDIUM_PURPLE, 0.7)

func _process(_delta: float) -> void:
	if Globais.arrastando:
		show()
	else:
		hide()
