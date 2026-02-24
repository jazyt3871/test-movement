extends CharacterBody2D

@export var speed = 180.0
@export var downjump_precision = 100
@export var downjump_velocity = 3.0
@export var jump_velocity = -400.0
@export var double_jump_velocity = -350.0
@export var ground_acceleration = 2500.0
@export var ground_friction = 3000.0
@export var air_acceleration = 600.0
@export var air_friction = 200.0 

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_double_jump = false

func _physics_process(delta):
	# 1. Apply Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		# Reset double jump when we touch the ground
		can_double_jump = true

	# 2. Handle Jump & Double Jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
		elif can_double_jump:
			velocity.y = double_jump_velocity
			can_double_jump = false # Use it up!
			
	if Input.is_action_just_pressed("down"):
		if abs(velocity.y) < 100:
			var precision = downjump_precision - abs(velocity.y)
			velocity.y = downjump_velocity * precision * 2


	# 3. Determine physics values based on state
	var accel = ground_acceleration if is_on_floor() else air_acceleration
	var frict = ground_friction if is_on_floor() else air_friction

	# 4. Handle Horizontal Movement
	var direction = Input.get_axis("left", "right")
	
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, frict * delta)

	move_and_slide()
