extends Node2D # Ou Control, dependendo do tipo do seu nó Personagem

func _ready() -> void:
	atualizar_visual()

func atualizar_visual() -> void:
	# Pega todos os filhos (Sprite2D, Sprite2D2, etc) na ordem exata que estão na aba Scene
	var sprites = get_children()
	
	# 1. Esconde absolutamente todos os sprites primeiro
	for sprite in sprites:
		if sprite is Sprite2D:
			sprite.hide()
			
	# 2. Descobre qual sprite deve aparecer. 
	# A função min() é uma trava de segurança: impede o jogo de quebrar
	# caso o jogador jogue mais vezes do que você tem sprites desenhados.
	var indice_seguro = min(Globais.indice_sprite_personagem, sprites.size() - 1)
	
	# 3. Mostra apenas o sprite correto
	if sprites[indice_seguro] is Sprite2D:
		sprites[indice_seguro].show()
