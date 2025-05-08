class_name ObjectCannon extends Node3D


@onready var shoot_timer: Timer = %ShootTimer
@onready var shoot_marker_3d: Marker3D = %ShootMarker3D

@export var can_shoot = true
@export var projectile_shoot_speed = 25
@export var projectile_shoot_cadence: float = 1.0
@export var cannon_projectile: PackedScene

func _ready():
	shoot_timer.wait_time = projectile_shoot_cadence
	shoot_timer.timeout.connect(on_shoot_timer_timeout)
	
func _physics_process(delta: float) -> void:
	if can_shoot and cannon_projectile:
		print("trying to shoot!")
		var projectile_instance = cannon_projectile.instantiate() as CharacterBody3D
		var entity_layer = get_tree().get_first_node_in_group("entity_layer")
		if entity_layer:
			can_shoot = false
			shoot_timer.start()
			entity_layer.add_child(projectile_instance)
			projectile_instance.global_position = shoot_marker_3d.global_position
			projectile_instance.global_transform = shoot_marker_3d.global_transform
			var dir_vec = shoot_marker_3d.global_transform.basis.z.normalized()
			projectile_instance.velocity = dir_vec * projectile_shoot_speed
			projectile_instance.start_timer()
		
	
func on_shoot_timer_timeout():
	can_shoot = true
	shoot_timer.start()
