extends Area2D

@export var nova_posicao: Vector2 = Vector2(54, 361)

func _ready() -> void:
	body_entered.connect(_ao_entrar)

func _ao_entrar(corpo: Node2D) -> void:
	if corpo is CharacterBody2D:
		_mudar_posicao.call_deferred(corpo)

func _mudar_posicao(personagem: CharacterBody2D) -> void:
	personagem.global_position = nova_posicao
	personagem.velocity = Vector2.ZERO
