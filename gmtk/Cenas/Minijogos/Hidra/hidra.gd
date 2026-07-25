extends MinigameBase
# enquanto estiver segurando, cabeça deve tremer
@export var cabeca_container: HBoxContainer

var vitoria: int = 0
var tempo_segurar: float = 0.0
var tempo_segurar_requerido: float = 0.6
var segurar_apertado: bool = false

var botao_atual: TextureButton = null

@export var intensidade_tremer: float = 5.0 
@export var efeito_escala: float = 1.05
@export var cor_alvo: Color = Color.RED
var posicao_inicial: Vector2 = Vector2.ZERO

func iniciar() -> void:
	super.iniciar()
	
	set_process(false)
	cabeca_container.add_theme_constant_override("separation", 8)
	for filho in cabeca_container.get_children():
		if filho is TextureButton:
			filho.button_down.connect(_on_qualquer_botao_down.bind(filho))
			filho.button_up.connect(_on_qualquer_botao_up.bind(filho))

func verificar_sucesso() -> bool:
	if vitoria == 3:
		minigame_concluido.emit(true)
		return true
	minigame_concluido.emit(false)
	return false

func _process(delta: float) -> void:
	if botao_atual:
		tempo_segurar += delta
		var progresso: float = min(tempo_segurar / tempo_segurar_requerido, 1.0)
		var tremer_atual: float = intensidade_tremer * progresso
		var variacao: Vector2 = Vector2(
			randf_range(-tremer_atual, tremer_atual),
			randf_range(-tremer_atual, tremer_atual))
		
		botao_atual.modulate = Color.WHITE.lerp(cor_alvo, progresso)
		botao_atual.global_position = posicao_inicial + variacao
		botao_atual.scale = Vector2.ONE * lerp(1.0, efeito_escala, progresso)
		
		if tempo_segurar >= tempo_segurar_requerido and not segurar_apertado:
			segurar_apertado = true
			_on_segurar_sucesso(botao_atual)

func _on_qualquer_botao_down(botao: TextureButton) -> void:
	botao_atual = botao
	tempo_segurar = 0.0
	segurar_apertado = false
	botao_atual.pivot_offset = botao_atual.size / 2
	posicao_inicial = botao_atual.global_position
	set_process(true)

func _on_qualquer_botao_up(botao: TextureButton) -> void:
	if botao_atual == botao:
		set_process(false)
		botao_atual.scale = Vector2.ONE
		botao_atual.modulate = Color.WHITE
		botao_atual.global_position = posicao_inicial
		cabeca_container.queue_sort()
		botao_atual = null

func _on_segurar_sucesso(botao: TextureButton) -> void:
	botao.queue_free()
	vitoria += 1
	cabeca_container.add_theme_constant_override("separation", 32)
