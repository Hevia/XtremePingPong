extends Node3D

@export var next_scene: PackedScene
@export var level: SinglePlayerLevel

@onready var goal_area_3d: Area3D = %GoalArea3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	goal_area_3d.area_entered.connect(on_goal_area_entetered)
	
	if not level:
		level = get_tree().get_first_node_in_group("level")

func ensure_music_stays_consistent() -> void:
	GameState.music_progress = level.music_player.get_playback_position()

func change_level() -> void:
	GameState.reset_enemy_counts()
	ensure_music_stays_consistent()
	get_tree().change_scene_to_packed(next_scene)

func on_goal_area_entetered(other_area: Area3D) -> void:
	if level.is_objective_complete() and other_area.owner is Player:
		if next_scene:
			call_deferred("change_level")
		else:
			print("Uh oh! Next scene is null...")
	else:
		pass # TODO Alert the objective isnt done
