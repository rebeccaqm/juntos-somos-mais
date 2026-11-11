extends Control

@onready var label_tutorial: Label = $LabelTutorial
@onready var botao_ok: Button = $OK

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# 1. FADE-IN INICIAL
	var fade_in = ColorRect.new()
	fade_in.color = Color(0, 0, 0, 1) # Começa totalmente preto
	fade_in.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fade_in.z_index = 4096 
	add_child(fade_in)
	
	var tempo_fade_in = 1.5
	var t = 0.0
	while t < tempo_fade_in:
		t += get_process_delta_time()
		fade_in.color.a = lerp(1.0, 0.0, t / tempo_fade_in)
		await get_tree().process_frame
	fade_in.queue_free()
	
	if label_tutorial:
		label_tutorial.modulate.a = 1.0
		label_tutorial.visible = true

	if botao_ok:
		botao_ok.modulate.a = 1.0
		botao_ok.visible = true

func _on_ok_pressed() -> void:
	# Toca o som de clique padrão em qualquer botão
	if GerenciadorAudio.has_method("tocar_clique"):
		GerenciadorAudio.tocar_clique()
		
	# 2. FAZ O FADE-OUT SUAVE DA MÚSICA DO MENU ANTES DE TROCAR DE CENA
	if GerenciadorAudio.has_method("parar_musica_menu"):
		await GerenciadorAudio.parar_musica_menu()
	
	# 3. Fade-out visual rápido da tela para a fase urbana
	var fade_out = ColorRect.new()
	fade_out.color = Color(0, 0, 0, 0)
	fade_out.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fade_out.z_index = 4096 
	add_child(fade_out)
	
	var t = 0.0
	while t < 1.0:
		t += get_process_delta_time()
		fade_out.color.a = lerp(0.0, 1.0, t / 1.0)
		await get_tree().process_frame
		
	# Muda para a primeira fase do jogo
	get_tree().change_scene_to_file("res://Cenas/fase_1_corredor.tscn")
