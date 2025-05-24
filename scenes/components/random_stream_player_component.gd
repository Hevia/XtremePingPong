class_name RandomAudioStreamPlayer extends AudioStreamPlayer

@export var streams: Array[AudioStream]
@export var randomize_pitch = true
@export var min_pitch = .9
@export var max_pitch = 1.1
@export var play_on_start: bool = false

func _ready() -> void:
	if play_on_start:
		play_random()


func play_random():
	if streams == null || streams.size() == 0:
		return
		
	if randomize_pitch:
		pitch_scale = randf_range(min_pitch, max_pitch)
	else:
		pitch_scale = 1

	stream = streams.pick_random()
	play()
