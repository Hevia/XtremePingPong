extends Node
class_name HealthComponent

signal died
signal health_changed
signal health_decreased

@export var max_health: float = 10
@export var persist_after_death: bool = false
@export var is_enemy: bool = false # TODO: I dont love this approach tbh
var current_health


func _ready():
	current_health = max_health

func damage(damage_amount: float):
	current_health = clamp(current_health - damage_amount, 0, max_health)
	health_changed.emit()
	if damage_amount > 0:
		health_decreased.emit()
	Callable(check_death).call_deferred()


func heal(heal_amount: int):
	damage(-heal_amount)


func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)


func check_death():
	if current_health <= 0.0:
		died.emit()
		
		if is_enemy:
			GameState.enemies -= 1
		
		# If we dont persist the object after death lets just queue free it
		if not persist_after_death:
			owner.queue_free()
