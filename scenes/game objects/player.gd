extends CharacterBody3D

# B_ refers to Base_
const B_WALKING_SPEED = 5.0
const B_SPRINTING_SPEED = 8.0
const B_CROUCHING_SPEED = 3.0
const B_JUMP_VELOCITY = 4.5
const B_MOUSE_SENSITIVITY = 0.4
const HEAD_Y_CLAMP_DOWN = deg_to_rad(-89)
const HEAD_Y_CLAMP_UP = deg_to_rad(90)
const CROUCHING_DEPTH = -0.5 # How much the head is dipping based on the camera
const SLIDE_LENGTH_MAX = 1.0
const B_SLIDE_SPEED = 10.0
const B_DASH_SPEED = 12.0
const DASH_LENGTH_MAX = 1.0
const SLOW_TIME_TOGGLE_SPEED = 0.1

var current_speed = 5.0
var curr_jump_velocity = 4.5
var lerp_speed = 10.0 # Used to add friction, lower is more friction
var air_control_lerp_speed = 5.0
var direction = Vector3.ZERO
var freelook_tilt_amt = 5.0
var slide_timer = 0.0
var slide_vec = Vector2.ZERO
var dash_timer = 0.0
var dash_vec = Vector2.ZERO
var last_velocity =  Vector3.ZERO

# Head bobbing vars
const head_bobbing_sprinting_speed = 22.0
const head_bobbing_walking_speed = 14.0
const head_bobbing_crouching_speed = 10.0

const head_bobbing_crouching_intensity = 0.05
const head_bobbing_walking_intensity = 0.1
const head_bobbing_sprinting_intensity = 0.2

var head_bobbing_vec = Vector2.ZERO
var head_bobbing_index = 0.0
var current_head_bob_intensity = 0.0

# States
var walking = false
var sprinting = false
var crouching = false
var freelooking = false
var sliding = false
var dashing = false
var slow_time_toggle = false

@onready var paddle_area_3d: Area3D = %PaddleArea3D
@onready var camera_3d: Camera3D = %Camera3D
@onready var freelook_pivot: Node3D = %FreelookPivot
@onready var head: Node3D = %Head
@onready var standing_collision_shape: CollisionShape3D = %StandingCollisionShape
@onready var crouching_collision_shape: CollisionShape3D = %CrouchingCollisionShape
@onready var crouching_ray_cast_check: RayCast3D = %CrouchingRayCastCheck
@onready var head_bob_pivot: Node3D = %HeadBobPivot
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var paddle_jump_raycast: RayCast3D = $FreelookPivot/Head/PaddleJumpRaycast

@export var player_color: Color = Color.BLUE

const PADDLE_JUMP_VELOCITY = 5.0

var hit_force = 100.0  # Adjust this to control hit strength

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	paddle_area_3d.area_entered.connect(on_paddle_area_entered)

func reset_time() -> void:
	if slow_time_toggle:
		Engine.time_scale = SLOW_TIME_TOGGLE_SPEED
	else:
		Engine.time_scale = 1.0

func hitstop(time_scale, duration) -> void:
	Engine.time_scale = time_scale
	await(get_tree().create_timer(duration * time_scale).timeout)
	reset_time()
	
func shake_screen():
	pass
	
func on_paddle_area_entered(other_area: Area3D):
	if other_area.owner is Ball:
		var ball = other_area.owner as Ball
		var hit_direction = calculate_hit_direction()
		var force = hit_direction * hit_force
		hitstop(0.05, 0.7)
		shake_screen()
		ball.apply_force(force)
		ball.set_color(player_color)

func calculate_hit_direction() -> Vector3:
	return -global_transform.basis.z.normalized()

func handle_paddle_jump():
	if not is_on_floor() and paddle_jump_raycast.enabled and paddle_jump_raycast.is_colliding():
		return true
	else:
		return false

func _input(event):
	if event is InputEventMouseMotion:
		var mouse_x_mov = -deg_to_rad(event.relative.x * B_MOUSE_SENSITIVITY)

		if freelooking:
			freelook_pivot.rotate_y(mouse_x_mov)
			freelook_pivot.rotation.y = clamp(freelook_pivot.rotation.y, deg_to_rad(-120), deg_to_rad(120))
		else:
			# the y axis is the x axis in 3d, but its the x axis for the mouse
			# we need to convert to degrees first
			rotate_y(mouse_x_mov)
		var mouse_y_mov = -deg_to_rad(event.relative.y * B_MOUSE_SENSITIVITY)
		head.rotate_x(mouse_y_mov)
		head.rotation.x = clamp(head.rotation.x, HEAD_Y_CLAMP_DOWN, HEAD_Y_CLAMP_UP)

func _process(_delta):
	if Input.is_action_pressed("primary") and not animation_player.is_playing():
		animation_player.play("swing_paddle")
	
	if Input.is_action_just_pressed("slow time"):
		slow_time_toggle = !slow_time_toggle
		
		if slow_time_toggle:
			Engine.time_scale = SLOW_TIME_TOGGLE_SPEED
		else:
			Engine.time_scale = 1.0
		
