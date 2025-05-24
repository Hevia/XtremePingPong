#class_name PaddleThrowable extends Throwable
#
#func _ready() -> void:
	#super()
#
#func _physics_process(delta):
	#if is_locked_on and target_ref:
		#var force = find_force_to_target(target_ref)
		#apply_force(force)
	#elif not is_on_floor():
		#velocity += get_gravity() * delta
			#
	#var collision = move_and_collide(velocity * delta)  
	#if collision:  
		#handle_ricochet(collision)  
#
#func align_to_velocity():
	#if velocity.length() > 0:
		#look_at(global_position + velocity.normalized(), Vector3.UP)
