class_name CharacterBase extends CharacterBody3D

func force_hspeed(forced_hspeed: float) -> void:
	velocity.x += forced_hspeed

func force_jump(forced_jump_velocity) -> void:
	velocity.y = forced_jump_velocity

func apply_force(dir_velocity: Vector3) -> void:
	print(dir_velocity)
	velocity = Vector3.ZERO
	velocity = dir_velocity
