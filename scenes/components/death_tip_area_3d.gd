class_name DeathTipArea3D extends Area3D

@export var death_tip: String = ""

func _ready() -> void:
	self.area_entered.connect(on_area_entered)

func on_area_entered(other_area: Area3D) -> void:
	if other_area.owner is Player:
		GameState.death_tip_msg = death_tip
