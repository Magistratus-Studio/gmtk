extends MinigameBase

@export var rocha_cima: Sprite2D
@export var rocha_baixo: Sprite2D
@export var barco: Sprite2D
@export var barra_forca: ProgressBar

var vitoria: bool = false
var tween: Tween

var forca_atual: float = 1.0
var forca_maxima: float = 550.0
var taxa_crescimento: float = 800.0
var carregando: bool = false
var velocidade: float = 0.0
var velocidade_rocha: float = 50.0
@export var gradiente_de_cor: Gradient
var cor_atual: Color
var atrito: float = 350.0
var posicao_inicial_rocha: Vector2 = Vector2.ZERO

func iniciar() -> void:
	super.iniciar()
	barra_forca.max_value = forca_maxima
	posicao_inicial_rocha = rocha_baixo.global_position

func verificar_sucesso() -> bool:
	if vitoria:
		minigame_concluido.emit(true)
		return true
	minigame_concluido.emit(false)
	return false

func _process(delta: float) -> void:
	if carregando and not vitoria:
		var progresso: float = min(forca_atual / forca_maxima, 1.0)
		var estilo_preenchimento = barra_forca.get_theme_stylebox("fill") as StyleBoxFlat
		if estilo_preenchimento:
			estilo_preenchimento.bg_color = gradiente_de_cor.sample(progresso)
		forca_atual += taxa_crescimento * delta
		barra_forca.value = forca_atual
		if forca_atual >= forca_maxima or forca_atual <= 0:
			taxa_crescimento *= -1.0
	
	barco.global_position += Vector2.RIGHT * velocidade * delta
	velocidade -= atrito * delta
	velocidade = max(velocidade, 0)
	
	rocha_baixo.global_position.y += -velocidade_rocha * delta
	rocha_cima.global_position.y += velocidade_rocha * delta
	if rocha_baixo.global_position.y >= posicao_inicial_rocha.y:
		velocidade_rocha *= -1.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("clique_esquerdo"):
		carregando = true
		forca_atual = 1.0
	
	if event.is_action_released("clique_esquerdo"):
		carregando = false
		velocidade = forca_atual

func _on_colisor_barco_area_entered(area: Area2D) -> void:
	if area.is_in_group("alvo"):
		vitoria = true
	else :
		barco.queue_free()
		set_process(false)

func _on_colisor_rocha_area_entered(_area: Area2D) -> void:
	velocidade_rocha *= -1.0
