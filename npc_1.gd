extends Area2D

@onready var sprite: Sprite2D = $"SeuZé"	

# dar pulinho quando o jogador ganhar
func dar_pulinho() -> void:
	# salva a posição exata p ele voltar p mesmo lugar
	var posicao_original := sprite.position
	var tween := create_tween()
	
	# sobe 10 pixels rápido e dps volta p posição original de forma suave
	tween.tween_property(sprite, "position:y", posicao_original.y - 10, 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "position:y", posicao_original.y, 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
