extends MinigameBase

@export var perseu: Sprite2D
@export var medusa: Sprite2D
@export var disparo: PackedScene
@export var timer_medusa: Timer
@export var area_medusa: Control

var venceu: bool = true

func iniciar() -> void:
	super.iniciar()

func verificar_sucesso() -> bool:
	if venceu:
		minigame_concluido.emit(true)
		return true
	minigame_concluido.emit(false)
	return false

func posicao_aleatoria() -> Vector2:
	var tamanho_tela: Vector2 = get_viewport_rect().size
	var posicao: Vector2 = Vector2.ZERO
	var distancia_segura: float = 200.0
	var tentativas: int = 0
	var max_tentativas: int = 100
	posicao = Vector2(randf_range(0, tamanho_tela.x), randf_range(0, tamanho_tela.y))
	while posicao.distance_to(perseu.global_position) < distancia_segura:
		posicao = Vector2(randf_range(0, tamanho_tela.x), randf_range(0, tamanho_tela.y))
		tentativas += 1
		if tentativas >= max_tentativas:
			posicao = Vector2(104, 240)
			break
	return posicao

func _process(_delta: float) -> void:
	if venceu:
		perseu.look_at(get_global_mouse_position())

func _on_timer_medusa_timeout() -> void:
	var novo_disparo: Sprite2D = disparo.instantiate()
	novo_disparo.perseu = perseu
	medusa.global_position = posicao_aleatoria()
	novo_disparo.global_position = medusa.global_position
	add_child(novo_disparo)

func _on_colisao_barreira_area_entered(area: Area2D) -> void:
	if area.is_in_group("disparos"):
		area.get_parent().queue_free()

func _on_colisao_perseu_area_entered(area: Area2D) -> void:
	if area.is_in_group("disparos"):
		area.get_parent().queue_free()
		timer_medusa.stop()
		venceu = false
