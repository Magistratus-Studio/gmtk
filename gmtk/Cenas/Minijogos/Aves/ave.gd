extends Sprite2D

signal abatido(ave: Sprite2D)

@export var velocidade: float = 100.0
var direcao: Vector2 = Vector2.ZERO
@onready var tamanho_tela: Vector2 = get_viewport_rect().size

func _ready() -> void:
	direcao = Vector2.RIGHT.rotated(randf_range(0, TAU))

func _process(delta: float) -> void:
	global_position += direcao * velocidade * delta
	
	global_position.x = clamp(global_position.x, 0, tamanho_tela.x)
	global_position.y = clamp(global_position.y, 100, tamanho_tela.y - 50)

func _on_timer_movimento_timeout() -> void:
	direcao = Vector2.RIGHT.rotated(randf_range(0, TAU))
	rotation = direcao.angle()

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("clique_esquerdo"):
		abatido.emit(self)

func _on_area_2d_area_entered(_area: Area2D) -> void:
	direcao *= -1
