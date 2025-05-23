class_name FishBowlThrowable extends Throwable

var blast_attack_scene: PackedScene = preload("res://scenes/game objects/attacks/blast_attack.tscn")

@export var attack_radius: float = 1.0

@onready var hit_collision_shape_3d: CollisionShape3D = $HitboxComponent3D/HitCollisionShape3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	super()
	hitbox_component_3d.area_entered.connect(on_hitbox_area_entered)
	projectile_hurtbox.area_entered.connect(on_hurtbox_entered)

func released_from_grab():
	super()
	is_grabbed = false
	grabbed_parent = null
	collision_shape_3d.disabled = false
	hit_collision_shape_3d.disabled = false

func set_grabbed_parent_ref(grabber: Node3D) -> void:
	super(grabber)
	collision_shape_3d.disabled = true
	hit_collision_shape_3d.disabled = true
	
func trigger_explosion() -> void:
	var entity_layer = get_tree().get_first_node_in_group("entity_layer")
	if entity_layer:
		var blast_attack_instance: BlastAttack = blast_attack_scene.instantiate()
		entity_layer.add_child(blast_attack_instance)
		blast_attack_instance.set_damage(hitbox_component_3d.damage)
		blast_attack_instance.set_radius(self.attack_radius)
	
func _physics_process(delta: float) -> void:
	super(delta)
	
	if is_on_floor():
		trigger_explosion()
		
func on_hurtbox_entered(other_area: Area3D) -> void:	
	if other_area is HurtboxComponent:
		trigger_explosion()
		
func on_hitbox_area_entered(other_area: Area3D) -> void:
	super(other_area)
	
	if other_area is HurtboxComponent:
		trigger_explosion()
