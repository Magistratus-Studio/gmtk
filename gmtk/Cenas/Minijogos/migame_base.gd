extends Control
class_name MinigameBase

signal minigame_concluido(sucesso: bool)

func iniciar() -> void:
	pass

func verificar_sucesso() -> bool:
	push_warning("A função verificar_sucesso não foi sobrescrita no minigame!")
	return false
