class_name ObjectCannon extends Node3D


@onready var shoot_timer: Timer = %ShootTimer
@onready var shoot_marker_3d: Marker3D = %ShootMarker3D

@export var can_shoot = false
@export var projectile_shoot_speed = 100
@export var cannon_projectile: Node3D

func _ready():
	shoot_timer.timeout.connect(on_shoot_timer_timeout)
	
func _physics_process(delta: float) -> void:
	if can_shoot and cannon_projectile:
		var projectile_instance = cannon_projectile.instantiate()
		var entity_layer = get_tree().get_first_node_in_group("entity_layer")
		if entity_layer:
			can_shoot = false
			shoot_timer.start()
			entity_layer.add_child(projectile_instance)
			projectile_instance.global_position = shoot_marker_3d.global_position
			var dir_vec = Vector3.ZERO			
			projectile_instance.velocity = dir_vec * projectile_shoot_speed
		
	
func on_shoot_timer_timeout():
	can_shoot = true
