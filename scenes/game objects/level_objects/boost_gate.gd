extends Node3D

@export var item_to_grant: PackedScene
@export var horizontal_speed_boost: float = 10.0
@onready var boost_area_3d: Area3D = %BoostArea3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boost_area_3d.area_entered.connect(on_boost_area_entered)

func on_boost_area_entered(other_area: Node3D):
	print(other_area)
	if other_area and other_area.owner is CharacterBase or other_area.owner is Player:
		(other_area.owner as CharacterBase).force_speed(horizontal_speed_boost)
