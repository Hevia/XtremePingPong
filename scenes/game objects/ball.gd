extends CharacterBody3D  
class_name Ball

const BASE_SPEED = 60.0  
var ricochets_remaining = 100  
var mass = 10.0

func apply_force(force: Vector3):
	# F = ma, so a = F/m
	var acceleration = force / mass
	# In Godot, we typically apply changes directly to velocity
	velocity += acceleration
	# Ensure the ball is aligned with its new velocity
	align_to_velocity()

func _physics_process(delta):  
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var collision = move_and_collide(velocity * delta)  
	if collision:  
		handle_ricochet(collision)  

func align_to_velocity():
	if velocity.length() > 0:
		look_at(global_position + velocity.normalized(), Vector3.UP)


func handle_ricochet(collision: KinematicCollision3D):  
	if ricochets_remaining <= 0:  
		queue_free()  
		return  

	velocity = velocity.bounce(collision.get_normal())  
	#align_to_velocity()  
	ricochets_remaining -= 1  
