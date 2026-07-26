extends Control

@export_category("Filhos")
@export var timer_minigame: Timer
@export var vidas_container: HBoxContainer
@export var label_timer_minigame: Label
@export var hud: Control
@export var scene_controller: Control

@export_category("Cenas")
@export var tela_conclusao: PackedScene
@export var tela_inicial: PackedScene
@export var tela_seletor: PackedScene

@export_category("Variáveis")
@export var temporizador_minigame: float = 4.0
@export var vidas: int = 3

@export_category("Minigames")
@export var minigames_disponiveis: Array[PackedScene]
var pool_minigames: Array[PackedScene]
var minigame_atual: MinigameBase

func _ready() -> void:
	pool_minigames = minigames_disponiveis.duplicate(true)
	hud.hide()
	carregar_cena(tela_inicial)

func _process(_delta: float) -> void:
	label_timer_minigame.text = String.num(timer_minigame.time_left, 2)

func checar_vitoria() -> void:
	if minigame_atual.verificar_sucesso():
		print("Jogador venceu o minigame atual!")

func _iniciar_jogo() -> void:
	hud.show()
	minigames_disponiveis = pool_minigames.duplicate(true)
	vidas = 3
	Globais.vitoria = false
	for vida: TextureRect in vidas_container.get_children():
		vida.modulate = Color.WHITE
	carregar_cena(tela_seletor)

func parar_timer_minigame() -> void:
	timer_minigame.stop()

func _on_timer_minigame_timeout() -> void:
	checar_vitoria()

func carregar_cena(nova_cena: PackedScene) -> void:
	for filho in scene_controller.get_children():
		filho.queue_free()
	
	var instancia = nova_cena.instantiate()
	
	if instancia is MinigameBase:
		instancia.minigame_concluido.connect(_on_minigame_concluido)
		instancia.call_deferred("iniciar")
		minigame_atual = instancia
		timer_minigame.wait_time = temporizador_minigame
		timer_minigame.start()
	elif instancia.has_signal("iniciar_jogo"): # conectar sinais menu
		instancia.iniciar_jogo.connect(_iniciar_jogo)
		Globais.indice_sprite_personagem = 0
	elif instancia.has_signal("minigame_selecionado"): # conectar sinais seletor
		instancia.minigame_selecionado.connect(_on_minigame_selecionado)
	elif instancia.has_signal("voltar_menu"): # conectar sinais tela final
		hud.hide()
		instancia.voltar_menu.connect(_on_voltar_menu)
	
	scene_controller.add_child(instancia)

func _on_minigame_concluido(sucesso: bool) -> void:
	parar_timer_minigame()
	if sucesso:
		Globais.indice_sprite_personagem += 1
		if minigames_disponiveis.size() == 0:
			Globais.vitoria = true
			carregar_cena(tela_conclusao) # com vitória
		else:
			carregar_cena(tela_seletor)
	else:
		vidas -= 1
		# diminuir uma vida do hud
		var vida: TextureRect = vidas_container.get_child(vidas)
		vida.modulate = Color.DIM_GRAY
		tocar_audio_sfx(load("res://Audios/SFX-1/lose.mp3"))
		if vidas == 0:
			Globais.vitoria = false
			carregar_cena(tela_conclusao) # com derrota
		else:
			carregar_cena(tela_seletor)
		print("Perdeu Minigame!") # aplicar debuf/ diminui o tempo maximo por minigame

func _on_minigame_selecionado(minigame: PackedScene) -> void:
	minigames_disponiveis.erase(minigame)
	carregar_cena(minigame)

func _on_voltar_menu() -> void:
	carregar_cena(tela_inicial)

func sortear_minigames() -> Array[PackedScene]:
	# Trava de segurança se a lista esvaziar
	if minigames_disponiveis.is_empty():
		return []
		
	minigames_disponiveis.shuffle()
	
	var sorteados: Array[PackedScene] = []
	sorteados.append(minigames_disponiveis[0])
	
	if minigames_disponiveis.size() > 1:
		sorteados.append(minigames_disponiveis[1])
		
	return sorteados

func tocar_audio_sfx(audio: AudioStream) -> void:
	$AudioSFX.stream = audio
	$AudioSFX.play()
