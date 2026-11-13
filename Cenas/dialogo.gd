extends CanvasLayer
## Caixa de diálogos do jogo "Juntos Somos Mais".
##
## - Menino aparece no canto inferior ESQUERDO, Menina no canto inferior DIREITO
##   e os demais (Seu Zé, Dona Marta, Dona Rosa, Slime, avisos) embaixo, no CENTRO.
## - Avançar: botão "Avançar" (mouse) ou teclas Enter / E.
## - O jogo fica pausado durante a conversa.
## - Nas fases que têm um nó "Timer" (pátio, biblioteca, cantina), o temporizador
##   só começa quando a conversa inicial da fase termina.

signal dialogo_terminou(id: String)

## Conversa que abre a fase. Se ficar vazio, é escolhida pelo nome da cena.
@export var conversa_inicial: String = ""
## Se ligado, a conversa inicial começa sozinha quando a fase carrega.
@export var iniciar_ao_carregar: bool = true
## Velocidade do texto aparecendo (segundos por letra). 0 = aparece tudo de uma vez.
@export_range(0.0, 0.1, 0.005) var segundos_por_letra: float = 0.03

## Liga para a caixa aparecer no canto SUPERIOR em vez do inferior.
@export var no_topo: bool = false

const TECLAS_AVANCAR := [KEY_ENTER, KEY_KP_ENTER, KEY_E]

# Cenas em que a caixa vai para o topo automaticamente (nome do arquivo da cena)
const CENAS_COM_CAIXA_NO_TOPO := ["fase_1_corredor", "sala_boss"]

# Qual conversa abre cada cena (pelo nome do arquivo da cena)
const CONVERSA_POR_CENA := {
	"fase_1_corredor": "corredor_inicio",
	"fase_2_patio": "patio_inicio",
	"fase_3_biblioteca": "biblioteca_inicio",
	"fase_4_cantina": "cantina_inicio",
	"sala_boss": "boss_inicio",
}

# Retratos de quem aparece na caixa do centro (Menino e Menina têm o retrato na própria cena)
const RETRATOS := {
	"Seu Zé": preload("res://Assets/Assets NPC's/NPCs/Zelador/parado_frente_00.png"),
	"Dona Marta": preload("res://Assets/Assets NPC's/NPCs/Bibliotecaria/parado_frente_00.png"),
	"Dona Rosa": preload("res://Assets/Assets NPC's/NPCs/Merendeira/parado_frente_00.png"),
}

