extends Area2D

@onready var sprite: Sprite2D = $DonaRosa

func dar_pulinho() -> void:
	var posicao_original := sprite.position
	var tween := create_tween()
	
	tween.tween_property(sprite, "position:y", posicao_original.y - 10, 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite, "position:y", posicao_original.y, 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
