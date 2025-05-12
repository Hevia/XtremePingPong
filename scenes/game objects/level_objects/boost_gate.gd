extends Node3D

@export var item_to_grant: PackedScene
@export var horizontal_speed_boost: float = 10.0
@onready var boost_area_3d: Area3D = %BoostArea3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boost_area_3d.body_entered.connect(on_boost_area_entered)

func on_boost_area_entered(other_body: Node3D):
	if other_body and other_body is CharacterBase:
		(other_body as CharacterBase).force_hspeed(horizontal_speed_boost)
