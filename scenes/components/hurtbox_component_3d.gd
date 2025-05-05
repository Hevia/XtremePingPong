extends Area3D
class_name HurtboxComponent

signal hit

@export var health_component: HealthComponent

func _ready():
	area_entered.connect(on_area_entered)

func on_area_entered(other_area: Area3D):
	if not other_area is HitboxComponent3D:
		return
	
	if health_component == null:
		return
	
	
	var hitbox_component = other_area as HitboxComponent3D
	
	if hitbox_component.team == Constants.Teams.None:
		return
	
	health_component.damage(hitbox_component.damage)
	
	if other_area.isProjectile:
		other_area.owner.call_deferred("decrease_health")
	
	# TODO: Maybe we want the floating text from Crowvolution?
	#var floating_text = floating_text_scene.instantiate() as Node2D
	#get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	
	hit.emit()
