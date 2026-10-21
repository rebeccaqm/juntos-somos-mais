extends CharacterBody2D

@export var SPEED: float = 200.0
@export var JUMP_VELOCITY: float = -400.0

# gravidade das configurações do projeto
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# se ele nao tiver no chão, aplica a gravidade para puxar p baixo a cada instante
	if not is_on_floor():
		velocity.y += gravity * delta

	# pulo
	if Input.is_action_just_pressed("p2_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# movimento horizontal
	var direction := Input.get_axis("p2_left", "p2_right")
	
	# se tiver direção, a v.x vai ser direção * speed
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		# p desacelerar até parar
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_animation(direction)

func update_animation(direction: float) -> void:
	# define esquerda e direita
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
