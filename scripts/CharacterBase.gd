class_name CharacterBase extends CharacterBody3D

var lock_control = false


func reset_control() -> void:
	lock_control = false
	
func add_timed_buff(buffdef, time):
	pass

func force_hspeed(speed_mult: float) -> void:
	pass

func force_jump(forced_jump_velocity) -> void:
	velocity.y = forced_jump_velocity

func apply_force(dir_velocity: Vector3) -> void:
	print(dir_velocity)
	lock_control = true
	velocity = Vector3.ZERO
	velocity = dir_velocity
