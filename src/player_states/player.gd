extends CharacterBody2D

@export var player_speed: float = 300.0
@export var jump_height: float = 800.0
@export var player_gravity: float = 2100.0
@export var player_stamina: float = 10
@export var run_speed_multiplier: float = 1.5
@export var climb_speed: float = 300.0

var isClimbing = false
var spawn_position = null

@onready var wall_ray: RayCast2D = $RayCast2D

func _ready() -> void:
	var spawn_position = get_tree().get_first_node_in_group("player_spawn_node")
	
	if spawn_position == null:
		print(str(self) + " could not find a spawn position")
	else:
		print(str(self) + " spawning at " + str(spawn_position.position))
		self.position = spawn_position.position
	
func _physics_process(delta: float) -> void:
	var isClimbing = false
	if not is_on_floor():
		velocity.y += player_gravity * delta
		
	if not is_on_floor() and Input.is_action_pressed("down"):
		velocity.y += (player_gravity * 2) * delta
		
	if not is_on_floor() and wall_ray.is_colliding():
		if Input.is_action_pressed("up"):
			velocity.y = -climb_speed
			isClimbing = true
	
	var direction = Input.get_axis("left", "right")
	if direction != 0 and Input.is_action_pressed("shift"):
		run(direction, player_speed)
	elif direction != 0:
		walk(direction, player_speed)
	else:
		idle()
		
	if Input.is_action_just_pressed("space") and (is_on_floor() or isClimbing):
		jump(jump_height)
		
	animation_update()
		
	move_and_slide()

func animation_update() -> void:
	if velocity.x != 0:
		$PlayerSprite.flip_h = velocity.x < 0
	if not is_on_floor and wall_ray.is_colliding():
		$PlayerSprite.rotation = -80.0
	
func walk(direction: float, player_speed: float) -> void:
	velocity.x = direction * player_speed
	
func run(direction: float, player_speed: float) -> void:
	velocity.x = direction * player_speed * run_speed_multiplier
	
func idle() -> void:
	velocity.x = 0
	
func jump(jump_height: float) -> void:
	velocity.y -= jump_height
