extends CharacterBody2D

@onready var animation_player = $AnimatedSprite2D

const MAX_SPEED = 1000

@export var player_speed: float = 1000.0
@export var jump_strength: float = 800.0

enum States { IDLE, WALK, RUN, JUMP, FALL }
@export var state = States.IDLE

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match state:
		States.IDLE:
			animation_player.play("idle")
			
			velocity.x = 0
			if Input.get_axis("left", "right") != 0:
				transition_to_state(state, States.WALK)
			elif Input.is_action_just_pressed("space"):
				transition_to_state(state, States.JUMP)
				
			if not is_on_floor():
				transition_to_state(state, States.FALL)
				
		States.WALK:
			animation_player.play("walk")
			
			var direction := Input.get_axis("left", "right")
			if direction != 0:
				velocity.x = direction * player_speed
			else:
				transition_to_state(state, States.IDLE)
				
			if Input.is_action_just_pressed("space"):
				transition_to_state(state, States.JUMP)
		
		# Too be implemented
		States.RUN:
			pass
			
		States.JUMP:
			animation_player.play("jump")
			
			if is_on_floor():
				velocity.y -= jump_strength
				
			var direction := Input.get_axis("left", "right")
			if direction != 0:
				velocity.x = direction * player_speed
			else:
				velocity.x = 0
				
			if velocity.y >= 0:
				transition_to_state(state, States.FALL)

		States.FALL:
			animation_player.play("fall")
			
			var direction := Input.get_axis("left", "right")
			if direction != 0:
				velocity.x = direction * player_speed
			else:
				velocity.x = 0
			
			if is_on_floor() and Input.get_axis("left", "right") != 0:
				transition_to_state(state, States.WALK)
			elif is_on_floor() and velocity.x == 0:
				transition_to_state(state, States.IDLE)
	
	if velocity.x > 0:
		animation_player.flip_h = false
	if velocity.x < 0:
		animation_player.flip_h = true
	
	move_and_slide()
	
func transition_to_state(current_state: States, new_state: States):
	_exit_state(state)
	
	state = new_state
	
	_enter_state(state)

func _exit_state(state: States):
	print("State exit: " + str(States.find_key(state)))

func _enter_state(state: States):
	print("State enter: " + str(States.find_key(state)) + "\n")
