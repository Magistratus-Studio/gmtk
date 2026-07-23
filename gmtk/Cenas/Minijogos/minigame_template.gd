extends Control

@export var label: Label

var contador: int = 0

func _on_button_pressed() -> void:
	contador += 1
	label.text = str(contador)

func _ready() -> void:
	MinigameManagerScene.iniciar_minigame()

func _process(_delta: float) -> void:
	if contador > 4:
		MinigameManagerScene.parar_timer_minigame()
		get_tree().change_scene_to_packed(Globais.CENA_SELETOR)
