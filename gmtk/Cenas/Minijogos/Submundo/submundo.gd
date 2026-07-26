extends MinigameBase

var vitoria: bool = false
enum NOTAS {A, B, C, D, E, F, G}
var senha: Array[int] = []
var notas_tocadas: Array[int] = []

@export var notas: Label
@export var teclado: GridContainer
@export var porta: Label
@export var audios: Array[AudioStreamWAV]

func iniciar() -> void:
	super.iniciar()
	
	for i in 4:
		senha.append(NOTAS.values().pick_random())
		notas.text += NOTAS.find_key(senha[i])
	
	for botao in teclado.get_children():
		if botao is Button:
			botao.pressed.connect(_on_botao_pressed.bind(botao))

func verificar_sucesso() -> bool:
	if vitoria:
		minigame_concluido.emit(true)
		return true
	minigame_concluido.emit(false)
	return false

func _on_botao_pressed(botao: Button) -> void:
	var Orquestrador = get_tree().get_nodes_in_group("orquestrador")[0]
	Orquestrador.tocar_audio_sfx(audios[NOTAS[botao.name]])
	if notas_tocadas.size() != senha.size():
		notas_tocadas.append(NOTAS[botao.name])
	else:
		notas_tocadas.pop_front()
		notas_tocadas.append(NOTAS[botao.name])
	if notas_tocadas == senha:
		vitoria = true
		porta.text = "Open"
