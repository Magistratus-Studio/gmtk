extends Control

signal iniciar_jogo()

func _on_iniciar_button_pressed() -> void:
	iniciar_jogo.emit()

func _on_sair_button_pressed() -> void:
	get_tree().quit()

func _on_config_button_pressed() -> void:
	pass # Replace with function body.
