extends Node3D

var mouse_mov
var sway_threshold = 5
var sway_lerp = 5.0

@export var sway_left: Vector3
@export var sway_right: Vector3
@export var sway_normal: Vector3

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_mov = -event.relative.x

func _process(delta: float) -> void:
	if mouse_mov:
		if mouse_mov > sway_threshold:
			rotation = rotation.lerp(sway_left, sway_lerp * delta)
		elif mouse_mov < -sway_threshold:
			rotation = rotation.lerp(sway_right, sway_lerp * delta)
		else:
			rotation = rotation.lerp(sway_normal, sway_lerp * delta)
