extends Node3D

@onready var camera_001: Camera3D = $Camera_001
@onready var camera: Camera3D = $Camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera_001.queue_free()
	camera.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