func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	
	if handle_paddle_jump():
		print("we paddle jumping")
		velocity.y = PADDLE_JUMP_VELOCITY
	
	# Crouching is dominant, we want it to overwrite sprint
	if (Input.is_action_pressed("crouch") || sliding) && not dashing:
		current_speed = lerp(current_speed, B_CROUCHING_SPEED, delta*lerp_speed)
		head.position.y = lerp(head.position.y, CROUCHING_DEPTH, delta*lerp_speed)
		crouching_collision_shape.disabled = false
		standing_collision_shape.disabled = true
		
		# Slide begin logic
		if sprinting && input_dir != Vector2.ZERO:
			sliding = true
			slide_timer = SLIDE_LENGTH_MAX
			slide_vec = input_dir
			freelooking = true
		
		dashing = false
		walking = false
		sprinting = false
		crouching = true
	elif !crouching_ray_cast_check.is_colliding():
		crouching_collision_shape.disabled = true
		standing_collision_shape.disabled = false
		head.position.y = lerp(head.position.y, 0.0, delta*lerp_speed)
		crouching = false
		
		if Input.is_action_pressed("sprint") && not dashing:
			walking = false
			sprinting = true
			current_speed = lerp(current_speed, B_SPRINTING_SPEED, delta*lerp_speed)
		else:
			walking = true
			sprinting = false
			current_speed = lerp(current_speed, B_WALKING_SPEED, delta*lerp_speed)
		
	# Handle freelooking
	if Input.is_action_pressed("freelook") || sliding:
		freelooking = true
		
		if sliding:
			camera_3d.rotation.z = lerp(camera_3d.rotation.z, -deg_to_rad(7.0), delta*lerp_speed) # TODO: Dont hardcode slide tilt
		else:
			# Negative is required otherwise its inverted
			camera_3d.rotation.z = -deg_to_rad(freelook_pivot.rotation.y*freelook_tilt_amt) # Z controls side to side tilt
	else:
		freelooking = false
		camera_3d.rotation.z = lerp(camera_3d.rotation.z, 0.0, delta*lerp_speed)
		freelook_pivot.rotation.y = lerp(freelook_pivot.rotation.y, 0.0, delta*lerp_speed)
	
	# Trigger dashing
	if Input.is_action_pressed("dash") && not sliding && input_dir != Vector2.ZERO:
		dashing = true
		walking = false
		sprinting = false
		sliding = false
		dash_timer = DASH_LENGTH_MAX
		dash_vec = input_dir
	
	# Handle dashing
	if dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			dash_timer = 0.0
			dashing = false
	
	# Handle sliding
	if sliding:
		slide_timer -= delta
		if slide_timer <= 0:
			slide_timer = 0.0
			sliding = false
			freelooking =  false
	
	# Handle head bob
	if sprinting:
		current_head_bob_intensity = head_bobbing_sprinting_intensity
		head_bobbing_index += head_bobbing_sprinting_speed*delta
	elif walking:
		current_head_bob_intensity = head_bobbing_walking_intensity
		head_bobbing_index += head_bobbing_walking_speed*delta
	elif crouching:
		current_head_bob_intensity = head_bobbing_crouching_intensity
		head_bobbing_index += head_bobbing_walking_speed*delta
		
	if is_on_floor() && !sliding && input_dir != Vector2.ZERO:
		head_bobbing_vec.y = sin(head_bobbing_index)
		head_bobbing_vec.x = sin(head_bobbing_index/2)*0.5 # for every side to side movement, you would have gone up and down twice
		
		# dividing by 2 for game's feel sake
		head_bob_pivot.position.y = lerp(head_bob_pivot.position.y, head_bobbing_vec.y * (current_head_bob_intensity/2), delta*lerp_speed)
		head_bob_pivot.position.x = lerp(head_bob_pivot.position.x, head_bobbing_vec.x * current_head_bob_intensity, delta*lerp_speed)
	else:
		head_bob_pivot.position.y = lerp(head_bob_pivot.position.y, 0.0, delta*lerp_speed)
		head_bob_pivot.position.x = lerp(head_bob_pivot.position.x, 0.0, delta*lerp_speed)
		
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() and !crouching_ray_cast_check.is_colliding():
		velocity.y = curr_jump_velocity
		sliding = false
	
	var input_vec = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Handle landing
	if is_on_floor():
		# Use this to handle different landings, small, heavy, etc
		if last_velocity.y <= -4.0:
			pass # Play a small camera bump animation
			
	
	# Handle air control
	if is_on_floor():
		direction = lerp(direction, input_vec, delta*lerp_speed)
	else:
		# This forces us to commit to our jump direction
		if input_dir != Vector2.ZERO:
			direction = lerp(direction, input_vec, delta*air_control_lerp_speed)
		
	if sliding:
		# Transform basis takes into account the rotation of the player
		direction = (transform.basis * Vector3(slide_vec.x, 0.0, slide_vec.y)).normalized()
	elif dashing:
		direction = (transform.basis * Vector3(dash_vec.x, 0.0, dash_vec.y)).normalized()
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		
		if sliding:
			# this makes the slide slow down over time
			# add 0.1 so it never truly reaches 0
			velocity.x = direction.x * (slide_timer + 0.1) * B_SLIDE_SPEED
			velocity.z = direction.z * slide_timer * B_SLIDE_SPEED
		elif dashing:
			velocity.x = direction.x * (dash_timer + 0.1) * B_DASH_SPEED
			velocity.z = direction.z * (dash_timer + 0.1) * B_DASH_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	last_velocity = velocity
	move_and_slide()
