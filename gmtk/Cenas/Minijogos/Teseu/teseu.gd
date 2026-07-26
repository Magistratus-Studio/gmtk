extends MinigameBase

var areas_ocupadas = 0

func iniciar() -> void:
	super.iniciar()

func verificar_sucesso() -> bool:
	if areas_ocupadas == 3:
		minigame_concluido.emit(true)
		Globais.arrastando = false
		return true
	Globais.arrastando = false
	minigame_concluido.emit(false)
	return false

func contar_peca() -> void:
	var areas = get_tree().get_nodes_in_group("areas_de_drop")
	areas_ocupadas = 0
	for area in areas:
		if area.ocupado == true:
			areas_ocupadas += 1
