extends CharacterBody2D

@export var speed: float = 90.0
@export var jump_force: float = -300
@export var jump_cooldown: float = 1.6 # Timer do Jump

var direction: float = 1.0
var can_jump: bool = true

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
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

# Jump & Wait Time
func pular() -> void:
	can_jump = false
	velocity.y = jump_force
	velocity.x = direction * speed
	
	# Espera o time até o próximo jump
	await get_tree().create_timer(jump_cooldown).timeout
	can_jump = true
