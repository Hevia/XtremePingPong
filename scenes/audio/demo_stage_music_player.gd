class_name DemoMusicPlayer extends AudioStreamPlayer


func _ready() -> void:
	play(GameState.music_progress)
