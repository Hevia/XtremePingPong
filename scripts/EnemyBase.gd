class_name EnemyBase extends CharacterBase

@export var B_PATH_UPDATE_TICKS = 60
@export var ENEMY_SEARCH_TICKS = 60

var search_tick_window = 0

# Check if the enemy has LOS on the player
func check_if_los(player_pos: Vector3) -> bool:
	var space_state = get_world_3d().direct_space_state
	var raycast = PhysicsRayQueryParameters3D.create(self.global_position, player_pos)
	var collision = space_state.intersect_ray(raycast)
	
	if collision and collision.collider is Player:
		return true

	return false
