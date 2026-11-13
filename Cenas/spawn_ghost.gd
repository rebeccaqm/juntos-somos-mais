extends Node2D

@export var cena_fantasma: PackedScene
@export var tempo_espera: float = 2.0

func _ready() -> void:
	# Agora olha para a posição E para o tamanho!
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
		
	# Espera os 2 segundos
	await get_tree().create_timer(tempo_espera).timeout
	
	# Segunda trava: Verifica novamente caso a fase tenha sido fechada durante esses 2 segundos
	if not is_inside_tree():
		return
		
	# Cria o fantasma novo!
	var novo_fantasma = cena_fantasma.instantiate()
	novo_fantasma.global_position = pos_inicial
	novo_fantasma.scale = escala_inicial 
	
	add_child(novo_fantasma)
	
	configurar_respawn(novo_fantasma, pos_inicial, escala_inicial)
