class_name HitboxComponent3D extends Area3D


@export var damage: float = 10
@export var isProjectile: bool = false
@export var team: Constants.Teams = Constants.Teams.None
@export var wait_to_confirm: bool = false

func set_team(new_team: Constants.Teams) -> void:
	team = new_team
