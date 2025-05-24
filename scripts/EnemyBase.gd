class_name EnemyBase extends CharacterBase

@export var JUMP_VELOCITY = 4.5
@export var B_SPEED = 15.0

#TODO: Remove these
@export var B_PATH_UPDATE_TICKS = 60
@export var ENEMY_SEARCH_TICKS = 60
@export var ENEMY_SEARCH_TIME = 4.0
@export var ENEMY_SEARCH_COOLDOWN = 1.0
@export var detection_area_component_3d: DetectionAreaComponent3D
@export var los_ray_cast_3d: RayCast3D

@export var ATTACK_TIMING = 0.3
@export var COOLDOWN_TIMING = 0.6

# Lower this to update the "thinking" more often
@export var path_update_window = 0

@export var loot_to_drop: Loot

var search_tick_window = 0
var is_searching: bool = true
var player_ref: Player
var can_attack: bool = false
var player_already_spotted = false

func _ready() -> void:
	update_stats(GameState.current_difficulty)

func update_stats(difficulty: Difficulty):
	# TODO: Nah dont like this 0.6 + (0.6 - (0.6*1.25))
	var new_cooldown = COOLDOWN_TIMING + (COOLDOWN_TIMING - (COOLDOWN_TIMING * difficulty.attack_speed_multiplier))
	COOLDOWN_TIMING = clamp(new_cooldown ,0.00001, COOLDOWN_TIMING)
	
	can_attack = difficulty.enemies_on_ready
	player_already_spotted = difficulty.enemies_on_ready

func check_for_search_reset():
	if not player_ref:
		is_searching = true
	elif player_ref and not check_if_los(player_ref):
		is_searching = true
		
# Check if the enemy has LOS on the player
func check_if_los(player: Player) -> bool:
	var player_pos = player.global_transform.origin
	var ray_origin = los_ray_cast_3d.global_transform.origin
	los_ray_cast_3d.target_position = los_ray_cast_3d.to_local(player_pos) + Vector3(0, 1, 0) # aim at player torso
	los_ray_cast_3d.force_raycast_update()

	if los_ray_cast_3d.is_colliding():
		var collider = los_ray_cast_3d.get_collider()
		if los_ray_cast_3d.get_collider() is Player:
			return true
	return false
