extends Control

signal finalizar(situacao: int)

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

func _ready() -> void:
	self.visible = false

func iniciar() -> void:
	self.visible = true
	timer_principal.wait_time = TIMER_TOTAL
	timer_principal.start()

func _process(_delta: float) -> void:
	label_timer_principal.text = String.num(timer_principal.time_left, 2)

func _on_timer_principal_timeout() -> void:
	finalizar.emit(Globais.SUCESSO)
