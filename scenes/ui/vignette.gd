class_name UIVignette extends CanvasLayer


@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	animation_player.stop()

func play_damage_vignette():
	animation_player.play("hit")
