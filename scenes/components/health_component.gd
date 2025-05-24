extends Node
class_name HealthComponent

signal died
signal health_changed
signal health_decreased

# TODO: I dont love having it here tbh.....
var loot_drop_scene: PackedScene = preload("res://scenes/game objects/loot_drop.tscn")

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
			var enemy_instance = owner as EnemyBase
			
			if enemy_instance.loot_to_drop:
				var entity_layer = get_tree().get_first_node_in_group("entity_layer")
				if entity_layer:
					var loot_drop_instance: LootDrop = loot_drop_scene.instantiate()
					entity_layer.add_child(loot_drop_instance)
					loot_drop_instance.create_loot_drop(enemy_instance.loot_to_drop)
					loot_drop_instance.global_position = enemy_instance.global_position
		
		# If we dont persist the object after death lets just queue free it
		if not persist_after_death:
			owner.queue_free()
