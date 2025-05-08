extends CharacterBody3D

@onready var lifetime_timer_component: LifetimeTimerComponent = %LifetimeTimerComponent

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func start_timer() -> void:
	lifetime_timer_component.start()

func _physics_process(delta: float) -> void:
	move_and_slide()
