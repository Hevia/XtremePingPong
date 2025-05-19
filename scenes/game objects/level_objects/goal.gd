extends Node3D

@export var next_scene: PackedScene

@onready var goal_area_3d: Area3D = %GoalArea3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	goal_area_3d.area_entered.connect(on_goal_area_entetered)

func change_level() -> void:
	get_tree().change_scene_to_packed(next_scene)

func on_goal_area_entetered(other_area: Area3D) -> void:
	if other_area.owner and other_area.owner is Player:
		if next_scene:
			call_deferred("change_level")
		else:
			print("Uh oh! Next scene is null...")
