class_name GameStateAutoload extends Node

signal settings_changed
signal difficulty_changed

var death_tip_msg: String = ""
var current_difficulty: Difficulty = preload("res://resources/difficulties/sunshine.tres")
var mouse_sensitivity: float = 0.4
var enemies: int = 0
var max_enemies: int  = 0
var music_progress: float = 0.0

func _ready() -> void:
	pass

func reset_enemy_counts() -> void:
	enemies = 0
	max_enemies = 0

func mouse_sen_changed(value: float) -> void:
	mouse_sensitivity = value / 100 # TODO: This sucks
	settings_changed.emit()

func set_difficulty(new_diff: Difficulty) -> void:
	if new_diff:
		current_difficulty = new_diff
		difficulty_changed.emit()
