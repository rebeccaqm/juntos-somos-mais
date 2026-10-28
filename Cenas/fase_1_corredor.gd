extends Node2D

var tarefas_concluidas: int = 0
@export var tarefas_para_liberar_portal: int = 9

@onready var portal: Area2D = $Porta

func concluir_tarefa() -> void:
	tarefas_concluidas += 1

	if tarefas_concluidas >= tarefas_para_liberar_portal:
		portal.ativar()
