class_name FishBowlHead extends EnemyBase

var projectile_scene = preload("res://scenes/game objects/ball.tscn")
@onready var shape_cast_3d: ShapeCast3D = $ShapeCast3D
@onready var marker_3d: Marker3D = $Marker3D
@onready var attack_timer: Timer = %AttackTimer
@onready var attack_cooldown_timer: Timer = %AttackCooldownTimer

@export var BASE_BALL_SHOOT_SPEED = 30
@export var ATTACK_TIMING = 0.3
@export var COOLDOWN_TIMING = 0.6

func _ready() -> void:
	can_attack = true
	detection_area_component_3d.area_entered.connect(on_detection_area_entered)
	attack_timer.wait_time = ATTACK_TIMING
	attack_cooldown_timer.wait_time = COOLDOWN_TIMING
	attack_timer.timeout.connect(on_attack_timer_timeout)
	attack_cooldown_timer.timeout.connect(on_attack_cooldown_timer_timeout)

func update_search_ticks():
	search_tick_window += 1
	
	if player_ref and search_tick_window >= ENEMY_SEARCH_TICKS:
		search_tick_window = 0
		search_for_player()

func shoot_at_player():
	if can_attack and player_ref:
		var projectile_instance = projectile_scene.instantiate() as Ball
		var entity_layer = get_tree().get_first_node_in_group("entity_layer")
		if entity_layer:
			can_attack = false
			attack_cooldown_timer.start()
			entity_layer.add_child(projectile_instance)
			projectile_instance.global_position = marker_3d.global_position
			var predicted_player_position = player_ref.global_position #+ player_ref.velocity
			var dir_vec = (predicted_player_position - projectile_instance.global_position).normalized()

			# Rotate the ball to face the player
			var yaw_rad = atan2(dir_vec.x, dir_vec.z)
			projectile_instance.rotation.y = yaw_rad
			
			projectile_instance.velocity = dir_vec * BASE_BALL_SHOOT_SPEED

func update_path_ticks():
	path_update_window += 1
	
	if path_update_window >= B_PATH_UPDATE_TICKS:
		path_update_window = 0
		shoot_at_player()

func _physics_process(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_searching:
		update_search_ticks()
	
	if player_ref:
		look_at(player_ref.global_position)
	
	check_for_search_reset()
	move_and_slide()

func search_for_player():
	if check_if_los(player_ref.global_position):
		is_searching = false

func on_detection_area_entered(other_area: Area3D):
	if is_searching and other_area and other_area.owner and other_area.owner is Player:
		player_ref = other_area.owner
		search_for_player()
		attack_timer.start()

func on_attack_timer_timeout():
	attack_timer.start()
	shoot_at_player()
	
func on_attack_cooldown_timer_timeout():
	can_attack = true
