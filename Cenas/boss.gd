extends CharacterBody2D

@export var speed: float = 90.0
@export var jump_force: float = -300.0
@export var jump_cooldown: float = 1.6

# --- NOVO: vidas e invencibilidade do boss ---
@export var vidas: int = 3
@export var TEMPO_INVENCIVEL: float = 2.0
@export var INTERVALO_PISCAR: float = 0.1

var direction: float = 1.0
var can_jump: bool = true
var is_dead: bool = false # Controla se o Slime travou/morreu
var invencivel: bool = false # NOVO

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
	verificar_contato_players()   # NOVO: dá dano nos players ao encostar

func pular() -> void:
	if is_dead:
		return

	can_jump = false
	velocity.y = jump_force
	velocity.x = direction * speed
	
	await get_tree().create_timer(jump_cooldown).timeout
	
	if not is_dead:
		can_jump = true

# NOVO: o boss também detecta o contato com os players
func verificar_contato_players() -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("player") and collider.has_method("tomar_dano"):
			# Player em cima do boss = pisão, tratado no script do player
			if collision.get_normal().y > 0.5:
				continue
			collider.tomar_dano()

# Quando o jogador pisar no Slime (MODIFICADO: agora tira 1 vida)
func die() -> void:
	if is_dead or invencivel:
		return

	vidas -= 1
	get_parent().atualizar_barra_boss(vidas)   # NOVO: atualiza os corações

	if vidas <= 0:
		morrer()
	else:
		piscar()

# NOVO: pisca durante a invencibilidade
func piscar() -> void:
	invencivel = true

	var tween := create_tween()
	tween.set_loops(int(TEMPO_INVENCIVEL / (INTERVALO_PISCAR * 2.0)))
	tween.tween_property(sprite, "modulate:a", 0.2, INTERVALO_PISCAR)
	tween.tween_property(sprite, "modulate:a", 1.0, INTERVALO_PISCAR)

	await get_tree().create_timer(TEMPO_INVENCIVEL).timeout

	tween.kill()
	sprite.modulate.a = 1.0
	invencivel = false

# NOVO: este é o antigo die(), com a morte de verdade
func morrer() -> void:
	is_dead = true
	can_jump = false
	velocity = Vector2.ZERO # O Slime PARA
	
	# Desativa a colisão física
	if collision_shape:
		collision_shape.set_deferred("disabled", true)
	
	# Animação de morte
	if sprite and sprite.sprite_frames.has_animation("dead"):
		sprite.play("dead")
		await sprite.animation_finished
		await get_tree().create_timer(0.8).timeout
		
	get_parent().dialogofinal()