# Todas as conversas do jogo. Cada fala é ["quem fala", "texto"].
const CONVERSAS := {
	# ---------- Corredor ----------
	"corredor_inicio": [
		["Menina", "Nossa, a escola hoje está uma bagunça completa..."],
		["Menino", "É verdade! O vento e a correria do intervalo deixaram lixo no pátio, livros espalhados na biblioteca e frutas no chão da cantina."],
		["Menina", "Não podemos deixar a escola assim! Se nos dividirmos e ajudarmos os funcionários, conseguimos organizar tudo antes do fim da aula."],
		["Menino", "Boa ideia! Vamos começar!"],
	],

	# ---------- Fase 1: Pátio ----------
	"patio_inicio": [
		["Seu Zé", "Olá, pessoal! O intervalo acabou e o pátio ficou uma bagunça..."],
		["Menina", "Nossa, Seu Zé! Tem garrafas e papéis espalhados por todo o chão."],
		["Menino", "Pode deixar com a gente! Vamos recolher tudo para deixar a escola limpa."],
		["Seu Zé", "Muito obrigado! Quando limparem o pátio, a porta para a biblioteca estará destrancada."],
	],
	"patio_porta_trancada": [
		["Aviso", "A porta para a Biblioteca está trancada. Limpe todo o lixo do pátio para avançar!"],
	],
	"patio_limpo": [
		["Seu Zé", "Excelente trabalho, jovens! O pátio está impecável. Já podem entrar na biblioteca!"],
	],

	# ---------- Fase 2: Biblioteca ----------
	"biblioteca_inicio": [
		["Dona Marta", "Psiu! Cuidado por onde andam... Houve um pequeno contratempo nas estantes."],
		["Menino", "Dona Marta, o que aconteceu com os livros?"],
		["Dona Marta", "Um vento forte soprou e derrubou vários exemplares pelos andares. Preciso da ajuda de vocês para recolher os livros caídos!"],
		["Dona Marta", "Assim que terminarem, abrirei a passagem para a Cantina."],
	],
	"biblioteca_limpa": [
		["Dona Marta", "Muito obrigada! Todos os livros estão de volta ao seu devido lugar. A porta da cantina está liberada."],
		["Menino", "Valeu, Dona Marta! Rumo à Cantina!"],
	],

	# ---------- Fase 3: Cantina ----------
	"cantina_inicio": [
		["Dona Rosa", "Ah, ainda bem que vocês chegaram! As frutas caíram das bancadas e estão espalhadas pelo chão."],
		["Menina", "Deixa com a gente, Dona Rosa! Vamos recolher todas as frutas."],
	],
	"cantina_limpa": [
		["Dona Rosa", "Que maravilha! A cantina está limpa e organizada!"],
		["Menina", "Conseguimos! Deixamos o pátio, a biblioteca e a cantina perfeitamente limpos!"],
		["Menino", "Mas está faltando uma coisa..."],
	],

	# ---------- Boss: o Slime de Sujeira ----------
	"boss_inicio": [
		["Slime", "Glooob... Vocês acharam que era só juntar uns papéis e livros? Eu sou a junção de toda a sujeira esquecida da escola!"],
		["Menina", "Nossa... isso sim é um monstro de sujeira gigante!"],
		["Menino", "Não adianta tentar nos assustar! Já limpamos o pátio e a biblioteca, e não vai ser uma bola gigante de sujeira que vai parar a gente."],
		["Slime", "Glub! Vou espalhar resto de comida por todo lado de novo!"],
	],
	"boss_derrotado": [
		["Slime", "Glooob... não... a limpeza... é meu único ponto fraco... glub..."],
		["Menina", "Conseguimos! Ele derreteu todinho!"],
		["Menino", "Agora sim, a escola está completamente limpa!"],
	],
}

## true enquanto uma conversa está na tela (os jogadores podem checar isso)
var ativo: bool = false

var _id_atual: String = ""
var _falas: Array = []
var _indice: int = 0
var _fila: Array[String] = []
var _pausa_anterior: bool = false
var _tween: Tween
var _texto: Label
var _timer: Timer
var _retrato_slime: AtlasTexture

@onready var _caixas: Dictionary = {
	"Menino": $Raiz/CaixaMenino,
	"Menina": $Raiz/CaixaMenina,
	"Outros": $Raiz/CaixaOutros,
}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS   # continua funcionando com o jogo pausado
	visible = false
	_esconder_caixas()
	if no_topo or CENAS_COM_CAIXA_NO_TOPO.has(_nome_da_cena()):
		_mover_caixas_para_o_topo()

	_retrato_slime = AtlasTexture.new()
	_retrato_slime.atlas = preload("res://Assets/Boss/slime_frames_all.png")
	_retrato_slime.region = Rect2(0, 32, 32, 32)

	for chave in _caixas:
		var botao: Button = _caixas[chave].get_node("Linha/Coluna/Cabecalho/Botao")
		botao.focus_mode = Control.FOCUS_NONE   # Espaço/Enter não "clicam" o botão duas vezes
		botao.pressed.connect(avancar)

	_timer = _achar_timer()
	if conversa_inicial.is_empty():
		conversa_inicial = CONVERSA_POR_CENA.get(_nome_da_cena(), "")
	if iniciar_ao_carregar and CONVERSAS.has(conversa_inicial):
		iniciar.call_deferred(conversa_inicial)


