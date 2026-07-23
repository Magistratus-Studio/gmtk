extends Control

#signal finalizar(situacao: int)

@export_category("Filhos")
@export var timer_principal: Timer
@export var timer_minigame: Timer
@export var barra_timer_principal: ProgressBar
@export var barra_timer_minigame: ProgressBar
@export var label_timer_principal: Label
@export var label_timer_minigame: Label

@export_category("Cena Final")
@export var tela_conclusao: PackedScene

@export_category("Variáveis")
@export var TIMER_TOTAL: float = 10.0

var temporizador_minigame: float = 2.0

func _ready() -> void:
	self.visible = false
	barra_timer_principal.max_value = TIMER_TOTAL

func _process(_delta: float) -> void:
	label_timer_principal.text = String.num(timer_principal.time_left, 2)
	label_timer_minigame.text = String.num(timer_minigame.time_left, 2)


func iniciar() -> void:
	self.visible = true
	timer_principal.wait_time = TIMER_TOTAL
	timer_principal.start()

func iniciar_minigame() -> void:
	timer_minigame.wait_time = temporizador_minigame
	timer_minigame.start()

func pausar_timer(status: bool) -> void:
	timer_principal.paused = status

func parar_timer_minigame() -> void:
	timer_minigame.stop()

func _on_timer_principal_timeout() -> void:
	#finalizar.emit(Globais.SUCESSO)
	parar_timer_minigame()
	get_tree().change_scene_to_packed(tela_conclusao)


func _on_timer_minigame_timeout() -> void:
	get_tree().change_scene_to_packed(Globais.CENA_SELETOR)
