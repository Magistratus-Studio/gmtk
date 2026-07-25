extends Control

signal minigame_selecionado(minigame: PackedScene)
@export var sisifus: PackedScene
@export var ciclope: PackedScene
@export var medusa: PackedScene
@export var hidra: PackedScene
@export var odisseu: PackedScene

func _on_button_2_pressed() -> void:
	minigame_selecionado.emit(sisifus)

func _on_button_pressed() -> void:
	minigame_selecionado.emit(ciclope)

func _on_button_3_pressed() -> void:
	minigame_selecionado.emit(medusa)

func _on_button_4_pressed() -> void:
	minigame_selecionado.emit(hidra)

func _on_button_5_pressed() -> void:
	minigame_selecionado.emit(odisseu)
