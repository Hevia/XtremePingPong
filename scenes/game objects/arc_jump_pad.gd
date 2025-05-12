extends Node3D

@onready var jump_pad_area_3d: Area3D = %JumpPadArea3D
@onready var direction_marker_3d: Marker3D = %DirectionMarker3D

@export var arc_pad_strength: float = 50.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jump_pad_area_3d.body_entered.connect(on_jump_pad_area_entered)

func on_jump_pad_area_entered(other_body: Node3D):
	if other_body and other_body is CharacterBase:
		var forward := direction_marker_3d.global_transform.basis.z.normalized()  # –Z is forward
		var launch_v := forward * arc_pad_strength                             # horizontal boost
		launch_v.y = arc_pad_strength
		(other_body as CharacterBase).apply_force(launch_v)
