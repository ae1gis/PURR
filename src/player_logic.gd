extends CharacterBody2D

@onready var animation_player = $AnimatedSprite2D
@onready var debug_label = $DebugStats/DebugInfoLabel

const MAX_SPEED = 1000

@export var player_speed: float = 750.0
@export var jump_strength: float = 1200.0

enum States { IDLE, WALK, RUN, JUMP, FALL }
@export var state = States.IDLE

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += (get_gravity() * 2) * delta
	
	match state:
		States.IDLE:
			velocity.x = 0
			if Input.get_axis("left", "right") != 0:
				if Input.is_action_pressed("shift"):
					transition_to_state(States.RUN)
				else:
					transition_to_state(States.WALK)
			elif Input.is_action_just_pressed("space"):
				transition_to_state(States.JUMP)
				
			if not is_on_floor():
				transition_to_state(States.FALL)
				
		States.WALK:
			var direction := Input.get_axis("left", "right")
			if direction != 0 and  Input.is_action_pressed("shift"):
				transition_to_state(States.RUN)
			elif direction != 0:
				velocity.x = direction * player_speed
			else:
				transition_to_state(States.IDLE)
				
			if Input.is_action_just_pressed("space"):
				transition_to_state(States.JUMP)
				
			if not is_on_floor():
				transition_to_state(States.FALL)
		
		# Too be implemented
		States.RUN:
			var direction := Input.get_axis("left", "right")
			if direction != 0 and Input.is_action_pressed("shift"):
				velocity.x = (direction * player_speed) * 1.5
			elif direction != 0:
				transition_to_state(States.WALK)
			else:
				transition_to_state(States.IDLE)
				
			if Input.is_action_just_pressed("space"):
				transition_to_state(States.JUMP)
				
			if not is_on_floor():
				transition_to_state(States.FALL)
			
		States.JUMP:
			if is_on_floor():
				velocity.y -= jump_strength
				
			var direction := Input.get_axis("left", "right")
			if direction != 0 and Input.is_action_pressed("shift"):
				velocity.x = direction * player_speed * 1.25
			elif direction != 0:
				velocity.x = direction * player_speed * 1.25
			else:
				velocity.x = 0
				
			if velocity.y >= 0:
				transition_to_state(States.FALL)

		States.FALL:
			var direction := Input.get_axis("left", "right")
			if direction != 0 and Input.is_action_pressed("shift"):
				velocity.x = direction * player_speed * 1.25
			elif direction != 0:
				velocity.x = direction * player_speed * 1.25
			else:
				velocity.x = 0
			
			if is_on_floor() and Input.get_axis("left", "right") != 0:
				transition_to_state(States.WALK)
			elif is_on_floor() and velocity.x == 0:
				transition_to_state(States.IDLE)
	
	if velocity.x > 0:
		animation_player.flip_h = false
	if velocity.x < 0:
		animation_player.flip_h = true
	
	move_and_slide()

func _process(_delta: float) -> void:
	debug_label.text = States.find_key(state)
	
func transition_to_state(new_state: States):
	_exit_state(state)
	
	state = new_state
	
	_enter_state(state)

func _exit_state(state: States):
	print("State exit: " + str(States.find_key(state)))

func _enter_state(state: States):
	print("State enter: " + str(States.find_key(state)) + "\n")
	
	animation_player.play(str(States.find_key(state)).to_lower())
