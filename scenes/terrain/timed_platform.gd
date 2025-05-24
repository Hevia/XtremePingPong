class_name TimedPlatform extends StaticBody3D

@export var platform_lifetime: float = 3.0

@onready var player_detection_area_3d: Area3D = %PlayerDetectionArea3D
@onready var lifetime_timer: Timer = %LifetimeTimer
@onready var random_stream_player_component: RandomAudioStreamPlayer = %RandomStreamPlayerComponent


func _ready() -> void:
	player_detection_area_3d.area_entered.connect(player_detection_area_entered)
	lifetime_timer.timeout.connect(on_lifetime_timer_timeout)
	
func player_detection_area_entered(other_area: Area3D) -> void:
	if other_area.owner is Player:
		lifetime_timer.start()
		random_stream_player_component.play_random()

func on_lifetime_timer_timeout() -> void:
	call_deferred("queue_free")
