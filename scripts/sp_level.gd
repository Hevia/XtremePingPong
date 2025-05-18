class_name SinglePlayerLevel extends Node3D

@export var player: Player

var pause_menu_scene = preload("res://scenes/menus/pause_screen.tscn")

func _ready() -> void:
	player.health_component.died.connect(on_player_death)

func on_player_death() -> void:
	add_child(pause_menu_scene.instantiate())
	get_tree().paused = true
