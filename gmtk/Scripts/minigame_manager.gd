extends Control

@export_category("Filhos")
@export var timer_principal: Timer
@export var timer_minigame: Timer
@export var label_timer_principal: Label
@export var label_timer_minigame: Label
@export var hud: Control
@export var scene_controller: Control

@export_category("Cenas")
@export var tela_conclusao: PackedScene
@export var tela_inicial: PackedScene
@export var tela_seletor: PackedScene

@export_category("Variáveis")
@export var TIMER_TOTAL: float = 20.0
@export var temporizador_minigame: float = 4.0

var minigame_atual: MinigameBase

func _ready() -> void:
	hud.hide()
	carregar_cena(tela_inicial)

func _process(_delta: float) -> void:
	label_timer_principal.text = String.num(timer_principal.time_left, 2)
	label_timer_minigame.text = String.num(timer_minigame.time_left, 2)

func checar_vitoria() -> void:
	if minigame_atual.verificar_sucesso():
		print("Jogador venceu o minigame atual!")
	carregar_cena(tela_seletor)

func _iniciar_jogo() -> void:
	hud.show()
	timer_principal.start(TIMER_TOTAL)
	carregar_cena(tela_seletor)

func pausar_timer(status: bool) -> void:
	timer_principal.paused = status

func parar_timer_minigame() -> void:
	timer_minigame.stop()

func _on_timer_principal_timeout() -> void:
	parar_timer_minigame()
	hud.hide()
	carregar_cena(tela_conclusao)

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
	elif instancia.has_signal("minigame_selecionado"): # conectar sinais seletor
		instancia.minigame_selecionado.connect(_on_minigame_selecionado)
	elif instancia.has_signal("voltar_menu"): # conectar sinais tela final
		instancia.voltar_menu.connect(_on_voltar_menu)
	
	scene_controller.add_child(instancia)

func _on_minigame_concluido(sucesso: bool) -> void:
	parar_timer_minigame()
	if sucesso:
		print("Venceu Minigame!") # passa para o proximo minigame 
	else:
		print("Perdeu Minigame!") # aplicar debuf/ diminui o tempo maximo por minigame

func _on_minigame_selecionado(minigame: PackedScene) -> void:
	carregar_cena(minigame)

func _on_voltar_menu() -> void:
	carregar_cena(tela_inicial)
