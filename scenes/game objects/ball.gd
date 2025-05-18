class_name Ball extends Throwable  

@onready var colorswitcher_timer: Timer = %ColorswitcherTimer
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var ball_collision_shape_3d: CollisionShape3D = $BallCollisionShape3D
@onready var hit_collision_shape_3d: CollisionShape3D = $Area3D/HitCollisionShape3D

var ricochets_remaining = 100  

var switch_colors = false
var current_color: Color = Color.WHITE
var next_color: Color = Color.WHITE

var material_ref = null

func _ready() -> void:
	super()
	# Since the ball color might change a lot, we just have this ref to change often
	material_ref = mesh_instance_3d.mesh.surface_get_material(0) as StandardMaterial3D
	#lock_on_timer.timeout.connect(on_lock_on_timer_timeout)

func set_color(target_color: Color) -> void:
	next_color = target_color
	colorswitcher_timer.start()
	
	if material_ref:
		material_ref.albedo_color = next_color
		
func apply_force(force: Vector3, momentum_retention = 0.7) -> void:
	# Store the previous velocity magnitude (speed)
	var prev_speed = velocity.length()
	
	# Calculate new direction from force
	var acceleration = force / mass
	var new_direction = acceleration.normalized()
	
	# Set velocity in the new direction
	velocity = new_direction * acceleration.length()
	
	# Add a percentage of the previous speed to the new velocity (in the new direction)
	velocity += new_direction * (prev_speed * momentum_retention)
	
	# Ensure the ball is aligned with its new velocity
	align_to_velocity()
	
func set_grabbed_parent_ref(grabber: Node3D) -> void:
	is_grabbed = true
	grabbed_parent = grabber
	grabber.grabbed_object_ref = self
	ball_collision_shape_3d.disabled = true
	hit_collision_shape_3d.disabled = true

func set_last_hit_by(hitter: Node3D) -> void:
	last_hit_or_thrown_by = hitter

func released_from_grab():
	is_grabbed = false
	grabbed_parent = null
	ball_collision_shape_3d.disabled = false
	hit_collision_shape_3d.disabled = false

func curve_towards_target(next_target: Node3D) -> void:
	if not is_grabbed and next_target and next_target is Node3D:
		target_ref = next_target
		is_locked_on = true
		var force = find_force_to_target(target_ref)
		lock_on_timer.start()
		apply_force(force)

func find_force_to_target(target: Node3D, desired_speed = BASE_SPEED):
	if target:
		var direction_to_target = (target.global_position - global_position).normalized()
		var force = direction_to_target * BASE_SPEED
		return force
	else:
		return Vector3.ZERO
	

func _physics_process(delta):
	if is_grabbed:
		if grabbed_parent:
			global_position = grabbed_parent.get_marker_pos()
		else:
			released_from_grab()
	else:
		# If we're locked on to target, ignore gravity and lets focus on going to the target
		if is_locked_on and target_ref:
			var force = find_force_to_target(target_ref)
			apply_force(force)
		elif not is_on_floor():
			velocity += get_gravity() * delta
		
		
			
		var collision = move_and_collide(velocity * delta)  
		if collision:  
			handle_ricochet(collision)  

func align_to_velocity():
	if velocity.length() > 0:
		look_at(global_position + velocity.normalized(), Vector3.UP)
