extends MinigameBase

@export var perseu: Sprite2D
@export var medusa: Sprite2D
@export var disparo: PackedScene
@export var timer_medusa: Timer
@export var escudo: AnimatedSprite2D

var venceu: bool = true
var Orquestrador

func iniciar() -> void:
	super.iniciar()
	Orquestrador = get_tree().get_nodes_in_group("orquestrador")[0]

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
	posicao = Vector2(randf_range(0, tamanho_tela.x), randf_range(100, tamanho_tela.y - 100))
	while posicao.distance_to(perseu.global_position) < distancia_segura:
		posicao = Vector2(randf_range(0, tamanho_tela.x), randf_range(100, tamanho_tela.y - 100))
		tentativas += 1
		if tentativas >= max_tentativas:
			posicao = Vector2(104, 240)
			break
	return posicao

func _process(_delta: float) -> void:
	if venceu:
		escudo.look_at(get_global_mouse_position())
		atualizar_sprite(escudo.rotation)

func _on_timer_medusa_timeout() -> void:
	var novo_disparo: Sprite2D = disparo.instantiate()
	novo_disparo.perseu = perseu
	medusa.global_position = posicao_aleatoria()
	if medusa.global_position.x > perseu.global_position.x:
		medusa.flip_h = true
	else:
		medusa.flip_h = false
	novo_disparo.global_position = medusa.global_position
	add_child(novo_disparo)
	Orquestrador.tocar_audio_sfx(load("res://Audios/SFX-1/medusa/medusa-shoot.mp3"))

func _on_colisao_barreira_area_entered(area: Area2D) -> void:
	if area.is_in_group("disparos"):
		area.get_parent().queue_free()
		Orquestrador.tocar_audio_sfx(load("res://Audios/SFX-1/medusa/shield-hit.mp3"))

func _on_colisao_perseu_area_entered(area: Area2D) -> void:
	if area.is_in_group("disparos"):
		area.get_parent().queue_free()
		timer_medusa.stop()
		venceu = false

func atualizar_sprite(angulo_radianos: float) -> void:
	
	var fatia_direcao: int = int(round(angulo_radianos / (PI / 4)))
	
	if fatia_direcao == -4:
		fatia_direcao = 4

	match fatia_direcao:
		
		# --- VERTICAIS PURAS ---
		2: # Baixo (90 graus)
			escudo.animation = "frente"
			escudo.flip_h = false
			
		-2: # Cima (-90 graus)
			escudo.animation = "cima"
			escudo.flip_h = false
			
		# --- LADO ESQUERDO ---
		3, 4: # Diagonal Inferior-Esquerda (135) E Esquerda Pura (180)
			escudo.animation = "esquerda_baixo"
			escudo.flip_h = false
			
		-3: # Diagonal Superior-Esquerda (-135)
			escudo.animation = "esquerda_cima"
			escudo.flip_h = false
			
		# --- LADO DIREITO (Espelhado) ---
		1, 0: # Diagonal Inferior-Direita (45) E Direita Pura (0)
			escudo.animation = "esquerda_baixo"
			escudo.flip_h = true
			
		-1: # Diagonal Superior-Direita (-45)
			escudo.animation = "esquerda_cima"
			escudo.flip_h = true
