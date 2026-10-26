extends Area2D

@export var jogadores_necessarios: int = 2

var jogadores_dentro: Array[Node2D] = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	desativar()

func ativar() -> void:
	visible = true
	set_deferred("monitoring", true)

func desativar() -> void:
	visible = false
	jogadores_dentro.clear()
	set_deferred("monitoring", false)

func _on_body_entered(body: Node2D) -> void:
	if body not in jogadores_dentro:
		jogadores_dentro.append(body)
	_verificar_troca()

func _on_body_exited(body: Node2D) -> void:
	jogadores_dentro.erase(body)

func _verificar_troca() -> void:
	if jogadores_dentro.size() < jogadores_necessarios:
		return
	get_tree().call_deferred("change_scene_to_file","res://Cenas/fase_1_patio.tscn")
