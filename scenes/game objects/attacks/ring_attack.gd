class_name RingAttack extends Node3D

@export var damage: float = 1.0
@export var team: Constants.Teams = Constants.Teams.Enemies
@export var attack_length: float = 2.0
@export var ring_grow_rate = 0.2
@export var starting_radius = 0.4

@onready var ring_mesh: CSGTorus3D = %RingMesh
@onready var damage_collision_shape_3d: CollisionShape3D = %DamageCollisionShape3D
@onready var immune_collision_shape_3d: CollisionShape3D = %ImmuneCollisionShape3D
@onready var attack_timer: Timer = %AttackTimer
@onready var damage_area_3d: Area3D = %DamageArea3D
@onready var immune_area_3d: Area3D = %ImmuneArea3D

var player_ref: Player
var is_player_in_immune_area: bool = false
var is_player_damage_area: bool = false

var immune_cylinder: CylinderShape3D
var damage_cylinder: CylinderShape3D

func _ready() -> void:
	attack_timer.wait_time = attack_length
	attack_timer.timeout.connect(on_attack_timer_timeout)
	immune_cylinder = immune_collision_shape_3d.shape as CylinderShape3D
	damage_cylinder = damage_collision_shape_3d.shape as CylinderShape3D
	damage_area_3d.area_entered.connect(on_damage_area_entered)
	damage_area_3d.area_exited.connect(on_damage_area_exited)
	immune_area_3d.area_entered.connect(on_immune_area_entered)
	immune_area_3d.area_exited.connect(on_immune_area_exited)
	
	ring_mesh.outer_radius = starting_radius
	damage_cylinder.radius = starting_radius
	immune_cylinder.radius = starting_radius - ring_grow_rate
	ring_mesh.inner_radius = starting_radius -ring_grow_rate
	
	attack_timer.start()
	
func _physics_process(delta: float) -> void:
	ring_mesh.outer_radius += ring_grow_rate
	damage_cylinder.radius += ring_grow_rate
	
	immune_cylinder.radius += ring_grow_rate
	ring_mesh.inner_radius += ring_grow_rate

func reset_cylinders():
	# Safety measure to fix a bug caused by the collison shape persisiting between spawns
	# Despite being marked as unique?
	if damage_cylinder and immune_cylinder:
		damage_cylinder.radius = starting_radius
		immune_cylinder.radius = starting_radius - ring_grow_rate

func on_attack_timer_timeout() -> void:
	self.call_deferred("reset_cylinders")
	self.call_deferred("queue_free")

func check_to_damage_player() -> void:
	if player_ref and not is_player_in_immune_area and is_player_damage_area:
		player_ref.health_component.damage(self.damage)
	

func on_damage_area_entered(other_area: Area3D) -> void:
	if other_area.owner is Player:
		is_player_damage_area = true
		player_ref = other_area.owner
		check_to_damage_player()

func on_damage_area_exited(other_area: Area3D) -> void:
	if other_area.owner is Player:
		is_player_damage_area = false
		player_ref = null

func on_immune_area_entered(other_area: Area3D) -> void:
	if other_area.owner is Player:
		is_player_in_immune_area = true
		player_ref = other_area.owner

func on_immune_area_exited(other_area: Area3D) -> void:
	if other_area.owner is Player:
		is_player_in_immune_area = false
