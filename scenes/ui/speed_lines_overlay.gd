class_name SpeedLines extends Control

@onready var color_rect: ColorRect = $ColorRect


func set_speed_lines_density(density) -> void:
	color_rect.material.set_shader_parameter("line_density", density)
