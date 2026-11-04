extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HUD/PainelPontos.visible = false
	$HUD/PainelPontos/IconeItemComida.visible = false
	$HUD/PainelPontos/IconeItemLixo.visible = false
	$HUD/PainelPontos/IconeItemLivro.visible = false
	$HUD/PainelPontos/ItensColetados.visible = false
	$HUD/PainelTempo.visible = false
	$HUD/PainelTempo/IconeTempo.visible = false
	$HUD/PainelTempo/Tempo.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
