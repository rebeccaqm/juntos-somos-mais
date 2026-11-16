extends Node2D

@export var cena_fantasma: PackedScene
@export var tempo_espera: float = 2.0 # Tempo de Spawn

func _ready() -> void:
	# Posição e Tamanho
	for fantasma in get_children():
		var posicao_inicial = fantasma.global_position
		var escala_inicial = fantasma.scale # Guarda o tamanho original
		configurar_respawn(fantasma, posicao_inicial, escala_inicial)

func configurar_respawn(fantasma_alvo, pos_inicial: Vector2, escala_inicial: Vector2) -> void:
	# Passa a posição e o tamanho para a função de renascer
	fantasma_alvo.tree_exited.connect(renascer_fantasma.bind(pos_inicial, escala_inicial))

func renascer_fantasma(pos_inicial: Vector2, escala_inicial: Vector2) -> void:
	# Trava de segurança: Se o gerenciador estiver a ser apagado (ex: reset da fase), cancela tudo.
	if not is_inside_tree():
		return
		
	# Espera o Time de Spawn
	await get_tree().create_timer(tempo_espera).timeout
	
	# Verifica novamente caso a fase tenha sido fechada durante esses 2 segundos
	if not is_inside_tree():
		return
		
	# Spawna o fantasma
	var novo_fantasma = cena_fantasma.instantiate()
	novo_fantasma.global_position = pos_inicial
	novo_fantasma.scale = escala_inicial 
	
	add_child(novo_fantasma)
	
	configurar_respawn(novo_fantasma, pos_inicial, escala_inicial)
