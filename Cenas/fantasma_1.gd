extends CharacterBody2D

@export var SPEED: float = 40.0
@export var DISTANCIA_PATRULHA: float = 80.0

var posicao_inicial_x: float
var direcao: int = 1

@onready var sprite: Sprite2D = $Fantasminha1

func _ready() -> void:
	# guarda o ponto x onde ele foi colocado no mapa
	posicao_inicial_x = global_position.x
	iniciar_flutuacao()

func _physics_process(_delta: float) -> void:
	# calcula a distância absoluta entre a posição atual do fantasma e o ponto inicial dele
	# se for maior que a dist patrulha, inverte a direção
	if abs(global_position.x - posicao_inicial_x) > DISTANCIA_PATRULHA:
		direcao *= -1

	# movimento horizontal da patrulha
	velocity.x = direcao * SPEED
	velocity.y = 0 # sem gravidade (fica no ar)

	move_and_slide()

	# vira o fantasminha p o lado que está andando
	if direcao < 0:
		sprite.flip_h = true
	elif direcao > 0:
		sprite.flip_h = false

# fantasminha flutuando
func iniciar_flutuacao() -> void:
	var tween := create_tween().set_loops() # repete
	# sobe 6 pixels em 1s de forma desacelerada, descendo de volta p posição original em 1s tbm
	tween.tween_property(sprite, "position:y", -6.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, "position:y", 0.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
