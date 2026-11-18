extends CharacterBody2D

@export var SPEED: float = 200.0
@export var JUMP_VELOCITY: float = -500.0
@export var STOMP_IMPULSE: float = -300.0 # Impulso 
@export var TEMPO_INVENCIVEL: float = 1.5   # duração em segundos
@export var INTERVALO_PISCAR: float = 0.1   # velocidade do piscar

var invencivel: bool = false
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dead: bool = false # Se o player morreu

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Se o jogador pegar de lado, parar
	if is_dead:
		velocity = Vector2.ZERO
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("p1_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("p1_left", "p1_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Executa o movimento físico
	move_and_slide()

	# Processa as colisões pós-movimento
	verificar_colisoes()

	update_animation(direction)

func verificar_colisoes() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider and collider.has_method("die") and not collider.is_dead:
			
			# Pulo por cima
			if collision.get_normal().y < -0.5:
				collider.die()                 
				velocity.y = STOMP_IMPULSE     
			else:
				# De lado
				tomar_dano()
				
				if collider.has_method("aplicar_recuo"):
					collider.aplicar_recuo(global_position)
				
func tomar_dano() -> void:
	if invencivel:
		return
	invencivel = true

	get_parent().morrer_ou_tomar_dano_menino()

	# Piscar
	var tween := create_tween()
	tween.set_loops(int(TEMPO_INVENCIVEL / (INTERVALO_PISCAR * 2.0)))
	tween.tween_property(animated_sprite, "modulate:a", 0.2, INTERVALO_PISCAR)
	tween.tween_property(animated_sprite, "modulate:a", 1.0, INTERVALO_PISCAR)

	await get_tree().create_timer(TEMPO_INVENCIVEL).timeout

	tween.kill()
	animated_sprite.modulate.a = 1.0
	invencivel = false
	
	
func update_animation(direction: float) -> void:
	if is_dead:
		return

	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	if not is_on_floor():
		animated_sprite.play("jump")
	elif direction != 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")
