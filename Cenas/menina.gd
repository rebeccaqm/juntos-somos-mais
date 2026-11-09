extends CharacterBody2D

@export var SPEED: float = 200.0
@export var JUMP_VELOCITY: float = -400.0
@export var STOMP_IMPULSE: float = -300.0 # Impulso

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dead: bool = false # Se player morreu

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Se o Jogador bater de lado, para
	if is_dead:
		velocity = Vector2.ZERO
		return

	# Gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	# Pulo
	if Input.is_action_just_pressed("p2_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimento horizontal
	var direction := Input.get_axis("p2_left", "p2_right")
	
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Executa a física de movimento
	move_and_slide()

	# Checa colisões
	verificar_colisoes()

	update_animation(direction)

func verificar_colisoes() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		# Se colidiu com o Slime e ele está vivo
		if collider and collider.has_method("die") and not collider.is_dead:
			
			# Se Pisar o Slime
			if collision.get_normal().y < -0.5:
				collider.die()                 # Para ele
				velocity.y = STOMP_IMPULSE     # Impuslo
			else:
				# Se pegar de lado
				get_parent().morrer_ou_tomar_dano_menina()

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
