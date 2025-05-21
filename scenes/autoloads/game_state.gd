class_name GameStateAutoload extends Node

signal settings_changed
signal difficulty_changed

var death_tip_msg: String = ""
var current_difficulty: Difficulty = preload("res://resources/difficulties/sunshine.tres")
var mouse_sensitivity: float

func set_difficulty(new_diff: Difficulty) -> void:
	if new_diff:
		current_difficulty = new_diff
		difficulty_changed.emit()
