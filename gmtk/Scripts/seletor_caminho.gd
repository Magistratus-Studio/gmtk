extends Control

signal minigame_selecionado(minigame: PackedScene)

# No script do Seletor
@onready var botao_1 = $HBoxContainer/Button
@onready var botao_2 = $HBoxContainer/Button2

var dados_dos_minigames: Dictionary = {
	"arco_odisseu": {
		"nome": "Bow of Odysseus",
		#"icone": preload("res://Cenas/Minijogos/Arco/icone_arco.png") 
	},
	"aves_estifalo": {
		"nome": "Stymphalian Birds",
		#"icone": preload("res://Cenas/Minijogos/Aves/icone_aves.png")
	},
	"ciclope": {
		"nome": "The Cyclops",
		#"icone": preload("res://Cenas/Minijogos/Ciclope/icone_ciclope.png")
	},
	"hidra": {
		"nome": "Lernaean Hydra",
		#"icone": preload("res://Cenas/Minijogos/Hidra/icone_hidra.png")
	},
	"Medusa": { # Atenção ao 'M' maiúsculo do seu arquivo Medusa.tscn
		"nome": "Medusa",
		#"icone": preload("res://Cenas/Minijogos/Medusa/icone_medusa.png")
	},
	"simplegades": {
		"nome": "Clashing Rocks", # Ou "Symplegades", mas Clashing Rocks soa melhor em inglês para jogos
		#"icone": preload("res://Cenas/Minijogos/Simplegades/icone_simplegades.png")
	},
	"Sisifo": { # Atenção ao 'S' maiúsculo do seu arquivo Sisifo.tscn
		"nome": "Sisyphus",
		#"icone": preload("res://Cenas/Minijogos/Sisifo/icone_sisifo.png")
	},
	"submundo": {
		"nome": "The Underworld",
		#"icone": preload("res://Cenas/Minijogos/Submundo/icone_submundo.png")
	},
	"teseu": {
		"nome": "Ship of Theseus", # Ou "The Labyrinth" dependendo do foco do seu minigame
		#"icone": preload("res://Cenas/Minijogos/Teseu/icone_teseu.png")
	}
}

func _ready() -> void:
	var Orquestrador = get_tree().get_nodes_in_group("orquestrador")[0]
	# Pede os jogos para o Orquestrador (supondo que o nome do Autoload seja 'Orquestrador')
	var sorteados = Orquestrador.sortear_minigames()
	
	botao_1.hide()
	botao_2.hide()
	
	if sorteados.size() > 0:
		configurar_botao(botao_1, sorteados[0])
	if sorteados.size() > 1:
		configurar_botao(botao_2, sorteados[1])

func configurar_botao(botao: Button, cena: PackedScene) -> void:
	botao.show()
	
	# Salva a cena na memória do botão para sabermos o que carregar ao clicar
	botao.set_meta("cena_minigame", cena)
	
	# Extrai a chave de identificação a partir do caminho do arquivo
	var id_cena: String = cena.resource_path.get_file().get_basename()
	
	# Verifica se essa chave existe no nosso dicionário
	if dados_dos_minigames.has(id_cena):
		var dados = dados_dos_minigames[id_cena]
		
		# Aplica o nome e o ícone
		botao.text = dados["nome"]
		#botao.icon = dados["icone"]
		
		# Opcional: Garante que o ícone se ajuste ao tamanho do botão
		#botao.expand_icon = true
	else:
		# Fallback de segurança (caso você esqueça de adicionar algum minigame no dicionário)
		botao.text = id_cena.capitalize()
		botao.icon = null

func _on_button_pressed(source: BaseButton) -> void:
	var cena = source.get_meta("cena_minigame")
	minigame_selecionado.emit(cena)
