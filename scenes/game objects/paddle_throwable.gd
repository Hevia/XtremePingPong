class_name PaddleThrowable extends Throwable

func _ready() -> void:
	super()

func apply_force(force: Vector3):
	# F = ma, so a = F/m
	var acceleration = force / mass
	# In Godot, we typically apply changes directly to velocity
	velocity += acceleration
	# Ensure the ball is aligned with its new velocity
	align_to_velocity()

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
			
	var collision = move_and_collide(velocity * delta)  
	if collision:  
		handle_ricochet(collision)  

func align_to_velocity():
	if velocity.length() > 0:
		look_at(global_position + velocity.normalized(), Vector3.UP)
