class_name PaddleThrowable extends CharacterBody3D

@onready var hitbox_component_3d: HitboxComponent3D = %HitboxComponent3D

const BASE_SPEED = 60.0  
var mass = 10.0

var thrown_by: CharacterBase = null


func _ready() -> void:
	hitbox_component_3d.area_entered.connect(on_hitbox_area_entered)

func apply_force(force: Vector3):
	# F = ma, so a = F/m
	var acceleration = force / mass
	# In Godot, we typically apply changes directly to velocity
	velocity += acceleration
	# Ensure the ball is aligned with its new velocity
	align_to_velocity()

func set_thrown_by(new_owner: CharacterBase) -> void:
	thrown_by = new_owner

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
			
	var collision = move_and_collide(velocity * delta)  
	if collision:  
		handle_ricochet(collision)  

func align_to_velocity():
	if velocity.length() > 0:
		look_at(global_position + velocity.normalized(), Vector3.UP)

func handle_ricochet(collision: KinematicCollision3D):  
	velocity = velocity.bounce(collision.get_normal())
	
func on_hitbox_area_entered(other_area: Area3D):
	if other_area.owner is CharacterBody3D:
		# Make sure we dont trigger hitbox against ourselves
		if thrown_by and thrown_by is Player and other_area.owner != thrown_by:
			(thrown_by as Player).trigger_hitmarker()
