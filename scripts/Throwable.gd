class_name Throwable extends CharacterBody3D

# Export Stats
@export var BASE_SPEED: float = 60.0
@export var mass: float = 10.0
@export var hitbox_component_3d: HitboxComponent3D
@export var start_team: Constants.Teams = Constants.Teams.None

# State Variables
## Grab State
var is_grabbed: bool = false
var grabbed_parent: Node3D = null

## Lock On State
var target_ref: Node3D = null
var is_locked_on: bool = false
@export var LOCK_ON_LENGTH: float = 2.0
@onready var lock_on_timer: Timer = Timer.new()

## Used for tracking who threw/hit
var last_hit_or_thrown_by: CharacterBase = null

func _ready() -> void:
	self.add_child(lock_on_timer)
	lock_on_timer.one_shot = true
	lock_on_timer.wait_time = LOCK_ON_LENGTH
	lock_on_timer.timeout.connect(on_lock_on_timer_timeout)
	hitbox_component_3d.set_team(start_team)
	hitbox_component_3d.area_entered.connect(on_hitbox_area_entered)

func stop_movement() -> void:
	velocity = Vector3.ZERO

func set_team(new_team: Constants.Teams) -> void:
	hitbox_component_3d.set_team(new_team)

func set_color(target_color: Color) -> void:
	# Not every projectile needs its color set
	pass

func set_last_hit_or_thrown_by(new_owner: CharacterBase) -> void:
	last_hit_or_thrown_by = new_owner

func handle_ricochet(collision: KinematicCollision3D):  
	velocity = velocity.bounce(collision.get_normal())

func on_lock_on_timer_timeout():
	is_locked_on = false
	
func on_hitbox_area_entered(other_area: Area3D):
	# So we dont trigger a hitmarker against ourselves lol
	if other_area.owner is CharacterBody3D and not other_area.owner is Player:
		if last_hit_or_thrown_by and last_hit_or_thrown_by is Player:
			(last_hit_or_thrown_by as Player).trigger_hitmarker()
			
