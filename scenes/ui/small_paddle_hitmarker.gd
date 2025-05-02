extends CanvasLayer

@onready var lifetime_timer: Timer = $LifetimeTimer

func _ready() -> void:
	lifetime_timer.timeout.connect(on_timer_timeout)

func on_timer_timeout() -> void:
	queue_free()
