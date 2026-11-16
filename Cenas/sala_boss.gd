extends Node2D

var vidas_menina = 3
var vidas_menino = 3

@onready var menino = $Menino
@onready var menina = $Menina

@export var coracao_vazio_menino: Texture2D
@export var coracao_vazio_menina: Texture2D
@export var coracao_boss_vazio: Texture2D

@onready var coracoesboss = [
	$HUD/PainelBoss/Corações/Coração1,
	$HUD/PainelBoss/Corações/Coração2,
	$HUD/PainelBoss/Corações/Coração3,
]

@onready var coracoesmenina = [
	$HUD/PainelBossMenina/Corações/Coração1,
	$HUD/PainelBossMenina/Corações/Coração2,
	$HUD/PainelBossMenina/Corações/Coração3
]

@onready var coracoesmenino = [
	$HUD/PainelBossMenino/Corações/Coração1,
	$HUD/PainelBossMenino/Corações/Coração2,
	$HUD/PainelBossMenino/Corações/Coração3
]


func _ready() -> void:
	$HUD/PainelPontos.visible = false
	$HUD/PainelTempo.visible = false
	
func atualizar_barra_boss(vidas: int) -> void:
	coracoesboss[vidas].texture = coracao_boss_vazio


func morrer_ou_tomar_dano_menina() -> void:
	if vidas_menina > 0:
		vidas_menina -= 1
		coracoesmenina[vidas_menina].texture = coracao_vazio_menina
		
	if vidas_menina == 0:
		$Menina/AnimatedSprite2D.visible = false
		$Menina/CollisionShape2D.set_deferred("disabled", true)
		
	verificar_fim_de_jogo()
	
	
func morrer_ou_tomar_dano_menino() -> void:
	if vidas_menino > 0:
		vidas_menino -= 1
		coracoesmenino[vidas_menino].texture = coracao_vazio_menino
		
	if vidas_menino == 0:
		$Menino/AnimatedSprite2D.visible = false
		$Menino/CollisionShape2D.set_deferred("disabled", true)
	
	verificar_fim_de_jogo()
	
	
func verificar_fim_de_jogo() -> void:
	if vidas_menino == 0 or vidas_menina == 0:
		await get_tree().create_timer(1.5).timeout
		get_tree().call_deferred("change_scene_to_file", "res://Cenas/game_over.tscn")
		
func dialogofinal() -> void:
	$Dialogo.iniciar("boss_derrotado")
	await $Dialogo.dialogo_terminou
	get_tree().call_deferred("change_scene_to_file", "res://Cenas/tela_final.tscn")
	
