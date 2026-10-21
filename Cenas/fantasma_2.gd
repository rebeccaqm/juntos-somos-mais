extends CharacterBody2D

@export var SPEED: float = 40.0
@export var DISTANCIA_PATRULHA: float = 80.0

var posicao_inicial_x: float
var direcao: int = 1

@onready var sprite: Sprite2D = $Fantasminha2

func _ready() -> void:
	posicao_inicial_x = global_position.x
	iniciar_flutuacao()

func _physics_process(_delta: float) -> void:
	if abs(global_position.x - posicao_inicial_x) > DISTANCIA_PATRULHA:
		direcao *= -1

	velocity.x = direcao * SPEED
	velocity.y = 0 

	move_and_slide()

	if direcao < 0:
		sprite.flip_h = true
	elif direcao > 0:
		sprite.flip_h = false

func iniciar_flutuacao() -> void:
	var tween := create_tween().set_loops()
	tween.tween_property(sprite, "position:y", -6.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, "position:y", 0.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
