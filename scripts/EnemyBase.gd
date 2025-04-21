class_name EnemyBase extends CharacterBase

@export var JUMP_VELOCITY = 4.5
@export var B_SPEED = 15.0
@export var B_PATH_UPDATE_TICKS = 60
@export var ENEMY_SEARCH_TICKS = 60
@export var detection_area_component_3d: DetectionAreaComponent3D

# Lower this to update the "thinking" more often
@export var path_update_window = 0

var search_tick_window = 0
var is_searching: bool = true
var player_ref: Player

func check_for_search_reset():
	if not player_ref:
		is_searching = true
		player_ref = null
		
# Check if the enemy has LOS on the player
func check_if_los(player_pos: Vector3) -> bool:
	var space_state = get_world_3d().direct_space_state
	var raycast = PhysicsRayQueryParameters3D.create(self.global_position, player_pos)
	var collision = space_state.intersect_ray(raycast)
	
	if collision and collision.collider is Player:
		return true

	return false
