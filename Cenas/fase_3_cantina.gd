extends Node2D


@export var tarefas_para_liberar_portal: int = 1

var tarefas_concluidas: int = 0
@onready var portal: Area2D = $Porta3

var tempo = 60


func _ready() -> void:
	pass


func concluir_tarefa() -> void:
	tarefas_concluidas += 1
	#if tarefas_concluidas >= tarefas_para_liberar_portal:
		#portal.ativar()


func _on_timer_timeout() -> void:
	tempo -= 1
	$HUD/Tempo.text = str (tempo)
	if tempo == 0:
		$Timer.stop()
		#get_tree().call_deferred("change_scene_to_file",[telagameover])
