extends Node2D


@export var tarefas_para_liberar_portal: int = 1

var tarefas_concluidas: int = 0
@onready var portal: Area2D = $Porta


func _ready() -> void:
	pass


func concluir_tarefa() -> void:
	tarefas_concluidas += 1
	#if tarefas_concluidas >= tarefas_para_liberar_portal:
		#portal.ativar()
