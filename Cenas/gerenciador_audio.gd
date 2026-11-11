extends Node

var musica_menu: AudioStream = preload("res://Assets/Sons/geral/jogo (1).mp3")
var musica_game_over: AudioStream = preload("res://Assets/Sons/geral/game-over.mp3")
var som_clique: AudioStream = preload("res://Assets/Sons/geral/game-start (mp3cut.net).mp3")

@onready var player_musica: AudioStreamPlayer = $MusicaFundo
@onready var player_sfx: AudioStreamPlayer = $SomClique


func _ready() -> void:
	# Toda vez que a árvore de cenas mudar de tela, ele busca os novos botões
	get_tree().node_added.connect(_on_node_added)

# Função que monitora nós novos entrando no jogo
func _on_node_added(node: Node) -> void:
	if node is Button:
		if not node.pressed.is_connected(tocar_clique_simples):
			node.pressed.connect(tocar_clique_simples)

func tocar_clique_simples() -> void:
	player_sfx.stream = som_clique
	player_sfx.play()

# Função de clique que RETORNA o sinal para usares com 'await' nos botões que mudam de cena
func tocar_clique() -> Signal:
	player_sfx.stream = som_clique
	player_sfx.stop()
	player_sfx.play()
	return player_sfx.finished

# Toca a música principal (Menu -> Tutorial -> Fases -> Vitória)
func tocar_musica_principal() -> void:
	if player_musica.stream != musica_menu or not player_musica.playing:
		player_musica.stream = musica_menu
		player_musica.play()

# Toca a música de Game Over
func tocar_game_over() -> void:
	player_musica.stream = musica_game_over
	player_musica.play()

# Para a música de fundo completamente
func parar_musica() -> void:
	player_musica.stop()
