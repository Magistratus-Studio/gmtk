extends Sprite2D

var perseu: Sprite2D
@export var velociadade: float = 200.0

func _process(delta: float) -> void:
	var direcao: Vector2 = global_position.direction_to(perseu.global_position)
	global_rotation = direcao.angle()
	global_position += direcao * velociadade * delta
