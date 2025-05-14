class_name CharacterBase extends CharacterBody3D

# B_ refers to Base_
var B_WALKING_SPEED = 5.0
var B_WALKING_BONUS = 5.0
var B_SPRINTING_SPEED = 8.0
var B_CROUCHING_SPEED = 3.0
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
const B_MAX_CHARGE = 100
const B_CHARGE_RATE = 25

# Jump Movement Variables
const B_JUMP_PEAK_TIME = 0.5
const B_JUMP_FALL_TIME = 0.5
const B_JUMP_HEIGHT = 2.0
const B_JUMP_DISTANCE = 4.0
var jump_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var fall_gravity = 5.0

var current_speed = 5.0
var curr_jump_velocity = 4.5
var lerp_speed = 10.0 # Used to add friction, lower is more friction
var air_control_lerp_speed = 5.0
var direction = Vector3.ZERO

var lock_control = false

func caclulate_movement_parameters() -> void:
	# Equation for better jump pulled from Building a Better Jump Godot 4 by Chaff
	jump_gravity = (2*B_JUMP_HEIGHT)/pow(B_JUMP_PEAK_TIME,2)
	fall_gravity = (2*B_JUMP_HEIGHT)/pow(B_JUMP_FALL_TIME,2)
	curr_jump_velocity = jump_gravity * B_JUMP_PEAK_TIME
	
	# Constant modifer to make walking less slow/miserable
	B_WALKING_SPEED = B_WALKING_BONUS + (B_JUMP_DISTANCE/(B_JUMP_PEAK_TIME+B_JUMP_FALL_TIME))
	B_CROUCHING_SPEED = B_WALKING_SPEED


func reset_control() -> void:
	lock_control = false
	
func add_timed_buff(buffdef: BuffDef, time: float):
	if buffdef and time:
		var buff_def_instance: BuffDef = buffdef.instantiate()
		self.add_child(buff_def_instance)
		buff_def_instance.character_owner = self
		buff_def_instance.apply_buff()
		var buff_timer = buff_def_instance.add_timer(time)
	else:
		pass # TODO: Log it maybe?

func force_hspeed(speed_mult: float) -> void:
	pass

func force_jump(forced_jump_velocity) -> void:
	velocity.y = forced_jump_velocity

func apply_force(dir_velocity: Vector3) -> void:
	print(dir_velocity)
	lock_control = true
	velocity = Vector3.ZERO
	velocity = dir_velocity
