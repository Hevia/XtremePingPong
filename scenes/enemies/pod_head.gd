class_name PodHead extends EnemyBase

var enemy_alert_vfx_scene = preload("res://scenes/vfx/enemy_attack_spark.tscn")
var ring_attack_scene = preload("res://scenes/game objects/attacks/ring_attack.tscn")

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var attack_spawn_marker_3d: Marker3D = %AttackSpawnMarker3D
@onready var attack_timer: Timer = %AttackTimer
@onready var attack_cooldown_timer: Timer = %AttackCooldownTimer
@onready var search_cooldown_timer: Timer = %SearchCooldownTimer
@onready var search_update_timer: Timer = %SearchUpdateTimer
@onready var alert_spawn_marker_3d: Marker3D = %AlertSpawnMarker3D

@export var ATTACK_TIMING = 0.3
@export var COOLDOWN_TIMING = 0.6
@export var RING_ATTACK_LENGTH = 1.5

func _ready() -> void:
	can_attack = false
	search_update_timer.wait_time = ENEMY_SEARCH_TIME
	search_cooldown_timer.wait_time = ENEMY_SEARCH_COOLDOWN
	detection_area_component_3d.area_entered.connect(on_detection_area_entered)
	detection_area_component_3d.area_exited.connect(on_detection_area_exited)
	attack_cooldown_timer.wait_time = COOLDOWN_TIMING
	attack_cooldown_timer.timeout.connect(on_attack_cooldown_timer_timeout)
	search_update_timer.timeout.connect(on_search_timer_timeout)
	search_cooldown_timer.timeout.connect(on_search_cooldown_timer_timeout)

func update_search_ticks():
	if player_ref:
		search_for_player()

func spawn_alert_vfx():
	if enemy_alert_vfx_scene:
		var vfx_instance: GPUParticles3D = enemy_alert_vfx_scene.instantiate()
		var entity_layer = get_tree().get_first_node_in_group("entity_layer")
		if entity_layer:
			entity_layer.add_child(vfx_instance)
			vfx_instance.global_position = alert_spawn_marker_3d.global_position
	

func spawn_ring_attack():
	var entity_layer = get_tree().get_first_node_in_group("entity_layer")
	if entity_layer:
		var ring_attack_instance: RingAttack = ring_attack_scene.instantiate() as RingAttack
		can_attack = false
		attack_cooldown_timer.start()
		entity_layer.add_child(ring_attack_instance)
		ring_attack_instance.global_position = attack_spawn_marker_3d.global_position
		ring_attack_instance.attack_length = RING_ATTACK_LENGTH
		
func try_shoot_at_player():
	print("can_attack: " + str(can_attack))
	print(check_if_los(player_ref))
	if can_attack and player_ref and check_if_los(player_ref):
		animation_player.play("Attack")

func _physics_process(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_searching:
		update_search_ticks()
	
	if player_ref and player_already_spotted:
		print("we be looking...")
		look_at(player_ref.global_position)
		# we try to shoot at the player if our attack isnt on cooldown
		try_shoot_at_player()
	
	check_for_search_reset()
	move_and_slide()

func search_for_player():
	if check_if_los(player_ref):
		is_searching = false
		if not player_already_spotted:
			animation_player.play("Surprise")
			player_already_spotted = true

func ready_attack():
	# Triggered in surprise anim
	can_attack = true

func on_detection_area_entered(other_area: Area3D):
	if other_area and other_area.owner and other_area.owner is Player:
		player_ref = other_area.owner
		search_for_player()
	
func on_detection_area_exited(other_area: Area3D):
	if other_area and other_area.owner and other_area.owner is Player:
		player_ref = null
		is_searching = true

func on_attack_cooldown_timer_timeout():
	can_attack = true

func on_search_cooldown_timer_timeout():
	is_searching = true
	search_update_timer.start()

func on_search_timer_timeout() -> void:
	search_cooldown_timer.start()
	is_searching = false
