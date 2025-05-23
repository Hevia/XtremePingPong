class_name BlastAttack extends Node3D


@onready var hitbox_component_3d: HitboxComponent3D = %HitboxComponent3D
@onready var sphere_collision_shape_3d: CollisionShape3D = %SphereCollisionShape3D
@onready var effects_container: Node3D = %EffectsContainer
@onready var explosion_prototype_effect: MeshInstance3D = %ExplosionPrototypeEffect

var sphere_mesh: SphereMesh
var sphere_collision_shape_ref: SphereShape3D

func _ready() -> void:
	sphere_collision_shape_ref = sphere_collision_shape_3d.shape
	sphere_mesh = explosion_prototype_effect.mesh
	
func set_damage(damage: float) -> void:
	hitbox_component_3d.damage = damage

func set_radius(radius: float) -> void:
	sphere_collision_shape_ref.radius = radius
	sphere_mesh.radius = radius
	sphere_mesh.height = radius*2
