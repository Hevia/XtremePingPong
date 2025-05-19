class_name SinglePlayerLevel extends Node3D

@export var player: Player

var death_menu_scene = preload("res://scenes/ui/death_screen.tscn")

func _ready() -> void:
	player.health_component.died.connect(on_player_death)

func on_player_death() -> void:
	add_child(death_menu_scene.instantiate())
	#get_tree().paused = true # TODO: Might cause issues lol
