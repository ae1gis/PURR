extends CharacterBody2D

@export var player_speed: float = 300.0
@export var jump_height: float = 800.0
@export var player_gravity: float = 1500.0
@export var player_stamina: float = 10
@export var run_speed_multiplier: float = 1.5

@onready var stamina_timer = $PlayerStaminaDepletionTimer
@onready var stamina_regen_timer = $PlayerStaminaRegenTimer

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += player_gravity * delta
		
	if not is_on_floor() and Input.is_action_pressed("down"):
		velocity.y += (player_gravity * 2) * delta
	
	var direction = Input.get_axis("left", "right")
	if direction != 0 and Input.is_action_pressed("shift"):
		run(direction, player_speed)
	elif direction != 0:
		walk(direction, player_speed)
	else:
		idle()
		
	if Input.is_action_just_pressed("space") and is_on_floor():
		jump(jump_height)
		
	animation_update()
		
	move_and_slide()

func animation_update() -> void:
	if velocity.x != 0:
		$PlayerSprite.flip_h = velocity.x < 0
	
func walk(direction: float, player_speed: float) -> void:
	velocity.x = direction * player_speed
	

func run(direction: float, player_speed: float) -> void:
	velocity.x = direction * player_speed * run_speed_multiplier
	

func idle() -> void:
	velocity.x = 0
	

func jump(jump_height: float) -> void:
	velocity.y -= jump_height
