class_name ProjectileHurtboxArea3D extends Area3D

@export var health_component: HealthComponent

var enabled = false

func _ready() -> void:
	self.area_entered.connect(on_area_entered)

func on_area_entered(other_area: Area3D) -> void:
	if other_area is HurtboxComponent and enabled:
		health_component.damage(1)
