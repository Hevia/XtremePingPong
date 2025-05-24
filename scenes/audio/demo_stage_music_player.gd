class_name DemoMusicPlayer extends AudioStreamPlayer


func _ready() -> void:
	print("GameState.music_progress: " + str(GameState.music_progress))
	play(GameState.music_progress)
