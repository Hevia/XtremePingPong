extends Node3D

@onready var jump_pad_area_3d: Area3D = $JumpPadArea3D

@export var jump_pad_strength: float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	jump_pad_area_3d.body_entered.connect(on_jump_pad_area_entered)


func on_jump_pad_area_entered(other_body: Node3D):
	print("Jump pad entered!")
	if other_body and other_body is CharacterBase:
		(other_body as CharacterBase).force_jump(jump_pad_strength)
