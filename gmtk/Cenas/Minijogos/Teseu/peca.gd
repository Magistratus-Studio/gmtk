extends Node2D

var arrastavel: bool = false
var dentro_area: bool = false
var referencia_corpo
var variacao: Vector2
var escala_original: Vector2
var area_atual_ocupada: Node2D = null
@export var meu_id: String = "triangulo"
var posicao_no_monte: Vector2

func _ready() -> void:
	posicao_no_monte = global_position

func _process(_delta: float) -> void:
	if arrastavel:
		if Input.is_action_just_pressed("clique_esquerdo"):
			variacao = get_global_mouse_position() - global_position
			Globais.arrastando = true
			
			if area_atual_ocupada != null:
				area_atual_ocupada.ocupado = false
				area_atual_ocupada = null
		
		if Input.is_action_pressed("clique_esquerdo"):
			global_position = get_global_mouse_position() - variacao
		elif Input.is_action_just_released("clique_esquerdo"):
			Globais.arrastando = false
			var tween: Tween = get_tree().create_tween()
			if dentro_area and referencia_corpo != null and not referencia_corpo.ocupado and meu_id == referencia_corpo.id_esperado:
				tween.tween_property(self, "position", referencia_corpo.position, 0.2).set_ease(Tween.EASE_OUT)
				referencia_corpo.ocupado = true
				area_atual_ocupada = referencia_corpo
				
				get_parent().contar_peca()
			else:
				tween.tween_property(self, "global_position", posicao_no_monte, 0.2).set_ease(Tween.EASE_OUT)

func _on_area_2d_mouse_entered() -> void:
	if not Globais.arrastando:
		arrastavel = true
		escala_original = scale
		scale *= 1.05

func _on_area_2d_mouse_exited() -> void:
	if not Globais.arrastando:
		arrastavel = false
		scale = escala_original

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("dropable"):
		if not body.ocupado:
			dentro_area = true
			body.modulate = Color(Color.REBECCA_PURPLE, 1)
			referencia_corpo = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("dropable"):
		dentro_area = false
		body.modulate = Color(Color.MEDIUM_PURPLE, 0.7)
		referencia_corpo = null
