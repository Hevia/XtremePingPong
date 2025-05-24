class_name UIVignette extends CanvasLayer


@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	reset_anims()

func reset_anims() -> void:
	animation_player.play("RESET")

func play_damage_vignette():
	animation_player.play("hit")
