extends Control

signal voltar_menu()

func _on_button_pressed() -> void:
	voltar_menu.emit()
