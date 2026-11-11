extends Control

func _ready() -> void:
	GerenciadorAudio.tocar_musica_principal()

func _on_play_pressed() -> void:
	# Espera o som de clique terminar antes de mudar a cena
	await GerenciadorAudio.tocar_clique()
	get_tree().change_scene_to_file("res://Cenas/fase_1_corredor.tscn")

func _on_quit_pressed() -> void:
	await GerenciadorAudio.tocar_clique()
	get_tree().quit()
