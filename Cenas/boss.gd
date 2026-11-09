extends CharacterBody2D

@export var speed: float = 90.0
@export var jump_force: float = -300.0
@export var jump_cooldown: float = 1.6

var direction: float = 1.0
var can_jump: bool = true
var is_dead: bool = false # Controla se o Slime travou/morreu

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:
	# Se o Slime foi pisado não se mover mais
	if is_dead:
		velocity = Vector2.ZERO
		return

	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		if can_jump:
			pular()

	if is_on_wall():
		direction *= -1.0

	if not is_on_floor():
		velocity.x = direction * speed
	else:
		velocity.x = 0.0

	if sprite:
		sprite.flip_h = (direction < 0.0)
		
		if is_on_floor() and velocity.x == 0:
			if sprite.animation != "idle":
				sprite.play("idle")
		else:
			if sprite.animation != "walk":
				sprite.play("walk")

	move_and_slide()

func pular() -> void:
	if is_dead:
		return

	can_jump = false
	velocity.y = jump_force
	velocity.x = direction * speed
	
	await get_tree().create_timer(jump_cooldown).timeout
	
	if not is_dead:
		can_jump = true

# Quando o jogador pisar no Slime
func die() -> void:
	if is_dead:
		return
		
	is_dead = true
	can_jump = false
	velocity = Vector2.ZERO # O Slime PARA
	
	# Desativa a colisão física
	if collision_shape:
		collision_shape.set_deferred("disabled", true)
	
	# Animação de morte
	if sprite and sprite.sprite_frames.has_animation("dead"):
		sprite.play("dead")
		get_parent().dialogofinal()
