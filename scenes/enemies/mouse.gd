class_name Mouse extends CharacterBase

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

@export var player: Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready() -> void:
	navigation_agent_3d.set_target_position(player.global_position)
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position # woaw this is how you get the local position??
	var direction = local_destination.normalized()
	
	velocity = SPEED * direction

	move_and_slide()
