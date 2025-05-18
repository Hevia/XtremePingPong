class_name EnemyBase extends CharacterBase

@export var JUMP_VELOCITY = 4.5
@export var B_SPEED = 15.0
@export var B_PATH_UPDATE_TICKS = 60
@export var ENEMY_SEARCH_TICKS = 60
@export var detection_area_component_3d: DetectionAreaComponent3D
@export var los_ray_cast_3d: RayCast3D

# Lower this to update the "thinking" more often
@export var path_update_window = 0

var search_tick_window = 0
var is_searching: bool = true
var player_ref: Player
var can_attack: bool = false

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
	
	#var space_state = get_world_3d().direct_space_state
	#var raycast = PhysicsRayQueryParameters3D.create(self.global_position, player_pos, 1)
	#var collision = space_state.intersect_ray(raycast)
	#
	#if collision and collision.collider is Player:
		#return true
#
	#return false
