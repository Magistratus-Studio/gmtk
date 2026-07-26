extends MinigameBase

@export var caminho_pedra: PathFollow2D
@export var pedra: Sprite2D
@export var sisifu: AnimatedSprite2D

var progresso_alvo: float = 0.0

func iniciar() -> void:
	super.iniciar()
	
	caminho_pedra.progress_ratio = 0

func verificar_sucesso() -> bool:
	if caminho_pedra.progress_ratio >= 0.9:
		minigame_concluido.emit(true)
		return true
	minigame_concluido.emit(false)
	return false

func _process(delta: float) -> void:
	progresso_alvo -= 0.3 * delta
	progresso_alvo = max(0.0, progresso_alvo)
	pedra.rotation = lerpf(caminho_pedra.progress_ratio, progresso_alvo, 0.05) * 10
	caminho_pedra.progress_ratio = lerpf(caminho_pedra.progress_ratio, progresso_alvo, 0.05)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("clique_esquerdo"):
		progresso_alvo += 0.2
	progresso_alvo = min(1.0, progresso_alvo)
