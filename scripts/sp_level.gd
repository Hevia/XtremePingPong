class_name SinglePlayerLevel extends Node3D

@export var player: Player
@export var music_player: DemoMusicPlayer

var death_menu_scene = preload("res://scenes/ui/death_screen.tscn")

func _ready() -> void:
	GameState.reset_enemy_counts()
	player.health_component.died.connect(on_player_death)
	self.call_deferred("count_enemies")
	
	
func count_enemies() -> void:
	var enemies_list = get_tree().get_nodes_in_group("enemies")
	GameState.enemies = enemies_list.size()
	GameState.max_enemies = enemies_list.size()
	
func is_objective_complete() -> bool:
	if GameState.enemies <= 0:
		return true
	else:
		return false
	
func update_difficulty_settings() -> void:
	if GameState.current_difficulty is Difficulty:
		var enemies: Array[EnemyBase] = get_tree().get_nodes_in_group("enemies") as Array[EnemyBase]
		var player: Player = get_tree().get_first_node_in_group("Player") as Player
		player.health_component.max_health = GameState.current_difficulty.starting_player_health
		player.health_component.current_health = player.health_component.max_health
		for enemy in enemies:
			enemy.update_stats(GameState.current_difficulty)
		

func on_player_death() -> void:
	GameState.reset_enemy_counts()
	GameState.music_progress = music_player.get_playback_position()
	add_child(death_menu_scene.instantiate())
	#get_tree().paused = true # TODO: Might cause issues lol
