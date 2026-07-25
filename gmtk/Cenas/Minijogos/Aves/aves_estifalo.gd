extends MinigameBase

var vitoria: int = 0

@export var contador_aves: HBoxContainer
@export var container_aves: Node2D
@onready var tamanho_tela: Vector2 = get_viewport_rect().size

func iniciar() -> void:
	super.iniciar()
	
	for ave in container_aves.get_children():
		ave.abatido.connect(_on_ave_abatido)
		ave.global_position.x = randf_range(0, tamanho_tela.x)
		ave.global_position.y = randf_range(100, tamanho_tela.y - 50)

func verificar_sucesso() -> bool:
	if vitoria == 7:
		minigame_concluido.emit(true)
		return true
	minigame_concluido.emit(false)
	return false

func _on_ave_abatido(ave: Sprite2D) -> void:
	ave.queue_free()
	vitoria += 1
	contador_aves.get_child(0).queue_free()
