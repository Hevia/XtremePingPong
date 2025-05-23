class_name FishBowlThrowable extends Throwable

@onready var hit_collision_shape_3d: CollisionShape3D = $HitboxComponent3D/HitCollisionShape3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	super()

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
