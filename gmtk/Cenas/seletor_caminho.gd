extends Control

signal minigame_selecionado(minigame: PackedScene)
@export var sisifus: PackedScene

func _on_button_2_pressed() -> void:
	minigame_selecionado.emit(sisifus)
