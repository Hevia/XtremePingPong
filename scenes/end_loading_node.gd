class_name EndLoadingNode extends Node

signal level_loaded

func _ready() -> void:
	print("Level has loaded...")
	level_loaded.emit()
