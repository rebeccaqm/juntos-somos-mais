extends CharacterBody2D

@export var SPEED: float = 20.0
@export var SPEED_PERSEGUICAO: float = 80.0
@export var DISTANCIA_PATRULHA: float = 90.0
@export var RAIO_DETECCAO: float = 200.0 # Distância em pixels para começar a seguir

var posicao_inicial_x: float
var direcao: int = 1
var is_dead: bool = false

@onready var sprite: Sprite2D = $Fantasminha1

func _ready() -> void:
	posicao_inicial_x = global_position.x
	iniciar_flutuacao()

func _physics_process(_delta: float) -> void:
	var alvo = buscar_player_mais_proximo()
	
	# Se encontrou um player dentro do raio de deteção, persegue!
	if alvo != null:
		# Adiciona pixels no eixo Y para o fantasma mais embaixo do player
		var alvo_mirado = alvo.global_position + Vector2(0, 140.0) 
		var direcao_vetor = (alvo_mirado - global_position).normalized()
		
		velocity = direcao_vetor * SPEED_PERSEGUICAO	
		# Vira o sprite para o lado do player
		if direcao_vetor.x < 0:
			sprite.flip_h = true
		elif direcao_vetor.x > 0:
			sprite.flip_h = false
			
	# Caso contrário, continua a patrulha normal
	else:
		if abs(global_position.x - posicao_inicial_x) > DISTANCIA_PATRULHA:
			direcao *= -1

		velocity.x = direcao * SPEED
		velocity.y = 0

		if direcao < 0:
			sprite.flip_h = true
		elif direcao > 0:
			sprite.flip_h = false

	move_and_slide()

# Procura entre os 2 jogadores quem está mais perto e dentro do raio
func buscar_player_mais_proximo() -> Node2D:
	var players = get_tree().get_nodes_in_group("player")
	var mais_proximo: Node2D = null
	var menor_distancia: float = RAIO_DETECCAO
	
	for player in players:
		var distancia = global_position.distance_to(player.global_position)
		if distancia < menor_distancia:
			menor_distancia = distancia
			mais_proximo = player
			
	return mais_proximo

# Fantasminha flutuando
func iniciar_flutuacao() -> void:
	var tween := create_tween().set_loops()
	tween.tween_property(sprite, "position:y", -6.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, "position:y", 0.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

# Fantasma morre
func die() -> void:
	if is_dead:
		return
	is_dead = true
	queue_free()
