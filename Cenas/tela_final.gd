extends Control


func _on_sair_pressed() -> void:
	get_tree().quit()


func _on_reiniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/fase_1_corredor.tscn")


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/menu.tscn")
