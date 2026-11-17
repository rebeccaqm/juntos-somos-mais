extends Control


func _on_reiniciar_pressed() -> void:
	GerenciadorAudio.tocar_musica_principal()
	get_tree().change_scene_to_file(Global.fase_atual)


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/menu.tscn")
	

func _ready() -> void:
	GerenciadorAudio.tocar_game_over()
