class_name LootDrop extends Node3D

@export var loot_resource: Loot
@onready var mesh_instance_3d: MeshInstance3D = %MeshInstance3D

func _ready() -> void:
	if loot_resource:
		mesh_instance_3d.mesh = loot_resource.pickup_model
	else:
		print("Uh oh this loot resource isnt set....")
