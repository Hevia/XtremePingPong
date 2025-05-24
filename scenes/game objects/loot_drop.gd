class_name LootDrop extends Node3D

@export var loot_resource: Loot
@export var loot_refresh_wait_time: float = 15.0

@onready var mesh_preview: Node3D = %MeshPreview
@onready var label_3d: Label3D = %Label3D
@onready var pickup_area_3d: Area3D = %PickupArea3D
@onready var loot_refresh_timer: Timer = %LootRefreshTimer

var pickup_ready = true

func _ready() -> void:
	loot_refresh_timer.wait_time = loot_refresh_wait_time
	pickup_area_3d.area_entered.connect(on_pickup_area_entered)
	loot_refresh_timer.timeout.connect(on_loot_refresh_timer_timeout)
	
	create_loot_drop(loot_resource)


func create_loot_drop(loot_res: Loot) -> void:
	loot_resource = loot_res
	if loot_resource:
		label_3d.text = loot_resource.name
		mesh_preview.add_child(loot_resource.pickup_model.instantiate())
	else:
		print("Uh oh this loot resource isnt set....")

func on_loot_refresh_timer_timeout() -> void:
		pickup_ready = true
		mesh_preview.visible = true
		label_3d.visible = true

func on_pickup_area_entered(other_area: Area3D) -> void:
	if pickup_ready and loot_resource and other_area.owner is Player:
		pickup_ready = false
		var player: Player = other_area.owner as Player
		
		label_3d.visible = false
		mesh_preview.visible = false 
		player.grant_item_to_player(loot_resource.pickup_scene)
		loot_refresh_timer.start()
