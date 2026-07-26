extends MinigameBase

@export var caminho_lanca: PathFollow2D
@export var lanca: Sprite2D
@export var distancia_estocada_certa: float = -110.0
@export var distancia_estocada_errada: float = -500
@export var tempo_ida: float = 0.05
@export var area_clique: Button
var vitoria: bool = false
var velocidade: float = 0.7
var tween: Tween
@export var olho_acertado: AtlasTexture
@export var boca_acertado: AtlasTexture
@export var rosto_acertado: AtlasTexture

func iniciar() -> void:
	super.iniciar()
	caminho_lanca.progress_ratio = 0.15
	area_clique.disabled = false

func verificar_sucesso() -> bool:
	if vitoria:
		minigame_concluido.emit(true)
		return true
	minigame_concluido.emit(false)
	return false

func _process(delta: float) -> void:
	caminho_lanca.progress_ratio += velocidade * delta
	if caminho_lanca.progress_ratio < 0.1 or caminho_lanca.progress_ratio > 0.9:
		velocidade = velocidade * -1.0

func _on_button_pressed() -> void:
	velocidade = 0
	area_clique.disabled = true
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	var Orquestrador = get_tree().get_nodes_in_group("orquestrador")[0]
	Orquestrador.tocar_audio_sfx(load("res://Audios/SFX-1/cyclops/arrow.mp3"))
	
	if caminho_lanca.progress_ratio >= 0.45 and caminho_lanca.progress_ratio <= 0.55:
		vitoria = true
		tween.tween_property(lanca, "position:y", distancia_estocada_certa, tempo_ida)\
		.as_relative().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(lanca, "scale", Vector2(1.5,1.5), tempo_ida)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$Ciclope/Olho.texture = olho_acertado
		$Ciclope/Olho.scale = Vector2(0.7,0.7)
		$Ciclope/Boca.texture = boca_acertado
		$Ciclope/Boca.global_position.y += 10
		$Ciclope.texture = rosto_acertado
		$Ciclope/Sprite2D2.hide()
	else:
		tween.tween_property(lanca, "position:y", distancia_estocada_errada, tempo_ida)\
			.as_relative().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(lanca, "scale", Vector2(1,1), tempo_ida)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
