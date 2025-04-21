class_name Player extends CharacterBase

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
const MAX_SLIDE_GAS = 5.0
const B_MAX_DASH = 2
const B_DASH_COOLDOWN = 0.4


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
var current_slide_gas = 0.0

# Dash variables
var current_dash_stock = 2
var queue_dash_cooldown = false # TODO: Need to use this later

# Jump Buffer
var jump_buffer_active = false

# Coyote Time
var coyote_time_active = true

# Grabbing variables
var grabbed_object_ref: Node3D = null
var grab_ready = true

var can_swing = true

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
@onready var grab_area_3d: Area3D = %GrabArea3D
@onready var grab_marker_3d: Marker3D = $FreelookPivot/Head/GrabNode3D/GrabMarker3D
@onready var grab_cooldown_timer: Timer = %GrabCooldownTimer
@onready var jump_buffer_timer: Timer = %JumpBufferTimer
@onready var speed_lines_overlay: SpeedLines = $SpeedLinesOverlay
@onready var coyote_timer: Timer = %CoyoteTimer
@onready var dash_cooldown_timer: Timer = %DashCooldownTimer
@onready var arms_anim_player: AnimationPlayer = %ArmsAnimPlayer
@onready var weapon_rig: Node3D = %WeaponRig
@onready var can_swing_timer: Timer = $Timers/CanSwingTimer

@export var player_color: Color = Color.BLUE


var pause_menu_scene = preload("res://scenes/menus/pause_screen.tscn")

const PADDLE_JUMP_VELOCITY = 5.0

@export var hit_force = 110.0  # Adjust this to control hit strength
@export var throw_force = 100.0


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	paddle_area_3d.area_entered.connect(on_paddle_area_entered)
	grab_area_3d.area_entered.connect(on_grab_area_entered)
	
	# Timers
	grab_cooldown_timer.timeout.connect(on_grab_timer_timeout)
	jump_buffer_timer.timeout.connect(on_jump_timer_timeout)
	coyote_timer.timeout.connect(on_coyote_timer_timeout)
	dash_cooldown_timer.timeout.connect(on_dash_timer_timeout)
	can_swing_timer.timeout.connect(on_can_swing_timer_timeout)

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
		#hitstop(0.05, 0.7)
		shake_screen()
		ball.apply_force(force)
		ball.set_color(player_color)

func on_grab_area_entered(other_area: Area3D):
	if other_area.owner is Ball:
		var ball = other_area.owner as Ball
		ball.stop_movement()
		ball.global_position = grab_marker_3d.global_position
		grabbed_object_ref = ball
		ball.set_grabbed_parent_ref(self)
	
func on_grab_timer_timeout() -> void:
	grab_ready = true

func on_jump_timer_timeout() -> void:
	jump_buffer_active = false

func on_coyote_timer_timeout() -> void:
	coyote_time_active = false

func on_dash_timer_timeout() -> void:
	current_dash_stock += 1

func get_marker_pos() -> Vector3:
	return grab_marker_3d.global_position

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

func throw_object():
	if grabbed_object_ref != null and grabbed_object_ref is Ball:
		var force = calculate_hit_direction() * throw_force
		grabbed_object_ref.released_from_grab()
		grabbed_object_ref.apply_force(force)
		grabbed_object_ref = null
		
func can_dash() -> bool:
	return current_dash_stock > 0 && !dashing

func dash() -> void:
	current_dash_stock -= 1
	if dash_cooldown_timer.is_stopped():
		dash_cooldown_timer.start()
	else:
		queue_dash_cooldown = true
	dashing = true
	walking = false
	sprinting = false
	sliding = false
	dash_timer = DASH_LENGTH_MAX

func on_can_swing_timer_timeout():
	can_swing = true

func jump() -> void:
	velocity.y = curr_jump_velocity
	sliding = false
	coyote_time_active = false

func _process(_delta):
	if Input.is_action_pressed("pause"):
		add_child(pause_menu_scene.instantiate())
		#get_tree().root.set_input_as_handled()
		get_tree().paused = true
		
	if Input.is_action_just_pressed("slow time"):
		slow_time_toggle = true
		reset_time()
	elif Input.is_action_just_released("slow time"):
		slow_time_toggle = false
		reset_time() # TODO: Use a better func name
		
	if Input.is_action_pressed("primary") and can_swing:
		if arms_anim_player.is_playing():
			arms_anim_player.stop()
		
		#animation_player.play("swing_paddle")
		arms_anim_player.play("swing_paddle")
		can_swing_timer.start()
		can_swing = false
		
	if Input.is_action_pressed("secondary") and not animation_player.is_playing():
		if grabbed_object_ref == null and grab_ready:
			animation_player.play("grab")
			arms_anim_player.play("grab")
		elif grabbed_object_ref != null:
			grab_ready = false
			throw_object()
			grab_cooldown_timer.start()
		
func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	
	
	if velocity.length() > 10:
		speed_lines_overlay.set_speed_lines_density(1.0)
	elif velocity.length() > 8:
		speed_lines_overlay.set_speed_lines_density(0.5)
	elif velocity.length() > 6:
		speed_lines_overlay.set_speed_lines_density(0.2)
	else:
		speed_lines_overlay.set_speed_lines_density(0.0)
	
	if handle_paddle_jump():
		velocity.y = PADDLE_JUMP_VELOCITY
	
	if Input.is_action_just_released("crouch"):
		sliding = false
		walking = true
	
	# Crouching is dominant, we want it to overwrite sprint
	if (Input.is_action_pressed("crouch") || sliding) && not dashing:
		current_speed = lerp(current_speed, B_CROUCHING_SPEED, delta*lerp_speed)
		head.position.y = lerp(head.position.y, CROUCHING_DEPTH, delta*lerp_speed)
		crouching_collision_shape.disabled = false
		standing_collision_shape.disabled = true
		
		# Slide begin logic
		if  input_dir != Vector2.ZERO:
			sliding = true
			slide_timer = SLIDE_LENGTH_MAX
			slide_vec = input_dir
			#freelooking = true
		
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
	if can_dash() && Input.is_action_pressed("dash") && not sliding && input_dir != Vector2.ZERO:
		dash()
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
		
		if coyote_timer.is_stopped():
			coyote_timer.start()
	else:
		coyote_time_active = true
		coyote_timer.stop()
		if jump_buffer_active:
			jump()
			jump_buffer_active = false

	# Handle jump.
	if Input.is_action_just_pressed("jump")  and !crouching_ray_cast_check.is_colliding():
		if coyote_time_active:
			jump()
		else:
			jump_buffer_active = true
			jump_buffer_timer.start()

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