## Começa uma conversa pelo id. Se já houver uma na tela, entra na fila.
## Para esperar o fim:  $Dialogo.iniciar("patio_limpo")  e depois  await $Dialogo.dialogo_terminou
func iniciar(id: String) -> void:
	if not CONVERSAS.has(id):
		push_warning("Dialogo: a conversa '%s' não existe." % id)
		return
	if ativo:
		_fila.append(id)
		return
	ativo = true
	_pausa_anterior = get_tree().paused
	get_tree().paused = true      # congela jogadores, inimigos e o resto do jogo
	visible = true
	_comecar(id)


func avancar() -> void:
	if not ativo:
		return
	# Se o texto ainda está aparecendo, o primeiro clique mostra a fala inteira
	if _tween and _tween.is_running():
		_tween.kill()
		_texto.visible_ratio = 1.0
		return
	_indice += 1
	if _indice >= _falas.size():
		_terminar()
	else:
		_mostrar_fala()


func _unhandled_input(event: InputEvent) -> void:
	if not ativo:
		return
	if event is InputEventKey and event.pressed and not event.echo \
			and event.physical_keycode in TECLAS_AVANCAR:
		get_viewport().set_input_as_handled()
		avancar()


func _comecar(id: String) -> void:
	_id_atual = id
	_falas = CONVERSAS[id]
	_indice = 0
	# O temporizador da fase espera a conversa inicial terminar
	if id == conversa_inicial and _timer:
		_timer.stop()
	_mostrar_fala()


func _mostrar_fala() -> void:
	var quem: String = _falas[_indice][0]
	var texto: String = _falas[_indice][1]

	_esconder_caixas()
	var caixa: PanelContainer = _caixas[_chave_da_caixa(quem)]
	caixa.show()
	(caixa.get_node("Linha/Coluna/Cabecalho/Nome") as Label).text = quem

	if caixa == _caixas["Outros"]:
		var retrato: TextureRect = caixa.get_node("Linha/Retrato")
		retrato.texture = _retrato_para(quem)
		retrato.visible = retrato.texture != null

	_texto = caixa.get_node("Linha/Coluna/Texto")
	_texto.text = texto
	_texto.visible_ratio = 0.0

	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)   # anima mesmo com o jogo pausado
	_tween.tween_property(_texto, "visible_ratio", 1.0, maxf(texto.length() * segundos_por_letra, 0.01))


func _terminar() -> void:
	var id := _id_atual
	if _tween:
		_tween.kill()
	_esconder_caixas()

	var proxima := ""
	if _fila.is_empty():
		ativo = false
		visible = false
		get_tree().paused = _pausa_anterior
	else:
		proxima = _fila.pop_front()

	# Fim da conversa inicial da fase: agora sim o temporizador começa
	if id == conversa_inicial and _timer:
		_timer.start()

	dialogo_terminou.emit(id)

	if proxima != "":
		_comecar(proxima)


func _mover_caixas_para_o_topo() -> void:
	for chave in _caixas:
		var caixa: Control = _caixas[chave]
		caixa.anchor_top = 0.0
		caixa.anchor_bottom = 0.0
		caixa.offset_top = 16.0       # distância da borda de cima
		caixa.offset_bottom = 200.0   # altura da caixa (16 + 184)
		caixa.grow_vertical = Control.GROW_DIRECTION_END


func _esconder_caixas() -> void:
	for chave in _caixas:
		_caixas[chave].hide()


func _chave_da_caixa(quem: String) -> String:
	if quem == "Menino":
		return "Menino"
	if quem == "Menina":
		return "Menina"
	return "Outros"


func _retrato_para(quem: String) -> Texture2D:
	if quem == "Slime":
		return _retrato_slime
	return RETRATOS.get(quem, null)


func _nome_da_cena() -> String:
	var cena: Node = get_parent()
	if cena == null or cena.scene_file_path.is_empty():
		cena = get_tree().current_scene
	if cena == null:
		return ""
	return cena.scene_file_path.get_file().get_basename()


func _achar_timer() -> Timer:
	var pai := get_parent()
	if pai:
		var t := pai.get_node_or_null("Timer")
		if t is Timer:
			return t
	return null
