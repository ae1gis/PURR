extends CharacterBody2D

@onready var animation = $AnimatedSprite2D

const MAX_SPEED = 1000

var direction: Vector2
var player_speed: float = 1000.0
var jump_strength: float = 800.0

func animate_player() -> void:
	if velocity.x > 0:
		animation.flip_h = false
	elif velocity.x < 0:
		animation.flip_h = true
		
	if velocity.x != 0 and is_on_floor():
		animation.play("walk")
	elif velocity.x == 0 and is_on_floor():
		animation.play("idle")
	else:
		animation.play("jump")

func _physics_process(delta: float) -> void:
	if is_on_floor() and Input.is_action_just_pressed("space"):
		velocity.y -= jump_strength
	
	velocity.y += get_gravity().y * 1.25 * delta
	
	direction.x = Input.get_axis("left", "right")
	
	if direction.x != 0:
		velocity.x = direction.x * player_speed
	else:
		velocity.x = velocity.move_toward(Vector2.ZERO, player_speed).x
		
	animate_player()
	move_and_slide()
