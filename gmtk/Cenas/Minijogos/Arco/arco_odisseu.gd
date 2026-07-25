extends MinigameBase

@export var velocidade: float = 450.0
@export var velocidade_angular: float = 2.5
@export var odisseu: Sprite2D
@export var flecha: Sprite2D
@export var desafio: Node2D
@export var limite_angular: int = 45

var vitoria: bool = false
var atirado: bool = false
var direcao: Vector2 = Vector2.ZERO

func iniciar() -> void:
	super.iniciar()
	vitoria = false

func verificar_sucesso() -> bool:
	if vitoria:
		minigame_concluido.emit(true)
		return true
	minigame_concluido.emit(false)
	return false

func _process(delta: float) -> void:
	if atirado:
		flecha.global_position += direcao * velocidade * delta
	else:
		odisseu.rotate(velocidade_angular * delta)
		flecha.rotate(velocidade_angular * delta)
	
	if odisseu.rotation_degrees >= limite_angular or odisseu.rotation_degrees <= -limite_angular:
		velocidade_angular *= -1.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("clique_esquerdo") and not atirado:
		atirado = true
		direcao = Vector2.from_angle(odisseu.rotation)

func _on_colisor_flecha_area_entered(area: Area2D) -> void:
	if area.is_in_group("alvo"):
		vitoria = true
	set_process(false)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	set_process(false)
