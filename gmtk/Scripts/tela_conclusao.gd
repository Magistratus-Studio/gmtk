extends Control

signal voltar_menu()

func _ready() -> void:
	$Titulo.text = "Win" if Globais.vitoria else "Lose"

func _on_button_pressed() -> void:
	voltar_menu.emit()
