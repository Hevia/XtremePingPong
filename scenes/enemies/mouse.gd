class_name Mouse extends EnemyBase

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
	detection_area_component_3d.area_entered.connect(on_detection_area_entered)


func update_path_ticks():
	path_update_window += 1
	
	if path_update_window >= B_PATH_UPDATE_TICKS:
		path_update_window = 0
		
		if player_ref:
			navigation_agent_3d.set_target_position(player_ref.global_position)


func search_for_player():
	if check_if_los(player_ref.global_position):
		is_searching = false
		navigation_agent_3d.set_target_position(player_ref.global_position)


func update_search_ticks():
	search_tick_window += 1
	
	if player_ref and search_tick_window >= ENEMY_SEARCH_TICKS:
		search_tick_window = 0
		search_for_player()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if not is_searching:
		update_path_ticks()
	else:
		update_search_ticks()
	
	if player_ref:
		var destination = navigation_agent_3d.get_next_path_position()
		var local_destination = destination - global_position # woaw this is how you get the local position??
		var direction = local_destination.normalized()
	
		velocity = B_SPEED * direction
	
	check_for_search_reset()
	move_and_slide()

func on_detection_area_entered(other_area: Area3D):
	if is_searching and other_area and other_area.owner and other_area.owner is Player:
		player_ref = other_area.owner
		search_for_player()
