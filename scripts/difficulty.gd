class_name Difficulty extends Resource

@export var name: String
@export var icon: Texture2D
@export var skybox_prefab: PackedScene
@export var attack_speed_multiplier: float = 1.0
@export var enemy_damage_multipler: float = 1.0
@export var enemy_health_multipler: float = 1.0
@export var projectile_speed_modifier = 1.0
@export var slow_mode_disabled: bool = false
@export var starting_player_health: int = 3
@export var enemies_on_ready: bool = false
